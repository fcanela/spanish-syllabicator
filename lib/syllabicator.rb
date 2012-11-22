#!/usr/bin/ruby

class Syllabicator
        VOWELS=['a', 'e', 'o', 'u']
        STRONG_VOWELS=['a', 'e', 'o']


        def handle_strong_vowels(word,pos)
                new_syllabe = ""
                remainder = word
                
                if STRONG_VOWELS.include? word[pos]
                        if STRONG_VOWELS.include? word[pos+1]
                                new_syllabe = word[0..pos]
                                remainder = word[pos+1..-1]
                        end
                end

                return new_syllabe, remainder
        end

        def process(word)
                syllabes = []
                new_syllabe = ""
                remainder = ""

                # Search for a splittable syllabe
                (0..word.length-1).each do |pos|
                        if VOWELS.include? word[pos]
                                # If it's a vowel, run vowel tests
                                new_syllabe, remainder = handle_strong_vowels(word,pos)
                                break if new_syllabe != ""
                        else
                                # If it's a consonant, run consonants tests
                        end
                end

                if new_syllabe != ""
                        # If we found any new syllabe
                        # Add it to syllabe list
                        syllabes << new_syllabe
                        # Process the remainder and concat
                        syllabes.concat process(remainder)
                else
                        # If this is the last syllabe found
                        # Add the part as syllabe
                        syllabes << word
                end

                puts "End of search:"
                p syllabes
                return syllabes
        end

        def syllabicate(word)
                word = word.downcase

                if word==""
                        return []
                end

                return process(word)
        end
end

s = Syllabicator.new
p s.syllabicate("aerodromo")
