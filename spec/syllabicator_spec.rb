# encoding: utf-8
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
                @s.syllabicate("libra").should eq(["li","bra"])
                @s.syllabicate("cofre").should eq(["co","fre"])
                @s.syllabicate("letra").should eq(["le","tra"])
                @s.syllabicate("alacran").should eq(["a","la","cran"])
                @s.syllabicate("granero").should eq(["gra","ne","ro"])
                @s.syllabicate("trigal").should eq(["tri","gal"])
        end

        it "splits three intervocalic consonants with Xr" do
                @s.syllabicate("astro").should eq(["as","tro"])
                @s.syllabicate("astros").should eq(["as","tros"])
                @s.syllabicate("mambru").should eq(["mam","bru"])
        end

        it "splits four intervocalic consonants with Xr" do
                @s.syllabicate("monstruo").should eq(["mons","truo"])
                @s.syllabicate("abstracto").should eq(["abs","trac","to"])
        end

        it "splits two intervocalic consonants with Xl" do
                @s.syllabicate("copla").should eq(["co","pla"])
                @s.syllabicate("bucle").should eq(["bu","cle"])
                @s.syllabicate("sigla").should eq(["si","gla"])
                @s.syllabicate("plomo").should eq(["plo","mo"])
        end

        it "splits three intervocalic consonants with Xl" do
                @s.syllabicate("cumple").should eq(["cum","ple"])
                @s.syllabicate("manglar").should eq(["man","glar"])
                @s.syllabicate("explorar").should eq(["ex","plo","rar"])
                @s.syllabicate("ciclo").should eq(["ci","clo"])
        end

        it "splits intervocalic rr" do
                @s.syllabicate("corro").should eq(["co","rro"])
                @s.syllabicate("arrebatar").should eq(["a","rre","ba","tar"])
        end

        it "splits intervocalic ll" do
                @s.syllabicate("callado").should eq(["ca","lla","do"])
                @s.syllabicate("llamada").should eq(["lla","ma","da"])
                @s.syllabicate("botella").should eq(["bo","te","lla"])
        end

        it "splits intervocalic ch" do
                @s.syllabicate("concha").should eq(["con","cha"])
                @s.syllabicate("choco").should eq(["cho","co"])
                @s.syllabicate("corcho").should eq(["cor","cho"])

        end

        it "splits intervocalic tl" do
                # It may need be more tested
                @s.syllabicate("atlas").should eq(["at","las"])
        end

        it "splits prefixed words" do
                @s.syllabicate("reincidir").should eq(["re","in","ci","dir"])
                @s.syllabicate("coincidir").should eq(["co","in","ci","dir"])
                @s.syllabicate("diagonal").should eq(["di","a","go","nal"])
                @s.syllabicate("autoinmune").should eq(["au","to","in","mu","ne"])
        end

        it "splits breaking hiatus" do
                @s.syllabicate("amaría").should eq(["a","ma","rí","a"])
                @s.syllabicate("librería").should eq(["li","bre","rí","a"])
                @s.syllabicate("ríos").should eq(["rí","os"])
                @s.syllabicate("raúl").should eq(["ra","úl"])
                @s.syllabicate("caía").should eq(["ca","í","a"])
        end

        it "splits anglicims ending in 'y'" do
                @s.syllabicate("sexy").should eq(["se","xy"])
                @s.syllabicate("rugby").should eq(["rug","by"])
                @s.syllabicate("curry").should eq(["cu","rry"])
                @s.syllabicate("panty").should eq(["pan","ty"])
        end

        it "splits random words" do
                @s.syllabicate("semiautomático").should eq(["se","mi","au", \
                        "to","má","ti","co"])
                @s.syllabicate("cigüeña").should eq(["ci","güe","ña"])
                @s.syllabicate("reía").should eq(["re","í","a"])
                @s.syllabicate("ea").should eq(["e","a"])
                @s.syllabicate("ña").should eq(["ña"])
                @s.syllabicate("ahí").should eq(["a","hí"])
                @s.syllabicate("bis").should eq(["bis"])
                @s.syllabicate("retroalimentar").should eq(["re","tro","a",\
                        "li","men","tar"])
                @s.syllabicate("construcción").should eq(["cons","truc","ción"])
                @s.syllabicate("luisa").should eq(["lui","sa"])
                @s.syllabicate("licuéis").should eq(["li", "cuéis"])
                @s.syllabicate("caray").should eq(["ca","ray"])
                @s.syllabicate("rey").should eq(["rey"])
                @s.syllabicate("y").should eq(["y"])
        end
end


