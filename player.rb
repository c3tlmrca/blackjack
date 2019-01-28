require './validation.rb'
require './bank.rb'
require './hand.rb'

class Player
  include Validation

  NAME_FORMAT = /\w+/.freeze

  attr_reader :name
  attr_accessor :bank, :cards, :bet, :points

  validate :name, :format, NAME_FORMAT

  def initialize(name = 'Freddie Mercury')
    @name = name.strip.capitalize
    @bank = Bank.new(100)
    @hand = Hand.new
    validate!
  end
end
