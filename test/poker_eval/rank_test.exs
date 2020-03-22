defmodule PokerEval.RankTest do
  use ExUnit.Case
  doctest PokerEval.Rank

  alias PokerEval.Card
  alias PokerEval.Rank

  describe "get_four_of_a_kind" do

    # @tag :pending
    test "returns nil if hand doesn't match rank" do
      cards = [
        %Card{rank: 2, suit: "H"},
        %Card{rank: 7, suit: "S"},
        %Card{rank: 2, suit: "D"},
        %Card{rank: 3, suit: "C"},
        %Card{rank: 10, suit: "H"}
      ]
      nil = Rank.four_of_a_kind?(cards)
    end

    # @tag :pending
    test "returns :four_of_a_kind when hand matches rank" do
      cards = [
        %Card{rank: 2, suit: "H"},
        %Card{rank: 5, suit: "S"},
        %Card{rank: 5, suit: "D"},
        %Card{rank: 5, suit: "C"},
        %Card{rank: 5, suit: "H"}
      ]
      {:four_of_a_kind, 5} = Rank.four_of_a_kind?(cards)
    end

  end
end