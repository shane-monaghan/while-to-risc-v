# WHILE to RISC-V Compiler

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

