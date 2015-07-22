module Wrap
  class Resource

    attr_accessor :name, :id

    def initialize(name, id = nil)
      @name = name
      @id = id
    end

    def sub_path
      @id ? "/#{ @name.to_s.pluralize }/#{ @id }" : "/#{ @name.to_s.pluralize }"
    end

  end
end
