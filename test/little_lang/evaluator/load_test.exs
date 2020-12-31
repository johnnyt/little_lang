defmodule LittleLang.Evaluator.BinaryExprTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  test "if the key is present, pushes the value onto the stack" do
    assert 42 == Evaluator.process([["load", "a"]], %{"a" => 42})
  end

  test "if the key is 'undefined', pushes undefined onto the stack" do
    assert :undefined == Evaluator.process([["load", "undefined"]])
  end

  test "if the key is not present, pushes undefined onto the stack" do
    assert :undefined == Evaluator.process([["load", "foo"]])
  end
end
