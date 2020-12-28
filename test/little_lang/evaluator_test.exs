defmodule LittleLang.EvaluatorTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  describe "build_context/1" do
    test "includes true and false" do
      assert %{"true" => true} = Evaluator.build_context()
      assert %{"false" => false} = Evaluator.build_context()
    end

    test "includes undefined" do
      assert %{"undefined" => :undefined} = Evaluator.build_context()
    end

    test "merges builds over provided context" do
      assert %{"true" => true} = Evaluator.build_context(%{"true" => "foo"})
    end

    test "includes provided context" do
      assert %{"name" => "Bob"} = Evaluator.build_context(%{"name" => "Bob"})
    end
  end
end
