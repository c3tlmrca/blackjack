require './validation.rb'

class Bank
  include Validation

  BET = 10

  attr_accessor :cash

  validate :cash, :positive

  def initialize(value = 0)
    @cash = value.to_i
    validate!
  end

  def add_cash(bet = BET)
    @cash += bet
  end

  alias return_cash add_cash

  def take_cash(bet = BET)
    @cash -= bet unless (@cash - bet).negative?
  end
end
