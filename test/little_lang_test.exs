defmodule LittleLangTest do
  use ExUnit.Case
  doctest LittleLang

  test "greets the world" do
    assert LittleLang.hello() == :world
  end
end
