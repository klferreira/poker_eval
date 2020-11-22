defmodule Game do
  alias Poker.Hand
  alias Poker.Dealer
  alias Game.Player

  def handle_call do
    # IO.puts("#{player} is calling")
  end

  def handle_raise do
    # IO.puts("#{player} is raising")
  end

  def handle_fold do
    # IO.puts("#{player} is folding")
  end

  def handle_player_action(_player, action) do
    case action do
      :call -> handle_call()
      :raise -> handle_raise()
      :fold -> handle_fold()
    end
  end

  def sort_hands_by_rank(hands),
    do:
      hands
      |> Enum.group_by(&(elem(&1, 1)))
      |> Enum.sort_by(fn {rank, _val} -> Poker.Hand.get_rank_index(rank) end, :asc)

  def start(players) do
    run_phase(players)
  end

  def run_phase(players) do
    # pre flop

    # deal cards
    {:ok, hole_cards, dealer} = Dealer.deal_hole_cards(Dealer.new(), length(players))

    players =
      hole_cards
      |> Enum.zip(players)
      |> Enum.map(fn {cards, player} -> Player.set_cards(player, cards) end)

    # flop
    dealer = Dealer.deal_community_cards(dealer)
    Enum.each(players, fn player -> handle_player_action(player, :call) end)

    # turn
    dealer = Dealer.deal_community_cards(dealer)
    Enum.each(players, fn player -> handle_player_action(player, :call) end)

    # river
    dealer = Dealer.deal_community_cards(dealer)
    Enum.each(players, fn player -> handle_player_action(player, :call) end)

    sorted_hands =
      players
      |> Enum.map(&Map.get(&1, :cards))
      |> Enum.map(&Poker.Hand.get_rank(&1, dealer.community_cards))
      |> sort_hands_by_rank

    IO.inspect(sorted_hands)
  end
end
