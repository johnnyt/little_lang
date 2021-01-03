defmodule LittleLang.Evaluator.RelExprTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  test "evaluates = expression with ints" do
    assert true ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["compare", "EQ"]],
               %{"a" => 42, "b" => 42}
             )

    assert false ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["compare", "EQ"]],
               %{"a" => 1, "b" => 42}
             )
  end

  test "evaluates = expression with strings" do
    assert true ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["compare", "EQ"]],
               %{"a" => "foo", "b" => "foo"}
             )

    assert false ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["compare", "EQ"]],
               %{"a" => "foo", "b" => "bar"}
             )
  end

  test "= results in undefined if either operand is undefined" do
    assert :undefined ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["compare", "EQ"]],
               %{"b" => 42}
             )

    assert :undefined ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["compare", "EQ"]],
               %{"a" => 1}
             )
  end

  test "= results in undefined if types don't match" do
    assert :undefined ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["compare", "EQ"]],
               %{"a" => true, "b" => 42}
             )
  end
end
