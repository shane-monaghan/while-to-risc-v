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
parseAtom (LeftParenthesis : restOfTokens) = 
    let 
        (innerExp, afterInnerExp) = (parseExpression restOfTokens)
        finalRest = expect RightParenthesis afterInnerExp
    in
        (innerExp, finalRest)
parseAtom _ = error "Unexpected token"

parseTerm :: [Token] -> (Expression, [Token])
parseTerm tokens = 
    let
        (leftHandSide, remainingTokens) = parseAtom tokens
    in
        parseTermHelper leftHandSide remainingTokens
    where 
        parseTermHelper :: Expression -> [Token] -> (Expression, [Token])
        parseTermHelper lhs (MultiplicationOp : restOfTokens) = 
            let
                (rightHandSide, remainingTokens) = parseAtom restOfTokens
            in
                parseTermHelper (MultiplyExp lhs rightHandSide) remainingTokens
        parseTermHelper lhs (DivisionOp : restOfTokens) =
            let
                (rightHandSide, remainingTokens) = parseAtom restOfTokens
            in
                parseTermHelper (DivideExp lhs rightHandSide) remainingTokens
        parseTermHelper lhs tokens =
            (lhs, tokens)

