#!/usr/bin/env dyalogscript

⍝ get the 300 most common n-grams of text
ngrams←{
  ⍝ partition input into strings of letters
  w←⍵⊆⍨⊃∨/(819⌶⍵)∘=¨819⌶⎕A
  ⍝ get n-grams of a word
  ng←(⊢,/(' '⍴⍨¯1+⊢),⍨' ',⊣)
  ⍝ get n-grams of all words of sizes 1 to 5
  n←~∘' '¨~∘' '⊃,/,w∘.ng⍳5
  300{⍺≤≢⍵:⍺↑⍵⋄(≢⍵)↑⍵}(∪n)[⍒(≢⊢)⌸n]
}

⍝ make n-gram models of all languages
l←{
  ⍝ get all languages
  langs←⎕sh'ls languages'
  ltext←langs,[0.5]{⊃,/⊃⎕nget('languages/',⍵)1}¨langs
  {(⊂ngrams 2⊃⍵⌷⍉ltext)⎕nput('models/',⊃⍵⌷⍉ltext)1}¨⍳≢ltext
}

⍝ classify text based on the language models
ct←{
  ⍝ calculate distance of two arrays of n-grams
  dist←{+/|r-(⍳≢⍵)×(≢⍺)≥r←⍺⍳⍥(' '∘,¨)⍵}
  ⍝ get all languages and their most common n-grams
  langs←⎕sh'ls models'
  ln←langs,[0.5]{⊃⎕nget('models/',⍵)1}¨langs
  ⍝ return classified language for each input
  ⊃¨(ln⌷⍨⊢)¨1,¨(⊢⍳⌊/)¨,/(ngrams¨⍵)∘.dist 2⌷ln
}

⍝ classify language of each paragraph of a thesis xml file
x←{
  xmlfile←⊃⎕nget⍵1
  ⍝ get all lines with a <p> tag
  ptags←xmlfile/⍨⊃,/0≠⊃¨('<p xml:id="'⎕s{⍵.Offsets})¨xmlfile
  ⍝ remove tags from lines
  paragraphs←{⍵/⍨~{⍵∨≠\⍵}'<>'∊⍨⍵}¨ptags
  ⍝ get paragraph ids for each line
  pids←{⊃'"'(≠⊆⊢){⍵/⍨{⍵∨≠\⍵}'"'∊⍨⍵}⍵}¨ptags
  ⎕←⍉pids,[0.5]ct paragraphs
}

main←{
  'l'=2⊃⍵:l⍬
  'f'=2⊃⍵:⎕←ct,/⊃⎕nget(3⊃⍵)1
  'x'=2⊃⍵:x 3⊃⍵
}

main ⊢2⎕nq#'getcommandlineargs'
