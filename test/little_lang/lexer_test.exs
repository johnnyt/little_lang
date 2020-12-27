defmodule LittleLang.LexerTest do
  use ExUnit.Case

  alias LittleLang.Lexer

  doctest Lexer

  test "lexes integer" do
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.lex("1")
    assert {:ok, [{:int_lit, 1, 42}]} = Lexer.lex("42")
    assert {:ok, [{:int_lit, 1, 314_159_265_358_979_323}]} = Lexer.lex("314159265358979323")
  end

  test "lexes and removes whitespace" do
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.lex(" 1")
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.lex("1\t")
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.lex("\r1\n")
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.lex("  \t \r\t 1\r\n\t  \t")

    assert {:ok, [{:int_lit, 1, 42}, {:int_lit, 1, 43}]} = Lexer.lex("42\t43")
  end

  test "lexes and removes comments" do
    assert {:ok, [{:int_lit, 1, 42}]} = Lexer.lex("42 # Single line comment")
  end

  test "lexes unary operators" do
    assert {:ok, [{:op, 1, :+}]} = Lexer.lex("+")
    assert {:ok, [{:op, 1, :-}]} = Lexer.lex("-")
    assert {:ok, [{:op, 1, :!}]} = Lexer.lex("!")
    assert {:ok, [{:op, 1, :not}]} = Lexer.lex("not")

    assert {:ok, [{:op, 1, :-}, {:int_lit, 1, 42}]} = Lexer.lex("-42")
  end

  test "lexes binary operators" do
    assert {:ok, [{:op, 1, :=}]} = Lexer.lex("=")
    assert {:ok, [{:op, 1, :!=}]} = Lexer.lex("!=")
    assert {:ok, [{:op, 1, :>}]} = Lexer.lex(">")
    assert {:ok, [{:op, 1, :>=}]} = Lexer.lex(">=")
    assert {:ok, [{:op, 1, :<}]} = Lexer.lex("<")
    assert {:ok, [{:op, 1, :<=}]} = Lexer.lex("<=")
    assert {:ok, [{:op, 1, :is}]} = Lexer.lex("is")
    assert {:ok, [{:op, 1, :"is not"}]} = Lexer.lex("is not")

    assert {:ok, [{:int_lit, 1, 42}, {:op, 1, :=}, {:int_lit, 1, 42}]} = Lexer.lex("42 = 42")
  end
end
