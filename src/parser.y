%{
#include <stdio.h>
#include <stdlib.h>


extern FILE *yyin;
extern FILE *yyout;	
void yyerror(const char *s);
int yylex();
extern int yylineno;
extern int lineno;

int err=0;


%}
%locations
%union{
	   int intval;
    	   char* charval; 	 
           
}
%token T_PROGRAM_LINE "to change line meta to onoma tou program."
%token  T_COLON  ":"
%token  T_LPAREN "("
%token  T_RPAREN ")"
%token  T_SEMI ";"
%token  T_COMA ","
%token  T_ASSIGN "="
%token 	T_LBRACK "["  
%token 	T_RBRACK "]" 
%token T_STRUCT "Struct"
%token T_VARS "VARS"
%token T_ENDSTRUCT "ENDSTRUCT"
%token T_TYPEDEF    "TYPEDEF"
%token T_STRUCT_LINE "to struct mazi me line change"
%token  T_PROGRAM T_FUNCTION T_ENDFUNCTION T_STARTMAIN T_ENDMAIN T_CHAR T_INT T_IF T_THEN T_ELSEIF T_ELSE T_ENDIF T_ANDOP T_OROP T_RETURN T_WHILE T_ENDWHILE T_SWITCH T_CASE T_DEFAULT T_ENDSWITCH T_BREAK T_FOR T_ENDFOR T_STEP T_COUNTER T_TO T_PRINT
%token <charval> T_ID T_CCONST
%token <intval> T_ICONST
%token T_POWER "^"
%token T_TEXT "otidhpote mesa se eisagwgika"
%token  T_RELOP "<, >, <=, >="
%token  T_EQUOP "=="
%token  T_NOTOP "!="
%token  T_ADDOP "+, -"
%token  T_MULOP "*, /, %"
%precedence NEG 
%precedence T_THEN
%precedence T_ELSE
%left T_ANDOP T_OROP
%left T_RELOP T_EQUOP T_NOTOP
%left T_ADDOP
%left T_MULOP

%%

start: T_PROGRAM  T_ID T_PROGRAM_LINE program ;

program: Structs functions main ;

Structs:struct Structs | %empty;

    struct: T_TYPEDEF T_STRUCT T_ID T_STRUCT_LINE T_VARS structdeclare T_ID T_ENDSTRUCT 
    {char* lathos ="lathos onoma" ; int value = strcmp ( $3,$7); if(value!=0) {yyerror(lathos); printf("Λάθος όνομα"); YYABORT; } }
    |  T_STRUCT T_ID T_STRUCT_LINE T_VARS structdeclare    T_ENDSTRUCT   ;
    
    
    
    structdeclare:T_INT T_ID T_SEMI structdeclare| T_CHAR T_ID T_SEMI structdeclare | T_INT T_ID "["T_ICONST"]" T_SEMI  structdeclare
    | T_CHAR T_ID "["T_ICONST"]" T_SEMI structdeclare |%empty;
  
functions:function functions 

| %empty ;

function: T_FUNCTION T_ID T_LPAREN parameters T_RPAREN body return T_ENDFUNCTION 
	{  if (@5.last_line == @6.first_line) {char* lathos ="Body of function must start on a new line";  yyerror(lathos);  printf("Body of function must start on a new line");YYABORT;
     }}
|T_FUNCTION T_ID T_LPAREN T_RPAREN body return T_ENDFUNCTION 
{  if (@4.last_line == @5.first_line) {char* lathos ="Body of function must start on a new line" ;yyerror(lathos);  printf("Body of function must start on a new line");YYABORT;
     }};

parameters: parameter T_COMA parameters 

| 
	parameter 
;

parameter: T_INT Variable 

|
T_CHAR Variable 

;

Variable: T_ID 

| 
T_ID "["T_ICONST"]"	
;


body: T_VARS Declarations  commands  | %empty  ;

commands:  Assigns commands |If commands|Switch commands|Print commands|while commands|For commands| %empty;
calc: T_ADDOP | T_MULOP ;

