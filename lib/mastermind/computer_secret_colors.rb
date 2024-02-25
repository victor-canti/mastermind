# frozen_string_literal: true

# computer generate ramdom secret colors
class ComputerSecretColors
  def secret_numbers
    @guesses = 1
    @secret_numbers = []
    (1..4).each do |_|
      @secret_numbers.push(Random.new.rand(1..6).to_s)
    end
    # p @secret_numbers
    puts "\nEvery round there are A right positions and B wrong positions\n\n"
    guesses
  end

  def guesses
    print 'Guess numbers: '
    @guessed_numbers = gets.chomp

    if @guessed_numbers.length != 4 || !@guessed_numbers.split('').all? { |num| '123456'.include?(num) }
      puts "\nYou need to guess 4 numbers between 1 and 6."
      guesses
    else
      rounds
    end
  end

  def rounds
    if @guessed_numbers.split('') == @secret_numbers
      player_win
    elsif @secret_numbers.any? { |num| @guessed_numbers.include?(num) }
      position
    else
      puts "#{@guesses}. Guess: #{@guessed_numbers}  0A0B  (there's no numbers match)\n\n"
      @guesses += 1
      guesses
    end
  end

  def position
    right_position_nums = []
    @quantity = @guessed_numbers.split('') & @secret_numbers
    @guessed_numbers.split('').each_with_index do |num, position|
      right_position_nums.push(num) if @guessed_numbers[position] == @secret_numbers[position]
    end
    hints(right_position_nums)
  end

  def hints(nums)
    if @secret_numbers.sort == @guessed_numbers.split('').sort && @switch == 1
      switch_didnt_work(nums.length)
    elsif @secret_numbers.sort == @guessed_numbers.split('').sort
      have_all_numbers(nums.length)
    elsif nums.length == 1 && @guessed_numbers.split('').uniq.length == 1
      only_one_positioned(nums[0])
    elsif nums.length == 1 && @quantity.length == 1 && @guessed_numbers.split('').uniq.length == 2
      @guessed_numbers.split('').uniq.delete(nums[0])
      one_positioned(nums[0], @guessed_numbers.split('').uniq[0])
    elsif nums.length == 2 && @guessed_numbers.split('').uniq.length == 2 && @a == 1
      two_positioned(nums[1])
    elsif nums.length == 1
      only_one_positioned(nums[0]) if @quantity.length == 1
      @quantity.delete(nums[0])
      wrong_positions(nums[0], @quantity) if @quantity.length > 0
    elsif @quantity == nums
      all_positioned(nums) if nums.length > 1
      only_one_positioned(nums[0]) if nums.length == 1
    elsif nums.length > 1
      position_hint(nums, @quantity)
    else
      bagel_hint
    end
  end

  def only_one_positioned(num)
    if @guessed_numbers.split('').uniq.length == 1
      puts "#{@guesses}. Guess: #{@guessed_numbers}  1A0B  (so there's one #{num})\n\n"
      @guesses += 1
      @a = 1
      guesses
    else
      puts "#{@guesses}. Guess: #{@guessed_numbers}  0A1B  (now you know #{num}'s position)\n\n"
      @guesses += 1
      @a = 1
      guesses
    end
  end

  def one_positioned(num, position)
    puts "#{@guesses}. Guess: #{@guessed_numbers}  1A1B  (so there's no #{position}'s', but now we know where the #{num} is)\n\n"
    @guesses += 1
    guesses
  end

  def two_positioned(num)
    puts "#{@guesses}. Guess: #{@guessed_numbers}  2A0B  (so there's one #{num}, because #{num - 1}+B increased by 1)\n\n"
    @guesses += 1
    guesses
  end

  def have_all_numbers(num)
    puts "#{@guesses}. Guess: #{@guessed_numbers}  #{num}A#{4 - num}B  (you now have all numbers, just not in the right order)\n\n"
    @guesses += 1
    @switch = 1
    guesses
  end

  def switch_didnt_work(num)
    puts "#{@guesses}. Guess: #{@guessed_numbers}  #{num}A#{4 - num}B  (the switch didn't work, try another one)\n\n"
    @guesses += 1
    guesses
  end

  def position_hint(positioned, quantity)
    b = 0
    hint = "#{@guesses}. Guess: #{@guessed_numbers}  #{positioned.length}A#{b}B  ("
    if quantity.each_with_index { |num, i| num == positioned[i] }.all?
      positioned.each_with_index do |num, position|
        if num != quantity[position]
          b += 1
        end
        if position == positioned.length - 1
          hint += "#{num} is right positioned)\n\n"
        else
          hint += "#{num} and "
        end
      end
    else
      b += 1
      positioned.each_with_index do |num, position|
        if num == quantity[position] && position == positioned.length - 1
          hint += "#{num} is right positioned)\n\n"
        elsif num == quantity[position] && positioned.length == 2
          hint += "#{num} and "
        elsif num == quantity[position] && positioned.length > 2
          hint += "#{num},"
        elsif num != quantity[position] && position == positioned.length - 1
          hint += "there's is one #{num})\n\n"
        elsif num != quantity[position] && position != positioned.length - 1
          hint += "there's one #{num} and "
        end
      end
    end
    puts hint
    @guesses += 1
    guesses
  end

  def all_positioned(positioned)
    hint = "#{@guesses}. Guess: #{@guessed_numbers}  #{positioned.length}A0B  ("
    positioned.each_with_index do |num, position|
      if position == positioned.length - 1
        hint += "and #{num} is on the right position)\n\n"
      else
        hint += "#{num} " if positioned.length == 2
        hint += "#{num}, " if positioned.length > 2
      end
    end
    puts hint
    @guesses += 1
    guesses
  end

  def wrong_positions(positioned, not_positioned)
    hint = "#{@guesses}. Guess: #{@guessed_numbers}  1A#{not_positioned.length}B  (#{positioned} is on the right position, but "
    not_positioned.each_with_index do |num, position|
      if position == not_positioned.length - 1
        hint += "and #{num}'s is at the wrong position)\n\n" if not_positioned.length > 1
        hint += "#{num} is at the wrong position)\n\n" if not_positioned.length == 1
      elsif not_positioned.length == 2 && position != not_positioned.length - 1
        hint += "#{num}'s "
      elsif not_positioned.length > 2 && position != not_positioned.length - 1
        hint += "#{num}'s,"
      end
    end
    puts hint
    @guesses += 1
    guesses
  end

  def bagel_hint
    bagel_nums = @guessed_numbers.split('') & @secret_numbers
    hint = "#{@guesses}. Guess: #{@guessed_numbers}  0A#{bagel_nums.length}B  ("
    bagel_nums.uniq.sort.each_with_index do |num, i|
      if i == bagel_nums.uniq.length - 1
        hint += "#{num}'s are on the wrong position)\n\n"
      else
        hint += "#{num}'s and "
      end
    end
    puts hint
    @guesses += 1
    guesses
  end

  def player_win
    print "Congratulations you win with #{@guesses} guesses!"
    print
  end
end
