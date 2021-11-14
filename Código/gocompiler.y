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

VarDeclaration: VAR VarSpec                                         {$$= $2;}
    |   VAR LPAR VarSpec SEMICOLON RPAR                             {$$=  $3;}
    ;

VarSpec: ID CommaId Type                                            {$$= create_node(VARDEC, "VarDecl", 0, 0);
                                                                    addChild($$, $3);
                                                                    addChild($$, create_node(IDE, $1, 0,0)); 
                                                                    addChild($$, $2); }
    ;
   
CommaId: COMMA ID CommaId                                           {$$= create_node(IDE, $2, 0, 0); add_next($$, $3);}
    |                                                               {$$ = NULL;}
    ;
    
Type: INT                                                           {$$= create_node(INTE, "Int", 0,0);}
    |   FLOAT32                                                     {$$= create_node(FLOAT32E, "Float32", 0,0);}
    |   BOOL                                                        {$$= create_node(BOOL, "Bool", 0,0);}
    |   STRING                                                      {$$= create_node(STRINGE, "String", 0,0);}
    ;

FuncDeclaration: FUNC ID LPAR Parameters RPAR Type FuncBody  {$$= create_node(FUNCDECL, "FuncDecl", 0, 0); 
                                                             struct node_list *aux= create_node(FUNCHEADER, "FuncHeader",0,0); 
                                                             struct node_list *aux2= create_node(PARAMETERS, "FuncParams",0,0);
                                                             addChild(aux, create_node(IDE, $2, 0, 0)); 
                                                             addChild(aux, $6);
                                                             addChild(aux, aux2); 
                                                             addChild(aux2, $4); 
                                                             
                                                             addChild($$, aux); 
                                                             addChild($$, $7);}

    | FUNC ID LPAR RPAR Type FuncBody             {$$= create_node(FUNCDECL, "FuncDecl", 0, 0); 
                                                         
                                                        struct node_list *aux= create_node(FUNCHEADER, "FuncHeader",0,0); 
                                                        struct node_list *aux2= create_node(PARAMETERS, "FuncParams",0,0);
                                                        addChild(aux, create_node(IDE, $2, 0, 0)); 
                                                        addChild(aux, $5);
                                                        addChild(aux,aux2);
                                                        addChild($$, aux); 
                                                        addChild($$, $6);}
                                                        
    | FUNC ID LPAR Parameters RPAR FuncBody        {$$= create_node(FUNCDECL, "FuncDecl", 0, 0);
                                                        struct node_list *aux= create_node(FUNCHEADER, "FuncHeader",0,0);
                                                        struct node_list *aux2= create_node(PARAMETERS, "FuncParams",0,0);  
                                                        addChild(aux, create_node(IDE, $2, 0, 0)); 
                                                        addChild(aux, aux2);
                                                        addChild(aux2, $4);
                                                        addChild($$, aux);
                                                        addChild($$, $6); 
                                                       }

    | FUNC ID LPAR RPAR FuncBody                  {$$= create_node(FUNCDECL, "FuncDecl", 0, 0);
                                                        struct node_list *aux= create_node(FUNCHEADER, "FuncHeader",0,0); 
                                                        addChild(aux, create_node(IDE, $2, 0, 0));
                                                        addChild(aux, create_node(PARAMETERS, "FuncParams", 0, 0)); 
                                                        addChild($$, aux);
                                                        addChild($$, $5);}

Parameters: ID Type                               {$$= create_node(PARAMDECL, "ParamDecl",0,0);
                                                    addChild($$, $2);
                                                    addChild($$, create_node(IDE, $1, 0, 0)); 
                                                    }
    | ID Type COMMA Parameters                     {$$= create_node(PARAMDECL, "ParamDecl",0,0);
                                                    addChild($$, $2);
                                                    addChild($$,create_node(IDE, $1, 0, 0));    
                                                    add_next($$,$4);}
;

FuncBody: LBRACE VarsAndStatements RBRACE          {$$= create_node(FUNCBODY, "FuncBody", 0, 0); addChild($$, $2);}
;

VarsAndStatements: VarsAndStatements VarsAndStatementsOpc SEMICOLON    {if($1 != NULL && $2 != NULL) add_max_next($1, $2);
 if($1 == NULL) $$ = $2; else $$ = $1; }
    |                                             {$$=NULL;}
    ;

VarsAndStatementsOpc: VarDeclaration              {printTree($1,0); $$= $1;}
    | Statement                                       {printTree($1,0);$$= $1;}
    |                                                 {$$ = NULL;}
    ;

