require 'syllabicator'

describe Syllabicator do
	it "can be created" do
		s = Syllabicator.new
	end
end

describe Syllabicator, '#syllabicate' do
	it "gives no syllabes if no word" do
		s = Syllabicator.new
		s.syllabicate("").should eq([])
	end

	it "splits strongs vocals" do
		s = Syllabicator.new
		s.syllabicate("ae").should eq(["a","e"])
		s.syllabicate("toe").should eq(["to","e"])
	end
end
