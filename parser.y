%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();   // Declare the yylex function

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
%}

%union {
    int num;   // Field for integer values
    char* str; // Field for string literals
}

%token PRINTF LPAREN RPAREN SEMICOLON NUM STRING IDENTIFIER
%type <num> NUM
%type <str> STRING

%%

program:
    statements
    ;

statements:
    statement
    | statements statement
    ;

statement:
    PRINTF LPAREN STRING RPAREN SEMICOLON {
        printf("%s\n", $3);  // Print the string literal
        free($3); // Free the memory allocated by strdup
    }
    | PRINTF LPAREN NUM RPAREN SEMICOLON {
        printf("%d\n", $3);  // Print the number
    }
    ;

%%  

int main(void) {
    printf("Enter a C printf statement (e.g., printf(\"Hello World\");):\n");
    yyparse();
    return 0;
}
