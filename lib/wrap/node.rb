module Wrap
  class Node

    attr_accessor :key, :host, :versions

    def initialize(key, host, versions)
      @key      = key
      @host     = host
      @versions = versions
    end

    def path
      @host = "#{ @host }/" unless @host.end_with? '/'
      "#{ @host }#{ @versions.first }"
    end

  end
end
