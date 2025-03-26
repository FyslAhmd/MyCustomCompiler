%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);  // Defined by Flex
void yyerror(const char *s);
int result; // To store the final result
%}

%union {
    int num;   // The `int` type for numbers
    char *str; // The `char*` type for strings
}

%token <num> NUMBER    // NUMBER is of type `int`
%token <str> STRING
%token PRINT
%token SEMICOLON       // Declare the semicolon token

%type <num> expr term

%%

program:
    | program statement SEMICOLON  // Expect semicolon after statement
    ;

statement:
    expr                    { printf("Result: %d\n", result); }
    | PRINT STRING          { printf("%s\n", $2); free($2); }
    ;

expr:
    expr '+' term           { result = $1 + $3; }
    | expr '-' term         { result = $1 - $3; }
    | expr '/' term         { 
                                  if ($3 == 0) {
                                      yyerror("Error: Division by zero");
                                  } else {
                                      result = $1 / $3; 
                                  }
                                }
    | term                  { result = $1; }
    | STRING                { printf("%s\n", $1); free($1); }  // Print the string directly
    ;

term:
    NUMBER                 { $$ = $1; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    printf("Enter an expression or a print statement:\n");
    yyparse();  // Parse the input
    return 0;
}
