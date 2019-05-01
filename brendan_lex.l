%{
<<<<<<< HEAD
#include<stdio.h>
int c = 1;
%}
comment \(\*\s*.*\n*.*\n*.*\n*.*\*\)
operator [-+*/]
comma  [,]
openparen [(]
closeparen [)]
colon [:]
semicolon [;]
assignment [=]
letter [a-f]
id     [a-f][a-f0-9]*
number [0-9]+

%%
\n  { c++; }
("VAR"|"INTEGER"|"BEGIN"|"END."|"PRINT") { printf("Key word %s found in line %d\t", yytext, c); printf("\n"); fprintf(yyout, "%s ", yytext); }
"PROGRAM"                                { printf("Key word %s found in line %d\t", yytext, c); printf("\n"); fprintf(yyout, "%s ", yytext); }
{id}                                     { printf("id: %s found in line %d\t", yytext, c); printf("\n"); fprintf(yyout, "%s ", yytext); }
{semicolon}                                     { printf("semicolon: %s found in line %d\t", yytext, c); printf("\n"); fprintf(yyout, "%s\n", yytext); }
{openparen}                                     { printf("openparen: %s found in line %d\t", yytext, c); printf("\n"); fprintf(yyout, "%s ", yytext); }
{closeparen}                                     { printf("closeparen: %s found in line %d\t", yytext, c); printf("\n"); fprintf(yyout, "%s ", yytext); }
{comma}                                     { printf("comma: %s found in line %d\t", yytext, c); printf("\n"); fprintf(yyout, "%s ", yytext); }
{colon}                                     { printf("colon: %s found in line %d\t", yytext, c); printf("\n"); fprintf(yyout, "%s ", yytext); }
{operator}                                     { printf("operator: %s found in line %d\t", yytext, c); printf("\n"); fprintf(yyout, "%s ", yytext); }
{assignment}                                     { printf("assignment: %s found in line %d\t", yytext, c); printf("\n"); fprintf(yyout, "%s ", yytext); }
{comment} ;
{number}                                     { printf("number: %s found in line %d\t", yytext, c); printf("\n"); fprintf(yyout, "%s ", yytext); }




.|\n ;
%%
int main()
{
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");
    yylex();
    fclose(yyin);
    fclose(yyout);
}
=======
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

>>>>>>> 833ac40f2ae682b983a4ab2315398fa353cf2a75
