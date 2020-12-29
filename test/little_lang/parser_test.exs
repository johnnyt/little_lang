defmodule LittleLang.ParserTest do
  use ExUnit.Case, async: true

  alias LittleLang.Parser

  doctest Parser

  test "parses basic boolean expression" do
    assert {:ok, {:bool_expr, {:expression, {:unary_expr, {:basic_expr, {:identifier, "true"}}}}}} =
             Parser.process("true")
  end

  test "parses unary op and expression" do
    assert {:bool_expr,
            {:expression,
             {:not, {:unary_expr, {:basic_expr, {:identifier, "true"}}}, {:bang, "!"}}}} =
             Parser.process!("!true")

    assert {:bool_expr,
            {:expression,
             {:not, {:unary_expr, {:basic_expr, {:identifier, "true"}}}, {:not, "not"}}}} =
             Parser.process!("not true")
  end

  test "parses binary expression" do
    assert {:bool_expr,
            {:expression, {:expression, {:unary_expr, {:basic_expr, {:identifier, "a"}}}},
             {:expression, {:unary_expr, {:basic_expr, {:identifier, "b"}}}},
             {:or, "or"}}} = Parser.process!("a or b")
  end
end
