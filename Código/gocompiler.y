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

Program: PACKAGE ID SEMICOLON Declarations                          {printf("%d\n", $1);}
    ;

Declarations: VarDeclaration SEMICOLON Declarations                 {;}
    |   FuncDeclaration SEMICOLON Declarations                      {;}
    |                                                               {;}
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

