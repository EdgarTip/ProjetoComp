%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "tree.h"
    int yylex(void);
    void yyerror (const char *s);
    
%}

%token PACKAGE  SEMICOLON VAR LPAR RPAR COMMA INT FLOAT32 BOOL STRING FUNC LBRACE RBRACE RETURN PRINT ASSIGN  BLANKID  PARSEINT CMDARGS LSQ RSQ OR AND LT GT EQ  NE LE GE PLUS MINUS STAR DIV MOD NOT   ELSE IF FOR END

%token<letters>ID REALLIT INTLIT STRLIT

%left COMMA
%left ASSIGN
%left OR 
%left AND 
%left EQ GE GT LT LE NE
%left PLUS MINUS
%left STAR DIV MOD 
%right NOT

%nonassoc LPAR RPAR 


%type<node>Program
%type<node>Declarations
%type<node>VarDeclaration
%type<node>VarSpec
%type<node>Type
%type<node>FuncDeclaration
%type<node>Parameters
%type<node>FuncBody
%type<node>VarsAndStatements
%type<node>Statement
%type<node>VarsAndStatementsOpc
%type<node>ExprSTRLITOpc
%type<node>ExprOpc
%type<node>ElseLBraceStatementRbraceOpc
%type<node>StatementSEMICOLON
%type<node>ParseArgs
%type<node>FuncInvocation
%type<node>OpcExpr
%type<node>CommaExpr
%type<node>Expr
%type<node>CommaId





%union{
int value;
char* letters;
struct node_list *node;
}

%%


Program: PACKAGE ID SEMICOLON Declarations END    {$$= create_node(PROGRAM, "Program", 0, 0); addChild($$,$4); printTree($$,0); freeTree($$);}
;


Declarations: VarDeclaration SEMICOLON Declarations       {$$= $1; add_next($$,$3); }
    |   FuncDeclaration SEMICOLON Declarations            {$$= $1; add_next($$,$3);}
    |  /*empty*/                                                   {$$=NULL;}
    ;

VarDeclaration: VAR VarSpec                                         {$$= create_node(VARDEC, "vardec", 0, 0); addChild($$, $2);}
    |   VAR LPAR VarSpec SEMICOLON RPAR                             {$$= create_node(VARDEC, "vardec", 0, 0); addChild($$, $3);}
    ;

VarSpec: ID CommaId Type                                            {$$= create_node(VARSPEC, "varspec", 0, 0);
    addChild($$, create_node(IDE, $1, 0,0)); addChild($$, $2); addChild($$, $3);}
    ;
   
CommaId: COMMA ID CommaId                                           {$$= create_node(IDE, $2, 0, 0); add_next($$, $3);}
    |                                                               {$$ = NULL;}
    ;
    
Type: INT                                                           {$$= create_node(INTE, "int", 0,0);}
    |   FLOAT32                                                     {$$= create_node(FLOAT32E, "float32", 0,0);}
    |   BOOL                                                        {$$= create_node(BOOL, "bool", 0,0);}
    |   STRING                                                      {$$= create_node(STRINGE, "string", 0,0);}
    ;

FuncDeclaration: FUNC ID LPAR Parameters RPAR Type FuncBody  {$$= create_node(FUNCDECL, "FuncDecl", 0, 0); 
    addChild($$, create_node(IDE, $2, 0, 0)); addChild($$, $4); addChild($$, $6); addChild($$, $7);}
    | FUNC ID LPAR RPAR Type FuncBody             {$$= create_node(FUNCDECL, "FuncDecl", 0, 0);
        addChild($$, create_node(IDE, $2, 0, 0)); addChild($$, $5); addChild($$, $6);}
    | FUNC ID LPAR Parameters RPAR FuncBody        {$$= create_node(FUNCDECL, "FuncDecl", 0, 0);
        addChild($$, create_node(IDE, $2, 0, 0)); addChild($$, $4); addChild($$, $6);}
    | FUNC ID LPAR RPAR FuncBody                  {$$= create_node(FUNCDECL, "FuncDecl", 0, 0);
        addChild($$, create_node(IDE, $2, 0, 0)); addChild($$, $5);}

Parameters: ID Type                               {$$= create_node(PARAMETERS, "Parameters", 0, 0);
    addChild($$, create_node(IDE, $1, 0, 0)); addChild($$, $2);}
    | ID Type COMMA Parameters                     {$$= create_node(PARAMETERS, "Parameters", 0, 0);
    addChild($$,create_node(IDE, $1, 0, 0)); addChild($$, $2); addChild($$, $4);}
;

FuncBody: LBRACE VarsAndStatements RBRACE          {$$= create_node(FUNCBODY, "FuncBody", 0, 0); addChild($$, $2);}
;

