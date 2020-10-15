defmodule Poker.Card do

  @suits ~w(C D H S)

  defstruct rank: "", suit: ""

  def of(bin) do
    with [first, last] <- split_card(bin),
      {:ok, rank} <- parse_rank(first),
      {:ok, suit} <- parse_suit(last)
    do
      {:ok, %Poker.Card{suit: suit, rank: rank}}
    else
      err -> err
    end
  end

  defp split_card(bin) do
    case bin
      |> String.split("")
      |> Enum.map(&String.upcase/1)
      |> Enum.filter(&(String.length(&1) > 0)) do
      [a, b] -> [a, b]
      _ -> {:error, :invalid_card}
    end
  end

  defp parse_suit(suit) when suit in @suits, do: {:ok, String.upcase(suit)}
  defp parse_suit(_invalid_suit), do: {:error, :invalid_suit}

  defp parse_rank("T"), do: {:ok, 10}
  defp parse_rank("J"), do: {:ok, 11}
  defp parse_rank("Q"), do: {:ok, 12}
  defp parse_rank("K"), do: {:ok, 13}
  defp parse_rank("1"), do: {:ok, 14}
  defp parse_rank("A"), do: {:ok, 14}
  defp parse_rank(rank) do
    case Integer.parse(rank) do
      {num, ""} when num in 2..14 -> {:ok, num}
      _ -> {:error, :invalid_rank}
    end
  end
end
