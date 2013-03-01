module WordDefine
  module Api
    class MerriamWebster

      include HTTParty
      format :xml

      attr_reader :word, :definition

      def initialize(init_word)
        @word = init_word
      end
      def definitions
        Parser::Definition.new( raw_definitions.body ).parsed_definitions
      end

      private

      def api_call_uri
        "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{@word}"
      end
      def api_call_query_params
        {:query => {:key => Config::API_KEY}}
      end
      def raw_definitions
        @raw_definitions ||= self.class.get(api_call_uri, api_call_query_params)
      end
    end
  end
end
