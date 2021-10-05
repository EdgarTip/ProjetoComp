id_characters                   [a-zA-Z0-9_]
letters                         [a-zA-Z] 
numbers                         [0-9]
numbers_Hexa                    [0-9ABCDEF]

%%



["+""-"]?[1-9]{numbers}+                   {printf("INTLIT\n");}
0[1-7][0-7]+                               {printf("INTLIT\n");}
0[xX][1-9ABCDEF]{numbers_Hexa}+            {printf("INTLIT\n");}     



";"                                        {printf("SEMICOLON\n");}
","                                        {printf("COMMA\n");}
"_"                                        {printf("BLANKID\n");}
"=="                                       {printf("EQ\n");}
">="                                       {printf("GQ\n");}
"="                                        {printf("ASSIGN\n");}
"*"                                        {printf("STAR\n");}
"/"                                        {printf("DIV\n");}
"-"                                        {printf("MINUS\n");}
"+"                                        {printf("PLUS\n");}
"&&"                                       {printf("AND\n");}
"||"                                       {printf("OR\n");}
"}"                                        {printf("RBRACE\n");}
")"                                        {printf("RPAR\n");}
"package"                                  {printf("PACKAGE\n");}
"return"                                   {printf("RETURN\n");}
"else"                                     {printf("ELSE\n");}
"for"                                      {printf("FOR\n");}
"if"                                       {printf("IF\n");}


[a-zA-Z]{id_characters}*                   {printf("ID(%s)\n", yytext);}

.                                          {;}
\n                                         {;}

%%

int main()
{
yylex();
return 0;
}

int yywrap()
{
return 1;
}