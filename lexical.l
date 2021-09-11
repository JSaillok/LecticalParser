%{

#include <stdio.h>
#include "parser.tab.h"
#define YY_USER_ACTION                                             \
  yylloc.first_line = yylloc.last_line;                            \
  yylloc.first_column = yylloc.last_column;                        \
  if (yylloc.last_line == yylineno)                                \
    yylloc.last_column += yyleng;                                  \
  else {                                                           \
    yylloc.last_line = yylineno;                                   \
    yylloc.last_column = yytext + yyleng - strrchr(yytext, '\n');  \
  }


int lineno=1;
int error_count=0;

%}

/* Αναγνώριση των λέξεων-κλειδιών και με κεφαλαία (π.χ. 'INT') και με πεζά (π.χ. 'int') */


/* Μεταβλητή τύπου int ενσωματωμένη στο Flex. Κάθε φορά που θα συναντά το Flex τον χαρακτήρα νέας γραμμής ('\n'), η μεταβλητή θα αυξάνεται ΑΥΤΟΜΑΤΑ κατά 1 */
%option yylineno

/* Για την ανάγνωση ΜΟΝΟ ενός αρχείου κάθε φορά */
%option noyywrap


%x PROGRAM
%x STRUCT

LETTER      [a-zA-Z]
DIGIT       [0-9]
CHARACTER   {LETTER}|{DIGIT}
NZNUMBER    [1-9]{DIGIT}*|0
ID          _?{LETTER}({LETTER}|{DIGIT}|_)*
ICONST      {NZNUMBER}
FCONST      {NZNUMBER}\.{DIGIT}*
CCONST      \'.\'
WHITESPACE  [ \t\t\r]+
TEXT        \"(\\.|[^"\\])*\"
COMMENT     %(.)*(\r\n|\r|\n)


%%

