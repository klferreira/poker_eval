defmodule PokerEval.Dealer do
  import PokerEval.Util

  defstruct deck: full_deck(), community_cards: []

  def new(community_cards \\ []) do
    %PokerEval.Dealer{community_cards: community_cards}
  end

  def deal_hole_cards(dealer, player_count) do
    shuffled = Enum.shuffle(dealer.deck)
    deal_hole_cards(shuffled, player_count, [])
  end

  def deal_hole_cards(deck, player_count, holes) when player_count === length(holes) do
    {:ok, holes, %PokerEval.Dealer{deck: deck}}
  end

  def deal_hole_cards(deck, player_count, holes) do
    [a, b | tail] = deck
    deal_hole_cards(tail, player_count, holes ++ [[a, b]])
  end

  def deal_community_cards(dealer) do
    case length(dealer.community_cards) do
      0 -> deal_community_cards(dealer, 3)
      3 -> deal_community_cards(dealer, 1)
      4 -> deal_community_cards(dealer, 1)
      _ -> dealer
    end
  end

  def deal_community_cards(dealer, amount) do
    {community_cards, deck} = Enum.split(dealer.deck, amount)

    %PokerEval.Dealer{
      deck: deck,
      community_cards: dealer.community_cards ++ community_cards
    }
  end
end
