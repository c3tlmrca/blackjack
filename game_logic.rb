require './validation.rb'
require './bank.rb'
require './deck.rb'
require './player.rb'
require './dealer.rb'

class GameLogic
  include Validation

  WHATS_YOUR_MOVE = <<-DOC.freeze
  \nYour move:
  1. Hit.
  2. Stand.
  3. Open cards.
  DOC
  INVALID_INPUT = 'Invalide input.'.freeze
  PUSH = 'Push!'.freeze
  DEALER_CARDS = "\nDealer cards: ".freeze
  PLAYER_CARDS = 'Your cards: '.freeze
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
    @opened_cards = false
    @game_over = false
  end

  def accept_bets
    @player.bank.take_cash
    @dealer.bank.take_cash
    @game_bank.add_cash(WINNING_BET)
  end

  def cards_clear
    @player.cards.clear
    @dealer.cards.clear
  end

  def reset_points
    @player.points = 0
    @dealer.points = 0
  end

  def deal_cards
    cards_clear
    reset_points
    2.times do
      hit(@player)
      hit(@dealer)
    end
    show_players_cards
    show_dealer_cards { dealer_cards_hidden }
  end

  def open_cards
    @player.open_cards
    @dealer.open_cards
    @opened_cards = true
  end

  def hit(person)
    random_card = @deck.cards.sample
    person.cards << random_card
    person.ace_correction
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
    @player.calculate_points
    @dealer.calculate_points
    true if @player.points.eql?(@dealer.points)
  end

  def player_won
    @game_bank.take_cash(WINNING_BET)
    @player.bank.add_cash(WINNING_BET)
    @player.win_bet
  end

  def dealer_won
    @game_bank.take_cash(WINNING_BET)
    @dealer.bank.add_cash(WINNING_BET)
    @dealer.win_bet
  end

  def push
    puts PUSH
    show_players_cards
    show_dealer_cards { dealer_cards_unhidden }
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
    show_dealer_cards { dealer_cards_unhidden }
    show_points
    show_cash
  end

  def show_players_cards
    print PLAYER_CARDS
    @player.show_each_card
    @player.calculate_points
  end

  def show_dealer_cards
    print DEALER_CARDS
    yield if block_given?
    @dealer.calculate_points
  end

  def show_points
    print "\nYour points: #{@player.points}"
    print "\nDealer Points: #{@dealer.points}"
  end

  def show_cash
    puts "\nPlayer bank: #{@player.bank.cash}"
    puts "Dealer bank: #{@dealer.bank.cash}\n"
  end

  def dealer_cards_hidden
    @dealer.cards.length.times { print '* ' }
  end

  def dealer_cards_unhidden
    @dealer.show_each_card
  end

  def player_move
    loop do
      input = players_move
      hit(@player) if input.equal?(HIT)
      break dealer_won, (self.game_over = true) if @player.busted?

      break @player.stand if input.equal?(STAND)

      break open_cards if input.equal?(OPEN_CARDS)

      next invalide_input unless MOVES.include?(input)

      break
    end
  end

  def invalide_input
    puts INVALID_INPUT
  end

  def players_move
    puts WHATS_YOUR_MOVE
    gets.to_i
  end

  def dealer_move
    return @dealer.stand if @dealer.points >= MAX_DEALERS_POINTS
    return hit(@dealer) if @dealer.points < MAX_DEALERS_POINTS
    return player_won, (self.game_over = true) if @dealer.busted?
  end
end
