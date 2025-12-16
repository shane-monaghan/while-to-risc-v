# WHILE to RISC-V Compiler

## Introduction
Would you like to write all your code in Assembly language? If your answer to that question is no, and it should be no, you owe great thanks to Grace Hopper for the invention of the compiler in 1949 ("Grace Hopper"). A compiler is a program that converts code written in a higher-level programming language into code written in a lower-level programming language that can actually be executed. This is important because it allows programmers to write their code in a language that is typically more readable to humans. For example, it allows programmers to write their code in C++ rather than Assembly.


There are multiple steps in the compilation process, though the exact number of steps depends on which source one is looking at. Generally speaking, the first step is always going to be tokenization, or breaking the original program into meaningful pieces, called tokens, based on the language's syntax. For example, the line

```
int classNumber = 341;
```

might be broken into the tokens ["int", "classNumber", "=", "341", ";"]. This makes it easier for the compiler to execute the next phase of the compilation process, syntax analysis, which ensures that the source code follows the syntactic rules of the language. Semantic analysis, the next step, ensures that there are no logical errors, such as incorrect types in the code. The exact order of the next steps vary, but they boil down to translating the source code into lower-level code and optimizing the code by, for example, removing unused code [4].


The other aspect of this project involves the languages being compiled to and from. The compiler written for this project will be compiling the WHILE language, which is a bare-bones imperative language, into RISC-V Assembly Language. The exact definition of the WHILE language can vary because it is a toy language that is primarily used for program analysis, so for the purposes of this project, the WHILE language will refer to the language outlined in the Parse Trees section of our in-class notes [1]. 

## Overview
As mentioned, the main deliverable of this project is a compiler that compiles code written in WHILE to RISC-V Assembly Language code. This compiler is written in Haskell, and follows three steps of the overall compilation process: tokenization, parsing/syntactic analysis, and code generation. For ease of reference, definitions for each step of the compilation process will be listed below, with an explanation for why a step was not implemented in this compiler if applicable. Additionally, information about the WHILE language, RISC-V Assembly, and Haskell will be provided.

### WHILE Language
The WHILE language is a simple language that is typically used for demonstrative purposes. The grammar for the language as used for the purposes of this project is pictured below. From it, one can see that the WHILE language has no types, and is barebones in that it only allows for if-else statements and while loops as well as basic arithmetic and boolean logic. WHILE is the source language for this compiler.

<img width="720" height="150" alt="Screenshot 2025-12-06 192430" src="https://github.com/user-attachments/assets/1ecd7837-70ea-4c2d-a820-964caa074d2e" />

*The grammar for the WHILE language (Schmid)*

### RISC-V Assembly
RISC-V Assembly is a low-level programming language that is designed for RISC-V processors. As far as this project goes, RISC-V Assembly was chosen as the target language because it is a low-level language that is used in Bucknell's systems courses.

### Haskell
Haskell is a functional programming language, and it is the language this compiler is written in. Haskell was chosen for this compiler because its strong type system, algebraic data types (ADT), and pattern matching lend themselves to writen compilers. 

### Steps of Compilation
#### Tokenization
This step breaks the source program into meaningful chunks called tokens. 

The example from earlier, restated below, is useful for understanding this step, as one can imagine how this would be applied to an entire program.

```
int classNumber = 341; // This line is tokenized as ["int", "classNumber", "=", "341", ";"]
```

(Aho et al.)

#### Parsing/Syntax Analysis
This step takes the list of tokens from the tokenization steps and uses it to generate an abstract syntax tree (AST). An AST is a tree that represents the overall structure of the program. In the process of creating the AST for the program, this step also checks to make sure that the program follows the syntax rules of the language, typically as defined in the language's grammar.

(Aho et al.)

#### Semantic Analysis
In general, this step checks to make sure that there are no logical errors in the program. Logical errors include mistakes like incorrectly type casting a variable or writing a while loop that runs forever, and a separate step is typically needed to check for them because errors of this nature technically follow the syntax of the language and will slip through the syntax analysis step. 

This step is not included in this compiler because the simplicity of the WHILE language makes it relatively unnecessary. 

(Aho et al.)

