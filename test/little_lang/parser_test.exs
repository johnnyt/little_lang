defmodule LittleLang.ParserTest do
  use ExUnit.Case, async: true

  alias LittleLang.Parser

  doctest Parser

  test "parses basic boolean expression" do
    assert {:bool_expr, {:bool_lit, true}} = Parser.process!("true")
  end

  test "parses unary op and expression" do
    assert {:bool_expr, {:unary_expr, {:bang, "!"}, {:identifier, "foo"}}} =
             Parser.process!("!foo")

    assert {:bool_expr, {:unary_expr, {:not, "not"}, {:identifier, "foo"}}} =
             Parser.process!("not foo")

    assert {:bool_expr, {:unary_expr, {:minus, "-"}, {:int_lit, 42}}} = Parser.process!("-42")
  end

  test "parses binary expression" do
    assert {:bool_expr,
            {
              :binary_expr,
              {:or, "or"},
              {:identifier, "a"},
              {:identifier, "b"}
            }} = Parser.process!("a or b")

    assert {:bool_expr,
            {
              :binary_expr,
              {:equals, "="},
              {:identifier, "a"},
              {:identifier, "b"}
            }} = Parser.process!("a = b")

    assert {:bool_expr,
            {
              :binary_expr,
              {:plus, "+"},
              {:identifier, "a"},
              {:identifier, "b"}
            }} = Parser.process!("a + b")

    assert {:bool_expr,
            {
              :binary_expr,
              {:minus, "-"},
              {:identifier, "a"},
              {:identifier, "b"}
            }} = Parser.process!("a - b")

    assert {:bool_expr,
            {
              :binary_expr,
              {:or, "or"},
              {:identifier, "a"},
              {:unary_expr, {:bang, "!"}, {:identifier, "b"}}
            }} = Parser.process!("a or !b")
  end

  test "parses grouping binary expressions" do
    assert {:bool_expr,
            {
              :binary_expr,
              {:or, "or"},
              {:identifier, "a"},
              {:group_expr, {:binary_expr, {:or, "or"}, {:identifier, "b"}, {:identifier, "c"}}}
            }} = Parser.process!("a or (b or c)")

    assert {:bool_expr,
            {
              :binary_expr,
              {:or, "or"},
              {:group_expr, {:binary_expr, {:or, "or"}, {:identifier, "a"}, {:identifier, "b"}}},
              {:identifier, "c"}
            }} = Parser.process!("(a or b) or c")
  end

  test "parses call expression" do
    assert {:bool_expr,
            {
              :call_expr,
              {:identifier, "min"},
              [{:identifier, "a"}, {:identifier, "b"}]
            }} = Parser.process!("min(a, b)")

    assert {:bool_expr,
            {
              :call_expr,
              {:identifier, "min"},
              [{:identifier, "a"}, {:unary_expr, {:bang, "!"}, {:identifier, "b"}}]
            }} = Parser.process!("min(a, !b)")
  end
end
