defmodule PokerEval.CardTest do
  use ExUnit.Case
  doctest PokerEval.Card

  alias PokerEval.Util
  alias PokerEval.Card

  describe "parse card" do
    test "parses all valid cards correctly" do
      for c <- Util.full_deck() do
        {:ok, _card} = Card.of(c)
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
