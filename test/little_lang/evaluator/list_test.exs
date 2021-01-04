defmodule LittleLang.Evaluator.ListTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  test "evaluates list with different types" do
    assert [:undefined, 42, "foo"] ==
             Evaluator.process([
               ["lit", []],
               ["load", "a"],
               ["append"],
               ["lit", 42],
               ["append"],
               ["lit", "foo"],
               ["append"]
             ])
  end
end
