defmodule WServerTest do
  use ExUnit.Case
  doctest WServer

  test "greets the world" do
    assert WServer.hello() == :world
  end
end
