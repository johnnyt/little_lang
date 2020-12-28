defmodule LittleLang.ParserTest do
  use ExUnit.Case, async: true

  alias LittleLang.Parser

  doctest Parser

  test "parses basic boolean expression" do
    assert {:ok, {:bool_expr, {:expression, {:unary_expr, {:basic_expr, {:identifier, "true"}}}}}} =
             Parser.process("true")
  end

  test "parses unary op and expression" do
    assert {:ok,
            {:bool_expr,
             {:expression,
              {:not_, {:unary_expr, {:basic_expr, {:identifier, "true"}}}, {:bang, "!"}}}}} =
             Parser.process("!true")

    assert {:ok,
            {:bool_expr,
             {:expression,
              {:not_, {:unary_expr, {:basic_expr, {:identifier, "true"}}}, {:not_, "not"}}}}} =
             Parser.process("not true")
  end
end
