# frozen_string_literal: true

# player choose random secret colors
module PlayerSecretColors
  def self.choose_secret_numbers
    @guesses = 1
    print "\nSecret number: "
    player_secret_numbers
    @possibilities = {}
    (1111..6666).each do |i|
      possibility = i.to_s.chars.map(&:to_i)
      if possibility.all? { |possibilities| (1..6).cover?(possibilities) }
      @possibilities[i.to_s.chars.map(&:to_i)] = true
      end
    end
    initial_guess
  end

  def self.player_secret_numbers
    @secret_numbers = gets.chomp.chars.map(&:to_i)
    if @secret_numbers.length != 4 || !@secret_numbers.all? { |num| (1..6).cover?(num) }
      print "Choose 4 numbers between 1 and 6: "
      return player_secret_numbers
    end
    puts
  end

  def self.initial_guess
    @comp_guess = [1,1,2,2]
    if @comp_guess == @secret_numbers
      win
    else
      @possibilities.delete(@comp_guess)
      remove_possibilities
    end
  end

  def self.remaining_guesses
    if @comp_guess == @secret_numbers
      win
    else
      @possibilities.delete(@comp_guess)
      remove_possibilities
    end
  end

  def self.remove_possibilities
    @match_positions = []
    @comp_guess.each_with_index do |num, position|
      @possibilities.each_key do |possibility|
        @possibilities.delete(possibility) if num == possibility[position] && num != @secret_numbers[position]
        @match_positions.push(num) if num == @secret_numbers[position]
      end
    end
    @match_positions.uniq!
    hints
    next_guess
  end

  def self.next_guess
    @possibilities.each_key do |possibility|
      if @secret_numbers.join('').to_i > 2200
        if possibility != @secret_numbers && @possibilities.length > 200
          @comp_guess = possibility
        elsif @possibilities.length < 201
          @comp_guess = possibility
        end
      else
        if possibility != @secret_numbers && @possibilities.length > 200
          @comp_guess = @possibilities.keys.min
        elsif @possibilities.length < 201
          @comp_guess = possibility
        end
      end
    end
    @guesses += 1 
    remaining_guesses
  end

  def self.hints
    @right_position_nums = @comp_guess & @secret_numbers
    first_hint if @guesses == 1
    second_hint if @guesses == 2
    third_hint if @guesses == 3
    fourth_hint if @guesses == 4
    fifth_hint if @guesses == 5
  end

  def self.first_hint
    return puts "#{@guesses}. #{@comp_guess.join}  (now we know there's 1's and 2's)" if @secret_numbers.include?(1) && @secret_numbers.include?(2)
    if !@comp_guess.any? { |num| @secret_numbers.include?(num)}
      puts "#{@guesses}. #{@comp_guess.join}  (I missed all positions lol)"
      @missed = 1
    elsif @match_positions.all? { |num| num == 1 } && !@match_positions.empty?
      puts "#{@guesses}. #{@comp_guess.join}  (now we know there's 1's)"
    elsif @match_positions.all? { |num| num == 2 } && !@match_positions.empty?
      puts "#{@guesses}. #{@comp_guess.join}  (now we know there's 2's)"
    elsif !@match_positions.empty?
      puts "#{@guesses}. #{@comp_guess.join}  (now we know there's 1's and 2's)"
    end
    return puts "#{@guesses}. #{@comp_guess.join}  (so there's 1's)" if @secret_numbers.include?(1)
    return puts "#{@guesses}. #{@comp_guess.join}  (so there's 2's)" if @secret_numbers.include?(2)
  end

  def self.second_hint
    if !@comp_guess.any? { |num| @secret_numbers.include?(num)} && @missed == 1
      puts "#{@guesses}. #{@comp_guess.join}  (I MISSED ALL POSITIONS AGAIN WTH)"
    elsif !@comp_guess.any? { |num| @secret_numbers.include?(num)}
      puts "#{@guesses}. #{@comp_guess.join}  (I missed all positions lol)"
    else
      @match_positions.each do |num|
        hint = "#{@guesses}. #{@comp_guess.join}  ("
        puts hint += "now we know there's #{num}'s)" if @match_positions.uniq.length == 1
      end
    end
    return puts "#{@guesses}. #{@comp_guess.join}  (you just switch the order, try new numbers)" if @secret_numbers.include?(1) && @secret_numbers.include?(2)
  end

  def self.third_hint
    hint = "#{@guesses}. #{@comp_guess.join}  ("
    if !@comp_guess.any? { |num| @secret_numbers.include?(num)}
      puts "#{@guesses}. #{@comp_guess.join}  (there's no pegs right here)"
    else
      @match_positions.each.with_index do |num, position|
        return puts "#{@guesses}. #{@comp_guess.join}  (good job! Now we got #{@match_positions[2]} as well)" if @secret_numbers.join('').to_i < 2200
        puts hint += "now we have almost all the numbers, you're missing just one of them)" if @match_positions.uniq.length == 1
        hint += "now we know there's #{num} and " if @match_positions.uniq.length > 1 && position == 0
        hint += "#{num}'s)" if @match_positions.uniq.length > 1 && position == 1
      end
    end
    puts hint if @match_positions.uniq.length > 1
  end

  def self.fourth_hint
    return puts "#{@guesses}. #{@comp_guess.join}  (we are almost there c'mon)" if @secret_numbers.join('').to_i < 2200
    hint = "#{@guesses}. #{@comp_guess.join}  ("
    if !@comp_guess.any? { |num| @secret_numbers.include?(num)}
      puts "#{@guesses}. #{@comp_guess.join}  (there's no pegs right here)"
    else
      @match_positions.each.with_index do |num, position|
        puts hint += "the switch didn't work, try another one)" if @match_positions.uniq.length == 1
        hint += "now we have #{num} and " if @match_positions.uniq.length > 1 && position == 0
        hint += "#{num}'s)" if @match_positions.uniq.length > 1 && position == 1
      end
    end
    puts hint if @match_positions.uniq.length > 1
  end

  def self.fifth_hint
    hint = "#{@guesses}. #{@comp_guess.join}  ("
    if !@comp_guess.any? { |num| @secret_numbers.include?(num)}
      puts "#{@guesses}. #{@comp_guess.join}  (there's no pegs right here)"
    else
      @match_positions.each.with_index do |num, position|
        puts hint += "you're almost there, you just need a number)" if @match_positions.uniq.length == 1
        hint += "now we have #{num} and " if @match_positions.uniq.length > 1 && position == 0
        hint += "#{num}'s)" if @match_positions.uniq.length > 1 && position == 1
      end
    end
    puts hint if @match_positions.uniq.length > 1
  end

  def self.win
    "#{@guesses}. #{@comp_guess.join}  (you win)"
  end
end
