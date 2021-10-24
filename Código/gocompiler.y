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
    |                                         {;}
    ;

VarDeclaration: VarDeclaration Declarations SEMICOLON
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



%%

int main() {
    yyparse();
    return 0;
}

