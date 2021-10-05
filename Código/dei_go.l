
%X  STRING

id_characters                   [a-zA-Z0-9_]
letters                         [a-zA-Z] 
numbers                         [0-9]
numbers_Hexa                    [0-9ABCDEF]

%%

["+""-"]?[1-9]{numbers}+                   {printf("INTLIT\n");}
0[1-7][0-7]+                               {printf("INTLIT\n");}
0[xX][1-9ABCDEF]{numbers_Hexa}+            {printf("INTLIT\n");}    

\"                                         {BEGIN STRING;printf("STRLIT(");}

"package"                                  {printf("PACKAGE\n");}
"return"                                   {printf("RETURN\n");}
"else"                                     {printf("ELSE\n");}
"for"                                      {printf("FOR\n");}
"if"                                       {printf("IF\n");}

"<="                                       {printf("LE\n");}
"!="                                       {printf("NE\n");}
"&&"                                       {printf("AND\n");}
"||"                                       {printf("OR\n");}
"=="                                       {printf("EQ\n");}
">="                                       {printf("GQ\n");}

">"                                        {printf("GT\n");}
"{"                                        {printf("LBRACE\n");}
"("                                        {printf("LPAR\n");}
"["                                        {printf("LSQ\n");}
"<"                                        {printf("LT\n");}
"%"                                        {printf("MOD\n");}
"!"                                        {printf("NOT\n");}
";"                                        {printf("SEMICOLON\n");}
","                                        {printf("COMMA\n");}
"_"                                        {printf("BLANKID\n");}
"="                                        {printf("ASSIGN\n");}
"*"                                        {printf("STAR\n");}
"/"                                        {printf("DIV\n");}
"-"                                        {printf("MINUS\n");}
"+"                                        {printf("PLUS\n");}
"}"                                        {printf("RBRACE\n");}
")"                                        {printf("RPAR\n");}

[a-zA-Z]{id_characters}*                   {printf("ID(%s)\n", yytext);}

.                                          {;}
\n                                         {;}

<STRING>"\""                {BEGIN 0;printf(")\n");}
<STRING>\\f                 {printf("\f");}
<STRING>\\n                 {printf("\n");}
<STRING>\\r                 {printf("\r");}
<STRING>\\t                 {printf("\t");}
<STRING>\\                  {printf("\\");}     
<STRING>\\\"                {printf("\"");} 
<STRING>.                   {ECHO;}         


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
