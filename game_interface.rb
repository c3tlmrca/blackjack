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
  PLAY_STILL = "\nContinue?(y/n)".freeze
  EXIT = 'n'.freeze
  CONTINUE = 'y'.freeze

  def show_points(player)
    print "\n#{player.class} points: #{player.hand.points}."
  end

  def show_cash(player)
    print "\n#{player.class} bank: #{player.bank.cash}."
  end

  def win_bet(player)
    print "\n#{player.class} is winner!\n"
  end

  def stand(player)
    print "\n#{player.class} #{STAND}"
  end

  def busted(player)
    print "\n#{player.class} is #{BUSTED}"
  end

  def print_player_name(player)
    print "\n#{player.class}: "
  end

  def show_cards_hidden(player)
    print_player_name(player)
    player.hand.cards.each { card_hidden }
  end

  def show_cards_unhidden(player)
    print_player_name(player)
    player.hand.cards.each { |card| card_unhidden(card) }
  end

  def card_hidden
    print '* '
  end

  def card_unhidden(card)
    print "#{card.suit}#{card.rank} "
  end

  def invalide_input
    puts INVALID_INPUT
  end

  def push
    print "\n#{PUSH}"
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
