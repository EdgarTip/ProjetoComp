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
    PRINT = 271,
    BLANKID = 272,
    CMDARGS = 273,
    LSQ = 274,
    RSQ = 275,
    ELSE = 276,
    END = 277,
    PLUSPLUS = 278,
    MINUSMINUS = 279,
    ID = 280,
    STRLIT = 281,
    REALLIT = 282,
    INTLIT = 283,
    OR = 284,
    AND = 285,
    LT = 286,
    GT = 287,
    EQ = 288,
    NE = 289,
    LE = 290,
    GE = 291,
    ASSIGN = 292,
    PLUS = 293,
    MINUS = 294,
    STAR = 295,
    DIV = 296,
    MOD = 297,
    NOT = 298,
    IF = 299,
    FOR = 300,
    PARSEINT = 301,
    RETURN = 302,
    UNARY = 303
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
#define PRINT 271
#define BLANKID 272
#define CMDARGS 273
#define LSQ 274
#define RSQ 275
#define ELSE 276
#define END 277
#define PLUSPLUS 278
#define MINUSMINUS 279
#define ID 280
#define STRLIT 281
#define REALLIT 282
#define INTLIT 283
#define OR 284
#define AND 285
#define LT 286
#define GT 287
#define EQ 288
#define NE 289
#define LE 290
#define GE 291
#define ASSIGN 292
#define PLUS 293
#define MINUS 294
#define STAR 295
#define DIV 296
#define MOD 297
#define NOT 298
#define IF 299
#define FOR 300
#define PARSEINT 301
#define RETURN 302
#define UNARY 303

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 60 "gocompiler.y"

int value;
char* letters;
struct node_list *node;
struct token *id_token;

#line 160 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
