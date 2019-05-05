%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *str);
int yylex();
int yyparse();
int yywrap()
{
    return 1;
}

int main()
{
    yyparse();
}

%}

%token PROGRAM INTEGER END VAR COMMA SEMICOLON COLON BEG PRINT ASSIGNMENT
%token OPAREN CPAREN OPERATOR PLUS MINUS TIMES DIVIDE

%union
{
    int number;
    char *string;
}

%token <number> STATE DIGIT
%token <string> LETTER IDENTIFIER STRING
%type <string> pname id dec print output
%type <number> assign expr term factor

%%

start: PROGRAM pname semicolon var dec_list semicolon begin stat_list end { printf("start completed\n"); }
    |   { printf("\nerror: PROGRAM expected.  exiting.\n"); exit(1);}
    ;

pname: id  { printf("pname returning\n"); }
    |   { printf("\nerror program name <pname> expected.  exiting.\n"); exit(1);}
    ;

id: IDENTIFIER { printf("id returning: [%s]\n", $1); }
    ;

var: VAR   { printf("var returning\n"); }
    |   { printf("\nerror: VAR expected.  exiting.\n"); exit(1);}
    ;

dec_list: dec colon type    { printf("dec_list returning\n"); }
    ;

dec:    IDENTIFIER comma dec    { printf("dec returning [%s]\n", $3); }
    |   IDENTIFIER   { printf("identifier returning [%s]\n", $1); }
    ;

colon: COLON   { printf("colon returning\n"); }
    |   { printf("\nerror no colon: ':' expected.  exiting.\n"); exit(1);}
    ;

semicolon: SEMICOLON   { printf("semicolon returning\n"); }
    |   { printf("\nerror: ';' expected.  exiting.\n"); exit(1);}
    ;

type: INTEGER   { printf("integer returning\n"); }
    |   { printf("\nerror type of INTEGER expected.  exiting.\n"); exit(1);}
    ;

begin: BEG  { printf("BEGIN returning\n"); }
    |   { printf("\nerror: BEGIN expected.  exiting.\n"); exit(1);}
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
    |   { printf("\nerror no open parenthesis: '(' expected.  exiting.\n"); exit(1);}
    ;

cparen: CPAREN { printf("close paren returning\n"); }
    |   { printf("\nerror no closed parenthesis: ')' expected.  exiting.\n"); exit(1);}
    ;

output: id  { printf("output id returning\n"); }
    |   STRING comma id { printf("string , id returning\n"); }
    ;

comma: COMMA { printf("comma returning\n"); }
    |   { printf("\nerror: ',' expected.  exiting.\n"); exit(1);}
    ;

assign: id assignment expr { printf("assign returning $1=%s $3=%d\n",$1,$3); $$ = $3; }
    ;

assignment: ASSIGNMENT { printf("assignment returning\n"); }
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
    |   { printf("\nerror: 'END.' expected.  exiting.\n"); exit(1);}
    ;

%%


void yyerror(const char *str)
{
    fprintf(stderr, "error: %s\n",str);
}

/*


id:
    | letter id { printf("id letter id:\n"); }
    | letter     { printf("id letter id:\n"); }
    ;

letter:
    | 'a'       { printf("a\n"); }
    | 'b'       { printf("b\n"); }
    | 'c'       { printf("c\n"); }
    | 'd'       { printf("d\n"); }
    | 'e'       { printf("e\n"); }
    | 'f'       { printf("f\n"); }











command:
    heat_switch | target_set | heater_select
    ;

heat_switch:
    TOKHEAT STATE
    {
        printf("\tHeater '%s' turned %s\n", heater, ($2) ? "on" : "off");
    }
    ;

target_set:
    TOKTARGET TOKTEMPERATURE NUMBER
    {
        printf("\tHeater '%s' temperature set to %d\n", heater, $3);
    }
    ;

heater_select:
    TOKHEATER WORD
    {
        printf("\tSelected heater '%s'\n", $2);
        heater = $2;
    }
    ;

*/