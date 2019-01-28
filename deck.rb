require './card.rb'

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    create_cards
    @cards.shuffle!
  end

  private

  def create_cards
    Card::SUITS.each do |suit|
      Card::RANKS.each_with_index do |rank, index|
        card = Card.new(suit, rank, Card::VALUES[index])
        @cards << card
      end
    end
  end
end
