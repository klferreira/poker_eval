defmodule Poker.Hand do
  import Poker.Rank

  defstruct cards: [], rank: nil

  def get_rank(hand, community) do
    rank = rank_with(hand ++ community, get_ordered_ranks())
    {:ok, rank, hand}
  end

  def rank_with(hand, [rank | ranks]) do
    case apply(PokerEval.Rank, :"#{rank}?", [hand]) do
      {rank, _} -> rank
      _ -> rank_with(hand, ranks)
    end
  end
end
