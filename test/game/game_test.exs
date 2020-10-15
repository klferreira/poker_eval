defmodule Game.GameTest do
  use ExUnit.Case
  doctest Game

  alias Game
  alias Game.Player

  describe "start" do
    setup do
      players = [
        %Player{name: "John Doe"},
        %Player{name: "Joanna Doe"}
      ]
      {:ok, players: players}
    end

    @tag :pending
    test "works", context do
      Game.start(context[:players])
    end
  end

end
