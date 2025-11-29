module CodeGen where

import Parser (Expression(..), Statement(..))
import Data.Map (Map)
import qualified Data.Map as Map

getVariables :: [Statement] -> [String]
getVariables [] = []
getVariables (AssignmentStmt varName exp : restOfStatements) = (varName : getVariables restOfStatements)
getVariables (WhileStmt exp statement : restOfStatements) = (getVariables [statement]) ++ (getVariables restOfStatements)
getVariables (IfStmt exp ifBlockStatements elseBlockStatements : restOfStatements) = (getVariables [ifBlockStatements]) ++ (getVariables [elseBlockStatements]) ++ (getVariables restOfStatements)
getVariables (BlockStmt blockStatements : restOfStatements) = (getVariables blockStatements) ++ (getVariables restOfStatements)




