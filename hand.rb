class Hand
  MAX_POINTS = 21
  ACE_CORRECTION = 10
  WINNING_BET = 20

  attr_accessor :points, :cards

  def initialize
    @points = 0
    @cards = []
  end

  def calculate_points
    @points = 0
    cards.each { |card| @points += card.value }
    ace_correction
    @points
  end

  def more_than_maxpoints?
    @points > MAX_POINTS
  end

  def ace_correction
    @points -= ACE_CORRECTION if include_ace? && more_than_maxpoints?
  end

  def include_ace?
    cards.each { |card| return true if card.rank.include?('A') }
    false
  end

  def busted?
    calculate_points
    true if points > MAX_POINTS
  end
end
