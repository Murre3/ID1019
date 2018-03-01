defmodule TransportTest do
  use ExUnit.Case
  doctest Transport

  test "greets the world" do
    assert Transport.hello() == :world
  end
end
