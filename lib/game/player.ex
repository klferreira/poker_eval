defmodule Game.Player do
  defstruct name: "", cards: [], chips: 1000

  def new(name) do
    %Game.Player{name: name}
  end

  def set_cards(player, cards) do
    %Game.Player{player | cards: cards}
  end
end
