defmodule PokerEval.Util do

  def full_deck() do
    for rank <- ~w(2 3 4 5 6 7 8 9 T J Q K A), suit <- ~w(C D H S), do: rank <> suit
  end
end
