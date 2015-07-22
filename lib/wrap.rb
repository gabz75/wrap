require 'rest_client'
require 'singleton'

require 'wrap/api'
require 'wrap/node'
require 'wrap/cluster'
require 'wrap/resource'
require 'wrap/request'
require 'wrap/async_request'

module Wrap
  def self.config
    yield Api.instance.cluster
  end

  def self.method_missing(method, *args, &block)
    Api.instance.send(method, *args, &block)
  end
end

class String

  def pluralize
    self + 's'
  end

end
