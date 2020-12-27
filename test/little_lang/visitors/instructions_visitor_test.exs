defmodule LittleLang.Visitors.InstructionsVisitorTest do
  use ExUnit.Case

  alias LittleLang.Parser
  alias LittleLang.Visitors.InstructionsVisitor

  test "boolean" do
    source = "true"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "true"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end
end
