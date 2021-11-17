%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "tree.h"
    int yylex(void);
    void yyerror (const char *s);
    char error = 0;
    extern int check2;

    extern int num_line;
    extern int num_column;
    
    int error_num_line = 0;
    int error_num_column = 0;

%}

%token PACKAGE SEMICOLON VAR LPAR RPAR COMMA INT FLOAT32 BOOL STRING FUNC LBRACE RBRACE RETURN PRINT ASSIGN  BLANKID  PARSEINT CMDARGS LSQ RSQ OR AND LT GT EQ  NE LE GE PLUS MINUS STAR DIV MOD NOT   ELSE IF FOR END PLUSPLUS MINUSMINUS

%token<letters>ID REALLIT INTLIT STRLIT

%left COMMA
%left ASSIGN
%left OR 
%left AND 
%left EQ GE GT LT LE NE
%left PLUS MINUS
%left STAR DIV MOD 
%right NOT

%nonassoc UNARY
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


Program: PACKAGE ID SEMICOLON Declarations END    {$$= create_node(PROGRAM, "Program", num_line, num_column); addChild($$,$4); if (!error) printTree($$,0); freeTree($$);}
;


Declarations: VarDeclaration SEMICOLON Declarations       {$$= $1; add_max_next($$,$3); }
    |   FuncDeclaration SEMICOLON Declarations            {$$= $1; add_max_next($$,$3);}
    |  /*empty*/                                                   {$$=NULL;}
    ;

VarDeclaration: VAR VarSpec                                         {$$= $2;}
    |   VAR LPAR VarSpec SEMICOLON RPAR                             {$$=  $3;}
    ;

VarSpec: ID CommaId Type                                            {$$= create_node(VARDEC, "VarDecl", num_line, num_column);
                                                                    add_next($$, $2);
                                                                    addChild($$, create_node(IDE, $1, num_line, num_column)); 
                                                                    add_child_to_all($$, $3);
                                                                    
                                                                    
                                                                    
                                                                   
                                                                     }
    ;
   
CommaId: COMMA ID CommaId                                           {$$= create_node(VARDEC, "VarDecl", num_line, num_column);
                                                                    addChild($$,create_node(IDE, $2, num_line, num_column));
                                                                    add_next($$, $3);}
    |                                                               {$$ = NULL;}
    ;
    
Type: INT                                                           {$$= create_node(INTE, "Int", num_line, num_column);}
    |   FLOAT32                                                     {$$= create_node(FLOAT32E, "Float32", num_line, num_column);}
    |   BOOL                                                        {$$= create_node(BOOL, "Bool", num_line, num_column);}
    |   STRING                                                      {$$= create_node(STRINGE, "String", num_line, num_column);}
    ;

FuncDeclaration: FUNC ID LPAR Parameters RPAR Type FuncBody  {$$= create_node(FUNCDECL, "FuncDecl", num_line, num_column); 
                                                             struct node_list *aux= create_node(FUNCHEADER, "FuncHeader", num_line, num_column); 
                                                             struct node_list *aux2= create_node(PARAMETERS, "FuncParams", num_line, num_column);
                                                             addChild(aux, create_node(IDE, $2, num_line, num_column)); 
                                                             addChild(aux, $6);
                                                             addChild(aux, aux2); 
                                                             addChild(aux2, $4); 
                                                             
                                                             addChild($$, aux); 
                                                             addChild($$, $7);}

    | FUNC ID LPAR RPAR Type FuncBody             {$$= create_node(FUNCDECL, "FuncDecl", num_line, num_column); 
                                                         
                                                        struct node_list *aux= create_node(FUNCHEADER, "FuncHeader", num_line, num_column); 
                                                        struct node_list *aux2= create_node(PARAMETERS, "FuncParams", num_line, num_column);
                                                        addChild(aux, create_node(IDE, $2, num_line, num_column)); 
                                                        addChild(aux, $5);
                                                        addChild(aux,aux2);
                                                        addChild($$, aux); 
                                                        addChild($$, $6);}
                                                        
    | FUNC ID LPAR Parameters RPAR FuncBody        {$$= create_node(FUNCDECL, "FuncDecl", num_line, num_column);
                                                        struct node_list *aux= create_node(FUNCHEADER, "FuncHeader", num_line, num_column);
                                                        struct node_list *aux2= create_node(PARAMETERS, "FuncParams", num_line, num_column);  
                                                        addChild(aux, create_node(IDE, $2, num_line, num_column)); 
                                                        addChild(aux, aux2);
                                                        addChild(aux2, $4);
                                                        addChild($$, aux);
                                                        addChild($$, $6); 
                                                       }

    | FUNC ID LPAR RPAR FuncBody                  {$$= create_node(FUNCDECL, "FuncDecl", num_line, num_column);
                                                        struct node_list *aux= create_node(FUNCHEADER, "FuncHeader", num_line, num_column); 
                                                        addChild(aux, create_node(IDE, $2, num_line, num_column));
                                                        addChild(aux, create_node(PARAMETERS, "FuncParams", num_line, num_column)); 
                                                        addChild($$, aux);
                                                        addChild($$, $5);}

