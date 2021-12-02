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
    CMDARGS = 274,
    LSQ = 275,
    RSQ = 276,
    ELSE = 277,
    END = 278,
    PLUSPLUS = 279,
    MINUSMINUS = 280,
    ID = 281,
    STRLIT = 282,
    REALLIT = 283,
    INTLIT = 284,
    OR = 285,
    AND = 286,
    LT = 287,
    GT = 288,
    EQ = 289,
    NE = 290,
    LE = 291,
    GE = 292,
    ASSIGN = 293,
    PLUS = 294,
    MINUS = 295,
    STAR = 296,
    DIV = 297,
    MOD = 298,
    NOT = 299,
    IF = 300,
    FOR = 301,
    PARSEINT = 302,
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
#define CMDARGS 274
#define LSQ 275
#define RSQ 276
#define ELSE 277
#define END 278
#define PLUSPLUS 279
#define MINUSMINUS 280
#define ID 281
#define STRLIT 282
#define REALLIT 283
#define INTLIT 284
#define OR 285
#define AND 286
#define LT 287
#define GT 288
#define EQ 289
#define NE 290
#define LE 291
#define GE 292
#define ASSIGN 293
#define PLUS 294
#define MINUS 295
#define STAR 296
#define DIV 297
#define MOD 298
#define NOT 299
#define IF 300
#define FOR 301
#define PARSEINT 302
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
