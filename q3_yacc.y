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
void assign_value_to_var(char * name, int value);
int lookup_variable_value(char *name);

int number_variables = 0;
const int MAX_NUMBER_DECLARED_VARS = 10;
char *variables_array[MAX_NUMBER_DECLARED_VARS] = { };
int values_array[MAX_NUMBER_DECLARED_VARS];

void print_vars_loop()
{
    for(int i = 0; i < number_variables; ++i)
    {
        printf("\nvariable '%s' at index %d value = %d\n", variables_array[i], i, values_array[i]);
    }
}


int main()
{
    yyparse();
    print_vars_loop();
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
%type <string> pname id dec output
%type <number> assign expr term factor print

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
    }
    ;

var: VAR   
    { 
        printf("var returning\n");
        FILE *pfile = fopen("abc13.cpp", "a");
        fprintf(pfile, "int ");
        fclose(pfile); 
    }
    |   { yyerror("keyword 'VAR' expected."); exit(1); }
    ;

dec_list: dec colon type    
        { 
            printf("dec_list returning, value of dec: %s\n", $1);
            // the 1st variable in the declaration list is the value at $1, so we add it here.
            assign_var($1);
            FILE *pfile = fopen("abc13.cpp", "a");
            fprintf(pfile, "%s;\n", $1);
            fclose(pfile);
        }
    ;

dec:    IDENTIFIER comma dec    
        { 
            printf("dec: IDENTIFIER comma dec returning [%s]\n", $3);
            assign_var($3);
            FILE *pfile = fopen("abc13.cpp", "a");
            fprintf(pfile, "%s, ", $3);
            fclose(pfile);
        }
    |   IDENTIFIER IDENTIFIER   { yyerror("two identifiers back to back without seperator. ',' expected."); exit(1); }
    |   IDENTIFIER   
        { 
            printf("dec: IDENTIFIER returning [%s]\n", $1); 
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

print:   PRINT oparen output cparen
        { 
            printf("### print returning: PRINT (%s) ###\n", $3);
            print_vars_loop();
            int value = lookup_variable_value($3);
            printf("print returning: PRINT (%d)\n", value);
            FILE *pfile = fopen("abc13.cpp", "a");
            fprintf(pfile, "cout << \"%s\" << %d;\n",$3, value);
            fclose(pfile);
            $$ = value;
        }
    ;

oparen: OPAREN { printf("open paren returning\n"); }
    |   { yyerror("open parenthesis '(' expected."); exit(1); }
    ;

cparen: CPAREN { printf("close paren returning\n"); }
    |   { yyerror("closed parenthesis ')' expected."); exit(1); }
    ;

output: id  { printf("output id returning\n"); $$ = $1; }
    |   STRING comma id { printf("string , id returning\n"); $$ = $3; }
    ;

comma: COMMA { printf("comma returning\n"); }
    |   { yyerror("',' expected."); exit(1); }
    ;

assign: id assignment expr 
        { 
            printf("assign returning $1=%s $3=%d\n",$1,$3); 
            assign_value_to_var($1, $3);
            FILE *pfile = fopen("abc13.cpp", "a"); 
            fprintf(pfile, "%s=%d;\n", $1,$3);
            fclose(pfile);
            $$ = $3; 
        }
    |   { yyerror("something went wrong during assignment."); exit(1); }
    ;

assignment: ASSIGNMENT { printf("assignment returning\n"); }
    |   { yyerror("assignment operator '=' expected."); exit(1); }
    ;

expr:  term         { printf("expr term returning\n"); }
    | expr PLUS term
        { 
            printf("expr[%d] + term[%d] returning\n", $1,$3); $$ = $1 + $3;
        
        }
    | expr MINUS term { printf("expr - term returning\n"); }
    ;

term:   term TIMES factor { printf("term * factor returning\n"); $$ = $<number>1 * $3; }
    |   term DIVIDE factor { printf("term / factor returning\n"); }
    |   factor          
        { 
            printf("factor returning factor value = %d\n", $1); $$ = $1;
        }
    ;

factor: id          
        { 
            // we need to look up the value of this id
            int value = lookup_variable_value($1);
            if(value == -99)
            {
                char errorStringBuffer[100];
                snprintf(errorStringBuffer, sizeof(errorStringBuffer), "use of undeclared variable '%s'", $1);
                yyerror(errorStringBuffer); exit(-1);    
            }

            printf("factor id returning value of id=%s, value = %d\n", $1,value); $$ = value; 
        }
    |   number      { printf("factor number returning\n"); $$ = $<number>1; }
    |   '(' expr ')'{ printf("( expr ) returning\n"); $$ = $<number>1; }
    ;

number: DIGIT   { printf("number DIGIT returning\n"); }
    ;

end: END
    { 
        printf("END. returning\n");
        FILE *pfile = fopen("abc13.cpp", "a");
        fprintf(pfile, "return 0;\n}");
        fclose(pfile);
    }
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
        The purpose of this function is to first check to see if a variable name has already been declared and added to the variables array.
        If not, add it and increment number variables found.
        Else, just fall through the function
    */
    int found = 0;
    int i = 0;
    while ( i < number_variables && found != 1)
    {
        
        if( strcmp(variables_array[i], name) == 0 ) { 
            found = 1; 
        }
        ++i;
    }

    if(found == 0)
    {
        variables_array[number_variables++] = name;
    }
    
}

void assign_value_to_var(char * name, int value)
{
    int found = 0;
    int i = 0;
    while ( i < number_variables && found != 1)
    {
        
        if( strcmp(variables_array[i], name) == 0 ) { 
            values_array[i] = value;
            found = 1; 
        }
        ++i;
    }
}

int lookup_variable_value(char *name)
{
    int i = 0;
    while ( i < number_variables )
    {
        if( strcmp(variables_array[i], name) == 0 ) { return values_array[i]; }
        ++i;
    }
    // this represents sentinel value meaning that variable doesn't exist
    return -99;
}