#!/usr/bin/ruby

class Syllabicator
        VOWELS=['a', 'e', 'i', 'o', 'u']
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

        def handle_intervocalic_consonants(word,pos)
                # Search the next vowel
                next_vowel_pos = pos
                (pos+1..word.length-1).each do |next_pos|
                        if VOWELS.include? word[next_pos] 
                                next_vowel_pos = next_pos
                                break
                        end
                end

                if next_vowel_pos == pos
                        # If no more vowels, it's not a
                        # intervocalic consonant: It will not
                        # be splitted.
                        # Example: Tal -> [Tal]
                        new_syllabe = word
                        remainder = ""

                        return new_syllabe, remainder
                end

                if next_vowel_pos == pos+2
                        # Only one intervocalic consonant. It
                        # is always splitted.
                        # The consonant group with the next
                        # vowel.
                        # Example: Ojo -> [O,jo]
                        new_syllabe = word[0..pos]
                        remainder = word[pos+1..-1]

                        return new_syllabe, remainder
                end

                new_syllabe = word[0..next_vowel_pos-2]
                remainder = word[next_vowel_pos-1..-1]

                return new_syllabe, remainder
        end

        def process(word)
                syllabes = []
                new_syllabe = ""
                remainder = ""

                # Search for a splittable syllabe
                (0..word.length-1).each do |pos|
                        if VOWELS.include? word[pos]
                                if VOWELS.include? word[pos+1]
                                        # If it's a vowel followed by a vowel...

                                        # Two strong vowels
                                        new_syllabe, remainder = handle_strong_vowels(word,pos)
                                        break if new_syllabe != ""
                                else
                                        # If it's a vowel followed by a consonant...

                                        # Search for intervocalic consonants
                                        new_syllabe, remainder = handle_intervocalic_consonants(word,pos)
                                        break if new_syllabe != ""
                                end
                        end
                end

                if new_syllabe != ""
                        # If we found any new syllabe
                        # Add it to syllabe list
                        syllabes << new_syllabe
                        # Process the remainder and concat
                        if remainder != ""
                                syllabes.concat process(remainder)
                        end
                else
                        # If this is the last syllabe found
                        # Add the part as syllabe
                        syllabes << word
                end

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
