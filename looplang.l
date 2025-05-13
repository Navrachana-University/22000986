%{
#include "looplang.tab.h"
#include <string.h>
%}

%%

"choose"        { return CHOOSE; }
"option"        { return OPTION; }
"fiza"          { return BREAK; }
"nomatch"       { return NOMATCH; }

"{"             { return LBRACE; }
"}"             { return RBRACE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
";"             { return SEMICOLON; }
"="             { return ASSIGN; }
"<"             { return LT; }
"+"             { return PLUS; }
":"             { return COLON; }

[0-9]+          { yylval.str = strdup(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENT; }

[ \t\r\n]+      { /* skip whitespace */ }
.               { printf("Unknown character: %s\n", yytext); }

%%

int yywrap() { return 1; }
