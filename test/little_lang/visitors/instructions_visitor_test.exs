defmodule LittleLang.Visitors.InstructionsVisitorTest do
  use ExUnit.Case

  alias LittleLang.Parser
  alias LittleLang.Visitors.InstructionsVisitor

  test "identifier" do
    source = "true"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "true"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "unary_op identifier" do
    source = "!true"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "true"],
             ["not"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)

    source = "not true"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "true"],
             ["not"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end

  test "identifier or identifier" do
    source = "true or false"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "true"],
             ["jtrue", 1],
             ["load", "false"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)

    source = "true or !false"
    {:ok, ast} = Parser.process(source)

    assert [
             ["load", "true"],
             ["jtrue", 2],
             ["load", "false"],
             ["not"],
             ["bool_expr"]
           ] = InstructionsVisitor.accept(ast)
  end
end
