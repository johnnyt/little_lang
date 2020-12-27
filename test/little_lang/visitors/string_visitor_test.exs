defmodule LittleLang.Visitors.StringVisitorTest do
  use ExUnit.Case

  alias LittleLang.Parser
  alias LittleLang.Visitors.StringVisitor

  test "boolean" do
    source = "true"
    {:ok, ast} = Parser.parse(source)
    assert source == StringVisitor.accept(ast)
  end
end
