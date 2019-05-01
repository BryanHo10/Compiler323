%{
    #include <stdio.h>
#include <stdlib.h>
#include "yacc.tab.h"

%}
%option noyywrap

%%
"PROGRAM"                   {;}
"VAR"                       {;}
"BEGIN"                     {;}
"PRINT"				        {return PRINT;}
"END"                       {;}
[a-zA-Z][a-zA-Z0-9]*	    {yylval.id = yytext[0]; return IDENTIFIER;}
[0-9]+                      {yylval.num = atoi(yytext); return NUMBER;}
[ \t\n]                     ;
"\(\*\s*.*\n*.*\n*.*\n*.*\*\)"      { fprintf(yyout, "");}
[-+=;()]           	        {return yytext[0];}
.                           {ECHO; yyerror ("unexpected character");}

%%

