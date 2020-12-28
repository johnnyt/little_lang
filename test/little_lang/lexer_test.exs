defmodule LittleLang.LexerTest do
  use ExUnit.Case, async: true

  alias LittleLang.Lexer

  doctest Lexer

  test "process! returns unwrapped tokens" do
    assert [{:identifier, 1, "true"}] = Lexer.process!("true")
  end

  test "lexes and removes whitespace" do
    assert {:ok, [{:identifier, 1, "true"}]} = Lexer.process(" true")
    assert {:ok, [{:identifier, 1, "true"}]} = Lexer.process("true\t")
    assert {:ok, [{:identifier, 1, "true"}]} = Lexer.process("\rtrue\n")
    assert {:ok, [{:identifier, 1, "true"}]} = Lexer.process("  \t \r\t true\r\n\t  \t")

    assert {:ok, [{:identifier, 1, "true"}, {:identifier, 1, "false"}]} =
             Lexer.process("true\t false")
  end

  test "lexes and removes comments" do
    assert {:ok, [{:identifier, 1, "true"}]} = Lexer.process("true # Single line comment")
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
    assert {:error, :invalid_char, _message} = Lexer.process("1var")
  end

  test "lexes unary operators" do
    assert {:ok, [{:bang, 1, "!"}]} = Lexer.process("!")
    assert {:ok, [{:not_, 1, "not"}]} = Lexer.process("not")
    assert {:ok, [{:bang, 1, "!"}, {:identifier, 1, "true"}]} = Lexer.process("!true")
  end
end
