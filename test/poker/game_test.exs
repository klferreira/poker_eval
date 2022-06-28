defmodule Poker.GameTest do
  use ExUnit.Case
  doctest Poker.Game

  # alias Poker.Card
  # alias Poker.Hand
  # alias Poker.Player
  alias Poker.Game

  def create_player(args \\ []) do
    Poker.Player.of(
      pid: args[:pid] || :c.pid(0, 250, 0),
      name: args[:name] || "John Doe",
      chips: args[:chips] || 0,
      hand: args[:hand] || []
    )
  end

  test "game is created with custom options" do
    game = Game.create(max_players: 6, small_blind: 15)

    assert game.max_players == 6
    assert game.small_blind == 15
  end

  test "waits for players after being created" do
    game = Game.create()
    assert game.phase == :waiting_for_players
  end

  describe "join/2" do
    setup do
      game = Game.create()

      players = [
        create_player(pid: :c.pid(0, 250, 0), name: "Cortabrisa"),
        create_player(pid: :c.pid(0, 251, 0), name: "Joaozin")
      ]

      {:ok, game: game, players: players}
    end

    test "new players are added to the player list", context do
      player = Enum.at(context[:players], 0)
      game = Game.join(context[:game], player)

      assert game.phase == :waiting_for_players
      assert game.players == [player]
    end

    test "is ready to start after the second player joins", context do
      [p1, p2] = context[:players]

      game =
        context[:game]
        |> Game.join(p1)
        |> Game.join(p2)

      assert game.phase == :ready_to_start
    end
  end

  describe "start/1" do
    setup do
      [p1, p2, p3] = [
        create_player(pid: :c.pid(0, 250, 0), name: "Cortabrisa", chips: 500),
        create_player(pid: :c.pid(0, 251, 0), name: "Joaozin", chips: 500),
        create_player(pid: :c.pid(0, 252, 0), name: "Mr Xistudo", chips: 500)
      ]

      game =
        Game.create()
        |> Game.join(p1)
        |> Game.join(p2)
        |> Game.join(p3)

      {:ok, game: game, players: [p1, p2, p3]}
    end

    test "blinds are collected", context do
      game = Game.start(context[:game])

      small_blind = game.small_blind

      [p1_before, p2_before, _] = context[:players]
      [p1_after, p2_after, _] = game.players

      assert p1_after.chips == p1_before.chips - small_blind
      assert p2_after.chips == p2_before.chips - small_blind * 2
    end

    test "cards are dealt to all players", context do
      full_deck = context[:game].deck
      game = Game.start(context[:game])

      [p1, p2, _] = game.players

      assert length(p1.hand) == 2
      assert length(p2.hand) == 2
      assert length(game.deck) == length(full_deck) - length(game.players) * 2
    end

    test "players are placed in the action queue", context do
      game = Game.start(context[:game])

      [p1, _, p3] = game.players
      assert [p3.pid, p1.pid] == game.action_queue
    end
  end

  @tag :pending
  describe "check/2" do

  end

  describe "call/2" do
    setup do
      [p1, p2, p3] = [
        create_player(pid: :c.pid(0, 250, 0), name: "Cortabrisa", chips: 500),
        create_player(pid: :c.pid(0, 251, 0), name: "Joaozin", chips: 500),
        create_player(pid: :c.pid(0, 252, 0), name: "Mr Xistudo", chips: 500)
      ]

      game =
        Game.create()
        |> Game.join(p1)
        |> Game.join(p2)
        |> Game.join(p3)
        |> Game.start()

      {:ok, game: game, players: [p1, p2, p3]}
    end

    test "chips are taken from the player", context do
      [_, _, player3] = context[:players]

      game = Game.take_action(context[:game], player3.pid, :call)

      [_, _, p3] = game.players

      assert p3.chips == player3.chips - 20
    end

    test "player is removed from the action queue", context do
      [player1, _, player3] = context[:players]

      game = Game.take_action(context[:game], player3.pid, :call)

      assert game.action_queue == [player1.pid]
    end

    test "player bet is completed if a bet was already placed", context do
      [player1, _, player3] = context[:players]

      game =
        context[:game]
        |> Game.take_action(player3.pid, :call)
        |> Game.take_action(player1.pid, :call)

      [p1, _, _] = game.players

      assert p1.chips == player1.chips - game.small_blind * 2
    end

    test "returns error if player chips are insufficient" do
      p1 = create_player(pid: :c.pid(0, 250, 0), name: "Cortabrisa", chips: 500)
      p2 = create_player(pid: :c.pid(0, 251, 0), name: "Cortabrisa", chips: 500)
      p3 = create_player(pid: :c.pid(0, 252, 0), name: "Cortabrisa", chips: 10)

      result =
        Game.create()
        |> Game.join(p1)
        |> Game.join(p2)
        |> Game.join(p3)
        |> Game.start()
        |> Game.take_action(p3.pid, :call)

      assert result == {:error, :insufficient_chips}
    end
  end

  describe "raise/2" do
    test "chips are taken from the player" do
    end

    test "all active players return to the action queue" do
    end
  end

  describe "fold/2" do
    test "no more chips are taken from the player" do
    end

    test "player is removed from the action queue" do
    end

    # describe "when action is last in the queue" do
    #   test "moves on to the next phase" do

    #   end
    # end
  end
end
