require 'rubygems'

require 'httparty'
require 'sanitize'
require 'rexml/document'

include REXML

class WordDefiner
  attr_reader :word

  def initialize(init_word)
    @word = init_word
  end


end

class MerriamWebsterApi
  include HTTParty
  format :xml

  attr_reader :word, :definition

  API_KEY = ''
  # http://www.dictionaryapi.com/api/v1/references/collegiate/xml/test?key=

  def initialize(init_word)
    @word = init_word
  end

  def simple_definitions
    # TODO transform raw_definitions to REXML object THEN:
    # each_element('//dt'){ |el| puts Sanitize.clean(el) }
    # on the REXML document
    raw_definitions
  end

  private

  def api_call_uri
    "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{@word}"
  end

  def api_call_query_params
    {:query => {:key => API_KEY}}
  end

  def raw_definitions
    @raw_definitions ||= self.class.get(api_call_uri, api_call_query_params)
  end

  def xml_definitions
    Document.new( raw_definitions.body )
  end


end

# class DictionaryComScraper
#   include HTTParty
#   format :html

#   attr_reader :word, :definition

#   def initialize(init_word)
#     @word = init_word
#   end

#   def definition
#     # @definition ||= page.elements('//div[@luna-Ent]').first
#   end

#   def simple_definition
#     @definition.elements('//div[@luna-Ent]').first
#   end

#   # private

#   def api_call_uri
#     "http://dictionary.reference.com/browse/#{@word}"
#   end

#   def api_call_query_params
#     {:query => { :s => 't' } }
#   end
  
#   def sanitized_html
#     sanitized = Sanitize.clean( page_html.force_encoding('UTF-8'),
#                     :remove_contents => true,
#                     :elements => ['div'],
#                     :add_attributes => {'div' => {'class' => 'dndata'}}
#                   )
#     raise sanitized.to_yaml
#   end

#   def page_html
#     '<input id="rincor2" type="text" /><div class="dndata"><div>dummy</div></div>'
#     # @page ||= self.class.get(api_call_uri, api_call_query_params).parsed_response
#   end

# end

# class DictionaryComApi
#   include HTTParty

#   attr_reader :word, :definition

#   API_KEY = ''
#   # http://www.dictionaryapi.com/api/v1/references/collegiate/xml/test?key=

#   def initialize(init_word)
#     @word = init_word
#   end

#   def api_call_uri
#     'http://api-pub.dictionary.com/v001'
#   end

#   def api_call_query_params
#     {:query => {
#                 :vid => API_KEY,
#                 :q => @word,
#                 :type => 'define',
#                 :site => 'dictionary'
#                }
#     }
#   end
  
#   def definition
#     @definition ||= self.class.get(api_call_uri, api_call_query_params)
#   end

#   def simple_definition
#     # definition
#   end
# end


