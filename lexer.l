%{
#include "parser.tab.h"
#include <string.h>
%}

%%
[0-9]+      { yylval.num = atoi(yytext); return NUMBER; }
"print"     { return PRINT; }
\"[^\"]*\"  { yylval.str = strdup(yytext); return STRING; }
[+\-]       { return yytext[0]; }
";"         { return SEMICOLON; }  // Recognize semicolon as SEMICOLON
[ \t\n]     { }
.           { return yytext[0]; }
%%

int yywrap(void) {
    return 1;
}