#### Code Generation/Translation
This step takes the AST produced by the parsing/syntax analysis step and uses it to generate code in the target language (the language being compiled to) that (typically) has the same structure and functions the same. For more complicated languages, this step might generate code in some intermediate language before generating code in the target language for reasons that can include it being easier to compile the intermediate language to the target language or it being easier to optimize code in the intermediate language. Due to the simplicity of this project and the WHILE language, there is no intermediate language and RISC-V Assembly code is generated immediately.

(Aho et al.)

#### Code Optimization
This step attempts to optimize the generated code. For example, if applicable, it can replace a computationally expensive multiplication operation with a less computationally expensive bitshift operation. Once again, due to the smaller scope of this project, this step was ommitted from this compiler.

(Aho et al.)

## Body of Write-up

### Project Goals
While the product of this project is a compiler, the primary goal of this project is to help me learn and to further my knowledge in some key areas of computer science:

- Compiler design
- Functional languages
- Pertinent Theory of Computation topics such as grammars and their applications, regular languages, and, to a lesser extent, the lambda calculus

### Implementation Details
This section includes details related to the implementation of this compiler. It also includes details for how to run the compiler.

#### How to Run

Assuming one has Haskell, GHC, and Cabal installed, building this project and running the executable is as simple as entering the following commands in the terminal.

```
cabal build
cabal run
```

Any program that one wants to compile should be pasted into sampleCode in Main.hs. It is not necessary for each line to be a separate item in the list.

```
sampleCode = unlines
    [
        "x = 1;",
        "while (x < 10) {",
        "   x = x * 2;"
    ]
```

#### Tokenizer.hs
In this file, the Token ADT and the "tokenize" function are defined. 

The Token ADT works by defining all the token types that could appear in a WHILE program. For example, there is an "If" token for the "if" keyword, there is a "Semicolon" token for the semicolon (";"), and there is "Variable" token for variable names such as "x", "y", and "firstName". 

The "tokenize" function works by recursively going through the source program, identifying tokens and adding them to a list of tokens as they appear. 

#### Parser.hs
In this file, the Expression ADT, Statement ADT, and various functions for parsing the program are defined. 

The Expression ADT, as the name implies, defines expressions that can occur in WHILE programs. For example, it defines SubtractExp, EqualsEqualsExp, and AddExp to represent subtraction, an equivalence expression, and an add expression, respectively. It is worth noting that every expression in the ADT is defined in terms of other Expressions, except for NumberExp and VariableExp which are integers and strings, respectively.

The Statement ADT defines all the statements that can occur in a WHILE program. These are things such as while loops and if statements, and they are all defined in terms of some combination of strings, expressions, statements, and lists of statements.

The overall structure of the parser is that there is one overarching function called parseProgram which makes calls to another function parseStatement. When called, parseStatement makes calls to functions that are in charge of parsing each type of statement (e.g., parseIf, parseWhile, etc). Generally, those functions make calls to parseExpression which makes calls to parseMath which makes calls to parseTerm and finally to parseAtom. These functions combine to create nodes, and these nodes are combined to form a tree. At its core, the parser is designed such that a large problem (the entire list of tokens from the previous step) is broken down into many different smaller problems that are easier to handle, yet combine to capture the entire structure of the entire program in an AST.

