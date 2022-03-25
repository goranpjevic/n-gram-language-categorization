#!/usr/bin/env dyalog -script

⍝ get ⍵-th command line argument
a←{1↓¯1↓⍕⍵⌷⊢2⎕nq#'getcommandlineargs'}
⍝ read input file
i←⊃,/⊃⎕nget(a 4)1
⍝ filter out all non-letters and split input at each word
w←i⊆⍨⊃∨/(i=∘⎕c⊢)¨⎕a
⍝ produce n-grams of sizes 1 to 5
n←~∘' '¨~∘' '⊃,/,w∘.(⊢,/(' '⍴⍨¯1+⊢),⍨' ',⊣)⍳5
⍝ display the 300 most common n-grams
⍪(∪n)[300↑⍒(≢⊢)⌸n]
