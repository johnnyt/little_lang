defmodule LittleLang.ExternalFunctionsTest do
  use ExUnit.Case, async: true

  alias LittleLang.ExternalFunctions

  doctest ExternalFunctions

  test "tru()" do
    assert true == ExternalFunctions.tru()
  end
end
