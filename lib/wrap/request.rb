module Wrap
  class Request

    attr_reader :http_method, :headers, :path, :body
    attr_writer :path

    def initialize(http_method, path, headers, body = nil)
      @http_method = http_method
      @path        = path
      @headers     = headers
      @body        = body
    end

    def execute
      if [:get, :delete].include? @http_method
        response = RestClient.send @http_method, @path, @headers
      else
        response = RestClient.send @http_method, @path, @body, @headers
      end
      response.body.strip == '' ? {} : JSON.parse(response.body)
    end

  end
end
