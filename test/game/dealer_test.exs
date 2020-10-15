defmodule Game.DealerTest do
  use ExUnit.Case
  doctest Game.Dealer

  alias Game.Dealer
  alias PokerEval.Card

  @full_deck_size 52

  describe "new" do
    test "creates a new dealer instance with a fresh deck" do
      dealer = Dealer.new()
      @full_deck_size = length(dealer.deck)
    end
  end

  describe "deal_hole_cards/2" do
    test "deals n starting hands and keeps the remaining cards" do
      player_count = Enum.random(2..5)
      {:ok, hands, dealer} = Dealer.deal_hole_cards(Dealer.new(), player_count)
      @full_deck_size = length(dealer.deck) + length(hands) * 2
    end
  end

  describe "deal_community_cards/1" do
    setup do
      cards = [
        Card.of("KS"),
        Card.of("2D"),
        Card.of("2C"),
        Card.of("5S"),
        Card.of("QH")
      ]

      {:ok, cards: cards}
    end

    test "deals three cards if community card pool is empty" do
      dealer = Dealer.new() |> Dealer.deal_community_cards()
      3 = length(dealer.community_cards)
    end

    test "deals a single card if community card pool has 3 or 4 cards", context do
      with dealer <-
             Enum.take(context[:cards], 3)
             |> Dealer.new()
             |> Dealer.deal_community_cards() do
        4 = length(dealer.community_cards)
      end

      with dealer <-
             Enum.take(context[:cards], 4)
             |> Dealer.new()
             |> Dealer.deal_community_cards() do
        5 = length(dealer.community_cards)
      end
    end

    test "does not deal if community card pool is full", context do
      with dealer <-
             Enum.take(context[:cards], 5)
             |> Dealer.new()
             |> Dealer.deal_community_cards() do
        5 = length(dealer.community_cards)
      end
    end
  end
end
