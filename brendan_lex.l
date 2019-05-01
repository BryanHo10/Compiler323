%{
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