require 'rubygems'
require 'rspec'
require './word_definer'


describe WordDefiner do

  let(:dummy_word){ 'dummy_word' }
  subject{ WordDefiner.new(dummy_word) }

  describe '#initialize' do
    it 'stores the passed word in @word' do
      subject.word.should == 'dummy_word'
    end
  end

  # TODO reenable this
  # describe '#define_word' do
  #   it 'stores the definition of the word in @definition' do
  #     subject.define_word.should be_kind_of DefinedWord
  #   end
  # end

end


describe MerriamWebsterApi do

  let(:dummy_word){ 'test' }
  subject{ MerriamWebsterApi.new(dummy_word) }

  # before do
  #   # TODO Test with non-ascii characters!!!
  #   MerriamWebsterApi.stub(:get).and_return('<entry_list version="1.0"> <entry id="test[1]"><ew>test</ew><subj>ED-2a(2)#MA-1b(1)#MT-1a#CH-2a(1)</subj><hw hindex="1">test</hw><sound><wav>test0001.wav</wav><wpr>!test</wpr></sound><pr>test</pr><fl>noun</fl><et>Middle English, vessel in which metals were assayed, potsherd, from Anglo-French <it>test, tees</it> pot, Latin <it>testum</it> earthen vessel; akin to Latin <it>testa</it> earthen pot, shell</et><def><date>14th century</date> <sn>1 a</sn> <ssl>chiefly British</ssl> <dt>:<sx>cupel</sx></dt>  <sn>b <snp>(1)</snp></sn> <dt>:a critical examination, observation, or evaluation :<sx>trial</sx></dt> <sd>specifically</sd> <dt>:the procedure of submitting a statement to such conditions or operations as will lead to its proof or disproof or to its acceptance or rejection <vi>a <it>test</it> of a statistical hypothesis</vi></dt>  <sn><snp>(2)</snp></sn> <dt>:a basis for evaluation :<sx>criterion</sx></dt>  <sn>c</sn> <dt>:an ordeal or oath required as proof of conformity with a set of beliefs</dt> <sn>2 a</sn> <dt> :a means of <fw>testing</fw>: as</dt>  <sn><snp>(1)</snp></sn> <dt>:a procedure, reaction, or reagent used to identify or characterize a substance or constituent</dt>  <sn><snp>(2)</snp></sn> <dt>:something (as a series of questions or exercises) for measuring the skill, knowledge, intelligence, capacities, or aptitudes of an individual or group </dt>  <sn>b</sn> <dt>:a positive result in such a test</dt> <sn>3</sn> <dt>:a result or value determined by testing</dt> <sn>4</sn> <dt>:<sx>test match</sx></dt></def></entry><entry_list>')
  # end

  describe MerriamWebsterApi::API_KEY do
    it 'returns a valid API key' do
      MerriamWebsterApi::API_KEY.should == ''
    end
  end

  describe '#initialize' do
    it 'stores the passed word in @word' do
      subject.word.should == 'test'
    end
  end

  describe '#api_call_uri' do
    it 'returns the URI to call for the API' do
      subject.send(:api_call_uri).should match /dictionaryapi.com/
      subject.send(:api_call_uri).should match /#{dummy_word}/
    end
  end

  describe '#api_call_query_params' do
    it 'returns a hash whose only key is :query' do
      subject.send(:api_call_query_params).keys.should == [:query]
    end
    it 'returns a hash whose only value is a hash containing the api key' do
      subject.send(:api_call_query_params).values.should == [ {:key => MerriamWebsterApi::API_KEY } ]
    end
  end

  describe '#raw_definitions' do
    it 'returns the raw definitions as returned by the api as a REXML object' do
      subject.send(:raw_definitions).class.should be HTTParty::Response
    end
    it 'assigns @raw_definitions is it is nil' do
      subject.instance_variable_set(:@raw_definitions, nil)
      subject.send(:raw_definitions)
      subject.instance_variable_get(:@raw_definitions).should_not be_nil
    end
  end

  describe '#xml_definitions' do
    it "parses the raw definition's response body into a REXML Document" do
      subject.send(:xml_definitions).should be_kind_of REXML::Document
    end

  end

  describe '#simple_definitions' do
    it 'returns the definiton for @word' do
      # raise subject.simple_definition.to_yaml
    end
  end
end

# describe DictionaryComScraper do
#   let(:dummy_word){ 'test' }
#   subject{ DictionaryComScraper.new(dummy_word) }

#   describe '#initialize' do
#     it 'stores the passed word in @word' do
#       subject.word.should == 'test'
#     end
#   end

#   describe '#api_call_uri' do
#     context 'returns the URI to call for the API' do
#       its(:api_call_uri){ should match %r{http://dictionary.reference.com/browse} }
#       its(:api_call_uri){ should match %r{#{ dummy_word }} }
#     end
#   end

#   describe '#api_call_query_params' do
#     it 'returns a hash whose only key is :query' do
#       subject.api_call_query_params.keys.should == [:query]
#     end
#     it 'returns a hash whose keys are the query params for the api' do
#       subject.api_call_query_params[:query].keys.sort.should == [:s].sort
#     end
#   end

#   describe '#page_html' do
#     it 'returns the dictionary.com html->xml for @word' do
#       subject.page_html.should match %r{DOCTYPE.*<html.*#{subject.word}.*</html>}m
#     end
#   end

#   describe '#sanitized_html' do
#     it 'returns only the <div class="dndata"> elements' do
#       subject.sanitized_html.should match /#{subject.word}/
#     end
#   end

#   # describe '#definition' do
#   #   its( :definition ){ should match %r{#{subject.word}} }
#   # end
# end

# describe DictionaryComApi do
#   let(:dummy_word){ 'test' }
#   subject{ DictionaryComApi.new(dummy_word) }

#   describe DictionaryComApi::API_KEY do
#     it 'returns a valid API key' do
#       DictionaryComApi::API_KEY.should == ''
#     end
#   end

#   describe '#initialize' do
#     it 'stores the passed word in @word' do
#       subject.word.should == 'test'
#     end
#   end

#   describe '#api_call_uri' do
#     it 'returns the URI to call for the API' do
#       subject.api_call_uri.should match %r{http://api-pub.dictionary.com/v001}
#     end
#   end

#   describe '#api_call_query_params' do
#     it 'returns a hash whose only key is :query' do
#       subject.api_call_query_params.keys.should == [:query]
#     end
#     it 'returns a hash whose keys are the query params for the api' do
#       subject.api_call_query_params[:query].keys.sort.should == [:vid, :q, :type, :site].sort
#     end
#   end

#   describe '#definition' do
#     it 'returns the definiton for @word' do
#       raise subject.definition.to_yaml
#     end
#   end
# end



