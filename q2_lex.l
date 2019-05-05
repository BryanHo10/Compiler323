%{
#include <stdio.h>
#include <string.h>
#include "q2_yacc.tab.h"
%}
%%
[0-9]+              yylval.number=atoi(yytext);return DIGIT;
"END."              return END;
VAR                 return VAR;
,                   return COMMA;
;                   return SEMICOLON;
:                   return COLON;
=                   return ASSIGNMENT;
"("                   return OPAREN;
")"                  return CPAREN;
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