<PROGRAM>\r\n|\r|\n {printf("Found KEYWORD ->  PROGRAM_CHANGE_LINE\n"); BEGIN (INITIAL); return T_PROGRAM_LINE; }
<STRUCT>\r\n|\r|\n  {printf("Found KEYWORD ->  CHANGE_LINE\n"); BEGIN (INITIAL); return T_STRUCT_LINE; }
"STRUCT"            { printf("Found KEYWORD -> STRUCT\n"); BEGIN (STRUCT); return T_STRUCT; }
"ENDSTRUCT"         { printf("Found KEYWORD -> ENDSTRUCT\n"); return T_ENDSTRUCT; }
"VARS"              { printf("Found KEYWORD -> VARS\n"); return T_VARS; }
"TYPEDEF"           { printf("Found KEYWORD -> TYPEDEF\n"); return T_TYPEDEF; }
"/*"			    { comment(); }
"PROGRAM"           { printf("Found KEYWORD -> program\n");BEGIN (PROGRAM); return T_PROGRAM; }
"CHAR"              { printf("Found KEYWORD -> char\n"); return T_CHAR; }
"INT"               { printf("Found KEYWORD -> int\n"); return T_INT; }
"FUNCTION"          { printf("Found KEYWORD -> function\n"); return T_FUNCTION; }
"END_FUNCTION"      { printf("Found KEYWORD -> end_function\n"); return T_ENDFUNCTION ; }
"IF"                { printf("Found KEYWORD -> if\n"); return T_IF; }
"THEN"              { printf("Found KEYWORD -> then\n"); return T_THEN; }
"ELSEIF"            { printf("Found KEYWORD -> elseif\n"); return T_ELSEIF; }
"ELSE"              { printf("Found KEYWORD -> else\n"); return T_ELSE; }
"ENDIF"             { printf("Found KEYWORD -> endif\n"); return T_ENDIF; }
"SWITCH"              { printf("Found KEYWORD -> switch\n"); return T_SWITCH; }
"CASE"               { printf("Found KEYWORD -> case\n"); return T_CASE; }
"DEFAULT"            { printf("Found KEYWORD -> default\n"); return T_DEFAULT; }
"ENDSWITCH"          { printf("Found KEYWORD -> endswitch\n"); return T_ENDSWITCH; }
"BREAK"              { printf("Found KEYWORD -> break\n"); return T_BREAK; }
"WHILE"             { printf("Found KEYWORD -> while\n"); return T_WHILE; }
"ENDWHILE"           { printf("Found KEYWORD -> endwhile\n"); return T_ENDWHILE; }
"FOR"               { printf("Found KEYWORD -> case\n"); return T_FOR; }
"TO"               { printf("Found KEYWORD -> case\n"); return T_TO; }
"STEP"               { printf("Found KEYWORD -> case\n"); return T_STEP; }
"ENDFOR"               { printf("Found KEYWORD -> case\n"); return T_ENDFOR; }
"PRINT"              { printf("Found KEYWORD -> PRINT\n"); return T_PRINT; }   
"RETURN"            { printf("Found KEYWORD -> return\n"); return T_RETURN; }
"STARTMAIN"         { printf("Found KEYWORD-> startmain\n"); return T_STARTMAIN; }
"ENDMAIN"             { printf("Found KEYWORD -> endmain\n"); return T_ENDMAIN; }
"OR"                { printf("Found OROP\n"); return T_OROP; }
"AND"                { printf("Found ANDOP\n"); return T_ANDOP; }
"=="|"!="           { printf("Found EQUOP -> %s\n", yytext); return T_EQUOP; }
">"|"<"               { printf("Found RELOP -> %s\n", yytext); return T_RELOP; }
"+"|"-"             { printf("Found ADDOP -> %s\n", yytext); return T_ADDOP; }
"*"|"/"|"%"         { printf("Found MULOP -> %s\n", yytext); return T_MULOP; }
"!"                 { printf("Found NOTOP\n"); return T_NOTOP; }
"("                 { printf("Found LPAREN\n"); return T_LPAREN; }
")"                 { printf("Found RPAREN\n"); return T_RPAREN; }
";"                 { printf("Found SEMI\n"); return T_SEMI; }
","                 { printf("Found COMMA\n"); return T_COMA; }
"="                 { printf("Found ASSIGN\n"); return T_ASSIGN; }
"["                 { printf("Found LBRACK\n"); return T_LBRACK; }
"]"                 { printf("Found RBRACK\n"); return T_RBRACK; }
":"                  { printf("Found COLON\n"); return T_COLON; }
"COUNTER:="           { printf("Found KEYWORD -> COUNTER \n"); return T_COUNTER; }
"^"                   { printf("Found POWER\n"); return T_POWER; }     
{COMMENT}           { printf("Found comment -> %s\n", yytext); /* ta comments ta opoia ginontai ignore */                      }
<STRUCT,INITIAL>{ID}   { yylval.charval= strdup(yytext);  printf("Found KEYWORD -> ID \n"); return T_ID; }
<PROGRAM,INITIAL>{ID} { yylval.charval= strdup(yytext);  printf("Found KEYWORD -> ID \n"); return T_ID; }

{TEXT}              { printf("Found TEXT -> %s\n", yytext); return T_TEXT; }
{ICONST}            { printf("Found ICONST -> %s\n", yytext); return T_ICONST; }
{CCONST}            { printf("Found CCONST -> %s\n", yytext); return T_CCONST; }
{WHITESPACE}        { /* Κενά (space) μέσα στο αρχείο - απλά τα αγνοούμε */ }
\n                  { lineno++; /* Εναλλακτικά βασιζόμαστε στο Flex να αυξήσει την μεταβλητή 'yylineno' κατά 1 ΑΥΤΟΜΑΤΑ */ }
<<EOF>> 	        {printf("we reached the end of file (EOF)!\n"); return 0;}
.                   { error_count++; printf("\nUnrecognised character at line %d->%s!\n", yylineno,yytext); }

%%


// comment()
// {
// 	char c, c1;
//           if (c=="\n" || c1=="\n") { lineno++;}
// loop:
// 	while ((c = input()) != '*' && c != 0)
// 		putchar(c);
//                 if (c=="\n" || c1=="\n") { lineno++;}
// lineno++ ;
// 	if ((c1 = input()) != '/' && c != 0)
// 	{           if (c=="\n" || c1=="\n") { lineno++;}
// 		unput(c1);
// 		goto loop;
// 	}

// 	if (c != 0){
//          if (c=="\n" || c1=="\n") { lineno++;}
// 		putchar(c1);    }

// }


comment()
{
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
}