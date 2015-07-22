module Wrap
  class Cluster

    attr_accessor :nodes

    def initialize
      @nodes = {}
    end

    def add(key, host, versions)
      add_node Node.new(key, host, versions)
    end

    def add_node(node)
      @nodes[node.key] = node
    end

  end
end
