class GameInterface
  WHATS_YOUR_MOVE = <<-DOC.freeze
  \nYour move:
  1. Hit.
  2. Stand.
  3. Open cards.
  DOC
  INVALID_INPUT = 'Invalide input.'.freeze
  PUSH = 'Push!'.freeze
  BUSTED = 'Busted!'.freeze
  STAND = 'Stand!'.freeze
  PLAYER_NAME = 'Enter your name: '.freeze
  PLAY_STILL = 'Continue?(y/n)'.freeze
  EXIT = 'n'.freeze
  CONTINUE = 'y'.freeze

  def show_points(player)
    print "\n#{player.name} points: #{player.points}."
  end

  def show_cash(player)
    print "\n#{player.name} bank: #{player.bank.cash}."
  end

  def win_bet(player)
    print "\n#{player.class} is winner!\n"
  end

  def stand(player)
    print "\n#{player.class} #{STAND}"
  end

  def show_cards_unhidden(player)
    player.cards.each { |card| each_card(card) }
  end

  def show_cards_hidden(player)
    player.cards.each { puts '* ' }
  end

  def each_card(card)
    puts "#{card.rank}#{card.suit}"
  end

  def invalide_input
    puts INVALID_INPUT
  end

  def push
    print "\nPUSH"
  end

  def players_move
    puts WHATS_YOUR_MOVE
    gets.to_i
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
