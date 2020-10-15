defmodule PokerEval.CardTest do
  use ExUnit.Case
  doctest PokerEval.Card

  alias PokerEval.Util
  alias PokerEval.Card

  describe "parse card" do
    test "parses all valid cards correctly" do
      for rank <- ~w(2 3 4 5 6 7 8 9 T J Q K A), suit <- ~w(C D H S) do
        {:ok, card} = Card.of(rank <> suit)
        card
      end
    end

    # @tag :pending
    test "returns error for invalid cards" do
      for invalid <- ["???", "", "123"] do
        {:error, :invalid_card} = Card.of(invalid)
      end
    end

    # @tag :pending
    test "returns error for invalid ranks" do
      for invalid <- ["XD", "ZH", "0S"] do
        {:error, :invalid_rank} = Card.of(invalid)
      end
    end

    # @tag :pending
    test "returns error for invalid suits" do
      for invalid <- ["KT", "QP", "T4"] do
        {:error, :invalid_suit} = Card.of(invalid)
      end
    end
  end
end
