require './validation.rb'
require './bank.rb'
require './deck.rb'
require './player.rb'
require './dealer.rb'
require './game_logic.rb'

class Main
  attr_accessor :game

  def initialize
    @game = GameLogic.new
  end

  def start_game
    loop do
      @game.deal_cards
      @game.accept_bets
      @game.moves
      @game.game_interface.play_still
    end
  end
end

main = Main.new
main.start_game
