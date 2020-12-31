defmodule LittleLang.Evaluator.BinaryExprTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  test "evaluates or expression" do
    assert true ==
             Evaluator.process([
               ["load", "true"],
               ["jtrue", 1],
               ["load", "false"],
               ["bool_expr"]
             ])

    assert true ==
             Evaluator.process([
               ["load", "false"],
               ["jtrue", 1],
               ["load", "true"],
               ["bool_expr"]
             ])
  end
end
