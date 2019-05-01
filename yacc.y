%{
    
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    void yyerror (char *s);
    extern int yylex();
    int symbols[52];
    int symbolVal(char symbol);
    void updateSymbolVal(char symbol, int val);
%}

%union {int num; char id;}
%start LINE
%token PROGRAM
%token VAR
%token PRINT
%token <num> NUMBER
%token <id> IDENTIFIER
%type <num> LINE EXP TERM
%type <id> ASSIGNMENT

%%

LINE    :   ASSIGNMENT ';'          {;}
        |   PRINT EXP  ';'          {printf("Printing %d\n", $2);}
        |   PRINT '(' EXP ')' ';'   {printf("Printing %d\n", $3);}
        |   LINE ASSIGNMENT ';'     {;}
        |   LINE PRINT EXP ';'      {printf("Printing %d\n", $3);}
        |   LINE PRINT '(' EXP ')' ';'  {printf("Printing %d\n", $4);}
        ;

ASSIGNMENT      :   IDENTIFIER '=' EXP      { updateSymbolVal($1, $3); }
                ;

EXP     :   TERM                {$$ = $1;}
        |   EXP '+' TERM        {$$ = $1 + $3;}
        |   EXP '-' TERM        {$$ = $1 - $3;}
        |   EXP '*' TERM        {$$ = $1 * $3;}
        |   EXP '/' TERM        {$$ = $1 / $3;}
        ;

TERM    :   NUMBER              {$$ = $1;}
        |   IDENTIFIER          {$$ = symbolVal($1);}
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

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main (void) {

    int numToken, valToken;

    yylex();

	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}
    yyparse ();
	return 0;
}

void yyerror (char *s) 
{
    // fprintf("Hello");
    fprintf (stderr, "%s\n", s);
    
} 
