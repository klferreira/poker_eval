defmodule Poker.Util do

  alias Poker.Card

  def full_deck() do
    for rank <- ~w(2 3 4 5 6 7 8 9 10 J Q K A), suit <- ~w(C D H S) do
      Card.of(rank <> suit)
    end
  end
end
