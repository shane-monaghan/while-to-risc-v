# WHILE to RISC-V Compiler

## Introduction
Would you like to write all your code in Assembly language? If your answer to that question is no, and it should be no, you owe great thanks to Grace Hopper for the invention of the compiler in 1949 [3]. A compiler is a program that converts code written in a higher-level programming language into code written in a lower-level programming language that can actually be executed. This is important because it allows programmers to write their code in a language that is typically more readable to humans [2]. For example, it allows programmers to write their code in C++ rather than Assembly.


There are multiple steps in the compilation process, though the exact number of steps depends on which source one is looking at. Generally speaking, the first step is always going to be tokenization, or breaking the original program into meaningful pieces, called tokens, based on the language's syntax. For example, the line

```
int classNumber = 341;
```

might be broken into the tokens ["int", "classNumber", "=", "341", ";"]. This makes it easier for the compiler to execute the next phase of the compilation process, syntax analysis, which ensures that the source code follows the syntactic rules of the language. Semantic analysis, the next step, ensures that there are no logical errors, such as incorrect types in the code. The exact order of the next steps vary, but they boil down to translating the source code into lower-level code and optimizing the code by, for example, removing unused code [4].


The other aspect of this project involves the languages being compiled to and from. The compiler written for this project will be compiling the WHILE language, which is a bare-bones imperative language, into RISC-V Assembly Language. The exact definition of the WHILE language can vary because it is a toy language that is primarily used for program analysis, so for the purposes of this project, the WHILE language will refer to the language outlined in the Parse Trees section of our in-class notes [1]. 

## One-Sentence Summary
This project aims to design a compiler that can compile programs written in the WHILE programming language into RISC-V code.

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

