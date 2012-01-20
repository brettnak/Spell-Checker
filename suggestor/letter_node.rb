class LetterNode

  @@vowels = [ 'a', 'e', 'i', 'o', 'u' ]

  def initialize
    @children = {}
  end

  # add
  def populate( letter_array, word )
    if letter_array.empty?
      @children[:terminal] = word
      return
    end

    current_letter = letter_array.first
    
    current_child = ( @children[current_letter] ||= LetterNode.new )
    
    current_child.populate( letter_array[1..-1], word )
  end

  # lower case letters only.
  def suggest( letter_array, previous_letter )
    current_letter    = letter_array.first
    remaining_letters = letter_array[1..-1] || []

    if letter_array.empty?
      return @children[:terminal]
    end

    next_node  = @children[current_letter]
    suggestion = next_node.suggest( remaining_letters, current_letter ) rescue nil

    # Couldn't find a word
    if suggestion.nil?

      # Handle the repeated letter case
      if previous_letter == current_letter
        suggestion = self.suggest( remaining_letters, current_letter )
        return suggestion unless suggestion.nil?
      end
        
      # If repeated letters didn't work, try a new vowel
      if @@vowels.include? current_letter
        suggestion = check_alternate_vowels( letter_array, remaining_letters )
      end
    end

    return suggestion
  end

  def check_alternate_vowels( letter_array, remaining_letters )
    suggestion = nil

    @@vowels.each do |vowel|
      # don't recheck the current letter
      next if letter_array.first == vowel

      suggestion = @children[vowel].suggest( remaining_letters, letter_array.first ) rescue nil
      break unless suggestion.nil?
    end

    return suggestion
  end

  def children
    return @children
  end
end

