require 'rubygems'

require 'httparty'
require 'sanitize'
require 'rexml/document'

require './lib/core.rb'

Dir[File.dirname(__FILE__) + '/./lib/**/*.rb'].each do |file| 
  require file
end

include REXML


class Runner
  include WordDefine

  def self.run(word)
    WordDefiner.new(word).define.each do |definition|
      puts definition 
    end  
  end
end
Runner.run( ARGV.first ) if __FILE__ == $0
