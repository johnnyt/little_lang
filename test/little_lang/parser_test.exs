defmodule LittleLang.ParserTest do
  use ExUnit.Case, async: true

  alias LittleLang.Parser

  doctest Parser

  test "parses basic boolean expression" do
    assert {:bool_expr, {:identifier, "true"}} = Parser.process!("true")
  end

  test "parses unary op and expression" do
    assert {:bool_expr, {:unary_expr, {:bang, "!"}, {:identifier, "true"}}} =
             Parser.process!("!true")

    assert {:bool_expr, {:unary_expr, {:not, "not"}, {:identifier, "true"}}} =
             Parser.process!("not true")
  end

  test "parses binary expression" do
    assert {:bool_expr, {:binary_expr, {:or, "or"}, {:identifier, "a"}, {:identifier, "b"}}} =
             Parser.process!("a or b")

    assert {:bool_expr,
            {:binary_expr, {:or, "or"}, {:identifier, "a"},
             {:unary_expr, {:bang, "!"}, {:identifier, "b"}}}} = Parser.process!("a or !b")
  end

  test "parses call expression" do
    assert {:bool_expr,
            {:call_expr, {:identifier, "min"}, [{:identifier, "a"}, {:identifier, "b"}]}} =
             Parser.process!("min(a, b)")

    assert {:bool_expr,
            {:call_expr, {:identifier, "min"},
             [{:identifier, "a"}, {:unary_expr, {:bang, "!"}, {:identifier, "b"}}]}} =
             Parser.process!("min(a, !b)")
  end
end
