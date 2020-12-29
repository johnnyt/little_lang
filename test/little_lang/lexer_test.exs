defmodule LittleLang.LexerTest do
  use ExUnit.Case, async: true

  alias LittleLang.Lexer

  doctest Lexer

  test "process returns wrapped tokens" do
    assert {:ok, [{:identifier, 1, "true"}]} = Lexer.process("true")
  end

  test "process! returns unwrapped tokens" do
    assert [{:identifier, 1, "true"}] = Lexer.process!("true")
  end

  test "lexes and removes whitespace" do
    assert [{:identifier, 1, "true"}] = Lexer.process!(" true")
    assert [{:identifier, 1, "true"}] = Lexer.process!("true\t")
    assert [{:identifier, 1, "true"}] = Lexer.process!("\rtrue\n")
    assert [{:identifier, 1, "true"}] = Lexer.process!("  \t \r\t true\r\n\t  \t")

    assert [{:identifier, 1, "true"}, {:identifier, 1, "false"}] = Lexer.process!("true\t false")
  end

  test "lexes and removes comments" do
    assert [{:identifier, 1, "true"}] = Lexer.process!("true # Single line comment")
  end

  test "lexes identifiers" do
    assert [{:identifier, 1, "true"}] = Lexer.process!("true")
    assert [{:identifier, 1, "false"}] = Lexer.process!("false")
    assert [{:identifier, 1, "undefined"}] = Lexer.process!("undefined")

    assert [{:identifier, 1, "var_1"}] = Lexer.process!("var_1")
    assert [{:identifier, 1, "_var"}] = Lexer.process!("_var")
    assert [{:identifier, 1, "Var_"}] = Lexer.process!("Var_")
  end

  test "does not lex invalid identifiers" do
    assert {:error, :invalid_char, _message} = Lexer.process("1var")
  end

  test "lexes unary operators" do
    assert [{:bang, 1, "!"}] = Lexer.process!("!")
    assert [{:not, 1, "not"}] = Lexer.process!("not")
    assert [{:bang, 1, "!"}, {:identifier, 1, "true"}] = Lexer.process!("!true")
  end

  test "lexes binary operators" do
    assert [{:or, 1, "or"}] = Lexer.process!("or")
  end
end
