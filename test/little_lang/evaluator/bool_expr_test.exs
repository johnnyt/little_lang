defmodule LittleLang.Evaluator.BoolExprTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  test "evaluates basic boolean expression" do
    assert true ==
             Evaluator.process([
               ["load", "true"],
               ["bool_expr"]
             ])

    assert false ==
             Evaluator.process([
               ["load", "false"],
               ["bool_expr"]
             ])
  end

  test "evaluates undefined" do
    assert :undefined ==
             Evaluator.process([
               ["load", "undefined"],
               ["bool_expr"]
             ])
  end

  test "converts any non-boolean value to :undefined" do
    assert :undefined ==
             Evaluator.process([
               ["load", "foo"],
               ["bool_expr"]
             ])
  end
end
