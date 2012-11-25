#!/usr/bin/ruby
# encoding: utf-8

# Downcase accents and ñ
require 'unicode_utils/downcase'

class Syllabicator
        VOWELS=['a', 'e', 'i', 'o', 'u', 'á', 'é', 'í', 'ó', 'ú', 'ü']
        STRONG_VOWELS=['a', 'e', 'o']
        ACCUTED_WEAK_VOWEL = ['í', 'ú']
        ANGLICISMS_VOWELS = VOWELS.dup.concat ['y']

        UNSPLITTABLE_R = ['p','b','f','t','d','g','c', 'r']
        UNSPLITTABLE_L = ['p','b','f','d','g','c','l']

        PREFIXES = [
                # A
                'acro', 'aero', 'agro', 'alo', 'andro',
                'anfi', 'ante', 'anti', 'antro', 'apo', 'archi',
                'auto',
                # B
                'bi', 'bio',
                # C
                'cardi', 'cata', 'ciclo', 'co', 'cuadri',
                # D
                'deci', 'demo', 'derma', 'di',
                # E
                'ecto', 'emi', 'endo', 'epi', 'etimo', 'etno',
                'eu', 'exo',
                # G
                'geo',
                # H
                'hecto', 'hemi', 'hetero', 'hidro', 'hipo', 'homo',
                # I
                'icono', 'idio', 'infra', 'intra', 'iso',
                # K/L
                'kilo', 'logo',
                # M
                'macro', 'mega', 'meta', 'micro', 'mio', 'mono',
                'morfo', 'multi',
                # N
                'nau', 'necro', 'neo', 'neuro',
                # O
                'octa', 'octo', 'omni',
                # P
                'pali', 'paqui', 'poli', 'pre', 'pro', 'proto',
                'psico',
                # Q/R/S
                'quiro', 're', 'retro', 'semi', 'supra',
                # U/V/Y
                'ultra', 'vice', 'uxta'
        ]

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

        def handle_breaking_hiatus(word,pos)
                if ACCUTED_WEAK_VOWEL.include? word[pos]
                        # When a weak vowel is accuted, it acts
                        # like a strong one.
                        if pos > 0 and STRONG_VOWELS.include? word[pos-1]
                                # Strong vowel before.
                                # Before should be managed first to
                                # correctly syllabicate words with
                                # vowel groups like "aía".
                                # Example: Raúl -> [Ra,úl]
                                new_syllabe = word[0..pos-1]
                                remainder = word[pos..-1]
                                return new_syllabe, remainder
                        end
                        if STRONG_VOWELS.include? word[pos+1]
                                # Strong vowel after.
                                # Example: ríos -> [rí,os]
                                new_syllabe = word[0..pos]
                                remainder = word[pos+1..-1]
                                return new_syllabe, remainder
                        end
                end

                new_syllabe = ""
                remainder = word
                return new_syllabe, remainder
        end


        def split_last_two_consonants(word, next_vowel_pos) 
                # If V is a vowel and C is a consonant, being
                # next_vowel_pos the position of the second
                # vowel:
                # VCCCV -> [VC,CCV]
                new_syllabe = word[0..next_vowel_pos-3]
                remainder = word[next_vowel_pos-2..-1]

                return new_syllabe, remainder
        end

        def handle_intervocalic_consonants(word,pos, is_anglicism=false)
                # Search the next vowel
                next_vowel_pos = pos
                (pos+1..word.length-1).each do |next_pos|
                        if not is_anglicism
                                if VOWELS.include? word[next_pos] 
                                        next_vowel_pos = next_pos
                                        break
                                end
                        else
                                if ANGLICISMS_VOWELS.include? word[next_pos] 
                                        next_vowel_pos = next_pos
                                        break
                                end
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

                last_consonant = word[next_vowel_pos-1]
                previous_consonant = word[next_vowel_pos-2] 

                if last_consonant == 'r' 
                        # Some intervocalic consonant can't be splitted
                        # when Xr group found. The last two are part of
                        # the remaining group
                        # Example: Control -> [Con,trol]
                        if UNSPLITTABLE_R.include? previous_consonant
                             return split_last_two_consonants(word, next_vowel_pos)                    
                        end
                end

                if last_consonant == 'l'
                        # Some intervocalic consonant can't be splitted
                        # when Xl group found. The last two are part of
                        # the remaining group
                        # Example: Ciclo -> [Ci,clo]
                        if UNSPLITTABLE_L.include? previous_consonant
                             return split_last_two_consonants(word, next_vowel_pos)                    
                        end
                end

                if last_consonant == 'h' and previous_consonant == 'c'
                        # "ch" group is never split.
                        # Example: Bicho -> [Bi,cho]
                        return split_last_two_consonants(word, next_vowel_pos)                    
                end

                # No special case, the last consonant between both vowels
                # can be splitted
                # Example: Honra -> [Hon,ra]
                new_syllabe = word[0..next_vowel_pos-2]
                remainder = word[next_vowel_pos-1..-1]

                return new_syllabe, remainder
        end

        def handle_anglicism(last_syllabe)
                syllabes = []
                new_syllabe = ""
                remainder = ""

                # Search for a splittable syllabe
                (0..last_syllabe.length-1).each do |pos|
                        if ANGLICISMS_VOWELS.include? last_syllabe[pos]
                                if not ANGLICISMS_VOWELS.include? last_syllabe[pos+1]
                                        # If it's a vowel followed by a consonant...
                                        # Search for intervocalic consonants
                                        new_syllabe, remainder = handle_intervocalic_consonants(last_syllabe,\
                                                pos,is_anglicism=true)
                                        break if new_syllabe != ""
                                end
                        end
                end

                # If this is the last syllabe found
                # Add the part as syllabe
                syllabes << new_syllabe
                syllabes << remainder if remainder != ""

                return syllabes
        end

        def process(word)
                syllabes = []
                new_syllabe = ""
                remainder = ""

                # Search for a splittable syllabe
                (0..word.length-1).each do |pos|
                        if VOWELS.include? word[pos]
                                # When a vowel is found, search for hiatus
                                new_syllabe, remainder = handle_breaking_hiatus(word,pos) 
                                break if new_syllabe != ""

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
                        # If this is the last syllabe found...
                        # Add the part as syllabe
                        syllabes << word
                end

                if remainder == ""
                        # Some anglicism ends with "y" and are not
                        # correctly parsed. Words like "sexy" or
                        # "ferry"·
                        last_syllabe = syllabes.last
                        if last_syllabe[-1] == "y"
                                # When the last syllabe ends in "y"
                                if not ANGLICISMS_VOWELS.include? last_syllabe[-2]
                                        # And the previous character is a consonant
                                        # (Done with ANGLICISMS_VOWELS to correctly
                                        # parse "y" word)
                                        
                                        # Remove the last syllabe from the current
                                        # syllabes list
                                        syllabes.pop
                                        # Get the correct syllabication
                                        new_syllabes = handle_anglicism(last_syllabe)
                                        # Append it
                                        syllabes.concat new_syllabes
                                end
                        end

                end

                return syllabes
        end

        def preprocess_prefix(word)
                if word.length < 2
                        return [], word
                end

                PREFIXES.each do |prefix|
                        if word.start_with? prefix
                                # Check if the word without prefix
                                # starts with vowel
                                word_pos = prefix.length
                                if VOWELS.include? word[word_pos]
                                        # Only if it starts with a vowel we
                                        # have to care about
                                        prefix_syllabes = process(prefix)
                                        word = word.dup.slice (prefix.length..-1)
                                        return prefix_syllabes, word
                                end
                        end
                end

                # Word is not prefixed or it's 
                # unknown
                return [], word
        end

        def syllabicate(word)
                word = UnicodeUtils.downcase word

                if word==""
                        return []
                end

                prefix_syllabes,word = preprocess_prefix(word)
                word_syllabes = process(word)
                syllabes = prefix_syllabes.concat word_syllabes

                return syllabes 
        end
end
