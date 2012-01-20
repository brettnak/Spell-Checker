require File.join( File.dirname( __FILE__ ), 'letter_node' )

class Suggestor
  def initialize
    @root = LetterNode.new
  end

  def root
    return @root
  end

  # Note, you can add more than words, any string will work but performance will get worse as strings get longer
  def add_word( string )
    chars = string.split("")
    @root.populate( chars, string )
  end

  def suggestion( string )
    letters = string.downcase.split( "" )
    return @root.suggest( letters, nil )
  end
end
