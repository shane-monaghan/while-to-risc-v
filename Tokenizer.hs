import Data.Char (isDigit, isAlpha, isAlphaNum, isSpace)

data Token = 
    If | -- "if"
    Else | -- "else"
    While | -- "while"
    Variable String | -- e.g., "x", "y", "firstName", "lastName123"
    Equals |
    EqualsEquals |
    LessThan | -- '<'
    Not | -- "not"
    And | -- "and"
    Or | -- "or"
    LeftParenthesis | -- '('
    RightParenthesis | -- ')'
    LeftBrace | -- '{'
    RightBrace | -- '}'
    Semicolon | -- ';'
    AdditionOp | -- '+'
    SubtractionOp | -- '-'
    MultiplicationOp | -- '*'
    DivisionOp | -- '/'
    Number Int -- e.g., 123, 5865, 9023 

tokenize :: String -> [Token]
tokenize ('+' : restOfString) = AdditionOp : tokenize restOfString
tokenize ('-' : restOfString) = SubtractionOp : tokenize restOfString
tokenize ('*' : restOfString) = MultiplicationOp : tokenize restOfString
tokenize ('/' : restOfString) = DivisionOp : tokenize restOfString
tokenize ('<' : restOfString) = LessThan : tokenize restOfString
tokenize ('(' : restOfString) = LeftParenthesis : tokenize restOfString
tokenize (')' : restOfString) = RightParenthesis : tokenize restOfString
tokenize ('{' : restOfString) = LeftBrace : tokenize restOfString
tokenize ('}' : restOfString) = RightBrace : tokenize restOfString
tokenize (';' : restOfString) = Semicolon : tokenize restOfString
tokenize ('=' : '=' : restOfString) = EqualsEquals : tokenize restOfString
tokenize ('=' : restOfString) = Equals : tokenize restOfString

tokenize (firstCharacter : restOfString)
    | isDigit firstCharacter = Number (read digits) : tokenize restOfInput
    | isAlpha firstCharacter = checkKeyword wordString : tokenize afterWord
    | isSpace firstCharacter = tokenize (dropWhile isSpace restOfString)

    where
        (digits, restOfInput) = span isDigit (firstCharacter : restOfString)
        (wordString, afterWord) = span isAlphaNum (firstCharacter : restOfString)
        checkKeyword :: String -> Token
        checkKeyword s
            | s == "if" = If
            | s == "else" = Else
            | s == "while" = While
            | s == "not" = Not
            | s == "and" = And
            | s == "or" = Or
            | otherwise = Variable s