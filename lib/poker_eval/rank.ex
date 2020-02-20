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

  def rank_hand(hand) do
    cond do
      {rank, cards} = straight_flush?(hand) -> {Enum.find_index(@ranks, &(&1 == rank)), rank, cards}
      {rank, cards} = four_of_a_kind?(hand) -> {Enum.find_index(@ranks, &(&1 == rank)), rank, cards}
      {rank, cards} = full_house?(hand) -> {Enum.find_index(@ranks, &(&1 == rank)), rank, cards}
      {rank, cards} = straight?(hand) -> {Enum.find_index(@ranks, &(&1 == rank)), rank, cards}
      {rank, cards} = flush?(hand) -> {Enum.find_index(@ranks, &(&1 == rank)), rank, cards}
      {rank, cards} = three_of_a_kind?(hand) -> {Enum.find_index(@ranks, &(&1 == rank)), rank, cards}
      {rank, cards} = two_pairs?(hand) -> {Enum.find_index(@ranks, &(&1 == rank)), rank, cards}
      {rank, cards} = pair?(hand) -> {Enum.find_index(@ranks, &(&1 == rank)), rank, cards}
      {rank, cards} = high_card?(hand) -> {Enum.find_index(@ranks, &(&1 == rank)), rank, cards}
    end
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
    {:four_of_a_kind, cards}
  end

  def full_house?(cards) do
    {:full_house, cards}
  end

  def flush?(cards) do
    {:flush, cards}
  end

  def straight?(cards) do
    {:straight, cards}
  end

  def three_of_a_kind?(cards) do
    {:three_of_a_kind, cards}
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
