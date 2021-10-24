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

Declarations: VarDeclaration SEMICOLON        {;}
    |   FuncDeclaration SEMICOLON             {;}
    |   Declarations Declarations             {;}
    |                                         {;}

VarDeclaration: VarDeclaration Declarations SEMICOLON

%%

int main() {
    yyparse();
    return 0;
}

