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
  ⊃¨(ln⌷⍨⊢)¨1,¨(⊢⍳⌊/)¨,/⍵∘.{⍵ dist ngrams ⍺}2⌷ln
}

⍝ classify language of each paragraph of a thesis xml file
px←{
  ⍝ read xml file
  xmlfile←⊃⎕nget⍵1
  ⍝ get all lines with a <p> tag
  ptags←xmlfile/⍨⊃,/0≠⊃¨('<p xml:id="'⎕s{⍵.Offsets})¨xmlfile
  ⍝ remove tags from lines
  paragraphs←{⍵/⍨~{⍵∨≠\⍵}'<>'∊⍨⍵}¨ptags
  ⍝ get paragraph ids for each line
  pids←{⊃'"'(≠⊆⊢){⍵/⍨{⍵∨≠\⍵}'"'∊⍨⍵}⍵}¨ptags
  ⎕←⍉pids,[0.5]ct paragraphs
}

⍝ classify language of a file
pf←{
  ⍝ read input file
  i←⊃,/⊃⎕nget⍵1
  ⎕←ct⊂i
}

main←{
  'l'=2⊃⍵:l⍬
  'f'=2⊃⍵:pf 3⊃⍵
  'x'=2⊃⍵:px 3⊃⍵
}

main ⊢2⎕nq#'getcommandlineargs'
