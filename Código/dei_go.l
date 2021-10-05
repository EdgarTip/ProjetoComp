id_characters                   [a-zA-Z0-9_]
letters                         [a-zA-Z] 
%%



[a-zA-Z]{id_characters}*                   {printf("ID(%s)\n", yytext);}
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