Assigns: parameter T_ASSIGN expr T_SEMI | Variable T_ASSIGN expr  T_SEMI ;

expr:T_ICONST | T_ID | expr calc expr | '-' expr %prec NEG |  expr T_POWER expr | T_LPAREN expr T_RPAREN  | functionassign ;

functionassign:T_ID T_LPAREN parametersassign T_RPAREN ;

parametersassign:Variable T_COMA Variable;


while: T_WHILE T_LPAREN condition T_RPAREN  bodywhile break T_ENDWHILE ;

bodywhile: commands | break commands ;

break:T_BREAK T_SEMI|%empty;



If: T_IF T_LPAREN condition T_RPAREN T_THEN commands ELSEIF ELSE T_ENDIF  ;

condition: T_ID T_EQUOP T_ID | T_ID T_RELOP T_ID | T_ID T_ANDOP T_ID | T_ID T_OROP T_ID |T_ICONST;

ELSEIF:T_ELSEIF T_LPAREN condition T_RPAREN commands ELSEIF| %empty;

ELSE:T_ELSE commands |%empty ;

Switch:T_SWITCH T_LPAREN T_ID T_RPAREN CASE DEFAULT T_ENDSWITCH;

CASE:T_CASE T_LPAREN T_ID T_RPAREN T_COLON commands CASE |T_CASE T_LPAREN T_ICONST T_RPAREN T_COLON commands CASE | T_CASE T_LPAREN T_CCONST T_RPAREN T_COLON commands CASE |%empty;

DEFAULT:T_DEFAULT T_COLON commands | %empty;

Print:T_PRINT T_LPAREN  TEXT  VAR T_RPAREN T_SEMI;

TEXT:T_TEXT| %empty;

For:T_FOR T_COUNTER T_ICONST T_TO T_ICONST T_STEP T_ICONST bodywhile break T_ENDFOR ;



VAR: T_LBRACK T_COMA T_ID T_RBRACK |%empty;

Declarations:  Declaration T_SEMI Declarations | Assigns |%empty ;

Declaration:T_INT Variables |  T_CHAR Variables ;

Variables: Variable T_COMA Variables | Variable ;


main: T_STARTMAIN body return T_ENDMAIN ;

return: T_RETURN T_ID T_SEMI |T_RETURN T_ICONST T_SEMI | T_RETURN T_CCONST T_SEMI ;



%%

void yyerror(const char *s) {
	printf(" ----   Error in line: %d\n",yylineno);

	err++;
}

char *readFileContent(const char *const filename)
{
    size_t size;
    FILE  *file;
    char  *data;

    file = fopen(filename, "r");
    if (file == NULL)
    {
        perror("fopen()\n");
        return NULL;
    }

    /* get the file size by seeking to the end and getting the position */
    fseek(file, 0L, SEEK_END);
    size = ftell(file);
    /* reset the file position to the begining. */
    rewind(file);

    /* allocate space to hold the file content */
    data = malloc(1 + size);
    if (data == NULL)
    {
        perror("malloc()\n");
        fclose(file);
        return NULL;
    }
    /* nul terminate the content to make it a valid string */
    data[size] = '\0';
    /* attempt to read all the data */
    if (fread(data, 1, size, file) != size)
    {
        perror("fread()\n");

        free(data);
        fclose(file);

        return NULL;
    }
    fclose(file);
    return data;
}
int main(int argc,char *argv[]){
  
     ++argv; --argc;
     if (argc > 0) {
	
        yyin = fopen(argv[0], "r");
		
        if (!yyin) {
            printf("Error file %s \n",argv[1]);
            exit(1);
        }
         
    }
    else 
		yyin=stdin;
		
		yyout = fopen ( "output", "w" );
	      
           	yyparse();
		
        printf("\n\n\n-------------------------------------------\n");

	if (err==0) {
		char *content;

    content = readFileContent(argv[0]);
	
	printf("%s\n", content);

	free(content);
		printf(" Systactic ok !\n\n\n");
		  
        
		}	
	else  printf(" Errors: %d !\n\n\n",err);
	return 0;	
}