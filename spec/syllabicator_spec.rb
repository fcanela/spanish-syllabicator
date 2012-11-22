require 'syllabicator'

describe Syllabicator do
	it "can be created" do
		s = Syllabicator.new
	end
end

describe Syllabicator, '#syllabicate' do
        before(:each) do
		@s = Syllabicator.new
        end

	it "gives no syllabes if no word" do
		@s.syllabicate("").should eq([])
	end

	it "splits strongs vocals" do
		@s.syllabicate("ae").should eq(["a","e"])
		@s.syllabicate("toe").should eq(["to","e"])
                @s.syllabicate("aeo").should eq(["a","e","o"])
                @s.syllabicate("aieeu").should eq(["aie","eu"])
	end

        it "splits two intervocalic consonant without Xr, Xl, ch" do
                #pending "under development"
                @s.syllabicate("tomate").should eq(["to","ma","te"])
                @s.syllabicate("eso").should eq(["e","so"])
                @s.syllabicate("ira").should eq(["i","ra"])
                @s.syllabicate("elegir").should eq(["e","le","gir"])
        end
end
