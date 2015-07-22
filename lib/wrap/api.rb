module Wrap
  class Api

    AUTH_HEADER = 'Authorization'

    include Singleton

    attr_accessor :cluster, :resources, :namespaces, :current_node
    attr_reader :async, :default_headers

    def initialize
      @cluster         = Cluster.new
      @default_headers = { content_type: 'application/json' }
      @extra_headers   = {}
      @namespaces      = ''
      reset
    end

    def node(key)
      fail "node #{ key } doesn't exists" unless @cluster.nodes[key]
      @current_node = @cluster.nodes[key]
      self
    end

    def namespace(*args)
      @namespaces = "/#{ args.map { |a| a.to_s }.join('/') }" if args.size > 0
      self
    end

    def resource(name, id = nil)
      @resources << Resource.new(name, id)
      self
    end

    def async
      @async = true
      self
    end

    def index(h_query = nil)
      request = build_request :get
      request.path = "#{ request.path }?#{ h_query_to_s(h_query) }" if h_query
      reset
      request.execute
    end

    def show(h_query = nil)
      request = build_request :get
      request.path = "#{ request.path }?#{ h_query_to_s(h_query) }" if h_query
      reset
      request.execute
    end

    def create(payload)
      request = build_request :post, payload
      reset
      request.execute
    end

    def update(payload)
      request = build_request :put, payload
      reset
      request.execute
    end

    def delete
      request = build_request :delete
      reset
      request.execute
    end

    def default_node
      fail 'you need to specify at least one node in the cluster' if @cluster.nodes.size == 0
      @cluster.nodes.first.last
    end

    def headers(new_header)
      @default_headers = new_header
    end

    def get_headers
      @default_headers.merge(@extra_headers)
    end

    def header(key, value)
      @extra_headers[key.to_sym] = value
    end

    def auth(credential, tmp = false)
      if tmp
        @extra_headers[AUTH_HEADER] = credential
      else
        @default_headers[AUTH_HEADER] = credential
      end
      self
    end

    def auth?
      h = get_headers
      h.key?(AUTH_HEADER) && ![nil, :anonymous].include?(h[AUTH_HEADER])
    end

    def unauth
      @default_headers.delete AUTH_HEADER
      @extra_headers.delete AUTH_HEADER
      self
    end

    def reset
      @resources     = []
      @extra_headers = {}
      @namespaces    = ''
      @async         = false
    end

    private

    def build_request(http_method, body = nil)
      klass = @async ? AsyncRequest : Request
      klass.new http_method, full_path, get_headers, body
    end

    def full_path
      node = @current_node || default_node
      "#{ node.path }#{ @namespaces }#{ @resources.map(&:sub_path).join }"
    end

    def h_query_to_s(hash)
      string = ''
      hash.each { |k,v| string = "#{ string }#{ k }=#{ v };" }
      string[0...-1]
    end

  end
end
