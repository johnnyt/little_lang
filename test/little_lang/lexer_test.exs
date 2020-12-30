defmodule LittleLang.LexerTest do
  use ExUnit.Case, async: true

  alias LittleLang.Lexer

  doctest Lexer

  test "process returns wrapped tokens" do
    assert {:ok, [{:bool_lit, 1, true}]} = Lexer.process("true")
  end

  test "process! returns unwrapped tokens" do
    assert [{:bool_lit, 1, true}] = Lexer.process!("true")
  end

  test "lexes true" do
    assert [{:bool_lit, 1, true}] = Lexer.process!("true")
  end

  test "lexes identifiers containing keyworkds" do
    assert [{:identifier, 1, "atrue"}] = Lexer.process!("atrue")
    assert [{:identifier, 1, "trueA"}] = Lexer.process!("trueA")
  end

  test "lexes and removes whitespace" do
    assert [{:identifier, 1, "foo"}] = Lexer.process!(" foo")
    assert [{:identifier, 1, "foo"}] = Lexer.process!("foo\t")
    assert [{:identifier, 1, "foo"}] = Lexer.process!("\rfoo\n")
    assert [{:identifier, 1, "foo"}] = Lexer.process!("  \t \r\t foo\r\n\t  \t")

    assert [{:identifier, 1, "foo"}, {:identifier, 1, "bar"}] = Lexer.process!("foo\t bar")
  end

  test "lexes and removes comments" do
    assert [{:identifier, 1, "foo"}] = Lexer.process!("foo # Single line comment")
  end

  test "lexes identifiers" do
    assert [{:identifier, 1, "foo"}] = Lexer.process!("foo")
    assert [{:identifier, 1, "bar"}] = Lexer.process!("bar")
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
    assert [{:bang, 1, "!"}, {:identifier, 1, "foo"}] = Lexer.process!("!foo")
  end

  test "lexes binary operators" do
    assert [{:or, 1, "or"}] = Lexer.process!("or")
  end

  test "lexes parens" do
    assert [{:open_paren, 1, "("}, {:close_paren, 1, ")"}] = Lexer.process!("()")
  end

  test "lexes comma" do
    assert [{:comma, 1, ","}] = Lexer.process!(",")
  end
end
