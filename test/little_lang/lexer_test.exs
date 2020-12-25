defmodule LittleLang.LexerTest do
  use ExUnit.Case

  alias LittleLang.Lexer

  doctest Lexer

  test "lex integer" do
    assert {:ok, [{:int_lit, 1, 1}]} = Lexer.lex("1")
    assert {:ok, [{:int_lit, 1, 42}]} = Lexer.lex("42")
    assert {:ok, [{:int_lit, 1, 314_159_265_358_979_323}]} = Lexer.lex("314159265358979323")
  end
end
