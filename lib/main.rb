class HangMan
  def initialize(words_file_name)
    all_words = File.new(words_file_name, 'r').readlines
    @dictionary = filter_words(all_words)
  end

  def start
    word_to_guess = @dictionary[rand(@dictionary.length)]
    puts word_to_guess
  end

  private

  def filter_words(word_list)
    word_list.keep_if { |word| word.chomp.length.between?(5, 12) }
  end
end

words_file_name = 'google-10000-english-no-swears.txt'
game = HangMan.new(words_file_name)