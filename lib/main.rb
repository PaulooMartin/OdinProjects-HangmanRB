class HangMan
  def initialize(words_file_name)
    all_words = File.new(words_file_name, 'r').readlines
    @dictionary = filter_words(all_words)
  end

  def start
    set_starting_variables
    current_guess = prompt_player_guess
    result_of_guess(current_guess)
  end

  private

  def set_starting_variables
    @word_to_guess = @dictionary[rand(@dictionary.length)].chomp
    @current_standing = Array.new(@word_to_guess.length, '_')
    @mistakes_left = 7
    @good_letters = []
    @bad_letters = []
  end

  def filter_words(word_list)
    word_list.keep_if { |word| word.chomp.length.between?(5, 12) }
  end

  def prompt_player_guess
    print 'Enter a letter: '
    guess = gets.chomp
    until guess.match?(/\A[a-zA-Z]\Z/)
      puts "\nIt seems like you gave an invalid input. Previous input: #{guess}"
      print 'Enter a letter: '
      guess = gets.chomp
    end
    guess.downcase
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
end

words_file_name = 'google-10000-english-no-swears.txt'
game = HangMan.new(words_file_name)

game.start
