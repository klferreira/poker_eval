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

  def get_ordered_ranks(), do: @ranks

  def get_rank_index(rank) do
    Enum.find_index(@ranks, &(&1 == rank))
  end

  defp group_by(cards, field), do: Enum.group_by(cards, &Map.get(&1, field))

  defp n_of_a_kind?(cards, n) do
    cards
    |> group_by(:rank)
    |> Map.values()
    |> Enum.filter(&(length(&1) == n))
    |> Enum.sort_by(fn [head | _] -> head.rank end, :desc)
  end

  def straight_flush?(cards) do
    with {:flush, hi} <- flush?(cards), {:straight, ^hi} <- straight?(cards) do
      {:straight_flush, hi}
    else
      _ -> nil
    end
  end

  def four_of_a_kind?(cards) do
    case n_of_a_kind?(cards, 4) do
      [] -> nil
      [[head | _] | _] -> {:four_of_a_kind, head.rank}
    end
  end

  def full_house?(cards) do
    # {:full_house, cards}
    nil
  end

  def flush?(cards) do
    cards
    |> group_by(:suit)
    |> Map.values()
    |> Enum.find(&(length(&1) >= 5))
    |> case do
      nil -> nil
      xs -> {:flush, Map.get(List.last(xs), :rank)}
    end
  end

  def straight?(cards) do
    cards =
      cards
      |> Enum.map(& &1.rank)
      |> case do
        [2, 3, 4, 5, 14] -> [1, 2, 3, 4, 5]
        x -> x
      end

    with lo <- List.first(cards),
         hi <- List.last(cards),
         seq <- Enum.to_list(lo..hi),
         true <- cards == seq do
      {:straight, hi}
    else
      _ -> nil
    end
  end

  def three_of_a_kind?(cards) do
    case n_of_a_kind?(cards, 3) do
      [] -> nil
      [[head | _] | _] -> {:three_of_a_kind, head.rank}
    end
  end

  def two_pairs?(cards) do
    case n_of_a_kind?(cards, 2) do
      [] -> nil
      [[a | _], [b | _ ] | _] -> {:two_pair, a.rank, b.rank}
    end
  end

  def pair?(cards) do
    case n_of_a_kind?(cards, 2) do
      [] -> nil
      [[head | _] | _] -> {:pair, head.rank}
    end
  end

  def high_card?(cards) do
    [card | _] = Enum.sort_by(cards, & &1.rank, :desc)
    {:high_card, card}
  end
end
