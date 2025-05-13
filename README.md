**Name: Pathan Fiza Faiyazkhan                         
Enrollment ID: 22000986**

**Description:**
Project named as LoopL or Switch-Case User-Defined is a simple programming language designed to demonstrate a custom conditional construct called choose. The choose statement evaluates a variable and executes a block of code associated with a matching option value. If no option matches, a nomatch block is executed. The language supports basic arithmetic expressions (e.g., addition), variable assignments, and a fiza keyword to terminate option blocks. This project includes a lexer and parser that generate three-address code (TAC) from LoopLang input.

**Key Features:**
Variables and Assignments: Supports variable assignments like x = 5
Arithmetic Operations: Supports basic operations like addition (+)
Choose Statement: A special control structure with:
                  option cases that compare against numeric values
                  nomatch as the default case
                  Uses fiza as the break statement (a unique keyword)
Three Address Code Generation: Outputs intermediate code suitable for further compilation

**Prerequisites:**
1. Flex (Fast Lexical Analyzer): For generating the lexer.
2. Bison (GNU Parser Generator): For generating the parser
3. GCC (GNU Compiler Collection): For compiling the generated C code
4. A Unix-like environment (Linux, macOS, or WSL on Windows).

**Compilation Steps:**
Generate Lexer and Parser:
bison -d looplang.y
flex looplang.l

**Compile the Generated Code:**
gcc lex.yy.c looplang.tab.c 

**Run the Compiler:**
a.exe
The program will prompt you to enter your LoopLang code
Type your code and press Ctrl+D (EOF) when finished
The compiler will output the generated Three Address Code

**Notes:**
The fiza keyword is used instead of break in the choose statement
The nomatch case serves as the default case
The compiler currently only supports integer numbers and basic arithmetic operations
Error messages will be displayed for invalid syntax


**Example Input:**
choose(x) {
  option 1: 
    y = 10;
    fiza;
  option 2:
    y = 20;
    fiza;
  nomatch:
    y = 30;
    fiza;
}

**Example Execution:**
Enter your code:
choose(x) {
  option 1: y = 10; fiza;
  option 2: y = 20; fiza;
  nomatch: y = 30; fiza;
}
Three Address Code:
  // Option 1
  L1:
    y = 10
    goto END

  // Option 2
  L2:
    y = 20
    goto END

  // nomatch case
  L3:
    y = 30
    goto END

  // Decision logic
  START:
    if (x == 1) goto L1
    if (x == 2) goto L2
    goto L3

  END:
    fiza
    return
The project demonstrates basic compiler construction techniques including lexical analysis, parsing, and intermediate code generation.
