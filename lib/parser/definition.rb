module WordDefine
  module  Parser
    class Definition
      include Enumerable

      def initialize(xml)
        @xml = xml
      end
      def parsed_definitions
        xml_definitions.elements.collect('//dt'){ |el| sanitize(el.to_s) }
      end

      private

      def xml_definitions
        Document.new( @xml )
      end
      def sanitize(tagged_string)
        Sanitize.clean(tagged_string).strip.sub(/^:/, '')
      end
    end
  end
end
