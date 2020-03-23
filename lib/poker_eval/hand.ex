defmodule PokerEval.Hand do

  alias PokerEval.Card
  import PokerEval.Rank

  def parse_hand([]), do: {:error, :invalid_hand_size}
  def parse_hand(hand) when length(hand) > 5, do: {:error, :invalid_hand_size}
  def parse_hand(hand) do
    with cards <- hand |> String.split(" "),
        true <- length(Enum.uniq(cards)) == length(cards),
        parsed_cards <- Enum.map(cards, &Card.of/1),
        {:invalid_cards, []} <- {:invalid_cards, Keyword.get_values(parsed_cards, :error)},
        parsed_hand <- Keyword.get_values(parsed_cards, :ok) |> Enum.sort_by(&(&1.rank))
    do
      {:ok, parsed_hand}
    else
      false -> {:error, :repeated_card}
      {:invalid_cards, [_]} -> {:error, :invalid_cards}
    end
  end

  def rank_hand(hand) do
    cond do
      {rank, cards} = straight_flush?(hand) -> {get_rank_index(rank), rank, cards}
      {rank, cards} = four_of_a_kind?(hand) -> {get_rank_index(rank), rank, cards}
      {rank, cards} = full_house?(hand) -> {get_rank_index(rank), rank, cards}
      {rank, cards} = straight?(hand) -> {get_rank_index(rank), rank, cards}
      {rank, cards} = flush?(hand) -> {get_rank_index(rank), rank, cards}
      {rank, cards} = three_of_a_kind?(hand) -> {get_rank_index(rank), rank, cards}
      {rank, cards} = two_pairs?(hand) -> {get_rank_index(rank), rank, cards}
      {rank, cards} = pair?(hand) -> {get_rank_index(rank), rank, cards}
      {rank, cards} = high_card?(hand) -> {get_rank_index(rank), rank, cards}
    end
  end
end
