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

calc: expression                        {printf("%d\n", $1);}

expression: expression '+' expression   {$$=$1+$3;}
    |   expression '-' expression       {$$=$1-$3;}
    |   expression '*' expression       {$$=$1*$3;}
    |   expression '/' expression       {if($3 ==0){printf("Divide by zero\n"); exit(1);} $$=$1/$3;}
    |   '-' expression                  {$$=-$2;}
    |   '+' expression                  {$$= $2;}
    |   NUMBER                          {$$=$1;}
    |   '(' expression ')'              {$$=$2;}
    ;
%%

int main() {
    yyparse();
    return 0;
}

