defmodule LittleLang.Visitors.StringVisitorTest do
  use ExUnit.Case

  alias LittleLang.Parser
  alias LittleLang.Visitors.StringVisitor

  test "boolean" do
    source = "true"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end
end
