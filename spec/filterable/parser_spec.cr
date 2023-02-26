require "../spec_helper"

describe Filterable::Parser do
  it "parses" do
    Filterable::Parser.new.parse("env:prod")
    Filterable::Parser.new.parse("http.status_code:200")
    Filterable::Parser.new.parse("http.status_code:200OK")
    Filterable::Parser.new.parse("\"key with space\":prod")
    Filterable::Parser.new.parse("\"key with space\":\"value with space\"")
  end

  it "OR" do
    Filterable::Parser.new.parse("env:prod OR http_status:200")
    Filterable::Parser.new.parse("(env:prod OR http_status:200)")
    Filterable::Parser.new.parse("env:prod or http_status:200")
    Filterable::Parser.new.parse("(env:prod or http_status:200)")
  end

  it "AND" do
    Filterable::Parser.new.parse("env:prod AND http_status:200")
    Filterable::Parser.new.parse("(env:prod AND http_status:200)")
    Filterable::Parser.new.parse("(env:prod AND http_status:200) AND foo:bar")
    Filterable::Parser.new.parse("env:prod and http_status:200")
    Filterable::Parser.new.parse("(env:prod and http_status:200)")
    Filterable::Parser.new.parse("(env:prod and http_status:200) AND foo:bar")

    Filterable::Parser.new.parse("env:prod http_status:200")
    Filterable::Parser.new.parse("(env:prod http_status:200)")
    Filterable::Parser.new.parse("(env:prod http_status:200) foo:bar")
    Filterable::Parser.new.parse("env:prod http_status:200")
    Filterable::Parser.new.parse("(env:prod http_status:200)")
    Filterable::Parser.new.parse("(env:prod http_status:200) foo:bar")
  end

  it "AND and OR" do
    Filterable::Parser.new.parse("env:prod AND http_status:200 OR foo:bar")
    Filterable::Parser.new.parse("(env:prod AND http_status:200) OR foo:bar")
    Filterable::Parser.new.parse("(env:prod OR http_status:200) AND foo:bar")
  end
end