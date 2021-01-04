defmodule LittleLang.Evaluator.AddTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  test "evaluates add instruction with ints" do
    assert 7 ==
             Evaluator.process([
               ["lit", 3],
               ["lit", 4],
               ["add"]
             ])
  end

  test "evaluates add instruction with strings" do
    assert "foo@bar.com" ==
             Evaluator.process([
               ["lit", "foo"],
               ["lit", "@bar.com"],
               ["add"]
             ])
  end

  test "+ results in undefined if either operand is undefined" do
    assert :undefined ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["add"]],
               %{"b" => 42}
             )

    assert :undefined ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["add"]],
               %{"a" => 1}
             )
  end

  test "+ results in undefined if types don't match" do
    assert :undefined ==
             Evaluator.process(
               [["load", "a"], ["load", "b"], ["add"]],
               %{"a" => true, "b" => 42}
             )
  end
end