Parameters: ID Type                               {$$= create_node(PARAMDECL, "ParamDecl", num_line, num_column);
                                                    addChild($$, $2);
                                                    addChild($$, create_node(IDE, $1, num_line, num_column)); 
                                                    }
    | ID Type COMMA Parameters                     {$$= create_node(PARAMDECL, "ParamDecl", num_line, num_column);
                                                    addChild($$, $2);
                                                    addChild($$,create_node(IDE, $1, num_line, num_column));    
                                                    add_next($$,$4);}
;

FuncBody: LBRACE VarsAndStatements RBRACE          {$$= create_node(FUNCBODY, "FuncBody", num_line, num_column); addChild($$, $2);}
;

VarsAndStatements: VarsAndStatements VarsAndStatementsOpc SEMICOLON    {if($1 != NULL && $2 != NULL) add_max_next($1, $2);
 if($1 == NULL) $$ = $2; else $$ = $1;}
    |                                             {$$=NULL;}
    ;

VarsAndStatementsOpc: VarDeclaration              {$$= $1;}
    | Statement                                   {$$= $1;  }
    |  /*empty*/                                               {$$ = NULL;}
    ;

Statement: ID ASSIGN Expr                         {$$= create_node(ASSIGN, "Assign", num_line, num_column); 
                                                        addChild($$,create_node(IDE, $1, num_line, num_column)); 
                                                        addChild($$,$3);
                                                        
                                                        }
    | LBRACE StatementSEMICOLON RBRACE            {if(number_of_children($2) > 1){ 
                                                    $$= create_node(BLOCK, "Block", num_line, num_column);
                                                    addChild($$,$2);
                                                    } else{$$= $2;}}
    | IF Expr LBRACE StatementSEMICOLON RBRACE ElseLBraceStatementRbraceOpc   {$$= create_node(IFE, "If", num_line, num_column); 
                                                                                struct node_list *aux= create_node(BLOCK, "Block", num_line, num_column);
                                                                                struct node_list *aux2= create_node(BLOCK, "Block", num_line, num_column);
                                                                                addChild($$,$2); 
                                                                                addChild(aux,$4); 
                                                                                addChild($$,aux);
                                                                                addChild(aux2,$6);
                                                                                addChild($$,aux2);
                                                                                }
    | FOR ExprOpc LBRACE StatementSEMICOLON RBRACE {$$= create_node(FORE, "For", num_line, num_column); 
                                                    struct node_list *aux= create_node(BLOCK, "Block", num_line, num_column);
                                                    addChild($$,$2); 
                                                    addChild(aux, $4);
                                                    addChild($$,aux);}
    | RETURN                                       {$$= create_node(RETURNE, "Return", num_line, num_column);}
    | RETURN Expr                                  {$$= create_node(RETURNE, "Return", num_line, num_column); addChild($$,$2);}
    | FuncInvocation                              {$$= create_node(CALL, "Call", num_line, num_column); addChild($$,$1);}
    | ParseArgs                                   {$$= $1;}
    | PRINT LPAR ExprSTRLITOpc RPAR               {$$= create_node(PRINTE, "Print", num_line, num_column); addChild($$,$3);}
    | error                                       {$$=NULL; /*printf("here1 %d__%d\n", num_line, num_column);*/ error = 1;}
;

ExprSTRLITOpc: Expr         {$$= $1;}
    | STRLIT                {$$= create_node(STRLITE, $1, num_line, num_column);}
;

ExprOpc: Expr               {$$=$1;}
|                           {$$=NULL;}
;

ElseLBraceStatementRbraceOpc: ELSE LBRACE StatementSEMICOLON RBRACE {$$ = $3;}
    |   {$$=NULL;}
