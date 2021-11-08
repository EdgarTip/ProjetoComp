%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex(void);
    void yyerror (const char *s);
%}

%token PACKAGE ID SEMICOLON VAR LPAR RPAR COMMA INT FLOAT32 BOOL STRING FUNC LBRACE RBRACE RETURN PRINT STRLIT ASSIGN  BLANKID  PARSEINT CMDARGS LSQ RSQ OR AND LT GT EQ  NE LE GE PLUS MINUS STAR DIV MOD NOT INTLIT REALLIT ELSE IF FOR


%left PLUS MINUS
%left STAR DIV MOD 
%right NOT
%right OR AND 
%right EQ GE GT LT LE NE






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
    | FUNC ID LPAR Parameters RPAR FuncBody        {;}
    | FUNC ID LPAR RPAR FuncBody                  {;}

Parameters: ID Type                               {;}
    | ID Type COMMA Parameters                     {;}
;

FuncBody: LBRACE VarsAndStatements RBRACE          {;}
;

VarsAndStatements: VarsAndStatements VarsAndStatementsOpc SEMICOLON    {;}
    |                                             {;}
    ;

VarsAndStatementsOpc: VarDeclaration              {;}
    | Statement                                       {;}
    |                                                 {;}
    ;

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

Expr: Expr OR Expr                                             {;}
    |   Expr AND Expr                                          {;}
    |   Expr LT Expr                                           {;}
    |   Expr GT Expr                                           {;}
    |   Expr EQ Expr                                           {;}
    |   Expr NE Expr                                           {;}
    |   Expr LE Expr                                           {;}
    |   Expr GE Expr                                           {;}
    |   Expr PLUS Expr                                         {;}
    |   Expr MINUS Expr                                        {;}
    |   Expr STAR Expr                                         {;}
    |   Expr DIV Expr                                          {;}
    |   Expr MOD Expr                                          {;}
    |   MINUS Expr                                             {;}
    |   PLUS  Expr                                             {;}
    |   NOT  Expr  
    |   INTLIT                                                 {;}
    |   REALLIT                                                {;}
    |   ID                                                     {;}
    |   FuncInvocation                                         {;}
    |   LPAR Expr RPAR                                         {;}
    ;




%%

int main() {
    yyparse();
    return 0;
}

