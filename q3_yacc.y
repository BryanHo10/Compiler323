%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *str);
void initialize_variable(char* var);
void init();
int yylex();
int yyparse();
char *array_variable[5];
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
%locations
%%
start: PROGRAM pname semicolon var dec_list semicolon begin stat_list end { printf("start completed\n"); }
    |   { yyerror("keyword 'PROGRAM' expected."); exit(1); }
    ;
pname: id  { printf("pname returning\n"); init(); }
    |   { yyerror("program name <pname> expected."); exit(1); }
    ;
id: IDENTIFIER { printf("id returning: [%s]\n", $1); }
    ;
var: VAR   { printf("var returning\n"); 
            FILE *pfile = fopen("abc13.cpp", "a");
            fprintf(pfile, "int ");
            fclose(pfile);}
    |   { yyerror("keyword 'VAR' expected."); exit(1); }
    ;
dec_list: dec colon type    { printf("dec_list returning\n"); FILE *pfile = fopen("abc13.cpp", "a");
                            fprintf(pfile, "%s", $1);
                            fprintf(pfile, ";\n");
                            fclose(pfile);}
    ;
dec:    IDENTIFIER comma dec    { printf("dec returning [%s]\n", $3);
                                FILE *pfile = fopen("abc13.cpp", "a");
                                fprintf(pfile, "%s, ", $3);
                                fclose(pfile);}
    |   IDENTIFIER IDENTIFIER   { yyerror("two identifiers back to back without seperator. ',' expected."); exit(1); }
    |   IDENTIFIER   { printf("identifier returning [%s]\n", $1); }
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
stat:  print     { printf("stat returning\n");}
    |  assign    { printf("assign returning value=%d\n",$1); }
    ;
print:   PRINT oparen output cparen   { printf("print returning\n");}
    ;
oparen: OPAREN { printf("open paren returning\n"); 
                FILE *pfile = fopen("abc13.cpp", "a");
                fprintf(pfile, "cout << ");
                fclose(pfile);}
    |   { yyerror("open parenthesis '(' expected."); exit(1); }
    ;
cparen: CPAREN { printf("close paren returning\n"); }
    |   { yyerror("closed parenthesis ')' expected."); exit(1); }
    ;
output: id  { printf("output id returning\n"); 
            FILE *pfile = fopen("abc13.cpp", "a");
            fprintf(pfile, "%s", $1);
            fprintf(pfile, ";\n");
            fclose(pfile);}
            //#this line is supposed to be cout << 'ab5=' << ab5
    |   STRING comma id { printf("string , id returning\n"); 
                        FILE *pfile = fopen("abc13.cpp", "a");
                        fprintf(pfile, "\"");
                        fprintf(pfile, "%s", $3);
                        fprintf(pfile, "\" << ");
                        fprintf(pfile, "%s", $3);
                        fprintf(pfile, ";\n");
                        fclose(pfile);}
    ;
comma: COMMA { printf("comma returning\n"); }
    |   { yyerror("',' expected."); exit(1); }
    ;
assign: id assignment expr { printf("assign returning $1=%s $3=%d\n",$1,$3); $$ = $3;
                            FILE *pfile = fopen("abc13.cpp", "a"); fprintf(pfile, "%s=", $1);
                            fprintf(pfile, "%d;\n", $3);
                            fclose(pfile);}
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
end: END { printf("END. returning\n"); 
         FILE *pfile = fopen("abc13.cpp", "a");
         fprintf(pfile, "return 0;\n}");
         fclose(pfile);}
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
        fprintf(pfile, "#include <iostream>\nusing namespace std;\nint main()\n{\n");
    }
    fclose(pfile);
}