defmodule LittleLang.Visitors.InstructionsVisitorTest do
  use ExUnit.Case

  alias LittleLang.Parser
  alias LittleLang.Visitors.InstructionsVisitor

  test "boolean literal" do
    source = "true"
    {:ok, ast} = Parser.process(source)

    assert [
             ["lit", true],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "integer literal" do
    source = "42"
    {:ok, ast} = Parser.process(source)

    assert [
             ["lit", 42],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "identifier" do
    source = "foo"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "foo"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "unary_op boolean" do
    source = "!foo"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "foo"],
             ["not"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)

    source = "not foo"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "foo"],
             ["not"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "unary_op integer" do
    source = "-42"
    {:ok, ast} = Parser.process(source)

    assert [
             ["lit", 42],
             ["minus"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "identifier = identifier" do
    source = "foo = bar"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "foo"],
             ["load", "bar"],
             ["compare", "EQ"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)

    source = "foo or !bar"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "foo"],
             ["jtrue", 2],
             ["load", "bar"],
             ["not"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "identifier + identifier" do
    source = "foo + bar"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "foo"],
             ["load", "bar"],
             ["add"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "identifier - identifier" do
    source = "foo - bar"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "foo"],
             ["load", "bar"],
             ["subtract"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "identifier or identifier" do
    source = "foo or bar"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "foo"],
             ["jtrue", 1],
             ["load", "bar"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)

    source = "foo or !bar"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "foo"],
             ["jtrue", 2],
             ["load", "bar"],
             ["not"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "call expression with no arguments" do
    source = "tru()"
    {:ok, ast} = Parser.process(source)

    assert [
             ["call", "tru", 0],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "call expression" do
    source = "min(a, !b)"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "a"],
             ["load", "b"],
             ["not"],
             ["call", "min", 2],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "group expression" do
    source = "a or (b or c)"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "a"],
             ["jtrue", 3],
             ["load", "b"],
             ["jtrue", 1],
             ["load", "c"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)

    source = "(a or b) or c"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "a"],
             ["jtrue", 1],
             ["load", "b"],
             ["jtrue", 1],
             ["load", "c"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end
end
