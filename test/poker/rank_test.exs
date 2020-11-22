defmodule Poker.RankTest do
  use ExUnit.Case
  doctest Poker.Rank

  alias Poker.Card
  alias Poker.Rank

  describe "high_card?/1" do
    # @tag :pending
    test "returns the highest card of the hand" do
      high = %Card{rank: 10, suit: "H"}

      cards = [
        %Card{rank: 2, suit: "H"},
        %Card{rank: 3, suit: "D"},
        %Card{rank: 7, suit: "C"},
        %Card{rank: 9, suit: "C"},
        high
      ]

      assert {:high_card, high} == Rank.high_card?(cards)
    end
  end

  describe "pair?/1" do
    # @tag :pending
    test "returns the highest pair of the hand" do
      cards = [
        %Card{rank: 2, suit: "H"},
        %Card{rank: 2, suit: "D"},
        %Card{rank: 7, suit: "C"},
        %Card{rank: 7, suit: "D"},
        %Card{rank: 10, suit: "C"}
      ]
      assert {:pair, 7} == Rank.pair?(cards)
    end

    test "returns nil if hand doesn't match rank" do
      cards = [
        %Card{rank: 2, suit: "H"},
        %Card{rank: 3, suit: "D"},
        %Card{rank: 7, suit: "C"},
        %Card{rank: 8, suit: "D"},
        %Card{rank: 10, suit: "C"}
      ]
      nil = Rank.pair?(cards)
    end
  end

  describe "two_pair?/1" do
    # @tag :pending
    test "returns the two pairs of the hand" do
      cards = [
        %Card{rank: 2, suit: "H"},
        %Card{rank: 2, suit: "D"},
        %Card{rank: 3, suit: "C"},
        %Card{rank: 3, suit: "D"},
        %Card{rank: 10, suit: "C"}
      ]

      assert {:two_pair, 3, 2} = Rank.two_pairs?(cards)
    end

    test "returns nil if only one pair is present" do
      cards = [
        %Card{rank: 1, suit: "H"},
        %Card{rank: 2, suit: "D"},
        %Card{rank: 3, suit: "C"},
        %Card{rank: 3, suit: "D"},
        %Card{rank: 10, suit: "C"}
      ]

      nil = Rank.two_pairs?(cards)
    end
  end

  describe "four_of_a_kind?/1" do
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
    test "succeeds when hand matches rank" do
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

  describe "three of a kind" do
    test "returns nil if hand doesn't match rank" do
      cards = [
        %Card{rank: 2, suit: "S"},
        %Card{rank: 4, suit: "D"},
        %Card{rank: 4, suit: "C"},
        %Card{rank: 6, suit: "C"},
        %Card{rank: 1, suit: "H"}
      ]

      nil = Rank.three_of_a_kind?(cards)
    end

    # @tag :pending
    test "succeeds when hand matches rank" do
      cards = [
        %Card{rank: 8, suit: "S"},
        %Card{rank: 8, suit: "D"},
        %Card{rank: 8, suit: "C"},
        %Card{rank: 6, suit: "C"},
        %Card{rank: 1, suit: "H"}
      ]

      {:three_of_a_kind, 8} = Rank.three_of_a_kind?(cards)
    end
  end

  describe "full_house/1" do
    test "suceeds when hand matches rank" do
      cards = [
        %Card{rank: 8, suit: "S"},
        %Card{rank: 8, suit: "D"},
        %Card{rank: 8, suit: "C"},
        %Card{rank: 2, suit: "C"},
        %Card{rank: 2, suit: "H"}
      ]

      {:full_house, _cards} = Rank.full_house?(cards)
    end
  end

  describe "flush" do
    # @tag :pending
    test "returns nil if hand doesn't match rank" do
      cards = [
        %Card{rank: 7, suit: "S"},
        %Card{rank: 14, suit: "S"},
        %Card{rank: 9, suit: "S"},
        %Card{rank: 4, suit: "S"},
        %Card{rank: 2, suit: "D"}
      ]

      nil = Rank.flush?(cards)
    end

    # @tag :pending
    test "succeeds when hand matches rank" do
      cards = [
        %Card{rank: 7, suit: "S"},
        %Card{rank: 1, suit: "S"},
        %Card{rank: 9, suit: "S"},
        %Card{rank: 4, suit: "S"},
        %Card{rank: 2, suit: "S"}
      ]

      {:flush, 9} =
        cards
        |> Enum.sort_by(& &1.rank)
        |> Rank.flush?()
    end
  end

  describe "straight" do
    # @tag :pending
    test "returns nil if hand doesn't match rank" do
      cards = [
        %Card{rank: 2, suit: "D"},
        %Card{rank: 3, suit: "S"},
        %Card{rank: 4, suit: "S"},
        %Card{rank: 5, suit: "H"},
        %Card{rank: 2, suit: "H"}
      ]

      nil = Rank.straight?(cards)
    end

    # @tag :pending
    test "succeeds when hand matches rank" do
      cards = [
        %Card{rank: 2, suit: "D"},
        %Card{rank: 3, suit: "S"},
        %Card{rank: 4, suit: "S"},
        %Card{rank: 5, suit: "H"},
        %Card{rank: 6, suit: "H"}
      ]

      {:straight, 6} = Rank.straight?(cards)
    end

    # @tag :pending
    test "succeeds when hand matches rank with ace low" do
      cards = [
        %Card{rank: 2, suit: "D"},
        %Card{rank: 3, suit: "S"},
        %Card{rank: 4, suit: "S"},
        %Card{rank: 5, suit: "H"},
        %Card{rank: 14, suit: "H"}
      ]

      {:straight, 5} = Rank.straight?(cards)
    end
  end

  describe "straight flush" do
    # @tag :pending
    test "returns nil if only flush" do
      cards = [
        %Card{rank: 4, suit: "D"},
        %Card{rank: 10, suit: "D"},
        %Card{rank: 3, suit: "D"},
        %Card{rank: 11, suit: "D"},
        %Card{rank: 9, suit: "D"}
      ]

      nil = Rank.straight_flush?(cards)
    end

    # @tag :pending
    test "returns nil if only straight" do
      cards = [
        %Card{rank: 4, suit: "S"},
        %Card{rank: 5, suit: "S"},
        %Card{rank: 6, suit: "D"},
        %Card{rank: 7, suit: "H"},
        %Card{rank: 8, suit: "D"}
      ]

      nil = Rank.straight_flush?(cards)
    end

    # tag :pending
    test "succeeds when hand matches rank" do
      cards = [
        %Card{rank: 4, suit: "S"},
        %Card{rank: 5, suit: "S"},
        %Card{rank: 6, suit: "S"},
        %Card{rank: 7, suit: "S"},
        %Card{rank: 8, suit: "S"}
      ]

      {:straight_flush, 8} = Rank.straight_flush?(cards)
    end
  end
end
