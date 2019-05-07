%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
extern char* yytext;
%}

%union {int num; char id;}         
%start LINE
%token PRINT
%token PROGRAM
%token exit_command
%token <num> NUMBER
%token <id> IDENTIFIER
%type <num> LINE EXP TERM 
%type <id> ASSIGNMENT

%%


LINE    : PROGRAM IDENTIFIER ';'        {printf("Found PROGRAM  \n", $2);}
        | INSTRUCTIONS                  {;}
        ;

INSTRUCTIONS    :         
          ASSIGNMENT ';'		        {;}
		| exit_command		            {exit(EXIT_SUCCESS);}
		| PRINT EXP ';'			        {printf("printing %d\n", $2);}
        | LINE PRINT '(' EXP ')' ';'    {printf("printing %d\n", $4);}
		| LINE ASSIGNMENT ';'	        {;}
		| LINE PRINT EXP ';'	        {printf("printing %d\n", $3);}
		| LINE exit_command             {exit(EXIT_SUCCESS);}

ASSIGNMENT : IDENTIFIER '=' EXP  { updateSymbolVal($1,$3); }
		    ;
EXP    	: TERM                  {$$ = $1;}
       	| EXP '+' TERM          {$$ = $1 + $3;}
       	| EXP '-' TERM          {$$ = $1 - $3;}
       	;
TERM   	: NUMBER                {$$ = $1;}
		| IDENTIFIER			{$$ = symbolVal($1);} 
        ;

%%                     

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 


int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}


void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main () {

	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

    int numToken, valToken;
    while(numToken)
    {
        valToken = yylex();
        if(valToken != PROGRAM)
        {
            printf("error no program");
            return 1;
        }
        break;
    }

	return yyparse ();
}

void yyerror (char *s) 
{
    fprintf (stderr, "%s\n", s);
    } 