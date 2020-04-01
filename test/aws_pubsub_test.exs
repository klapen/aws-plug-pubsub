defmodule AwsPubsubTest do
  use ExUnit.Case
  doctest AwsPubsub

  test "greets the world" do
    assert AwsPubsub.hello() == :world
  end
end
