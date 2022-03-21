#!/usr/bin/env dyalog -script

⍝ read input file
s←⊃,/⊃⎕nget'examples/input.txt'1
⍝ produce n-grams of sizes 1 to 5, and get their frequency
ngrams←(⊣,(≢⊢))⌸¨{⍵,/s}¨⍳5
⍝ sort n-grams based on their frequency, separated by size
sorted←{⍵[(⍒2⌷⍉)⍵;]}¨ngrams
⍝ display the 300 most used n-grams
300↑{⍵[(⍒2⌷⍉)⍵;]}⊃⍪/ngrams
