defmodule LittleLang.EvaluatorTest do
  use ExUnit.Case

  alias LittleLang.Evaluator

  doctest Evaluator

  describe "default_context/0" do
    test "includes true and false" do
      assert %{"true" => true} = Evaluator.default_context()
      assert %{"false" => false} = Evaluator.default_context()
    end
  end

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
