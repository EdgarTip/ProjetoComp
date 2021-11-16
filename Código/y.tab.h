/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
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
    PACKAGE = 258,
    SEMICOLON = 259,
    VAR = 260,
    LPAR = 261,
    RPAR = 262,
    COMMA = 263,
    INT = 264,
    FLOAT32 = 265,
    BOOL = 266,
    STRING = 267,
    FUNC = 268,
    LBRACE = 269,
    RBRACE = 270,
    RETURN = 271,
    PRINT = 272,
    ASSIGN = 273,
    BLANKID = 274,
    PARSEINT = 275,
    CMDARGS = 276,
    LSQ = 277,
    RSQ = 278,
    OR = 279,
    AND = 280,
    LT = 281,
    GT = 282,
    EQ = 283,
    NE = 284,
    LE = 285,
    GE = 286,
    PLUS = 287,
    MINUS = 288,
    STAR = 289,
    DIV = 290,
    MOD = 291,
    NOT = 292,
    ELSE = 293,
    IF = 294,
    FOR = 295,
    END = 296,
    PLUSPLUS = 297,
    MINUSMINUS = 298,
    ID = 299,
    REALLIT = 300,
    INTLIT = 301,
    STRLIT = 302
  };
#endif
/* Tokens.  */
#define PACKAGE 258
#define SEMICOLON 259
#define VAR 260
#define LPAR 261
#define RPAR 262
#define COMMA 263
#define INT 264
#define FLOAT32 265
#define BOOL 266
#define STRING 267
#define FUNC 268
#define LBRACE 269
#define RBRACE 270
#define RETURN 271
#define PRINT 272
#define ASSIGN 273
#define BLANKID 274
#define PARSEINT 275
#define CMDARGS 276
#define LSQ 277
#define RSQ 278
#define OR 279
#define AND 280
#define LT 281
#define GT 282
#define EQ 283
#define NE 284
#define LE 285
#define GE 286
#define PLUS 287
#define MINUS 288
#define STAR 289
#define DIV 290
#define MOD 291
#define NOT 292
#define ELSE 293
#define IF 294
#define FOR 295
#define END 296
#define PLUSPLUS 297
#define MINUSMINUS 298
#define ID 299
#define REALLIT 300
#define INTLIT 301
#define STRLIT 302

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 56 "gocompiler.y"

int value;
char* letters;
struct node_list *node;

#line 157 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
