defmodule LittleLang.EvaluatorTest do
  use ExUnit.Case, async: true

  alias LittleLang.Evaluator

  doctest Evaluator

  describe "build_context/1" do
    test "includes undefined" do
      assert %{"undefined" => :undefined} = Evaluator.build_context()
    end

    test "merges builds over provided context" do
      assert %{"undefined" => :undefined} = Evaluator.build_context(%{"undefined" => "foo"})
    end

    test "includes provided context" do
      assert %{"name" => "Bob"} = Evaluator.build_context(%{"name" => "Bob"})
    end
  end
end
