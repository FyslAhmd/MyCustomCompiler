%{
#include "parser.tab.h"
#include <string.h>   // Include string.h to use strdup
%}

%%

"printf"    { return PRINTF; }
"("         { return LPAREN; }
")"         { return RPAREN; }
";"         { return SEMICOLON; }
[0-9]+      { yylval.num = atoi(yytext); return NUM; }
\"[^\"]*\"  { yylval.str = strdup(yytext); return STRING; }  // Capture string literals
[a-zA-Z_][a-zA-Z0-9_]*  { return IDENTIFIER; }

[ \t\n]      { /* Ignore whitespace */ }

%%

int yywrap() {
    return 1;
}
