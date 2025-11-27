module Parser where

import Tokenizer (Token(..))

data Expression =
    NumberExp Int |
    VariableExp String |
    AddExp Expression Expression |
    SubtractExp Expression Expression |
    MultiplyExp Expression Expression |
    DivideExp Expression Expression |
    LessThanExp Expression Expression |
    NotExp Expression |
    AndExp Expression Expression |
    OrExp Expression Expression |
    EqualsEqualsExp Expression Expression

data Statement = 
    Assignment String Expression |
    While Expression Statement |
    If Expression Statement Statement |
    Block [Statement]

expect :: Token -> [Token] -> [Token]
expect expectedToken (actualToken : restOfTokens)
    | expectedToken == actualToken = restOfTokens
    | otherwise = error ("Expected " ++ show expectedToken ++ " but got " ++ show actualToken)

parseAtom :: [Token] -> (Expression, [Token])
parseAtom (Number x : restOfTokens) = (NumberExp x, restOfTokens)
parseAtom (Variable s : restOfTokens) = (VariableExp s, restOfTokens)
