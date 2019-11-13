/*
 * pwgen.js
 *
 * Copyright (C) 2003-2006 KATO Kazuyoshi <kzys@8-p.info>
 * Updates by Frank4DD (C) 2010
 *
 * This program is a JavaScript port of pwgen.
 * The original C source code written by Theodore Ts'o.
 * <http://sourceforge.net/projects/pwgen/>
 * 
 * This file may be distributed under the terms of the GNU General
 * Public License.
 *
 * В эту великолепную библиотеку вмешался Ревякин А.А., т.к. cscript не понимал 
 * объявления классов, а я ничего не понимаю в таком объявлении через прототипы
 * и не знаю чем движок JS cscript отличается от chrome или FF, поэтому я 
 * кастрировал этот файл до линейного скрипта выбрасывающего на выходе пароль из
 * 7 символов
 *
 */

var INCLUDE_CAPITAL_LETTER =	1 << 1;
var INCLUDE_NUMBER =		1;
var INCLUDE_SPECIAL =		1 << 1 << 1;

var CONSONANT =	1;
var VOWEL =	1 << 1;
var DIPTHONG =	1 << 2;
var NOT_FIRST =	1 << 3;
var maxLength = 7;

ELEMENTS = [
    [ "a",  VOWEL ],
    [ "ae", VOWEL | DIPTHONG ],
    [ "ah", VOWEL | DIPTHONG ],
    [ "ai", VOWEL | DIPTHONG ],
    [ "b",  CONSONANT ],
    [ "c",  CONSONANT ],
    [ "ch", CONSONANT | DIPTHONG ],
    [ "d",  CONSONANT ],
    [ "e",  VOWEL ],
    [ "ee", VOWEL | DIPTHONG ],
    [ "ei", VOWEL | DIPTHONG ],
    [ "f",  CONSONANT ],
    [ "g",  CONSONANT ],
    [ "gh", CONSONANT | DIPTHONG | NOT_FIRST ],
    [ "h",  CONSONANT ],
    [ "i",  VOWEL ],
    [ "ie", VOWEL | DIPTHONG ],
    [ "j",  CONSONANT ],
    [ "k",  CONSONANT ],
    [ "l",  CONSONANT ],
    [ "m",  CONSONANT ],
    [ "n",  CONSONANT ],
    [ "ng", CONSONANT | DIPTHONG | NOT_FIRST ],
    [ "o",  VOWEL ],
    [ "oh", VOWEL | DIPTHONG ],
    [ "oo", VOWEL | DIPTHONG],
    [ "p",  CONSONANT ],
    [ "ph", CONSONANT | DIPTHONG ],
    [ "qu", CONSONANT | DIPTHONG],
    [ "r",  CONSONANT ],
    [ "s",  CONSONANT ],
    [ "sh", CONSONANT | DIPTHONG],
    [ "t",  CONSONANT ],
    [ "th", CONSONANT | DIPTHONG],
    [ "u",  VOWEL ],
    [ "v",  CONSONANT ],
    [ "w",  CONSONANT ],
    [ "x",  CONSONANT ],
    [ "y",  CONSONANT ],
    [ "z",  CONSONANT ],
];


    function generate0() {
        var result = "";
        var prev = 0;
        var isFirst = true;
        
        var requested = 0;
        requested |= INCLUDE_CAPITAL_LETTER;
        requested |= INCLUDE_NUMBER;
        requested |= INCLUDE_SPECIAL;
        
        var shouldBe = (Math.random() < 0.5) ? VOWEL : CONSONANT;
        
        while (result.length < maxLength) {
            i = Math.floor((ELEMENTS.length - 1) * Math.random());
            str = ELEMENTS[i][0];
            flags = ELEMENTS[i][1];

            /* Filter on the basic type of the next element */
            if ((flags & shouldBe) == 0)
                continue;
            /* Handle the NOT_FIRST flag */
            if (isFirst && (flags & NOT_FIRST))
                continue;
            /* Don't allow VOWEL followed a Vowel/Dipthong pair */
            if ((prev & VOWEL) && (flags & VOWEL) && (flags & DIPTHONG))
                continue;
            /* Don't allow us to overflow the buffer */
            if ( (result.length + str.length) > maxLength)
                continue;
            
            
            if (requested & INCLUDE_CAPITAL_LETTER) {
                if ((isFirst || (flags & CONSONANT)) &&
                    (Math.random() > 0.3)) {
                    str = str.slice(0, 1).toUpperCase() + str.slice(1, str.length);
                    requested &= ~INCLUDE_CAPITAL_LETTER;
                }
            }
            
            /*
             * OK, we found an element which matches our criteria,
             * let's do it!
             */
            result += str;
            
            
            if (requested & INCLUDE_NUMBER) {
                if (!isFirst && (Math.random() < 0.3)) {
                    if ( (result.length + str.length) > maxLength)
                        result = result.slice(0,-1);
                    result += Math.floor(10 * Math.random()).toString();
                    requested &= ~INCLUDE_NUMBER;
                    
                    isFirst = true;
                    prev = 0;
                    shouldBe = (Math.random() < 0.5) ? VOWEL : CONSONANT;
                    continue;
                }
            }
            

            if (requested & INCLUDE_SPECIAL) {
                if (!isFirst && (Math.random() < 0.3)) {
                    if ( (result.length + str.length) > maxLength)
                        result = result.slice(0,-1);
                var possible = "!@#$^*()-_+?=./:,";
                result += possible.charAt(Math.floor(Math.random() * possible.length));
                requested &= ~INCLUDE_SPECIAL;

                    isFirst = true;
                    prev = 0;
                    shouldBe = (Math.random() < 0.5) ? VOWEL : CONSONANT;
                    continue;
                }
            }

            /*
             * OK, figure out what the next element should be
             */
            if (shouldBe == CONSONANT) {
                shouldBe = VOWEL;
            } else { /* should_be == VOWEL */
                if ((prev & VOWEL) ||
                    (flags & DIPTHONG) || (Math.random() > 0.3)) {
                    shouldBe = CONSONANT;
                } else {
                    shouldBe = VOWEL;
                }
            }
            prev = flags;
            isFirst = false;
        }
        
        if (requested & (INCLUDE_NUMBER | INCLUDE_SPECIAL | INCLUDE_CAPITAL_LETTER))
            return null;
        
        return result;
    }

    function  generate() {
        var result = null;

        while (! result)
            result = generate0();
        
        return result;
    }

    WScript.echo(generate());