require 'json'

def start_message
  puts 'Welcome to Hangman!'
  puts 'In Hangman, you will have to guess the secret word (eg. _____) by giving its individual letters.'
  sleep 4
  puts 'Giving a letter will yield a result. If the letter was good, it will replace the "_" in place (eg. a___e).'
  puts 'If the letter was bad, the number of mistakes you have left will decrease.'
  sleep 4
  puts 'If you wish to save your current progress, type "save" when prompted for a letter'
  puts ''
  puts 'Welcome to Hangman! Goodluck!'
end

class HangMan
  def initialize(words_file_name, save_file_name)
    all_words = File.new(words_file_name, 'r').readlines
    @save_file_name = save_file_name
    @dictionary = filter_words(all_words)
  end

  def start
    set_starting_variables
    display_game_state
    is_win = false
    until @mistakes_left.zero? || is_win
      current_guess = prompt_player_guess
      result_of_guess(current_guess)
      display_game_state
      is_win = @current_standing.join('') == @word_to_guess
    end
    game_result(is_win)
  end

  private

  def set_starting_variables
    @word_to_guess = @dictionary[rand(@dictionary.length)].chomp
    @current_standing = Array.new(@word_to_guess.length, '_')
    @mistakes_left = 7
    @good_letters = []
    @bad_letters = []
    load_game?
  end

  def filter_words(word_list)
    word_list.keep_if { |word| word.chomp.length.between?(5, 12) }
  end

  def prompt_player_guess
    print 'Enter a letter or "save": '
    guess = gets.chomp.downcase
    until guess.match?(/\A[a-zA-Z]\Z/) && !(@good_letters.include?(guess) || @bad_letters.include?(guess))
      save_game_state if guess == 'save'
      message = guess == 'save' ? 'Game saved' : "It seems like you gave an invalid or used input. Prev input: #{guess}"
      puts "\n#{message}"
      print 'Enter a new letter or "save": '
      guess = gets.chomp.downcase
    end
    guess
  end

  def result_of_guess(current_guess)
    result = @word_to_guess.include?(current_guess)
    if result
      update_standing(current_guess)
      @good_letters.push(current_guess)
    else
      @mistakes_left -= 1
      @bad_letters.push(current_guess)
    end
    result
  end

  def update_standing(current_guess)
    @word_to_guess.split('').each_with_index do |letter, index|
      @current_standing[index] = current_guess if letter == current_guess
    end
  end

  def display_game_state
    puts "\n____________________________  Hangman  ____________________________________________"
    puts 'Mistakes left || Current Standing || Correct letters used || Incorrect letters used'
    mistakes_column = @mistakes_left.to_s.ljust(8).rjust(14)
    standing_column = @current_standing.join('').ljust(14)
    correct_column = @good_letters.join(' ').ljust(21)
    puts "#{mistakes_column}|| #{standing_column}(#{@current_standing.length})|| #{correct_column}|| #{@bad_letters.join(' ')}"
  end

  def game_result(is_win)
    if is_win
      puts 'Congratulations player! You won the game :D'
    else
      puts "Unfortunately, you lost! The word to guess was '#{@word_to_guess}'."
    end
  end

  def save_game_state
    File.open(@save_file_name, 'w') do |file|
      JSON.dump({
                  word_to_guess: @word_to_guess,
                  current_standing: @current_standing,
                  mistakes_left: @mistakes_left,
                  good_letters: @good_letters,
                  bad_letters: @bad_letters
                }, file)
    end
  end

  def load_game?
    answer = 'meh'
    until %w[y n].include?(answer)
      print 'Do you want to load last saved progress? (y/n): '
      answer = gets.chomp.downcase
    end
    load_last_saved_progress if answer == 'y'
  end

  def load_last_saved_progress
    loaded_game_state = JSON.parse File.read(@save_file_name)
    @word_to_guess = loaded_game_state['word_to_guess']
    @current_standing = loaded_game_state['current_standing']
    @mistakes_left = loaded_game_state['mistakes_left']
    @good_letters = loaded_game_state['good_letters']
    @bad_letters = loaded_game_state['bad_letters']
  end
end

words_file_name = 'google-10000-english-no-swears.txt'
save_file_name =  'hangman-save-file.json'
start_message
game = HangMan.new(words_file_name, save_file_name)

game.start