It is also worth mentioning that the parser throws an error if at any point the syntax of the WHILE language is violated (e.g., if there's a missing semicolon).

#### CodeGenerator.hs

#### Main.hs


### Sample Usage
This section will walk through each step of a test run of this compiler.

#### Example Program Written in WHILE
``` 
x = 1;
while (x < 10) {
  x = x * 2;
}
```
This is the program to be compiled. Note that this is a valid WHILE program given the language’s grammar.

#### Tokenization


```
tokens = [
          Variable "x", Equals, Number 1, Semicolon, // Line 1
          While, LeftParenthesis, Variable "x", LessThan, Number 10, RightParenthesis, LeftBrace, // Line 2
          Variable "x", Equals, Variable "x", MultiplicationOp, Number 2, Semicolon, // Line 3
          RightBrace // Line 4
          ]
```


After being passed into the tokenizer, the input program is tokenized into the list of tokens depicted above.

#### Parsing


The list of tokens generated in the previous step is passed into the parser, resulting in the following abstract syntax tree which represents the structure of the input program:


![AbstractSyntaxTree](https://github.com/user-attachments/assets/750c6ed0-09f4-4b3d-baa1-6214bf1ad6cd)

#### Code Generation

```
.globl main
main:
  addi sp, sp, -4
  mv fp, sp
li a0, 1
sw a0, -4(fp)
L0:
lw a0, -4(fp)
mv t0, a0
li a0, 10
slt a0, t0, a0
beqz a0, L1
lw a0, -4(fp)
mv t0, a0
li a0, 2
mul a0, t0, a0
sw a0, -4(fp)
j L0
L1:
  li a0, 0
  addi sp, fp, 0
  ret
```


The abstract syntax tree is passed into the code generator which produces the above RISC-V Assembly code in the form of a string.

### Reflection
Overall, this project substantially strengthened my understanding of Theory of Computation topics such as context-free grammars, regular languages, and the lambda calculus, as they all played a critical role (both directly and indirectly) in my project. For example, defining the ADTs for the Tokenizer and the Parser was entirely based in the WHILE language's grammar. Similarly, choosing to write the compiler in Haskell meant that I was indirectly working with the lambda calculus, and it helped me develop a much better grasp of the concept and how it is used outside of pure theory. Strengthening my understanding of such topics was a key goal of this project, and it was most definitely accomplished.

On that note, another key goal of this project was to strengthen my skills in programming in functional languages. I had had some exposure to Haskell in CSCI 308, but I really wanted to learn more because programming in such languages truly does require a different way of thinking compared to programming in imperative languages. This project gave me an opportunity to write more code in a functional language than I have ever written for anything, and my skills developed a lot as a result. It was also really neat that the choice to write the compiler in Haskell was not made solely because it was something I wanted to learn, as functional languages are actually known for being good for writing compilers! 

This project also allowed me to strengthen my knowledge of computer systems beyond what is offered in the standard Bucknell curriculum, as there are no courses that have been offered during my time here that provide in-depth exposure to compilers. We use them, but there is a lot of mystery behind them and how they work, and that mystery was part of what inspired me to choose this project. I did not want to complete my undergraduate experience being relatively ignorant to a fairly critical aspect of computer science. After putting in the time to research compiler design and then actually implementing one, it is safe to say that I have a significantly better understanding of compilers than I did before, and I would love to continue to learn more, as I find the subject fascinating. 

In the end, I was not able to do anything particularly novel with this compiler (some ideas for future tasks are in the Future Work section, though), but I truly believe this has been one of the most valuable projects I have worked on during my time at Bucknell. It allowed me to choose something I was interested in that connected to the course, and as a result, I truly believe that I learned a lot more than I would have otherwise. Overall, I loved working on this project, and I look forward to taking what I learned and applying it both to this project and other projects in the future!

## Related Projects
As far as the awesome projects of my fellow classmates go, one stands out as being especially related to mine: Radley's project. His project shows how JavaScript, which pulls from the functional programming paradigm, behaves like the untyped lambda calculus. Additionally, he shows how TypeScript's addition of a type system makes the language behave like the simply typed lambda calculus. In other words, he shows that the lambda calculus is foundational to these two languages.

This relates to my project because I chose to write my compiler in Haskell which is a functional language. In general, the lambda calculus is foundational to functional languages, like Haskell, so Radley's research into it is very closely related to the implementation side of my project.

## Future Work

For this project specifically, future improvements include the following:
- Semantic Analysis functionality such as type checking (this would require an expanded version of WHILE).
- Optimization of the final RISC-V code (e.g., replacing expensive operations with cheaper ones).
- Repurpose compiler for a more widely-used programming language.

In the realm of compilers as a whole, active research areas include:
- Verified compilers, meaning that it has been mathematically proven that the compiled code behaves exactly like the source code, for functional languages (Kiam Tan et al.).
- Mathematical construction of compilers from language semantics (Swierstra).

## Citations

- Aho, Alfred V., et al. Compilers: Principles, Techniques, and Tools. 2nd ed., Pearson, 2006.
- “Grace Hopper”. Lemelson‑MIT Program, n.d., https://lemelson.mit.edu/resources/grace-hopper.
- Kiam Tan, Yong et al. “The Verified CakeML Compiler Backend.” Journal of Functional Programming 29 (2019): e2. Web.
- Schmid, Todd. “Parse Trees.” CSCI 341 Theory of Computation, Fall 2025, toddtoddtodd.net/courses/csci341/compiled/csci341_notes_2_02_parse_trees.html. 
- Swierstra, Wouter. “Towards Type-Directed Compiler Calculation.” Journal of Functional Programming 35 (2025): e20. Web.

