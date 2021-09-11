/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_PROGRAM_LINE = 258,
    T_COLON = 259,
    T_LPAREN = 260,
    T_RPAREN = 261,
    T_SEMI = 262,
    T_COMA = 263,
    T_ASSIGN = 264,
    T_LBRACK = 265,
    T_RBRACK = 266,
    T_STRUCT = 267,
    T_VARS = 268,
    T_ENDSTRUCT = 269,
    T_TYPEDEF = 270,
    T_STRUCT_LINE = 271,
    T_PROGRAM = 272,
    T_FUNCTION = 273,
    T_ENDFUNCTION = 274,
    T_STARTMAIN = 275,
    T_ENDMAIN = 276,
    T_CHAR = 277,
    T_INT = 278,
    T_IF = 279,
    T_THEN = 280,
    T_ELSEIF = 281,
    T_ELSE = 282,
    T_ENDIF = 283,
    T_ANDOP = 284,
    T_OROP = 285,
    T_RETURN = 286,
    T_WHILE = 287,
    T_ENDWHILE = 288,
    T_SWITCH = 289,
    T_CASE = 290,
    T_DEFAULT = 291,
    T_ENDSWITCH = 292,
    T_BREAK = 293,
    T_FOR = 294,
    T_ENDFOR = 295,
    T_STEP = 296,
    T_COUNTER = 297,
    T_TO = 298,
    T_PRINT = 299,
    T_ID = 300,
    T_CCONST = 301,
    T_ICONST = 302,
    T_POWER = 303,
    T_TEXT = 304,
    T_RELOP = 305,
    T_EQUOP = 306,
    T_NOTOP = 307,
    T_ADDOP = 308,
    T_MULOP = 309,
    NEG = 310
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 18 "parser.y" /* yacc.c:1909  */

	   int intval;
    	   char* charval; 	 
           

#line 116 "parser.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
