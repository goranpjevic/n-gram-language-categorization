#!/usr/bin/env dyalog -script

⍝ get ⍵-th command line argument
a←{1↓¯1↓⍕⍵⌷⊢2⎕nq#'getcommandlineargs'}
⍝ read input file
s←⊃,/⊃⎕nget(a 4)1
⍝ produce n-grams of sizes 1 to 5, and get their frequency
ngrams←(⊣,(≢⊢))⌸¨{⍵,/s}¨⍳5
⍝ display the 300 most used n-grams
300↑{⍵[(⍒2⌷⍉)⍵;]}⊃⍪/ngrams
