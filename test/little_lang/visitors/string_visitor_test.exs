defmodule LittleLang.Visitors.StringVisitorTest do
  use ExUnit.Case

  alias LittleLang.Parser
  alias LittleLang.Visitors.StringVisitor

  test "boolean" do
    source = "true"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "unary_op boolean" do
    source = "!true"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)

    source = "not true"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "identifier logical_op identifier" do
    source = "a or b"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "call_expr" do
    source = "min(a, b)"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end
end
