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
    ID = 259,
    SEMICOLON = 260,
    VAR = 261,
    LPAR = 262,
    RPAR = 263,
    COMMA = 264,
    INT = 265,
    FLOAT32 = 266,
    BOOL = 267,
    STRING = 268,
    FUNC = 269,
    LBRACE = 270,
    RBRACE = 271,
    RETURN = 272,
    PRINT = 273,
    STRLIT = 274,
    ASSIGN = 275,
    BLANKID = 276,
    PARSEINT = 277,
    CMDARGS = 278,
    LSQ = 279,
    RSQ = 280,
    OR = 281,
    AND = 282,
    LT = 283,
    GT = 284,
    EQ = 285,
    NE = 286,
    LE = 287,
    GE = 288,
    PLUS = 289,
    MINUS = 290,
    STAR = 291,
    DIV = 292,
    MOD = 293,
    NOT = 294,
    INTLIT = 295,
    REALLIT = 296,
    ELSE = 297,
    IF = 298,
    FOR = 299
  };
#endif
/* Tokens.  */
#define PACKAGE 258
#define ID 259
#define SEMICOLON 260
#define VAR 261
#define LPAR 262
#define RPAR 263
#define COMMA 264
#define INT 265
#define FLOAT32 266
#define BOOL 267
#define STRING 268
#define FUNC 269
#define LBRACE 270
#define RBRACE 271
#define RETURN 272
#define PRINT 273
#define STRLIT 274
#define ASSIGN 275
#define BLANKID 276
#define PARSEINT 277
#define CMDARGS 278
#define LSQ 279
#define RSQ 280
#define OR 281
#define AND 282
#define LT 283
#define GT 284
#define EQ 285
#define NE 286
#define LE 287
#define GE 288
#define PLUS 289
#define MINUS 290
#define STAR 291
#define DIV 292
#define MOD 293
#define NOT 294
#define INTLIT 295
#define REALLIT 296
#define ELSE 297
#define IF 298
#define FOR 299

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
