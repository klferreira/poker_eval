defmodule Poker.Card do

  @ranks 2..14 |> Enum.to_list()
  @suits ~w(clubs diamonds hearts spades)a

  def ranks, do: @ranks
  def suits, do: @suits

  defstruct rank: "", suit: ""

  def of(bin) do
    card_regex = ~r/(.{1,2})([CDHS])/
    case Regex.scan(card_regex, bin) do
      [] -> %Poker.Card{rank: nil, suit: nil}
      [[_, rank, suit]] -> %Poker.Card{rank: parse_rank(rank), suit: parse_suit(suit)}
    end
  end

  defp parse_suit("C"), do: :clubs
  defp parse_suit("D"), do: :diamonds
  defp parse_suit("H"), do: :hearts
  defp parse_suit("S"), do: :spades
  defp parse_suit(_), do: nil

  defp parse_rank("J"), do: 11
  defp parse_rank("Q"), do: 12
  defp parse_rank("K"), do: 13
  defp parse_rank("A"), do: 14
  defp parse_rank(number) do
    case Integer.parse(number) do
      :error -> nil
      {rank, _} ->
        case rank > 1 and rank <= 10 do
          false -> nil
          true -> rank
        end
    end
  end

  def suit_to_string(:clubs), do: "♣"
  def suit_to_string(:diamonds), do: "♦"
  def suit_to_string(:hearts), do: "♥"
  def suit_to_string(:spades), do: "♠"

  def print_card(card = %Poker.Card{}), do:
    "[#{card.rank}#{suit_to_string(card.suit)}]"
end
