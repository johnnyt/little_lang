defmodule LittleLang.Evaluator.CallExprTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  test "evaluates basic call expression" do
    assert true ==
             Evaluator.process([
               ["call", "tru", 0],
               ["bool_expr"]
             ])
  end
end
