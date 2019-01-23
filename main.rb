require './validation.rb'
require './bank.rb'
require './deck.rb'
require './player.rb'
require './dealer.rb'
require './game_logic.rb'

class Main
  attr_accessor :game

  PLAYER_NAME = 'Enter your name: '.freeze
  PLAY_STILL = 'Continue?(y/n)'.freeze
  EXIT = 'n'.freeze
  CONTINUE = 'y'.freeze
  INVALID_INPUT = 'Invalid input.'.freeze

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

  def play_still
    loop do
      print PLAY_STILL
      input = gets.strip.downcase
      exit if input.eql?(EXIT)
      break if input.eql?(CONTINUE)

      puts INVALID_INPUT
    end
  end
end

print 'Enter your name: '
player_name = gets.strip

main = Main.new(player_name)
main.start_game
