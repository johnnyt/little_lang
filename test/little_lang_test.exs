defmodule LittleLangTest do
  use ExUnit.Case, async: true
  doctest LittleLang

  test "greets the world" do
    assert LittleLang.hello() == :world
  end
end
