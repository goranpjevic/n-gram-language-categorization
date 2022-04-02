#!/usr/bin/env dyalogscript

⍝ get the 300 most common n-grams of text
ngrams←{
  ⍝ partition input into strings of letters
  w←⍵⊆⍨⊃∨/(⍵=⍥⎕c⊢)¨⎕a
  ⍝ get n-grams of a word
  ng←(⊢,/(' '⍴⍨¯1+⊢),⍨' ',⊣)
  ⍝ get n-grams of all words of sizes 1 to 5
  n←~∘' '¨~∘' '⊃,/,w∘.ng⍳5
  300{⍺≤≢⍵:⍺↑⍵⋄⍵}(∪n)[⍒(≢⊢)⌸n]
}

⍝ make n-gram models of all languages
l←{
  ⍝ get all languages
  langs←⎕sh'ls languages'
  {(⊂ngrams⊃,/⊃⎕nget('languages/',⍵)1)⎕nput('models/',⍵)1}¨langs
}

⍝ classify text based on the language models
ct←{
  ⍝ calculate distance of two arrays of n-grams
  dist←{+/|r-(⍳≢⍵)×(≢⍺)≥r←⍺⍳⍥(' '∘,¨)⍵}
  ⍝ get all languages and their most common n-grams
  langs←⎕sh'ls models'
  ln←{⊃⎕nget('models/',⍵)1}¨langs
  ⍝ return classified language for each input
  (⊃langs⌷⍨⊢⍳⌊/)¨,/⍉ln∘.dist ngrams¨⍵
}

⍝ classify language of each paragraph of a thesis xml file
x←{
  xmlfile←⊃⎕nget⍵1
  ⍝ get all lines with a <p> tag
  ptags←⊃,/('<p xml:id="'⎕s{⍵.Block})¨xmlfile
  ⍝ remove tags from lines
  paragraphs←{⍵/⍨~{⍵∨≠\⍵}'<>'∊⍨⍵}¨ptags
  ⍝ get paragraph ids for each line
  pids←{2⊃'"'(≠⊆⊢)⍵}¨ptags
  ⎕←⍉pids,[0.5]ct paragraphs
}

main←{
  'l'=2⊃⍵:l⍬
  'f'=2⊃⍵:⎕←ct,/⊃⎕nget(3⊃⍵)1
  'x'=2⊃⍵:x 3⊃⍵
}

main ⊢2⎕nq#'getcommandlineargs'
