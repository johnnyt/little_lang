defmodule LittleLang.LexerTest do
  use ExUnit.Case, async: true

  alias LittleLang.Lexer

  doctest Lexer

  test "process! returns unwrapped tokens" do
    assert [{:identifier, 1, "true"}] = Lexer.process!("true")
  end

  test "lexes identifiers" do
    assert {:ok, [{:identifier, 1, "true"}]} = Lexer.process("true")
    assert {:ok, [{:identifier, 1, "false"}]} = Lexer.process("false")
    assert {:ok, [{:identifier, 1, "undefined"}]} = Lexer.process("undefined")

    assert {:ok, [{:identifier, 1, "var_1"}]} = Lexer.process("var_1")
    assert {:ok, [{:identifier, 1, "_var"}]} = Lexer.process("_var")
    assert {:ok, [{:identifier, 1, "Var_"}]} = Lexer.process("Var_")
  end

  test "does not lex invalid identifiers" do
    refute {:ok, [{:identifier, 1, "1var"}]} == Lexer.process("1var")
  end

  test "lexes integer" do
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.process("1")
    assert {:ok, [{:int_lit, 1, 42}]} = Lexer.process("42")
    assert {:ok, [{:int_lit, 1, 314_159_265_358_979_323}]} = Lexer.process("314159265358979323")
  end

  test "lexes and removes whitespace" do
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.process(" 1")
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.process("1\t")
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.process("\r1\n")
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.process("  \t \r\t 1\r\n\t  \t")

    assert {:ok, [{:int_lit, 1, 42}, {:int_lit, 1, 43}]} = Lexer.process("42\t43")
  end

  test "lexes and removes comments" do
    assert {:ok, [{:int_lit, 1, 42}]} = Lexer.process("42 # Single line comment")
  end

  test "lexes unary operators" do
    assert {:ok, [{:op, 1, :+}]} = Lexer.process("+")
    assert {:ok, [{:op, 1, :-}]} = Lexer.process("-")
    assert {:ok, [{:op, 1, :!}]} = Lexer.process("!")
    assert {:ok, [{:op, 1, :not}]} = Lexer.process("not")

    assert {:ok, [{:op, 1, :-}, {:int_lit, 1, 42}]} = Lexer.process("-42")
  end

  test "lexes binary operators" do
    assert {:ok, [{:op, 1, :=}]} = Lexer.process("=")
    assert {:ok, [{:op, 1, :!=}]} = Lexer.process("!=")
    assert {:ok, [{:op, 1, :>}]} = Lexer.process(">")
    assert {:ok, [{:op, 1, :>=}]} = Lexer.process(">=")
    assert {:ok, [{:op, 1, :<}]} = Lexer.process("<")
    assert {:ok, [{:op, 1, :<=}]} = Lexer.process("<=")
    assert {:ok, [{:op, 1, :is}]} = Lexer.process("is")
    assert {:ok, [{:op, 1, :"is not"}]} = Lexer.process("is not")

    assert {:ok, [{:int_lit, 1, 42}, {:op, 1, :=}, {:int_lit, 1, 42}]} = Lexer.process("42 = 42")
  end
end
