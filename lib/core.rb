module WordDefine
  class WordDefiner
    # raise WordDefine::Api::MerriamWebster.inspect
    attr_reader :word

    def initialize(init_word)
      @word = init_word
    end
    def define
      Api::MerriamWebster.new( @word ).definitions
    end
    def pretty
      define.join("\r")
    end
  end
end
