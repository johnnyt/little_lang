defmodule LittleLang.Evaluator.UnaryExprTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  test "evaluates unary_op integer" do
    assert -42 ==
             Evaluator.process([
               ["lit", 42],
               ["minus"]
             ])
  end

  test "evaluates unary_op identifier" do
    assert 42 ==
             Evaluator.process(
               [
                 ["load", "the_negative_number"],
                 ["minus"]
               ],
               %{"the_negative_number" => -42}
             )
  end
end
