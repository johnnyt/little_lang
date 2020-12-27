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
    instructions = [
      ["load", "true"],
      ["bool_expr"]
    ]

    assert true = Evaluator.process(instructions)
  end
end
