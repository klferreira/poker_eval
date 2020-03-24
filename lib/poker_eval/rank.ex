defmodule PokerEval.Rank do

  @ranks ~w(
    straight_flush
    four_of_a_kind
    full_house
    flush
    straight
    three_of_a_kind
    two_pairs
    pair
    high_card
  )a

  def get_rank_index(rank) do
    Enum.find_index(@ranks, &(&1 == rank))
  end

  defp group_by(cards, field), do: Enum.group_by(cards, &(Map.get(&1, field)))

  defp n_of_a_kind?(cards, n) do
    cards
      |> group_by(:rank)
      |> Map.values
      |> Enum.find(&(length(&1) == n))
  end

  def straight_flush?(cards) do
    with {:flush, cards} <- flush?(cards), {:straight, ^cards} <- straight?(cards)
    do
      {:straight_flush, cards}
    else
      _ -> nil
    end
  end

  def four_of_a_kind?(cards) do
    case n_of_a_kind?(cards, 4) do
      nil -> nil
      [head | _] -> {:four_of_a_kind, head.rank}
    end
  end

  def full_house?(cards) do
    {:full_house, cards}
  end

  def flush?(cards) do
    cards
      |> group_by(:suit)
      |> Map.values
      |> Enum.find(&(length(&1) >= 5))
      |> case do
        nil -> nil
        xs -> {:flush, Map.get(List.last(xs), :rank)}
      end
  end

  def straight?(cards) do
    cards = cards
      |> Enum.map(&(&1.rank))
      |> case do
        [2, 3, 4, 5, 14] -> [1, 2, 3, 4, 5]
        x -> x
      end

    with lo <- List.first(cards), hi <- List.last(cards),
      seq <- Enum.to_list(lo..hi), true <- cards == seq
    do
      {:straight, hi}
    else
      _ -> nil
    end
  end

  def three_of_a_kind?(cards) do
    case n_of_a_kind?(cards, 3) do
      nil -> nil
      [head | _] -> {:three_of_a_kind, head.rank}
    end
  end
  def two_pairs?(cards) do
    {:two_pairs, cards}
  end
  def pair?(cards) do
    {:pair, cards}
  end
  def high_card?(cards) do
    {:high_card, cards}
  end
end
