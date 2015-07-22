class MockResponse

  attr_accessor :body

  def initialize(body = nil)
    @body = body ? body : '{ "foo" : "bar" }'
  end

end
