defmodule LittleLang.EvaluatorTest do
  use ExUnit.Case

  alias LittleLang.Evaluator

  doctest Evaluator

  describe "build_context/1" do
    test "includes true and false" do
      assert %{"true" => true} = Evaluator.build_context()
      assert %{"false" => false} = Evaluator.build_context()
    end

    test "merges builds over provided context" do
      assert %{"true" => true} = Evaluator.build_context(%{"true" => "foo"})
    end

    test "includes provided context" do
      assert %{"name" => "Bob"} = Evaluator.build_context(%{"name" => "Bob"})
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
