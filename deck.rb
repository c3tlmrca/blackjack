class Deck
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[<3 <> + ^].freeze
  VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11].*(4).sort.freeze
  ACE_CORRECTION = 1

  attr_accessor :cards

  def initialize
    @cards = []
    @cards = create_deck
    @cards.shuffle!
  end

  private

  def create_deck
    cards = create_cards
    cards_with_values = add_values(cards)
  end

  def create_cards
    cards = []
    RANKS.each.with_index do |rank, _index|
      SUITS.each do |suit|
        cards << rank + suit
      end
    end
    cards
  end

  def add_values(cards)
    added_values = []
    cards.each.with_index do |rank, index|
      hash = {}
      hash[rank] = VALUES[index]
      added_values << hash
    end
    added_values
  end
end
