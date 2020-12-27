defmodule LittleLang.LexerTest do
  use ExUnit.Case

  alias LittleLang.Lexer

  doctest Lexer

  test "tokenize! returns unwrapped tokens" do
    assert [{:identifier, 1, "true"}] = Lexer.tokenize!("true")
  end

  test "lexes identifiers" do
    assert {:ok, [{:identifier, 1, "true"}]} = Lexer.tokenize("true")
    assert {:ok, [{:identifier, 1, "false"}]} = Lexer.tokenize("false")
    assert {:ok, [{:identifier, 1, "undefined"}]} = Lexer.tokenize("undefined")

    assert {:ok, [{:identifier, 1, "var_1"}]} = Lexer.tokenize("var_1")
    assert {:ok, [{:identifier, 1, "_var"}]} = Lexer.tokenize("_var")
    assert {:ok, [{:identifier, 1, "Var_"}]} = Lexer.tokenize("Var_")
  end

  test "does not lex invalid identifiers" do
    refute {:ok, [{:identifier, 1, "1var"}]} == Lexer.tokenize("1var")
  end

  test "lexes integer" do
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.tokenize("1")
    assert {:ok, [{:int_lit, 1, 42}]} = Lexer.tokenize("42")
    assert {:ok, [{:int_lit, 1, 314_159_265_358_979_323}]} = Lexer.tokenize("314159265358979323")
  end

  test "lexes and removes whitespace" do
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.tokenize(" 1")
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.tokenize("1\t")
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.tokenize("\r1\n")
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.tokenize("  \t \r\t 1\r\n\t  \t")

    assert {:ok, [{:int_lit, 1, 42}, {:int_lit, 1, 43}]} = Lexer.tokenize("42\t43")
  end

  test "lexes and removes comments" do
    assert {:ok, [{:int_lit, 1, 42}]} = Lexer.tokenize("42 # Single line comment")
  end

  test "lexes unary operators" do
    assert {:ok, [{:op, 1, :+}]} = Lexer.tokenize("+")
    assert {:ok, [{:op, 1, :-}]} = Lexer.tokenize("-")
    assert {:ok, [{:op, 1, :!}]} = Lexer.tokenize("!")
    assert {:ok, [{:op, 1, :not}]} = Lexer.tokenize("not")

    assert {:ok, [{:op, 1, :-}, {:int_lit, 1, 42}]} = Lexer.tokenize("-42")
  end

  test "lexes binary operators" do
    assert {:ok, [{:op, 1, :=}]} = Lexer.tokenize("=")
    assert {:ok, [{:op, 1, :!=}]} = Lexer.tokenize("!=")
    assert {:ok, [{:op, 1, :>}]} = Lexer.tokenize(">")
    assert {:ok, [{:op, 1, :>=}]} = Lexer.tokenize(">=")
    assert {:ok, [{:op, 1, :<}]} = Lexer.tokenize("<")
    assert {:ok, [{:op, 1, :<=}]} = Lexer.tokenize("<=")
    assert {:ok, [{:op, 1, :is}]} = Lexer.tokenize("is")
    assert {:ok, [{:op, 1, :"is not"}]} = Lexer.tokenize("is not")

    assert {:ok, [{:int_lit, 1, 42}, {:op, 1, :=}, {:int_lit, 1, 42}]} = Lexer.tokenize("42 = 42")
  end
end
