%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *str);
void init();
int yylex();
int yyparse();
int yywrap(){return 1;}
void assign_var(char* name);

int number_variables = 0;
char *variables_array[4] = { };
int values_array[4];


int main()
{
    yyparse();
    for(int i = 0; i < number_variables; ++i)
    {
        printf("\nvariable `%s` at index %d\n", variables_array[i], i);
    }
}

%}

%token PROGRAM INTEGER END VAR COMMA SEMICOLON COLON BEG PRINT ASSIGNMENT
%token OPAREN CPAREN PLUS MINUS TIMES DIVIDE

%union
{
    int number;
    char *string;
}

%token <number> DIGIT
%token <string> LETTER IDENTIFIER STRING
%type <string> pname id dec print output
%type <number> assign expr term factor

%locations

%%

start: PROGRAM pname semicolon var dec_list semicolon begin stat_list end { printf("start completed\n"); }
    |   { yyerror("keyword 'PROGRAM' expected."); exit(1); }
    ;

pname: id  { printf("pname returning\n"); init(); }
    |   { yyerror("program name <pname> expected."); exit(1); }
    ;

id: IDENTIFIER 
    { 
        printf("id returning: [%s]\n", $1); 
        assign_var($1);
    }
    ;

var: VAR   { printf("var returning\n"); }
    |   { yyerror("keyword 'VAR' expected."); exit(1); }
    ;

dec_list: dec colon type    { printf("dec_list returning\n"); }
    ;

dec:    IDENTIFIER comma dec    
        { 
            printf("dec returning [%s]\n", $3);
            assign_var($3);
        }
    |   IDENTIFIER IDENTIFIER   { yyerror("two identifiers back to back without seperator. ',' expected."); exit(1); }
    |   IDENTIFIER   
        { 
            printf("identifier returning [%s]\n", $1); 
            assign_var($1);
        }
    ;

colon: COLON   { printf("colon returning\n"); }
    |   { yyerror("colon ':' expected."); exit(1); }
    ;

semicolon: SEMICOLON   { printf("semicolon returning\n"); }
    |   { yyerror("semicolon ';' expected."); exit(1); }
    ;

type: INTEGER   { printf("integer returning\n"); }
    |   { yyerror("keyword type of 'INTEGER' expected."); exit(1); }
    ;

begin: BEG  { printf("BEGIN returning\n"); }
    |   { yyerror("keyword 'BEGIN' expected."); exit(1); }
    ;

stat_list: stat semicolon   { printf("stat ; returning\n"); }
    | stat semicolon stat_list  { printf("stat ; stat_list returning\n"); }
    ;

stat:  print     { printf("stat returning\n"); }
    |  assign    { printf("assign returning value=%d\n",$1); }
    ;

print:   PRINT oparen output cparen   { printf("print returning\n");}
    ;

oparen: OPAREN { printf("open paren returning\n"); }
    |   { yyerror("open parenthesis '(' expected."); exit(1); }
    ;

cparen: CPAREN { printf("close paren returning\n"); }
    |   { yyerror("closed parenthesis ')' expected."); exit(1); }
    ;

output: id  { printf("output id returning\n"); }
    |   STRING comma id { printf("string , id returning\n"); }
    ;

comma: COMMA { printf("comma returning\n"); }
    |   { yyerror("',' expected."); exit(1); }
    ;

assign: id assignment expr 
        { 
            printf("assign returning $1=%s $3=%d\n",$1,$3); 
            
            $$ = $3; 
        }
    |   { yyerror("something went wrong during assignment."); exit(1); }
    ;

assignment: ASSIGNMENT { printf("assignment returning\n"); }
    |   { yyerror("assignment operator '=' expected."); exit(1); }
    ;

expr:  term         { printf("expr term returning\n"); }
    | expr PLUS term { printf("expr + term returning\n"); $$ = $1 + $3; }
    | expr MINUS term { printf("expr - term returning\n"); }
    ;

term:   term TIMES factor { printf("term * factor returning\n"); $$ = $1 * $3; }
    |   term DIVIDE factor { printf("term / factor returning\n"); }
    |   factor          { printf("factor returning\n"); }
    ;

factor: id          { printf("factor id returning\n"); }
    |   number      { printf("factor number returning\n"); }
    |   '(' expr ')'{ printf("( expr ) returning\n"); }
    ;

number: DIGIT   { printf("number DIGIT returning\n"); }
    ;

end: END { printf("END. returning\n"); }
    |   { yyerror("keyword 'END.' expected."); exit(1); }
    ;

%%

void init()
{
    FILE *pfile = fopen("abc13.cpp", "a");
    char buffer[256];
    if (pfile == NULL)
    {
        perror("Error opening file.");
    }
    else
    {
        fprintf(pfile, "#include <iostream>\n using namespace std;\n int main()\n {");
    }
    fclose(pfile);
}

void assign_var(char *name)
{   
    /*
        The purpose of this function is to first check to see if a variable name has already been declared and add to the variables array.
        If not, add it and increment number variables found.
        Else, just fall through the function
    */
    int found = 0;
    int i = 0;
    while ( i < number_variables && !found)
    {
        if(variables_array[i] == name) { found = 1; }
        ++i;
    }

    if(! found)
    {
        variables_array[number_variables++] = name;
    }
    
}