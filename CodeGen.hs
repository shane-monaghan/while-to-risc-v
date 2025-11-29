module CodeGen where

import Parser (Expression(..), Statement(..))
import Data.Map (Map)
import qualified Data.Map as Map
import qualified Data.Set as Set

getVariables :: [Statement] -> [String]
getVariables [] = []
getVariables (AssignmentStmt varName exp : restOfStatements) = (varName : getVariables restOfStatements)
getVariables (WhileStmt exp statement : restOfStatements) = (getVariables [statement]) ++ (getVariables restOfStatements)
getVariables (IfStmt exp ifBlockStatements elseBlockStatements : restOfStatements) = (getVariables [ifBlockStatements]) ++ (getVariables [elseBlockStatements]) ++ (getVariables restOfStatements)
getVariables (BlockStmt blockStatements : restOfStatements) = (getVariables blockStatements) ++ (getVariables restOfStatements)

getUniqueVariables :: [Statement] -> Set.Set String
getUniqueVariables listOfStatements = Set.fromList (getVariables listOfStatements)

makeMemoryMap :: Set.Set String -> Map.Map String Int
makeMemoryMap setOfVariables = Map.fromList (zip (Set.toList setOfVariables) [-4, -8..])