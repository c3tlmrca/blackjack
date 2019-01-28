class Card
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[<3 <> + ^].freeze
  VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11].freeze

  attr_reader :suit, :rank, :value

  def initialize(rank, suit, value)
    @rank = rank
    @suit = suit
    @value = value
  end
end
