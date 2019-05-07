%{
#include <stdio.h>
#include <string.h>
#include "q3_yacc.tab.h"
%}
%option yylineno
%%
[0-9]+              yylval.number=atoi(yytext);return DIGIT;
"END."              return END;
VAR                 return VAR;
,                   return COMMA;
;                   return SEMICOLON;
:                   return COLON;
=                   return ASSIGNMENT;
"("                 return OPAREN;
")"                 return CPAREN;
"+"                 return PLUS;
"-"                 return MINUS;
"*"                 return TIMES;
"/"                 return DIVIDE;
PROGRAM             return PROGRAM;
INTEGER             return INTEGER;
BEGIN               return BEG;
PRINT               return PRINT;
[a-f][a-f0-9]*      yylval.string=strdup(yytext);return IDENTIFIER;
'.*'                return STRING;
\n                  ;
[ \t]+              ;
%%


void yyerror(const char *str)
{
    fprintf(stderr, "Error: %s   near line: %d. Exiting.\n", str, yylineno);
}