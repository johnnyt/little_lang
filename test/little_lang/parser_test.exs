defmodule LittleLang.ParserTest do
  use ExUnit.Case

  alias LittleLang.Parser

  doctest Parser

  test "parses basic boolean expression" do
    assert {:ok, {:bool_expr, {:expression, {:identifier, "true"}}}} = Parser.parse("true")
  end
end
