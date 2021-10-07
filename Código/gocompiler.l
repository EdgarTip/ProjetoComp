  //Edgar Duarte 2019216077 Rodrigo Ferreira 2019220060
%X  STRING COMMENT 
%{
    int num_line = 1;
    int num_column = 1;  
    int check = 0;
    int last = 0;
%}


id_characters                   [a-zA-Z0-9_]
letters                         [a-zA-Z] 
numbers                         [0-9]
numbers_Hexa                    [0-9ABCDEFabcdef]
illegal_octals                  [89a-zA-Z]
legal_after                     [^" "\n\r"=="">=""<=""!=""&&""||"";"",""_""=""*""/""-""+"">""{""(""[""<""%""!""}"")""\]""\t"]*


%%

[1-9]{numbers}*                             {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
0[0-7]*                                     {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
0[xX]{numbers_Hexa}*                        {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1;}    

0[0-7{illegal_octals}]*                    { printf("Line %d, column %d: invalid octal constant (%s)\n", num_line, num_column, yytext);num_column += yyleng;}


{numbers}+"."{numbers}*[eE][+-]{numbers}+   {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
{numbers}+"."{numbers}+                     {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1;}

\"                                          {BEGIN STRING;if(check) printf("STRLIT("); num_column += yyleng;}
"/""/".*                                    {num_column += yyleng; last = 0;}
"/""*"                                      {BEGIN COMMENT; num_column += yyleng; last = 0;}

"package"                                   {if(check) printf("PACKAGE\n"); num_column += yyleng; last = 0;}
"return"                                    {if(check) printf("RETURN\n"); num_column += yyleng; last = 1;}
"else"                                      {if(check) printf("ELSE\n"); num_column += yyleng; last = 0;}
"for"                                       {if(check) printf("FOR\n"); num_column += yyleng; last = 0;}
"if"                                        {if(check) printf("IF\n"); num_column += yyleng; last = 0;}
"var"                                       {if(check) printf("VAR\n"); num_column += yyleng; last = 0;}
"int"                                       {if(check) printf("INT\n"); num_column += yyleng; last = 0;}
"float32"                                   {if(check) printf("FLOAT32\n"); num_column += yyleng; last = 0;}
"bool"                                      {if(check) printf("BOOL\n"); num_column += yyleng; last = 0;}
"string"                                    {if(check) printf("STRING\n"); num_column += yyleng; last = 0;}
"fmt.Println"                               {if(check) printf("PRINT\n"); num_column += yyleng; last = 0;}
"strconv.Atoi"                              {if(check) printf("PARSEINT\n"); num_column += yyleng; last = 0;}
"func"                                      {if(check) printf("FUNC\n"); num_column += yyleng; last = 0;}
"os.Args"                                   {if(check) printf("CMDARGS\n"); num_column += yyleng; last = 0;}

"break"                                     {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"default"                                   {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"interface"                                 {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"select"                                    {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"case"                                      {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"defer"                                     {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"go"                                        {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"map"                                       {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"struct"                                    {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"chan"                                      {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"goto"                                      {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"switch"                                    {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"const"                                     {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"fallthrough"                               {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"range"                                     {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"type"                                      {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"continue"                                  {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"import"                                    {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"++"                                        {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}
"--"                                        {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}

"=="                                        {if(check) printf("EQ\n"); num_column+=2; last = 0;}
">="                                        {if(check) printf("GQ\n"); num_column+=2; last = 0;}
"<="                                        {if(check) printf("LE\n"); num_column+=2; last = 0;}
"!="                                        {if(check) printf("NE\n"); num_column+=2; last = 0;}
"&&"                                        {if(check) printf("AND\n"); num_column+=2; last = 0;}
"||"                                        {if(check) printf("OR\n"); num_column+=2; last = 0;}

";"                                         {if(check) printf("SEMICOLON\n"); num_column++; last = 0;}
","                                         {if(check) printf("COMMA\n"); num_column++; last = 0;}
"_"                                         {if(check) printf("BLANKID\n"); num_column++; last = 0;}
"="                                         {if(check) printf("ASSIGN\n"); num_column++; last = 0;}
"*"                                         {if(check) printf("STAR\n"); num_column++; last = 0;}
"/"                                         {if(check) printf("DIV\n"); num_column++; last = 0;}
"-"                                         {if(check) printf("MINUS\n"); num_column++; last = 0;}
"+"                                         {if(check) printf("PLUS\n"); num_column++; last = 0;}
">"                                         {if(check) printf("GT\n"); num_column++; last = 0;}
"{"                                         {if(check) printf("LBRACE\n"); num_column++; last = 0;}
"("                                         {if(check) printf("LPAR\n"); num_column++; last = 0;}
"["                                         {if(check) printf("LSQ\n"); num_column++; last = 0;}
"<"                                         {if(check) printf("LT\n"); num_column++; last = 0;}
"%"                                         {if(check) printf("MOD\n"); num_column++; last = 0;}
"!"                                         {if(check) printf("NOT\n"); num_column++; last = 0;}
"}"                                         {if(check) printf("RBRACE\n"); num_column++; last = 1;}
")"                                         {if(check) printf("RPAR\n"); num_column++; last = 1;}
"]"                                         {if(check) printf("RSQ\n"); num_column++; last = 1;}

[a-zA-Z]{id_characters}*                    {if(check) printf("ID(%s)\n", yytext); num_column += yyleng; last = 1;}

<<EOF>>                                     {return 0;}
" "                                         {num_column++;}
\t                                          {;}
\r                                          {;}
{legal_after}                                 {printf("Line %d, column %d: illegal character (%s)\n", num_line, num_column, yytext); num_column += yyleng; last = 0;}
\n                                          {num_line++; num_column = 1; if(last){ if(check) printf("SEMICOLON\n");} last = 0;}


<STRING>"\""                                {BEGIN 0; if(check) printf(")\n"); num_column += yyleng; last = 1;}
<STRING>\\f                                 {if(check) printf("\f"); num_column += yyleng;}
<STRING>\\n                                 {if(check) printf("\n"); num_column += yyleng;}
<STRING>\\r                                 {if(check) printf("\r"); num_column += yyleng;}
<STRING>\\t                                 {if(check) printf("\t"); num_column += yyleng;}
<STRING>\\                                  {if(check) printf("\\"); num_column += yyleng;}     
<STRING>\\\"                                {if(check) printf("\""); num_column += yyleng;} 
<STRING>\\[^fnrt]                           {num_column += yyleng++; printf("Line %d, column %d: invalid escape sequence (\\%c)\n", num_line, num_column, yytext[1]); last = 0;}
<STRING>.                                   {if(check) ECHO; num_column += yyleng;}
<STRING>\n                                  {printf("Line %d, column %d: unterminated string literal\n", num_line, num_column); num_line++; num_column = 1; last = 0; BEGIN 0;}         

 

<COMMENT>"*""/"                             {BEGIN 0;}
<COMMENT>EOF                                {;}     //TODO
<COMMENT>.                                  {num_column++;}
<COMMENT>\n                                 {num_line++; num_column = 1;}

%%

int main(int argc, char* argv[])
{
    if(argc == 2){
        if(strcmp(argv[1], "-l") == 0){
            check = 1;
        }
    }
yylex();
return 0;
}

int yywrap()
{
return 1;
}
