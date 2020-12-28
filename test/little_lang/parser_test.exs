defmodule LittleLang.ParserTest do
  use ExUnit.Case, async: true

  alias LittleLang.Parser

  doctest Parser

  test "parses basic boolean expression" do
    assert {:ok, {:bool_expr, {:expression, {:unary_expr, {:basic_expr, {:identifier, "true"}}}}}} =
             Parser.process("true")
  end
end
