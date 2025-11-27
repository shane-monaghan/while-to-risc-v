module Main where

import Tokenizer

sampleCode :: String
sampleCode = unlines
    [
        "x = 1;",
        "while (x < 10) {",
        "   x = x * 2;",
        "}"
    ]

main :: IO ()
main = do
    let tokens = tokenize sampleCode
    print tokens