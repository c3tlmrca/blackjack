require './validation.rb'
require './bank.rb'

class Player
  include Validation

  NAME_FORMAT = /\w+/.freeze
  MAX_POINTS = 21
  ACE_CORRECTION = 10
  WINNING_BET = 20
  BUSTED = 'Busted!'.freeze
  STAND = 'Stand!'.freeze

  attr_reader :name
  attr_accessor :bank, :cards, :bet, :points

  validate :name, :format, NAME_FORMAT

  def initialize(name = 'Freddie Mercury')
    @name = name.strip
    @bank = Bank.new(100)
    @cards = []
    @points = 0
    validate!
  end

  def open_cards
    show_each_card
  end

  def win_bet
    print "\n#{self.class} is winner!\n"
  end

  def stand
    print "\n#{self.class} #{STAND}"
  end

  def busted?
    calculate_points
    true if points > MAX_POINTS
  end

  def calculate_points
    self.points = 0
    cards.each { |card| card.each_value { |value| self.points += value } }
    ace_correction
    self.points
  end

  def more_than_maxpoints?
    self.points > MAX_POINTS
  end

  def ace_correction
    self.points -= ACE_CORRECTION if include_ace? && more_than_maxpoints?
  end

  def include_ace?
    cards.each { |card| card.each_key { |key| return true if key.include?('A') } }
    false
  end

  def show_each_card
    cards.each { |card| card.each_key { |key| print "#{key} " } }
  end

  def win?(player)
    calculate_points
    self.points > player.points && self.points <= MAX_POINTS
  end
end
