defmodule LittleLang.Evaluator.NotTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  test "evaluates not operation for booleans" do
    assert false ==
             Evaluator.process([
               ["load", "true"],
               ["not"],
               ["bool_expr"]
             ])

    assert true ==
             Evaluator.process([
               ["load", "false"],
               ["not"],
               ["bool_expr"]
             ])

    assert true ==
             Evaluator.process([
               ["load", "true"],
               ["not"],
               ["not"],
               ["bool_expr"]
             ])
  end

  test "not operation for non-booleans results in undefined" do
    assert :undefined ==
             Evaluator.process([
               ["load", "foo"],
               ["not"]
             ])
  end
end
