module Wrap
  class AsyncRequest < Request

    def execute
      Thread.new { super }
    end

  end
end
