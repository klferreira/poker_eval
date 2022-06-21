defmodule Poker.Player do
  defstruct pid: nil, name: "", chips: 0, hand: [], last_action: nil

  def of(pid: pid, name: name, chips: chips, hand: hand)
      when is_pid(pid) and is_binary(name) and is_number(chips) and is_list(hand) do
    %Poker.Player{
      pid: pid,
      name: name,
      chips: chips,
      hand: hand,
      last_action: nil
    }
  end
  def of(_args), do: nil

  def take_chips(player = %Poker.Player{}, amount) when is_number(amount) do
    %{player | chips: player.chips - amount}
  end

  def take_chips(player = %Poker.Player{}, _), do: player

  def set_last_action(player = %Poker.Player{}, action) do
    %{player | last_action: action}
  end

  def add_chips(player = %Poker.Player{}, amount) when is_number(amount) do
    %{player | chips: player.chips + amount}
  end
end
