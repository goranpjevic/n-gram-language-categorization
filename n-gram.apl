#!/usr/bin/env dyalog -script

⍝ get ⍵-th command line argument
a←{1↓¯1↓⍕⍵⌷⊢2⎕nq#'getcommandlineargs'}
⍝ read input file
s←⊃,/⊃⎕nget(a 4)1
⍝ filter out all non-characters and split input at each word
filter←⎕a,819⌶⎕a,' '
t←' '(≠⊆⊢){⍵/⍨(≢filter)≥filter⍳⍵}s
⍝ produce n-grams of sizes 1 to 5
ngrams←⊃,/⊃,/,¨{tmp←⍵⋄(⍳5)∘.{⍺,/' ',tmp,⍺⍴' '}1}¨t
⍝ filter out spaces from ngrams
n←{⍵/⍨0≠≢¨⍵}{⍵/⍨¨' '≠⍵}ngrams
⍝ display the 300 most common n-grams
300↑↑⍪{(1⌷⍉⍵)[⍒2⌷⍉⍵]}{⍺(≢⍵)}⌸n
