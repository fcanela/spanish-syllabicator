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

        it "splits one intervocalic consonant" do
                @s.syllabicate("tomate").should eq(["to","ma","te"])
                @s.syllabicate("eso").should eq(["e","so"])
                @s.syllabicate("ira").should eq(["i","ra"])
                @s.syllabicate("elegir").should eq(["e","le","gir"])
        end

        it "splits two intervocalic consonants without Xr, Xl, ch" do
                @s.syllabicate("palma").should eq(["pal","ma"])
                @s.syllabicate("mantel").should eq(["man","tel"])
                @s.syllabicate("naranja").should eq(["na","ran","ja"])
        end

        it "splits three intervocalic consonant without Xr, Xl, ch" do
                @s.syllabicate("consta").should eq(["cons","ta"])
                @s.syllabicate("perspicaz").should eq(["pers","pi","caz"])
        end

        it "splits two intervocalic consonants with Xr" do
                pending "to implement"
                @s.syllabicate("libra").should eq(["li","bra"])
                @s.syllabicate("cofre").should eq(["co","fre"])
                @s.syllabicate("letra").should eq(["le","tra"])
                @s.syllabicate("alacran").should eq(["a","la","cran"])
                @s.syllabicate("granero").should eq(["gra","ne","ro"])
                @s.syllabicate("trigal").should eq(["tri","gal"])
        end
end
