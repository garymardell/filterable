require "./ast"

module Filterable
  class Scope
    getter stack

    def initialize
      @stack = [] of AST::Node
    end

    def fold
      while stack.size > 1
        node = stack.pop

        root = stack.last

        case root
        when AST::Or
          root.right = node
        end
      end

      stack.last
    end
  end

  class Visitor < Lingo::Visitor
    getter scopes

    def initialize
      @scopes = [] of Scope
      @scopes << Scope.new
    end

    def root
      current_scope.stack.last
    end

    def current_scope
      @scopes.last
    end

    enter(:filter) {
      root = visitor.current_scope.stack.last?

      case root
      when AST::And
        root.right = AST::Filter.new
      when AST::Or
        visitor.current_scope.stack << AST::Filter.new
      else
        visitor.current_scope.stack << AST::Filter.new
      end
    }

    enter(:lparen) {
      visitor.scopes << Scope.new
    }

    enter(:rparen) {
      scope = visitor.scopes.pop
      right = scope.fold

      root = visitor.current_scope.stack.last?

      case root
      when AST::And
        root.right = right
      else
        visitor.current_scope.stack << right
      end
    }

    enter(:and) {
      left = visitor.current_scope.stack.pop

      visitor.current_scope.stack << AST::And.new(left: left)
    }

    enter(:or) {
      left = visitor.current_scope.stack.pop
      visitor.current_scope.stack << AST::Or.new(left: left)
    }

    enter(:identifier) {
      root = visitor.current_scope.stack.last?

      case root
      when AST::And
        root.right.as(AST::Filter).identifier = node.full_value
      when AST::Filter
        root.identifier = node.full_value
      end
    }

    enter(:value) {
      root = visitor.current_scope.stack.last?

      case root
      when AST::And
        root.right.as(AST::Filter).value = node.full_value
      when AST::Filter
        root.value = node.full_value
      end
    }

    exit(:main) {
      visitor.current_scope.fold
    }
  end
end
