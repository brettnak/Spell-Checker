require "spec_helper"

describe LetterNode do

  describe :populate do
    before :each do
      @root = LetterNode.new
    end

    it "should set it's own :terminal if the given letter_array is empty" do
      @root.populate( [], "word" )

      @root.children[:terminal].should == "word"
    end
    
    it "should create a child node if the child node for the first letter is empty" do
      @root.children['a'].should be_nil
      @root.populate( ['a'], "a" )
      @root.children['a'].should be_a LetterNode
    end

    it "should not create the child node if it already has one" do
      @child = LetterNode.new
      @root.children['a'] = @child

      @root.populate( ['a'], "term" )
      @root.children['a'].should be @child
    end
  end

  describe :suggest do
    before :each do
      @root = LetterNode.new
    end

    it "should return @children[:terminal] if letter_array is empty" do
      @root.children[:terminal] = "foo"
      suggestion = @root.suggest( [], nil )
      suggestion.should == "foo"
    end

    it "should suggest @children[<letter_array.first>] if it is present" do
      @child = LetterNode.new
      @child.children[:terminal] = "term"

      @child.should_receive( :suggest ).and_return( @child.children[:terminal] )
      @root.children["a"] = @child

      @root.suggest( ['a'], nil )
    end

    it "should should recurse on itself ( instead of children ) if it's next node is nil and the next letter of the privided word is a repeat" do
      @child = LetterNode.new
      @child.children[:terminal] = "term"

      @root.children["b"] = @child

      @child.should_receive( :suggest ).with([], 'b').once.and_return( @child.children[:terminal] )

      suggestion = @root.suggest( [ 'c', 'b' ], 'c' )
      suggestion.should == "term"
    end

    it "should check_alternate_vowels if the current_letter is a vowel and the normal next_node returned nil" do
      @child = LetterNode.new
      @child.children[:terminal] = "term"
      
      @root.children["a"] = @child
      
      @child.should_receive( :suggest ).with([], 'e').once.and_return( @child.children[:terminal] )

      @root.suggest( ["e"], nil )
    end
  end

  describe :check_alternate_vowels do
    # this is pretty much tested in the test above
    # it "should iterate over all possible vowels and break on the first suggestion"
  end
end
