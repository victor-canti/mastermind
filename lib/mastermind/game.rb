# frozen_string_literal: true

require './computer_secret_colors'
require './player_secret_colors'

# instatiate class
class Game < ComputerSecretColors
  def initialize
    super
    puts 'You want to Guess the secret colors or Choose your own secret colors?'
    print 'Type "Guess" or "Choose": '
    @game_mode = gets.chomp
  end

  def start_game
    if @game_mode.downcase == 'guess'
      player_guess_colors
    elsif @game_mode.downcase == 'choose'
      player_choose_colors
    else
      print 'Type "Guess" or "Choose": '
      @game_mode = gets.chomp
      start_game
    end
  end

  def player_guess_colors
    secret_numbers
  end

  def player_choose_colors
    PlayerSecretColors.choose_secret_numbers
  end
end
