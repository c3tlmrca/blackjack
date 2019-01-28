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

  attr_accessor :game_bank, :deck, :player, :dealer, :game_over

  def initialize(player_name)
    @player = Player.new(player_name)
    @dealer = Dealer.new
    @game_bank = Bank.new
    @deck = Deck.new
    @game_interface = GameIntreface.new
    @opened_cards = false
    @game_over = false
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
    show_dealer_cards
  end

  def open_cards
    @player.open_cards
    @dealer.open_cards
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

    return if @game_over

    dealer_move
    return push if push?

    determine_winner
  end

  def push?
    @player.hand.calculate_points
    @dealer.hand.calculate_points
    true if @player.points.eql?(@dealer.points)
  end

  def player_won
    @game_bank.take_cash(WINNING_BET)
    @player.bank.add_cash(WINNING_BET)
    @game_interface.win_bet(@player)
  end

  def dealer_won
    @game_bank.take_cash(WINNING_BET)
    @dealer.bank.add_cash(WINNING_BET)
    @game_interface.win_bet(@dealer)
  end

  def push
    @game_interface.push
    show_players_cards
    show_dealer_cards
    @game_bank.take_cash(WINNING_BET)
    @player.bank.return_cash
    @dealer.bank.return_cash
    show_points
    show_cash
  end

  def determine_winner
    @game_bank.take_cash(WINNING_BET)
    if @player.win?(@dealer)
      player_won
    elsif @dealer.win?(@player)
      dealer_won
    end
    show_players_cards
    show_dealer_cards
    show_points
    show_cash
  end

  def show_players_cards
    @game_interface.show_cards_unhidden(@player)
    @player.hand.calculate_points
  end

  def show_dealer_cards_unhiden
    @game_interface.show_cards_unhidden(@dealer)
    @dealer.hand.calculate_points
  end

  def player_move
    loop do
      input = players_move
      hit(@player) if input.equal?(HIT)
      break dealer_won, (self.game_over = true) if @player.hand.busted?

      break @game_interface.stand(@player) if input.equal?(STAND)

      break open_cards if input.equal?(OPEN_CARDS)

      next invalide_input unless MOVES.include?(input)

      break
    end
  end

  def dealer_move
    return @game_interface.stand(@dealer) if @dealer.hand.points >= MAX_DEALERS_POINTS
    return hit(@dealer) if @dealer.hand.points < MAX_DEALERS_POINTS
    return player_won, (self.game_over = true) if @dealer.hand.busted?
  end
end
