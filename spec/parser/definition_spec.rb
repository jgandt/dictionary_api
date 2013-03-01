describe Parser::Definition do

  let(:definition_xml){ %{<?xml version="1.0" encoding="utf-8" ?>
  let(:definition_strings){ ["cupel", "a critical examination, observation, or evaluation :trial"] }

  subject { Parser::Definition.new( definition_xml ) }

  describe '#parsed_definitions' do
    it 'should parse the xml definitions' do
      subject.parsed_definitions.should be_kind_of Array
    end
    it 'pulls out the dt elements' do
      subject.parsed_definitions.should == definition_strings
    end
    it 'removes all xml from the dt elements' do
      subject.parsed_definitions.first.should_not match /<.*>/
    end
  end
  describe '#xml_definitions' do
    it "parses the raw definition's response body into a REXML Document" do
      subject.send(:xml_definitions).should be_kind_of REXML::Document
    end
    it 'parses the body of the web service request properly' do
      subject.send(:xml_definitions).elements.collect('//dt'){|a|a}.should_not be_nil
    end
  end
  describe '#sanitize' do
    let(:string_with_xml){ ':hey<a /> a str<b>in</b>g with some <c></c>tags' }
    let(:string_without_xml){ 'hey a string with so<a />me tags' }

    it 'removes all xml tags from the passed string' do
      subject.send(:sanitize, string_with_xml).should_not match /<.*>/
    end
    it 'removes the leading ":" from the passed string' do
      subject.send(:sanitize, string_with_xml).should_not match /:/
    end
  end
end
