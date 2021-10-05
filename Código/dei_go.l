
%X  STRING COMMENT

id_characters                   [a-zA-Z0-9_]
letters                         [a-zA-Z] 
numbers                         [0-9]
numbers_Hexa                    [0-9ABCDEFabcdef]

%%

["+""-"]?[1-9]{numbers}+                    {printf("INTLIT\n");}
0[1-7][0-7]+                                {printf("INTLIT\n");}
0[xX][1-9ABCDEFabcdef]{numbers_Hexa}+       {printf("INTLIT\n");}    

{numbers}+"."{numbers}*[eE][+-]{numbers}+   {printf("REALLIT\n");}
{numbers}+"."{numbers}+                     {printf("REALLIT\n");}

\"                                          {BEGIN STRING;printf("STRLIT(");}
"/""/".*                                    {;}
"/""*"                                      {BEGIN COMMENT;}

<COMMENT>"*""/"                             {BEGIN 0;}
<COMMENT>EOF                                {;}     //TODO
<COMMENT>[.\n]                              {;}


"package"                                   {printf("PACKAGE\n");}
"return"                                    {printf("RETURN\n");}
"else"                                      {printf("ELSE\n");}
"for"                                       {printf("FOR\n");}
"if"                                        {printf("IF\n");}
"var"                                       {printf("VAR\n");}
"int"                                       {printf("INT\n");}
"float32"                                   {printf("FLOAT32\n");}
"bool"                                      {printf("BOOL\n");}
"string"                                    {printf("STRING\n");}
"fmt.Println"                               {printf("PRINT\n");}
"strconv.Atoi"                              {printf("PARSEINT\n");}
"func"                                      {printf("FUNC\n");}
"os.Args"                                   {printf("CMDARGS\n");}

"break"                                     {printf("BREAK\n");}
"default"                                   {printf("DEFAULT\n");}
"interface"                                 {printf("INTERFACE\n");}
"select"                                    {printf("SELECT\n");}
"case"                                      {printf("CASE\n");}
"defer"                                     {printf("DEFER\n");}
"go"                                        {printf("GO\n");}
"map"                                       {printf("MAP\n");}
"struct"                                    {printf("STRUCT\n");}
"chan"                                      {printf("CHAN\n");}
"goto"                                      {printf("GOTO\n");}
"switch"                                    {printf("SWITCH\n");}
"const"                                     {printf("CONST\n");}
"fallthrough"                               {printf("FALLTHROUGH\n");}
"range"                                     {printf("RANGE\n");}
"type"                                      {printf("TYPE\n");}
"continue"                                  {printf("CONTINUE\n");}
"import"                                    {printf("IMPORT\n");}


"=="                                        {printf("EQ\n");}
">="                                        {printf("GQ\n");}
"<="                                        {printf("LE\n");}
"!="                                        {printf("NE\n");}
"&&"                                        {printf("AND\n");}
"||"                                        {printf("OR\n");}

";"                                         {printf("SEMICOLON\n");}
","                                         {printf("COMMA\n");}
"_"                                         {printf("BLANKID\n");}
"="                                         {printf("ASSIGN\n");}
"*"                                         {printf("STAR\n");}
"/"                                         {printf("DIV\n");}
"-"                                         {printf("MINUS\n");}
"+"                                         {printf("PLUS\n");}
">"                                         {printf("GT\n");}
"{"                                         {printf("LBRACE\n");}
"("                                         {printf("LPAR\n");}
"["                                         {printf("LSQ\n");}
"<"                                         {printf("LT\n");}
"%"                                         {printf("MOD\n");}
"!"                                         {printf("NOT\n");}
"}"                                         {printf("RBRACE\n");}
")"                                         {printf("RPAR\n");}
"]"                                         {printf("RSQ\n");}

[a-zA-Z]{id_characters}*                    {printf("ID(%s)\n", yytext);}

.                                           {;}
\n                                          {;}

<STRING>"\""                                {BEGIN 0;printf(")\n");}
<STRING>\\f                                 {printf("\f");}
<STRING>\\n                                 {printf("\n");}
<STRING>\\r                                 {printf("\r");}
<STRING>\\t                                 {printf("\t");}
<STRING>\\                                  {printf("\\");}     
<STRING>\\\"                                {printf("\"");} 
<STRING>.                                   {ECHO;}         


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
