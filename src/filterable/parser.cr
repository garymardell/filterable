require "lingo"

module Filterable
  class Parser < Lingo::Parser
    root(:main)

    rule(:main) { or_filter }

    rule(:or_filter) {
      (and_filter >> space >> or_op.named(:or) >> space? >> or_filter) | and_filter
    }

    rule(:and_filter) {
      (expression >> (space >> and_op.maybe).named(:and) >> space? >> and_filter) | expression
    }

    rule(:expression) {
      (lparen.named(:lparen) >> space? >> or_filter >> space? >> rparen.named(:rparen)) |
      filter.named(:filter)
    }

    rule(:filter) { identifier.named(:identifier) >> colon >> value.named(:value) }

    rule(:identifier) { (match(/[a-zA-Z]/) >> match(/[a-zA-Z0-9._-]+/).maybe) | string }
    rule(:value) { match(/[a-zA-Z0-9._-]+/) | string }
    rule(:string) {
      str('"') >> (
        str("\\") >> any | str('"').absent >> any
      ).repeat >> str('"')
    }

    rule(:lparen) { str("(") }
    rule(:rparen) { str(")") }

    rule(:and_op) { str("and") | str("AND") }
    rule(:or_op) { str("or") | str("OR") }

    rule(:colon) { str(":") }
    rule(:space) { match(/\s/).repeat(1) }
    rule(:space?) { match(/\s+/).maybe }
  end
end