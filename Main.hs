module Main where

import Tokenizer
import Parser
import CodeGen
import Text.Pretty.Simple (pPrint)

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
    pPrint tokens
    let ast = parseProgram tokens
    pPrint ast
    let program = generateProgram ast
    pPrint program