;


StatementSEMICOLON: Statement SEMICOLON StatementSEMICOLON {if($1 != NULL){$$=$1; add_next($$,$3);}else $$ = $3;}
    |                                                      {$$=NULL;}
;

ParseArgs: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR  {$$= create_node(PARSEARGS, "ParseArgs", num_line, num_column); 
                                                                            addChild($$,create_node(IDE, $1, num_line, num_column)); 
                                                                            addChild($$,$9);}
    |   ID COMMA BLANKID ASSIGN PARSEINT LPAR error RPAR  {$$=NULL; /*printf("here2\n");*/ error = 1;}
    ;

FuncInvocation: ID LPAR OpcExpr RPAR                                {$$=  create_node(IDE, $1, num_line, num_column); add_next($$,$3);}
    |   ID LPAR error RPAR                                          {$$=NULL; /*printf("here3\n");*/ error = 1;}
    ;

OpcExpr: Expr CommaExpr                                             {$$= $1; add_next($$,$2);}
    |                                                               {$$=NULL;}
    ;

CommaExpr: COMMA Expr CommaExpr                                     {$$= $2; add_next($$,$3);}
    |                                                               {$$=NULL;}
    ;

Expr: Expr OR Expr                                             {$$= create_node(OPERATOR, "Or", num_line, num_column); addChild($$,$1); addChild($$,$3); }
    |   Expr AND Expr                                          {$$= create_node(OPERATOR, "And", num_line, num_column); addChild($$,$1); addChild($$,$3); }
    |   Expr LT Expr                                           {$$= create_node(OPERATOR, "Lt", num_line, num_column); addChild($$,$1); addChild($$,$3); }
    |   Expr GT Expr                                           {$$= create_node(OPERATOR, "Gt", num_line, num_column); addChild($$,$1); addChild($$,$3); }
    |   Expr EQ Expr                                           {$$= create_node(OPERATOR, "Eq", num_line, num_column); addChild($$,$1); addChild($$,$3); }
    |   Expr NE Expr                                           {$$= create_node(OPERATOR, "Ne", num_line, num_column); addChild($$,$1); addChild($$,$3);}
    |   Expr LE Expr                                           {$$= create_node(OPERATOR, "Le", num_line, num_column); addChild($$,$1); addChild($$,$3);}
    |   Expr GE Expr                                           {$$= create_node(OPERATOR, "Ge", num_line, num_column); addChild($$,$1); addChild($$,$3);}
    |   Expr PLUS Expr                                         {$$= create_node(OPERATOR, "Add", num_line, num_column); addChild($$,$1); addChild($$,$3);}
    |   Expr MINUS Expr                                        {$$= create_node(OPERATOR, "Sub", num_line, num_column); addChild($$,$1); addChild($$,$3);}
    |   Expr STAR Expr                                         {$$= create_node(OPERATOR, "Mul", num_line, num_column); addChild($$,$1); addChild($$,$3);}
    |   Expr DIV Expr                                          {$$= create_node(OPERATOR, "Div", num_line, num_column); addChild($$,$1); addChild($$,$3); }
    |   Expr MOD Expr                                          {$$= create_node(OPERATOR, "Mod", num_line, num_column); addChild($$,$1); addChild($$,$3); }
    |   MINUS Expr  %prec UNARY                                {$$= create_node(OPERATOR, "Minus", num_line, num_column); addChild($$,$2);}
    |   PLUS  Expr  %prec UNARY                                {$$= create_node(OPERATOR, "Plus", num_line, num_column); addChild($$,$2); }
    |   NOT  Expr                                              {$$= create_node(OPERATOR, "Not", num_line, num_column); addChild($$,$2); }
    |   INTLIT                                                 {$$ = create_node(INTLITE,$1, num_line, num_column);}
    |   REALLIT                                                {$$ = create_node(REALLITE,$1, num_line, num_column);}
    |   ID                                                     {$$ = create_node(IDE,$1, num_line, num_column);}
    |   FuncInvocation                                         {$$= create_node(CALL, "Call", num_line, num_column); addChild($$,$1);}
    |   LPAR Expr RPAR                                         {/*printf("here133 %d__%d\n", num_line, num_column);*/$$ = $2;}
    |   LPAR error RPAR                                        {$$=NULL; /*printf("here4\n"); printf("%d__%d\n", num_line, num_column);*/ error = 1;}
    ;




%%


