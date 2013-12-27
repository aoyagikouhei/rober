module Rober
  class Entity
    attr_accessor :logical_name, :physical_name, :comment
    attr_reader :attributes
    def initialize
      @attributes = []
    end

    def add(attribute)
      @attributes << attribute
    end
  end
end
