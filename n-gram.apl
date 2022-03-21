#!/usr/bin/env dyalog -script

s←'test sentence'

⍝ produce n-grams of sizes 1 to 5, and get their frequency
ngrams←(⊣,(≢⊢))⌸¨{⍵,/s}¨⍳5
⍝ sort n-grams based on their frequency, separated by size
sorted←{⍵[(⍒2⌷⍉)⍵;]}¨ngrams
sorted
