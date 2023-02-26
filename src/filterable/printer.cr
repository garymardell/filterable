module Filterable
  class Printer
    def initialize(@root : AST::Node)
    end

    def to_s
      String.build do |io|
        traverse(io, @root)
      end
    end

    def print
      puts to_s
    end

    def traverse(io, node : AST::And)
      traverse(io, node.left)
      io << " AND "
      traverse(io, node.right)
    end

    def traverse(io, node : AST::Or)
      io << "("
      traverse(io, node.left)
      io << " OR "
      traverse(io, node.right)
      io << ")"
    end

    def traverse(io, node : AST::Filter)
      io << node.identifier
      io << " = "
      io << node.value
    end

    def traverse(io, node)
    end
  end
end