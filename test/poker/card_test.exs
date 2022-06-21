defmodule Poker.CardTest do
  use ExUnit.Case
  doctest Poker.Card

  alias Poker.Card

  describe "parse card" do
    test "parses all valid cards correctly" do
      for rank <- ~w(2 3 4 5 6 7 8 9 10 J Q K A), suit <- ~w(C D H S) do
        card = Card.of(rank <> suit)
        assert card.rank != nil and card.suit != nil
      end
    end

    # @tag :pending
    test "returns error for invalid cards" do
      for invalid <- ["???", "", "123"] do
        %Poker.Card{rank: nil, suit: nil} = Card.of(invalid)
      end
    end

    # @tag :pending
    test "returns error for invalid ranks" do
      for invalid <- ["XD", "ZH", "0S"] do
        %Poker.Card{rank: nil, suit: _} = Card.of(invalid)
      end
    end

    # @tag :pending
    test "returns error for invalid suits" do
      for invalid <- ["KT", "QP", "T4"] do
        %Poker.Card{rank: _, suit: nil} = Card.of(invalid)
      end
    end
  end
end
