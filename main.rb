require './validation.rb'
require './bank.rb'
require './deck.rb'
require './player.rb'
require './dealer.rb'
require './game_logic.rb'

class Main
  attr_accessor :game

  def initialize(player_name)
    @game = GameLogic.new(player_name)
  end

  def start_game
    loop do
      @game.deal_cards
      @game.accept_bets
      @game.moves
      play_still
    end
  end
end

main = Main.new(player_name)
main.start_game
