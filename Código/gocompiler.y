%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex(void);
    void yyerror (const char *s);
%}

%token NUMBER

%left '+' '-'
%left '*' '/'
%nonassoc '('')'




%%

Program: PACKAGE ID SEMICOLON Declarations    {printf("%d\n", $1);}
;

Declarations: VarDeclaration SEMICOLON Declarations       {;}
    |   FuncDeclaration SEMICOLON Declarations            {;}
    |                                                     {;}
    ;

VarDeclaration: VAR VarSpec                                         {;}
    |   VAR LPAR VarSpec SEMICOLON RPAR                             {;}
    ;

VarSpec: ID CommaId Type                                            {;}
    ;
   
CommaId: COMMA ID CommaId                                           {;}
    |                                                               {;}
    ;
    
Type: INT                                                           {;}
    |   FLOAT32                                                     {;}
    |   BOOL                                                        {;}
    |   STRING                                                      {;}
    ;

FuncDeclaration: FUNC ID LPAR Parameters RPAR Type FuncBody  {;}
    | FUNC ID LPAR RPAR Type FuncBody             {;}
    | FUNC ID LPAR Parameter RPAR FuncBody        {;}
    | FUNC ID LPAR RPAR FuncBody                  {;}

Parameters: ID Type                               {;}
    | ID Type COMMA Parameter                     {;}
;

FuncBody: LBRACE VarsAndStatments RBRACE          {;}

VarsAndStatements: VarsAndStatements varsAndStatementsOpc SEMICOLON    {;}
    |                                             {;}

varsAndStatementsOpc: VarDeclaration              {;}
| Statement                                       {;}
|                                                 {;}

Statement: ID ASSIGN Expr                         {;}
    | LBRACE StatementSEMICOLON RBRACE            {;}
    | IF Expr LBRACE StatementSEMICOLON RBRACE ElseLBraceStatementRbraceOpc   {;}
    | FOR ExprOpc LBRACE StatementSEMICOLON RBRACE {;}
    | RETURN ExprOpc                              {;}
    | FuncInvocation                              {;}
    | ParseArgs                                   {;}
    | PRINT LPAR ExprSTRLITOpc RPAR               {;}
;

ExprSTRLITOpc: Expr         {;}
    | STRLIT                {;}
;

ExprOpc: Expr               {;}
|                           {;}
;

ElseLBraceStatementRbraceOpc: ELSE LBRACE StatementSEMICOLON RBRACE {;}
    |   {;}
;


StatementSEMICOLON: Statement SEMICOLON StatementSEMICOLON {;}
    |                                                      {;}
;

ParseArgs: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR  {;}
    ;

FuncInvocation: ID LPAR OpcExpr RPAR                                {;}
    ;

OpcExpr: Expr CommaExpr                                             {;}
    |                                                               {;}
    ;

CommaExpr: COMMA Expr CommaExpr                                     {;}
    |                                                               {;}
    ;

Expr: Expr (OR | AND) Expr                                          {;}
    |   Expr (LT | GT | EQ | NE | LE | GE) Expr                     {;}
    |   Expr (PLUS | MINUS | STAR | DIV | MOD) Expr                 {;}
    |   (NOT | MINUS | PLUS) Expr                                   {;}
    |   (INTLIT | REALLIT | ID | FuncInvocation | LPAR Expr RPAR)   {;}
    ;


%%

int main() {
    yyparse();
    return 0;
}

