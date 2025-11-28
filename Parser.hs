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
    AssignmentStmt String Expression |
    WhileStmt Expression Statement |
    IfStmt Expression Statement Statement |
    BlockStmt [Statement]

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

parseMath :: [Token] -> (Expression, [Token])
parseMath tokens =
    let
        (leftHandSide, remainingTokens) = parseTerm tokens
    in
        parseMathHelper leftHandSide remainingTokens
    where
        parseMathHelper :: Expression -> [Token] -> (Expression, [Token])
        parseMathHelper lhs (AdditionOp : restOfTokens) = 
            let
                (rightHandSide, remainingTokens) = parseTerm restOfTokens
            in
                parseMathHelper (AddExp lhs rightHandSide) remainingTokens
        parseMathHelper lhs (SubtractionOp : restOfTokens) =
            let
                (rightHandSide, remainingTokens) = parseTerm restOfTokens
            in
                parseMathHelper (SubtractExp lhs rightHandSide) remainingTokens
        parseMathHelper lhs tokens =
            (lhs, tokens)

parseExpression :: [Token] -> (Expression , [Token])
parseExpression tokens =
    let
        (leftHandSide, remainingTokens) = parseMath tokens
    in
        parseExpressionHelper leftHandSide remainingTokens
    where
        parseExpressionHelper :: Expression -> [Token] -> (Expression, [Token])
        parseExpressionHelper lhs (EqualsEquals : restOfTokens) =
            let
                (rightHandSide, remainingTokens) = parseMath restOfTokens
            in
                parseExpressionHelper (EqualsEqualsExp lhs rightHandSide) remainingTokens
        parseExpressionHelper lhs (LessThan : restOfTokens) = 
            let
                (rightHandSide, remainingTokens) = parseMath restOfTokens
            in
                parseExpressionHelper (LessThanExp lhs rightHandSide) remainingTokens
        parseExpressionHelper lhs tokens =
            (lhs, tokens)

parseStatement :: [Token] -> (Statement, [Token])
parseStatement (If : restOfTokens) = parseIf restOfTokens
parseStatement (While : restOfTokens) = parseWhile restOfTokens
parseStatement (LeftBrace : restOfTokens) = parseBlock restOfTokens
parseStatement (Variable varName : restOfTokens) = parseAssignment (Variable varName : restOfTokens)
parseStatement tokens = error "Illegal program"

parseAssignment :: [Token] -> (Statement, [Token])
parseAssignment (Variable varName : Equals : restOfTokens) =
    let

        (expressionNode, tokensAfterExpression) = parseExpression restOfTokens
        finalTokens = expect Semicolon tokensAfterExpression
    in
        (AssignmentStmt varName expressionNode, finalTokens)
parseAssignment tokens =
    error "Syntax does not align with an assignment"

parseBlock :: [Token] -> (Statement, [Token])
parseBlock tokens = 
    let
        (statements, remainingTokens) = parseBlockHelper tokens
    in
        (BlockStmt statements, remainingTokens)
    where
        parseBlockHelper :: [Token] -> ([Statement], [Token])
        parseBlockHelper (RightBrace : restOfTokens) = ([], restOfTokens)
        parseBlockHelper tokens =
            let
                (singleStatement, tokensAfterStatement) = parseStatement tokens
                (otherStatements, finalTokens) = parseBlockHelper tokensAfterStatement
            in
                (singleStatement : otherStatements, finalTokens)

parseIf :: [Token] -> (Statement, [Token])
parseIf tokens =
    let
        tokensAfterLeftParenthesis = expect LeftParenthesis tokens 
        (expressionNode, tokensAfterExpression) = parseExpression tokensAfterLeftParenthesis
        tokensAfterRightParenthesis = expect RightParenthesis tokensAfterExpression
        (ifStatement, tokensAfterIfBlock) = parseBlock tokensAfterRightParenthesis
        (elseStatement, tokensAfterElseStatement) = 
            case tokensAfterIfBlock of
                (Else : tokensAfterElse) -> parseBlock tokensAfterElse
                _ -> (BlockStmt [], tokensAfterIfBlock)
    in
        (IfStmt expressionNode ifStatement elseStatement, tokensAfterElseStatement)

