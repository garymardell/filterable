module Filterable
  module AST
    abstract class Node
      def to_s
        printer = Filterable::Printer.new(self)
        printer.to_s
      end
    end

    class And < Node
      property left : Node?
      property right : Node?

      def initialize(@left = nil, @right = nil)
      end

      def_equals_and_hash @left, @right
    end

    class Or < Node
      property left : Node?
      property right : Node?

      def initialize(@left = nil, @right = nil)
      end

      def_equals_and_hash @left, @right
    end

    class Filter < Node
      property identifier : String?
      property value : String?

      def_equals_and_hash @identifier, @value
    end
  end
end