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
    BLANKID = 273,
    PARSEINT = 274,
    CMDARGS = 275,
    LSQ = 276,
    RSQ = 277,
    NOT = 278,
    ELSE = 279,
    IF = 280,
    FOR = 281,
    END = 282,
    PLUSPLUS = 283,
    MINUSMINUS = 284,
    ID = 285,
    STRLIT = 286,
    REALLIT = 287,
    INTLIT = 288,
    OR = 289,
    AND = 290,
    LT = 291,
    GT = 292,
    EQ = 293,
    NE = 294,
    LE = 295,
    GE = 296,
    ASSIGN = 297,
    PLUS = 298,
    MINUS = 299,
    STAR = 300,
    DIV = 301,
    MOD = 302,
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
#define RETURN 271
#define PRINT 272
#define BLANKID 273
#define PARSEINT 274
#define CMDARGS 275
#define LSQ 276
#define RSQ 277
#define NOT 278
#define ELSE 279
#define IF 280
#define FOR 281
#define END 282
#define PLUSPLUS 283
#define MINUSMINUS 284
#define ID 285
#define STRLIT 286
#define REALLIT 287
#define INTLIT 288
#define OR 289
#define AND 290
#define LT 291
#define GT 292
#define EQ 293
#define NE 294
#define LE 295
#define GE 296
#define ASSIGN 297
#define PLUS 298
#define MINUS 299
#define STAR 300
#define DIV 301
#define MOD 302
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
