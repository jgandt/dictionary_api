module WordDefine
  class Config
    API_KEY = 'dummy_key'
  end
end

describe Api::MerriamWebster do

  let(:dummy_word){ 'test' }
  subject{ Api::MerriamWebster.new(dummy_word) }

  let(:definition_xml){ %{<?xml version="1.0" encoding="utf-8" ?>
  let(:definition_strings){ ["cupel", "a critical examination, observation, or evaluation :trial"] }

  let(:response){ HTTParty::Response.new(nil, OpenStruct.new({:body => definition_xml}), Proc.new{ }) }

  before do
    # TODO Test with non-ascii characters!!!
    Api::MerriamWebster.stub(:get).and_return( response )
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
      subject.send(:api_call_query_params).values.should == [ {:key => WordDefine::Config::API_KEY } ]
    end
  end

  describe '#raw_definitions' do
    before { subject.class.stub(:get).and_return( response ) }
    it 'returns the raw definitions as returned by the api as a REXML object' do
      subject.send(:raw_definitions).class.should be HTTParty::Response
    end

    it 'assigns @raw_definitions is it is nil' do
      subject.instance_variable_set(:@raw_definitions, 'something')
      subject.send(:raw_definitions)
      subject.instance_variable_get(:@raw_definitions).should_not be_nil
    end

    it 'returns an object that has a body of the xml' do
      subject.send(:raw_definitions).body.should == definition_xml
    end
  end

  describe '#definitions' do
    let(:definition_parser){ OpenStruct.new(:parsed_definitions => definition_strings ) }
    before { Parser::Definition.should_receive(:new).with( definition_xml ).and_return( definition_parser ) }
    it 'returns the definitons for @word' do
      subject.definitions.should == definition_strings
    end
  end
end