%option yylineno

%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}

%%

BEGIN                   {return BEGIN;}
PROGRAM                 {return PROGRAM;}
PRINT                   {return PRINT;}
END                     {return exit_command;}
[a-f][a-f0-9]*          {yylval.id = yytext[0]; return IDENTIFIER;}
[0-9]+                  {yylval.num = atoi(yytext); return NUMBER;}
[ \t\n]                 ;
[-+=;]                  {return yytext[0];}
"("|")"                 {return yytext[0];}
.                       {ECHO; yyerror ("unexpected character");}
"\(\*\s*.*\n*.*\n*.*\n*.*\*\)"  ;
%%

int yywrap (void) {
    return 1;
}
