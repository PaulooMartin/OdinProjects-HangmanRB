class HangMan
  def initialize(words_file_name)
    all_words = File.new(words_file_name, 'r').readlines
    @dictionary = filter_words(all_words)
  end

  def start
    word_to_guess = @dictionary[rand(@dictionary.length)]
    current_guess = prompt_player_guess
    puts word_to_guess
    puts current_guess
  end

  private

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
    guess
  end
end

words_file_name = 'google-10000-english-no-swears.txt'
game = HangMan.new(words_file_name)