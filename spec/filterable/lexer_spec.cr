require "../spec_helper"

describe Filterable::Lexer do
  it "ident" do
    lexer = Filterable::Lexer.new("env")

    token = lexer.next_token
    token.type.should eq(Filterable::Token::Kind::IDENT)
    token.value.should eq("env")
  end

  it "string" do
    lexer = Filterable::Lexer.new("\"env test\"")

    token = lexer.next_token
    token.type.should eq(Filterable::Token::Kind::STRING)
    token.value.should eq("env test")
  end

  it "colon" do
    lexer = Filterable::Lexer.new(":")
    lexer.next_token.type.should eq(Filterable::Token::Kind::COLON)
  end

  it "space" do
    lexer = Filterable::Lexer.new("    ")
    lexer.next_token.type.should eq(Filterable::Token::Kind::SPACE)

    lexer = Filterable::Lexer.new(" ")
    lexer.next_token.type.should eq(Filterable::Token::Kind::SPACE)
  end

  it "eof" do
    lexer = Filterable::Lexer.new("")
    lexer.next_token.type.should eq(Filterable::Token::Kind::EOF)
  end

  it "tag" do
    lexer = Filterable::Lexer.new("env:prod")

    token = lexer.next_token
    token.type.should eq(Filterable::Token::Kind::IDENT)
    token.value.should eq("env")

    lexer.next_token.type.should eq(Filterable::Token::Kind::COLON)

    token = lexer.next_token
    token.type.should eq(Filterable::Token::Kind::IDENT)
    token.value.should eq("prod")

    lexer.next_token.type.should eq(Filterable::Token::Kind::EOF)
  end

  it "tags" do
    lexer = Filterable::Lexer.new("env:prod http.status_code:200")

    token = lexer.next_token
    token.type.should eq(Filterable::Token::Kind::IDENT)
    token.value.should eq("env")

    lexer.next_token.type.should eq(Filterable::Token::Kind::COLON)

    token = lexer.next_token
    token.type.should eq(Filterable::Token::Kind::IDENT)
    token.value.should eq("prod")

    lexer.next_token.type.should eq(Filterable::Token::Kind::SPACE)

    token = lexer.next_token
    token.type.should eq(Filterable::Token::Kind::IDENT)
    token.value.should eq("http.status_code")

    lexer.next_token.type.should eq(Filterable::Token::Kind::COLON)

    token = lexer.next_token
    token.type.should eq(Filterable::Token::Kind::IDENT)
    token.value.should eq("200")

    lexer.next_token.type.should eq(Filterable::Token::Kind::EOF)
  end

  it "unexpected" do
    lexer = Filterable::Lexer.new("-")

    expect_raises(Exception) do
      lexer.next_token
    end
  end
end
