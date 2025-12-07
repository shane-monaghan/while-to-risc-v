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

labelGenerator :: Int -> (String, Int)
labelGenerator n = ("L" ++ show n, n + 1)

generateExpression :: Map.Map String Int -> Expression -> Int -> ([String], Int)
generateExpression memory (NumberExp n) label = (["li a0, " ++ show n], label)
generateExpression memory (VariableExp x) label = (["lw a0, " ++ show (memory Map.! x) ++ "(fp)"], label)
generateExpression memory (AddExp e1 e2) label =
    let (c1, l1) = generateExpression memory e1 label
        save1    = ["mv t0, a0"]
        (c2, l2) = generateExpression memory e2 l1
        op       = ["add a0, t0, a0"]
    in (c1 ++ save1 ++ c2 ++ op, l2)

generateExpression memory (SubtractExp e1 e2) label =
    let (c1, l1) = generateExpression memory e1 label
        save1    = ["mv t0, a0"]
        (c2, l2) = generateExpression memory e2 l1
        op       = ["sub a0, t0, a0"]
    in (c1 ++ save1 ++ c2 ++ op, l2)

generateExpression memory (MultiplyExp e1 e2) label =
    let (c1, l1) = generateExpression memory e1 label
        save1    = ["mv t0, a0"]
        (c2, l2) = generateExpression memory e2 l1
        op       = ["mul a0, t0, a0"]
    in (c1 ++ save1 ++ c2 ++ op, l2)

generateExpression memory (DivideExp e1 e2) label =
    let (c1, l1) = generateExpression memory e1 label
        save1    = ["mv t0, a0"]
        (c2, l2) = generateExpression memory e2 l1
        op       = ["div a0, t0, a0"]
    in (c1 ++ save1 ++ c2 ++ op, l2)

generateExpression memory (LessThanExp e1 e2) label =
    let (c1, l1) = generateExpression memory e1 label
        save1    = ["mv t0, a0"]
        (c2, l2) = generateExpression memory e2 l1
        op       = ["slt a0, t0, a0"]
    in (c1 ++ save1 ++ c2 ++ op, l2)

generateExpression memory (EqualsEqualsExp e1 e2) label =
    let (c1, l1) = generateExpression memory e1 label
        save1    = ["mv t0, a0"]
        (c2, l2) = generateExpression memory e2 l1
        op       = ["sub t1, t0, a0", "seqz a0, t1"]
    in (c1 ++ save1 ++ c2 ++ op, l2)

generateExpression memory (AndExp e1 e2) label =
    let (c1, l1) = generateExpression memory e1 label
        save1    = ["mv t0, a0"]
        (c2, l2) = generateExpression memory e2 l1
        op       = ["and a0, t0, a0"]
    in (c1 ++ save1 ++ c2 ++ op, l2)

generateExpression memory (OrExp e1 e2) label =
    let (c1, l1) = generateExpression memory e1 label
        save1    = ["mv t0, a0"]
        (c2, l2) = generateExpression memory e2 l1
        op       = ["or a0, t0, a0"]
    in (c1 ++ save1 ++ c2 ++ op, l2)

generateExpression memory (NotExp e) label =
    let (c, l1) = generateExpression memory e label
        op      = ["seqz a0, a0"]
    in (c ++ op, l1)

generateStatement :: Map String Int -> Statement -> Int -> ([String], Int)
generateStatement memory (AssignmentStmt var expr) label =
    let (c, l1) = generateExpression memory expr label
        store   = ["sw a0, " ++ show (memory Map.! var) ++ "(fp)"]
    in (c ++ store, l1)

generateStatement memory (BlockStmt stmts) label =
    foldl
        (\(acc, l) s ->
            let (c, l2) = generateStatement memory s l
            in (acc ++ c, l2)
        )
        ([], label)
        stmts

generateStatement memory (IfStmt cond ifBlock elseBlock) label =
    let (condCode, l1) = generateExpression memory cond label
        (elseLbl, l2)  = labelGenerator l1
        (endLbl,  l3)  = labelGenerator l2
        (ifCode,   l4) = generateStatement memory ifBlock l3
        (elseCode, l5) = generateStatement memory elseBlock l4
    in ( condCode
         ++ ["beqz a0, " ++ elseLbl]
         ++ ifCode
         ++ ["j " ++ endLbl]
         ++ [elseLbl ++ ":"]
         ++ elseCode
         ++ [endLbl ++ ":"]
       , l5 )

generateStatement memory (WhileStmt cond body) label =
    let (startLbl, l1) = labelGenerator label
        (endLbl,   l2) = labelGenerator l1
        (condCode, l3) = generateExpression memory cond l2
        (bodyCode, l4) = generateStatement memory body l3
    in ( [startLbl ++ ":"]
         ++ condCode
         ++ ["beqz a0, " ++ endLbl]
         ++ bodyCode
         ++ ["j " ++ startLbl]
         ++ [endLbl ++ ":"]
       , l4 )

generateProgram :: [Statement] -> String
generateProgram stmts =
    let vars      = getUniqueVariables stmts
        mem       = makeMemoryMap vars
        stackSize = 4 * Set.size vars   -- enough space for all variables
        prologue =
            [ ".globl main"
            , "main:"
            , "  addi sp, sp, -" ++ show stackSize
            , "  mv fp, sp"
            ]
        (body, _) = foldl
                        (\(acc, l) s ->
                            let (c, l2) = generateStatement mem s l
                            in (acc ++ c, l2)
                        )
                        ([], 0)
                        stmts
        epilogue =
            [ "  li a0, 0"
            , "  addi sp, fp, 0"
            , "  ret"
            ]
    in unlines (prologue ++ body ++ epilogue)


