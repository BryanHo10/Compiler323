%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
"PROGRAM"                   {;}
"VAR"                       {;}
"BEGIN"                     {;}
"PRINT"				        {return PRINT;}
"END"                       {;}
[a-zA-Z][a-zA-Z0-9]*	    {yylval.id = yytext[0]; return IDENTIFIER;}
[0-9]+                      {yylval.num = atoi(yytext); return NUMBER;}
[ \t\n]                     ;
"\(\*\s*.*\n*.*\n*.*\n*.*\*\)"      {;}
[-+=;]           	        {return yytext[0];}
.                           {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {
    return 1;
    }