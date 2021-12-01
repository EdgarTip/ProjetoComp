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
    ELSE = 278,
    IF = 279,
    FOR = 280,
    END = 281,
    PLUSPLUS = 282,
    MINUSMINUS = 283,
    ID = 284,
    STRLIT = 285,
    REALLIT = 286,
    INTLIT = 287,
    OR = 288,
    AND = 289,
    LT = 290,
    GT = 291,
    EQ = 292,
    NE = 293,
    LE = 294,
    GE = 295,
    ASSIGN = 296,
    PLUS = 297,
    MINUS = 298,
    STAR = 299,
    DIV = 300,
    MOD = 301,
    NOT = 302,
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
#define ELSE 278
#define IF 279
#define FOR 280
#define END 281
#define PLUSPLUS 282
#define MINUSMINUS 283
#define ID 284
#define STRLIT 285
#define REALLIT 286
#define INTLIT 287
#define OR 288
#define AND 289
#define LT 290
#define GT 291
#define EQ 292
#define NE 293
#define LE 294
#define GE 295
#define ASSIGN 296
#define PLUS 297
#define MINUS 298
#define STAR 299
#define DIV 300
#define MOD 301
#define NOT 302
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