VarsAndStatements: VarsAndStatements VarsAndStatementsOpc SEMICOLON    {$$= create_node(VARSANDSTAT, "VarsAndStatements", 0, 0); addChild($$, $2); add_next($$, $1);}
    |                                             {$$=NULL;}
    ;

VarsAndStatementsOpc: VarDeclaration              {$$= create_node(VARSANDSTATOPC, "VarsAndStatementsOPC", 0, 0); addChild($$, $1);}
    | Statement                                       {$$= create_node(VARSANDSTATOPC, "VarsAndStatementsOPC", 0, 0); addChild($$, $1);}
    |                                                 {$$ = NULL;}
    ;

Statement: ID ASSIGN Expr                         {$$= create_node(STATEMENT, "Statement", 0,0); 
    addChild($$,create_node(IDE, $1,0,0)); addChild($$,$3);}
    | LBRACE StatementSEMICOLON RBRACE            {$$= create_node(STATEMENT, "Statement", 0,0); addChild($$,$2);}
    | IF Expr LBRACE StatementSEMICOLON RBRACE ElseLBraceStatementRbraceOpc   {$$= create_node(STATEMENT, "Statement", 0,0); addChild($$,$2); addChild($$,$4); addChild($$,$6);}
    | FOR ExprOpc LBRACE StatementSEMICOLON RBRACE {$$= create_node(STATEMENT, "Statement", 0,0); addChild($$,$2); addChild($$,$4);}
    | RETURN ExprOpc                              {$$= create_node(STATEMENT, "Statement", 0,0); addChild($$,$2);}
    | FuncInvocation                              {$$= create_node(STATEMENT, "Statement", 0,0); addChild($$,$1);}
    | ParseArgs                                   {$$= create_node(STATEMENT, "Statement", 0,0); addChild($$,$1);}
    | PRINT LPAR ExprSTRLITOpc RPAR               {$$= create_node(STATEMENT, "Statement", 0,0); addChild($$,$3);}
;

ExprSTRLITOpc: Expr         {$$= $1;}
    | STRLIT                {$$= create_node(STRLITE, $1, 0,0);}
;

ExprOpc: Expr               {$$=$1;}
|                           {$$=NULL;}
;

ElseLBraceStatementRbraceOpc: ELSE LBRACE StatementSEMICOLON RBRACE {$$ = $3;}
    |   {$$=NULL;}
;


StatementSEMICOLON: Statement SEMICOLON StatementSEMICOLON {$$=create_node(STATESEMI, "Statement Semicolon", 0,0);addChild($$,$1); addChild($$,$3);}
    |                                                      {$$=NULL;}
;

ParseArgs: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR  {$$= create_node(PARSEARGS, "Parse Args", 0,0); addChild($$,create_node(IDE, $1,0,0)); addChild($$,$9);}
    ;

FuncInvocation: ID LPAR OpcExpr RPAR                                {$$= create_node(FUNCINVOCATION,"FuncInvocation",0,0); addChild($$,create_node(IDE, $1, 0, 0)); addChild($$,$3);}
    ;

OpcExpr: Expr CommaExpr                                             {$$= $1; add_next($$,$1);}
    |                                                               {$$=NULL;}
    ;

CommaExpr: COMMA Expr CommaExpr                                     {$$= $2; add_next($$,$3);}
    |                                                               {$$=NULL;}
    ;

Expr: Expr OR Expr                                             {add_next($1,$3); $$=$1;}
    |   Expr AND Expr                                          {add_next($1,$3); $$=$1;}
    |   Expr LT Expr                                           {add_next($1,$3); $$=$1;}
    |   Expr GT Expr                                           {add_next($1,$3); $$=$1;}
    |   Expr EQ Expr                                           {add_next($1,$3); $$=$1;}
    |   Expr NE Expr                                           {add_next($1,$3); $$=$1;}
    |   Expr LE Expr                                           {add_next($1,$3); $$=$1;}
    |   Expr GE Expr                                           {add_next($1,$3); $$=$1;}
    |   Expr PLUS Expr                                         {add_next($1,$3); $$=$1;}
    |   Expr MINUS Expr                                        {add_next($1,$3); $$=$1;}
    |   Expr STAR Expr                                         {add_next($1,$3); $$=$1;}
    |   Expr DIV Expr                                          {add_next($1,$3); $$=$1;}
    |   Expr MOD Expr                                          {add_next($1,$3); $$=$1;}
    |   MINUS Expr                                             {$$=$2;}
    |   PLUS  Expr                                             {$$=$2;}
    |   NOT  Expr                                              {$$=$2;}
    |   INTLIT                                                 {$$ = create_node(INTLITE,$1,0,0);}
    |   REALLIT                                                {$$ = create_node(REALLITE,$1,0,0);}
    |   ID                                                     {$$ = create_node(IDE,$1,0,0);}
    |   FuncInvocation                                         {$$ = $1;}
    |   LPAR Expr RPAR                                         {$$ = $2;}
    ;




%%


