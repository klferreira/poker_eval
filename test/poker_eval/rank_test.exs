defmodule PokerEval.RankTest do
  use ExUnit.Case
  doctest PokerEval.Rank

  alias PokerEval.Rank

  describe "rank hands" do

    @tag :pending
    test "evaluates a straight flush" do
      hand = []
      {:straight_flush, _} = Rank.rank_hand(hand)
    end

    @tag :pending
    test "evaluates a four of a kind" do
      hand = []
      {:four_of_a_kind, _} = Rank.rank_hand(hand)
    end

    @tag :pending
    test "evaluates a full_house" do
      hand = []
      {:full_house, _} = Rank.rank_hand(hand)
    end

    @tag :pending
    test "evaluates a flush" do
      hand = []
      {:flush, _} = Rank.rank_hand(hand)
    end

    @tag :pending
    test "evaluates a straight" do
      hand = []
      {:straight, _} = Rank.rank_hand(hand)
    end

    @tag :pending
    test "evaluates a three_of_a_kind" do
      hand = []
      {:three_of_a_kind, _} = Rank.rank_hand(hand)
    end

    @tag :pending
    test "evaluates a two_pairs" do
      hand = []
      {:two_pairs, _} = Rank.rank_hand(hand)
    end

    @tag :pending
    test "evaluates a pair" do
      hand = []
      {:pair, _} = Rank.rank_hand(hand)
    end

    @tag :pending
    test "evaluates a high_card" do
      hand = []
      {:high_card, _} = Rank.rank_hand(hand)
    end

  end
end
