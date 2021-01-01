defmodule LittleLang.Evaluator.SubtractTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  test "evaluates subtract instruction" do
    assert -1 ==
             Evaluator.process([
               ["lit", 3],
               ["lit", 4],
               ["subtract"]
             ])
  end

  test "- results in undefined if either operand is undefined" do
    assert :undefined ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["subtract"]],
               %{"b" => 42}
             )

    assert :undefined ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["subtract"]],
               %{"a" => 1}
             )
  end

  test "- results in undefined if types don't match" do
    assert :undefined ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["subtract"]],
               %{"a" => true, "b" => 42}
             )
  end
end
