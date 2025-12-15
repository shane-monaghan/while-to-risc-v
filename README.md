# WHILE to RISC-V Compiler

## Introduction
Would you like to write all your code in Assembly language? If your answer to that question is no, and it should be no, you owe great thanks to Grace Hopper for the invention of the compiler in 1949 [3]. A compiler is a program that converts code written in a higher-level programming language into code written in a lower-level programming language that can actually be executed. This is important because it allows programmers to write their code in a language that is typically more readable to humans [2]. For example, it allows programmers to write their code in C++ rather than Assembly.


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

#### Parsing/Syntax Analysis
This step takes the list of tokens from the tokenization steps and uses it to generate an abstract syntax tree (AST). An AST is a tree that represents the overall structure of the program. In the process of creating the AST for the program, this step also checks to make sure that the program follows the syntax rules of the language, typically as defined in the language's grammar.

#### Semantic Analysis
In general, this step checks to make sure that there are no logical errors in the program. Logical errors include mistakes like incorrectly type casting a variable or writing a while loop that runs forever, and a separate step is typically needed to check for them because errors of this nature technically follow the syntax of the language and will slip through the syntax analysis step. 

This step is not included in this compiler because the simplicity of the WHILE language makes it relatively unnecessary. 

#### Code Generation/Translation
This step takes the AST produced by the parsing/syntax analysis step and uses it to generate code in the target language (the language being compiled to) that (typically) has the same structure and functions the same. For more complicated languages, this step might generate code in some intermediate language before generating code in the target language for reasons that can include it being easier to compile the intermediate language to the target language or it being easier to optimize code in the intermediate language. Due to the simplicity of this project and the WHILE language, there is no intermediate language and RISC-V Assembly code is generated immediately.

#### Code Optimization
This step attempts to optimize the generated code. For example, if applicable, it can replace a computationally expensive multiplication operation with a less computationally expensive bitshift operation. Once again, due to the smaller scope of this project, this step was ommitted from this compiler.

## Project Goals
While the product of this project is a compiler, the primary goal of this project is to help me learn and to further my knowledge in some key areas of computer science:

- Compiler design
- Functional languages
- Pertinent Theory of Computation topics

## Relevant Resources
This section will include notable resources that I use, as well as resources that may be helful to anyone who is unfamiliar with this topic.

## Sample Usage
This section will walk through each step of a test run of the compiler.

### Example Program Written in WHILE
``` 
x = 1;
while (x < 10) {
  x = x * 2;
}
```
### Tokenization
The compiler tokenizes the example program as follows:
```
tokens = [
          Variable "x", Equals, Number 1, Semicolon, -- Line 1
          While, LeftParenthesis, Variable "x", LessThan, Number 10, RightParenthesis, LeftBrace, -- Line 2
          Variable "x", Equals, Variable "x", MultiplicationOp, Number 2, Semicolon, -- Line 3
          RightBrace -- Line 4
          ]
```

### Parsing
The result of the compiler parsing the above tokens is as follows (shown using console output for ease of viewing):

![AbstractSyntaxTree](https://github.com/user-attachments/assets/750c6ed0-09f4-4b3d-baa1-6214bf1ad6cd)

### Etc.

