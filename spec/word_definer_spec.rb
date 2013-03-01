require 'rubygems'
require 'rspec'
require 'ostruct'

require './word_definer'

include WordDefine

Dir[File.dirname(__FILE__) + '/./**/*_spec.rb'].each do |file| 
  require file
end

describe WordDefiner do

  let(:dummy_word){ 'dummy_word' }
  subject{ WordDefiner.new(dummy_word) }

  let(:definition_string_array){ [":cupel", ":a critical examination, observation, or evaluation :trial"] }
  let(:api){ Api::MerriamWebster.new( dummy_word )}

  let(:merriam_webster_api){ OpenStruct.new(:definitions => definition_string_array) }

  before { Api::MerriamWebster.stub(:new).and_return(merriam_webster_api) }

  describe '#initialize' do
    it 'stores the passed word in @word' do
      subject.word.should == 'dummy_word'
    end
  end
  describe '#define' do
    before { Api::MerriamWebster.should_receive(:new).with(dummy_word).and_return(merriam_webster_api) }
    it 'stores the definition of the word in @definition' do
      subject.define.should == definition_string_array
    end
  end
  describe '#pretty' do
    it 'puts out a string representation of the definitions' do
      subject.pretty.should == definition_string_array.join("\r")
    end
  end
end
