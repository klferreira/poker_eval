defmodule Poker.DealerTest do
  use ExUnit.Case
  doctest Poker.Dealer

  alias Poker.Card
  alias Poker.Dealer

  describe "new" do
    setup do
      {:ok, dealer: Dealer.new()}
    end

    test "creates a new dealer instance with a fresh deck", context do
      assert 52 == length(context[:dealer].deck)
    end
  end

  describe "deal_hole_cards/2" do
    setup do
      player_count = Enum.random(2..5)
      {:ok, hands, dealer} = Dealer.deal_hole_cards(Dealer.new(), player_count)
      {:ok, hands: hands, dealer: dealer}
    end

    test "dealt cards are removed from deck", context do
      assert 52 == length(context[:dealer].deck) + length(context[:hands]) * 2
    end
  end

  describe "deal_community_cards/1" do
    setup do
      cards = [
        Card.of("KS"), Card.of("2D"), Card.of("2C"), Card.of("5S"), Card.of("QH")
      ]

      {:ok, cards: cards}
    end

    test "deals three cards if community card pool is empty" do
      dealer = Dealer.new() |> Dealer.deal_community_cards()
      3 = length(dealer.community_cards)
    end

    test "deals a single card if community card pool has 3 cards", context do
      dealer =
        Enum.take(context[:cards], 3)
        |> Dealer.new()
        |> Dealer.deal_community_cards()

      assert 4 == length(dealer.community_cards)
    end

    test "deals a single card if community card pool has 4 cards", context do
      dealer =
        Enum.take(context[:cards], 4)
        |> Dealer.new()
        |> Dealer.deal_community_cards()

      assert 5 == length(dealer.community_cards)
    end

    test "does not deal if community card pool is full", context do
      dealer =
        Enum.take(context[:cards], 5)
        |> Dealer.new()
        |> Dealer.deal_community_cards()

      assert 5 == length(dealer.community_cards)
    end
  end
end
