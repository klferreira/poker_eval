defmodule Poker.Game do
  alias Poker.Game
  alias Poker.Player

  @max_players 8
  @small_blind 10

  defstruct board: [],
            bets: [],
            players: [],
            action_queue: [],
            phase: :waiting_for_players,
            max_players: @max_players,
            small_blind: @small_blind,
            deck: Enum.shuffle(Poker.Util.full_deck())

  # public api
  def create(max_players: max_players, small_blind: small_blind) do
    %Game{max_players: max_players, small_blind: small_blind}
  end

  def create(), do: %Game{}

  def join(state = %Poker.Game{}, player = %Poker.Player{}) do
    player_count = length(state.players)

    case player_count < state.max_players do
      false ->
        {:failed, :full_table}

      true ->
        case state.phase == :waiting_for_players && player_count >= 1 do
          false -> state |> add_player(player)
          true -> state |> add_player(player) |> set_game_phase(:ready_to_start)
        end
    end
  end

  def start(state = %Poker.Game{}) do
    player_count = length(state.players)

    updated_state =
      case player_count > 1 do
        false -> {:failed, :insufficient_players}
        true -> set_game_phase(state, :pre_flop)
      end

    run_phase(updated_state)
  end

  def run_phase(state = %Poker.Game{}) do
    case state.phase do
      :pre_flop -> pre_flop(state)
      _ -> {:failed, :unknown_phase}
    end
  end

  # private fns
  defp get_player(state = %Game{}, player_id) do
    Enum.find(state.players, fn player -> player.pid == player_id end)
  end

  defp add_player(state = %Game{}, player = %Player{}) do
    %{state | players: state.players ++ [player]}
  end

  defp set_player_data(state = %Game{}, player = %Player{}) do
    updated_players =
      Enum.map(
        state.players,
        fn p -> if p.pid != player.pid, do: p, else: player end
      )

    %{state | players: updated_players}
  end

  defp set_game_phase(state = %Game{}, phase) do
    %{state | phase: phase}
  end

  defp set_players(state = %Game{}, players) do
    %{state | players: players}
  end

  defp set_action_queue(state = %Game{}, queue) do
    %{state | action_queue: queue}
  end

  defp set_bets(state = %Game{}, bets) do
    %{state | bets: bets}
  end

  defp set_deck(state = %Game{}, deck) do
    %{state | deck: deck}
  end

  defp place_bet(state = %Game{}, player_id, amount) do
    case get_player(state, player_id) do
      nil ->
        {:error, :player_not_found}

      player ->
        case player.chips >= amount do
          false ->
            {:error, :insufficient_chips}

          true ->
            state
            |> set_player_data(%{player | chips: player.chips - amount})
            |> set_bets([{player_id, amount} | state.bets])
        end
    end
  end

  defp total_player_bet(state = %Game{}, player_id) do
    state.bets
      |> Enum.filter(fn {id, _amount} -> id == player_id end)
      |> Enum.reduce(0, fn {_id, amount}, total -> total + amount end)
  end

  defp deal_player_cards(state) do
    [deck | players] = Enum.reverse(deal_player_cards(state.players, state.deck))

    state
    |> set_players(Enum.reverse(players))
    |> set_deck(deck)
  end

  defp deal_player_cards([], deck), do: [deck]

  defp deal_player_cards([player | players], [a, b | deck]) do
    [%{player | hand: [a, b]} | deal_player_cards(players, deck)]
  end

  defp pre_flop(state = %Poker.Game{}) do
    with [first, second | other_players] <- state.players do
      re_ordered_players = other_players ++ [first]

      player_pids = Enum.map(re_ordered_players, fn player -> player.pid end)

      state
      |> place_bet(first.pid, state.small_blind)
      |> place_bet(second.pid, state.small_blind * 2)
      |> set_action_queue(player_pids)
      |> deal_player_cards()
    end
  end

  def take_action(state = %Poker.Game{}, player_id, :call) do
    with [{_player_id, last_bet_amount} | _] <- state.bets,
         [expected_player_id | remaining_players] <- state.action_queue do
      case expected_player_id == player_id do
        false ->
          {:error, :unexpected_action, player_id}

        true ->
          current_bet = total_player_bet(state, player_id)
          state
          |> place_bet(player_id, last_bet_amount - current_bet)
          |> set_action_queue(remaining_players)
      end
    end
  end

  def take_action(state = %Poker.Game{}, player_id, :check) do
    with [expected_player_id | remaining_players] <- state.action_queue do
      case expected_player_id == player_id do
        false ->
          {:error, :unexpected_action, player_id}

        true ->
          case state.bets do
            [] -> set_action_queue(state, remaining_players)
            false -> {:error, :unexpected_action, player_id}
          end
      end
    end
  end
end