Statement: ID ASSIGN Expr                         {$$= create_node(ASSIGN, "Assign", 0,0); 
                                                        addChild($$,create_node(IDE, $1,0,0)); 
                                                        addChild($$,$3);}
    | LBRACE StatementSEMICOLON RBRACE            {$$= $2;}
    | IF Expr LBRACE StatementSEMICOLON RBRACE ElseLBraceStatementRbraceOpc   {$$= create_node(IFE, "If", 0,0); addChild($$,$2); addChild($$,$4); addChild($$,$6); }
    | FOR ExprOpc LBRACE StatementSEMICOLON RBRACE {$$= create_node(STATEMENT, "Statement", 0,0); addChild($$,$2); addChild($$,$4);}
    | RETURN                                       {$$= create_node(RETURNE, "Return", 0,0);}
    | RETURN Expr                                  {$$= create_node(RETURNE, "Return", 0,0); addChild($$,$2);}
    | FuncInvocation                              {$$= create_node(STATEMENT, "Statement", 0,0); addChild($$,$1);}
    | ParseArgs                                   {;$$= $1;}
    | PRINT LPAR ExprSTRLITOpc RPAR               {$$= create_node(PRINTE, "Print", 0,0); addChild($$,$3);}
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


StatementSEMICOLON: Statement SEMICOLON StatementSEMICOLON {$$=$1; add_next($$,$3);}
    |                                                      {$$=NULL;}
;

ParseArgs: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR  {$$= create_node(PARSEARGS, "ParseArgs", 0,0); 
                                                                            addChild($$,create_node(IDE, $1,0,0)); 
                                                                            addChild($$,$9);}
    ;

FuncInvocation: ID LPAR OpcExpr RPAR                                {$$=  create_node(IDE, $1, 0, 0); add_next($$,$3);}
    ;

OpcExpr: Expr CommaExpr                                             {$$= $1; add_next($$,$2);}
    |                                                               {$$=NULL;}
    ;

CommaExpr: COMMA Expr CommaExpr                                     {$$= $2; add_next($$,$3);}
    |                                                               {$$=NULL;}
    ;

Expr: Expr OR Expr                                             {$$= create_node(OPERATOR, "Or", 0,0); addChild($$,$1); addChild($$,$3); }
    |   Expr AND Expr                                          {$$= create_node(OPERATOR, "And", 0,0); addChild($$,$1); addChild($$,$3); }
    |   Expr LT Expr                                           {$$= create_node(OPERATOR, "Lt", 0,0); addChild($$,$1); addChild($$,$3); }
    |   Expr GT Expr                                           {$$= create_node(OPERATOR, "Gt", 0,0); addChild($$,$1); addChild($$,$3); }
    |   Expr EQ Expr                                           {$$= create_node(OPERATOR, "Eq", 0,0); addChild($$,$1); addChild($$,$3); }
    |   Expr NE Expr                                           {$$= create_node(OPERATOR, "Ne", 0,0); addChild($$,$1); addChild($$,$3);}
    |   Expr LE Expr                                           {$$= create_node(OPERATOR, "Le", 0,0); addChild($$,$1); addChild($$,$3);}
    |   Expr GE Expr                                           {$$= create_node(OPERATOR, "Ge", 0,0); addChild($$,$1); addChild($$,$3);}
    |   Expr PLUS Expr                                         {$$= create_node(OPERATOR, "Plus", 0,0); addChild($$,$1); addChild($$,$3);}
    |   Expr MINUS Expr                                        {$$= create_node(OPERATOR, "Sub", 0,0); addChild($$,$1); addChild($$,$3);}
    |   Expr STAR Expr                                         {$$= create_node(OPERATOR, "Mul", 0,0); addChild($$,$1); addChild($$,$3);}
    |   Expr DIV Expr                                          {$$= create_node(OPERATOR, "Div", 0,0); addChild($$,$1); addChild($$,$3); }
    |   Expr MOD Expr                                          {$$= create_node(OPERATOR, "Mod", 0,0); addChild($$,$1); addChild($$,$3); }
    |   MINUS Expr                                             {$$= create_node(OPERATOR, "Sub", 0,0); addChild($$,$2);}
    |   PLUS  Expr                                             {$$= create_node(OPERATOR, "Plus", 0,0); addChild($$,$2); }
    |   NOT  Expr                                              {$$= create_node(OPERATOR, "Not", 0,0); addChild($$,$2); }
    |   INTLIT                                                 {$$ = create_node(INTLITE,$1,0,0);}
    |   REALLIT                                                {$$ = create_node(REALLITE,$1,0,0);}
    |   ID                                                     {$$ = create_node(IDE,$1,0,0);}
    |   FuncInvocation                                         {$$= create_node(CALL, "Call", 0,0); addChild($$,$1);}
    |   LPAR Expr RPAR                                         {$$ = $2;}
    ;




%%


