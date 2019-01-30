require './validation.rb'
require './bank.rb'
require './deck.rb'
require './player.rb'
require './dealer.rb'
require './game_interface.rb'

class GameLogic
  include Validation

  MOVES = (1..3).freeze
  HIT = 1
  STAND = 2
  OPEN_CARDS = 3
  MAX_CARDS = 3
  MAX_DEALERS_POINTS = 17
  WINNING_BET = 20

  attr_accessor :game_bank, :deck, :player, :dealer, :game_over, :game_interface

  def initialize
    @game_interface = GameInterface.new
    player_name = @game_interface.player_name
    @player = Player.new(player_name)
    @dealer = Dealer.new
    @game_bank = Bank.new
    @deck = Deck.new
    @opened_cards = false
  end

  def accept_bets
    @player.bank.take_cash
    @dealer.bank.take_cash
    @game_bank.add_cash(WINNING_BET)
  end

  def cards_clear
    @player.hand.cards.clear
    @dealer.hand.cards.clear
  end

  def reset_points
    @player.hand.points = 0
    @dealer.hand.points = 0
  end

  def deal_cards
    cards_clear
    reset_points
    2.times do
      hit(@player)
      hit(@dealer)
    end
    show_players_cards
    show_dealer_cards_hidden
  end

  def open_cards
    show_players_cards
    show_dealer_cards_unhidden
    @opened_cards = true
  end

  def hit(person)
    random_card = @deck.cards.sample
    person.hand.cards << random_card
    person.hand.ace_correction
    @deck.cards.delete(random_card)
  end

  def moves
    player_move
    return determine_winner if @opened_cards

    return @game_interface.busted(@player), dealer_won if @player.hand.busted?

    dealer_move
    return @game_interface.busted(@dealer), player_won if @dealer.hand.busted?
    return push if push?

    determine_winner
  end

  def push?
    @player.hand.calculate_points
    @dealer.hand.calculate_points
    true if @player.hand.points.eql?(@dealer.hand.points)
  end

  def player_won
    @game_bank.take_cash(WINNING_BET)
    @player.bank.add_cash(WINNING_BET)
    @game_interface.win_bet(@player)
    end_game
  end

  def dealer_won
    @game_bank.take_cash(WINNING_BET)
    @dealer.bank.add_cash(WINNING_BET)
    @game_interface.win_bet(@dealer)
    end_game
  end

  def end_game
    show_players_cards
    show_dealer_cards_unhidden
    show_points
    show_bank
  end

  def push
    @game_interface.push
    @game_bank.take_cash(WINNING_BET)
    @player.bank.return_cash
    @dealer.bank.return_cash
    end_game
  end

  def show_points
    @game_interface.show_points(@player)
    @game_interface.show_points(@dealer)
  end

  def determine_winner
    @game_bank.take_cash(WINNING_BET)
    if @player.hand.win?(@dealer)
      player_won
    elsif @dealer.hand.win?(@player)
      dealer_won
    end
  end

  def show_bank
    @game_interface.show_cash(@player)
    @game_interface.show_cash(@dealer)
  end

  def show_players_cards
    @game_interface.show_cards_unhidden(@player)
    @player.hand.calculate_points
  end

  def show_dealer_cards_unhidden
    @game_interface.show_cards_unhidden(@dealer)
    @dealer.hand.calculate_points
  end

  def show_dealer_cards_hidden
    @game_interface.show_cards_hidden(@dealer)
    @dealer.hand.calculate_points
  end

  def player_move
    loop do
      input = @game_interface.players_move
      hit(@player) if input.equal?(HIT)

      break @game_interface.stand(@player) if input.equal?(STAND)

      break open_cards if input.equal?(OPEN_CARDS)

      next @game_interface.invalide_input unless MOVES.include?(input)

      break
    end
  end

  def dealer_move
    return @game_interface.stand(@dealer) if @dealer.hand.points >= MAX_DEALERS_POINTS
    return hit(@dealer) if @dealer.hand.points < MAX_DEALERS_POINTS
  end
end
