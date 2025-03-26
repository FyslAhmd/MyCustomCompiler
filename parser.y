%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_VARS 100  // Maximum number of variables

// Structure for storing variables
typedef struct {
    char* name;
    int value;
} Var;

// Symbol table for variables
Var symbol_table[MAX_VARS];
int var_count = 0;  // Counter for variables

extern int yylex();   // Declare the yylex function

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

// Function to find a variable in the symbol table
int get_var_value(char* name) {
    for (int i = 0; i < var_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].value;
        }
    }
    return -1;  // Variable not found
}

// Function to assign a value to a variable
void set_var_value(char* name, int value) {
    for (int i = 0; i < var_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].value = value;
            return;
        }
    }
    // If the variable is not found, add a new one
    symbol_table[var_count].name = strdup(name);
    symbol_table[var_count].value = value;
    var_count++;
}

%}

%union {
    int num;   // Field for integer values
    char* str; // Field for string literals
}

%token PRINTF LPAREN RPAREN SEMICOLON NUM STRING IDENTIFIER INT
%type <num> NUM
%type <str> STRING
%type <str> IDENTIFIER  // Add the type for IDENTIFIER (string type for variable names)
%type <num> expression   // Declare the type for expression as integer

%left '+' '-'  // Addition and subtraction have lower precedence
%left '*' '/'  // Multiplication and division have higher precedence

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
    | PRINTF LPAREN IDENTIFIER RPAREN SEMICOLON {
        // Print the value of a variable
        int value = get_var_value($3);  // Get the value of the variable
        if (value != -1) {
            printf("%d\n", value);  // Print the value
        } else {
            printf("Error: Variable %s not found\n", $3);  // Variable not found
        }
    }
    | PRINTF LPAREN expression RPAREN SEMICOLON {
        printf("%d\n", $3);  // Print the result of the expression
    }
    | INT IDENTIFIER SEMICOLON {
        // Declare an integer variable without initialization
        set_var_value($2, 0);  // Initialize to 0
    }
    | INT IDENTIFIER '=' NUM SEMICOLON {
        // Declare and initialize an integer variable
        set_var_value($2, $4);  // Initialize with the value of $4
    }
    | IDENTIFIER '=' NUM SEMICOLON {
        // Assignment to an existing variable
        set_var_value($1, $3);  // Assign the value of $3 to variable $1
    }
    ;

expression:
    NUM {
        $$ = $1;  // Directly assign the number to the result
    }
    | IDENTIFIER {
        $$ = get_var_value($1);  // Get the value of the variable
    }
    | expression '+' expression {
        $$ = $1 + $3;  // Addition
    }
    | expression '-' expression {
        $$ = $1 - $3;  // Subtraction
    }
    | expression '*' expression {
        $$ = $1 * $3;  // Multiplication
    }
    | expression '/' expression {
        if ($3 == 0) {
            yyerror("Error: Division by zero");
            $$ = 0;  // Avoid division by zero
        } else {
            $$ = $1 / $3;  // Division
        }
    }
    | LPAREN expression RPAREN {
        $$ = $2;  // Handle parentheses
    }
    ;

%%  

int main(void) {
    yyparse();  // Start parsing without any additional prompt
    return 0;
}
