defmodule LittleLang.Visitors.StringVisitorTest do
  use ExUnit.Case

  alias LittleLang.Parser
  alias LittleLang.Visitors.StringVisitor

  test "boolean literal" do
    source = "true"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)

    source = "false"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "integer literal" do
    source = "42"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "string literal" do
    source = ~s["this is a string"]
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "identifier" do
    source = "foo"
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

  test "unary_op integer" do
    source = "-42"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "group_expr" do
    source = "(true)"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "identifier logical_op identifier" do
    source = "a or b"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "identifier equals identifier" do
    source = "a = b"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "identifier + identifier" do
    source = "a + b"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "call_expr" do
    source = "min(a, b)"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "blank ListLit" do
    source = "[]"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end

  test "ListLit" do
    source = "[1, 2]"
    {:ok, ast} = Parser.process(source)
    assert source == StringVisitor.accept(ast)
  end
end
