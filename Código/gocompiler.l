  //Edgar Duarte 2019216077 Rodrigo Ferreira 2019220060
%X  STRING OCTAL_ERROR OCTAL_ERROR2 COMMENT ERRORS 
%{
    int num_line = 1;
    int num_column = 1;  
    int check = 0;
%}


id_characters                   [a-zA-Z0-9_]
letters                         [a-zA-Z] 
numbers                         [0-9]
numbers_Hexa                    [0-9ABCDEFabcdef]
illegal_octals                  [89a-zA-Z]

%%

[1-9]{numbers}*                             {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng;}
0[0-7]*                                     {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng;}
0[xX]{numbers_Hexa}*                        {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng;}    

0[0-7]*{illegal_octals}                     {num_column += yyleng; printf("Line %d, column %d: invalid octal constant (%c)\n", num_line, num_column, yytext[yyleng-1]); BEGIN OCTAL_ERROR; }

{numbers}+"."{numbers}*[eE][+-]{numbers}+   {if(check) printf("REALLIT\n"); num_column += yyleng;}
{numbers}+"."{numbers}+                     {if(check) printf("REALLIT\n"); num_column += yyleng;}

\"                                          {BEGIN STRING;if(check) printf("STRLIT("); num_column += yyleng;}
"/""/".*                                    {num_column += yyleng;}
"/""*"                                      {BEGIN COMMENT; num_column += yyleng;}

"package"                                   {if(check) printf("PACKAGE\n"); num_column += yyleng;}
"return"                                    {if(check) printf("RETURN\n"); num_column += yyleng;}
"else"                                      {if(check) printf("ELSE\n"); num_column += yyleng;}
"for"                                       {if(check) printf("FOR\n"); num_column += yyleng;}
"if"                                        {if(check) printf("IF\n"); num_column += yyleng;}
"var"                                       {if(check) printf("VAR\n"); num_column += yyleng;}
"int"                                       {if(check) printf("INT\n"); num_column += yyleng;}
"float32"                                   {if(check) printf("FLOAT32\n"); num_column += yyleng;}
"bool"                                      {if(check) printf("BOOL\n"); num_column += yyleng;}
"string"                                    {if(check) printf("STRING\n"); num_column += yyleng;}
"fmt.Println"                               {if(check) printf("PRINT\n"); num_column += yyleng;}
"strconv.Atoi"                              {if(check) printf("PARSEINT\n"); num_column += yyleng;}
"func"                                      {if(check) printf("FUNC\n"); num_column += yyleng;}
"os.Args"                                   {if(check) printf("CMDARGS\n"); num_column += yyleng;}

"break"                                     {if(check) printf("RESERVED\n"); num_column += yyleng;}
"default"                                   {if(check) printf("RESERVED\n"); num_column += yyleng;}
"interface"                                 {if(check) printf("RESERVED\n"); num_column += yyleng;}
"select"                                    {if(check) printf("RESERVED\n"); num_column += yyleng;}
"case"                                      {if(check) printf("RESERVED\n"); num_column += yyleng;}
"defer"                                     {if(check) printf("RESERVED\n"); num_column += yyleng;}
"go"                                        {if(check) printf("RESERVED\n"); num_column += yyleng;}
"map"                                       {if(check) printf("RESERVED\n"); num_column += yyleng;}
"struct"                                    {if(check) printf("RESERVED\n"); num_column += yyleng;}
"chan"                                      {if(check) printf("RESERVED\n"); num_column += yyleng;}
"goto"                                      {if(check) printf("RESERVED\n"); num_column += yyleng;}
"switch"                                    {if(check) printf("RESERVED\n"); num_column += yyleng;}
"const"                                     {if(check) printf("RESERVED\n"); num_column += yyleng;}
"fallthrough"                               {if(check) printf("RESERVED\n"); num_column += yyleng;}
"range"                                     {if(check) printf("RESERVED\n"); num_column += yyleng;}
"type"                                      {if(check) printf("RESERVED\n"); num_column += yyleng;}
"continue"                                  {if(check) printf("RESERVED\n"); num_column += yyleng;}
"import"                                    {if(check) printf("RESERVED\n"); num_column += yyleng;}

"=="                                        {if(check) printf("EQ\n"); num_column+=2;}
">="                                        {if(check) printf("GQ\n"); num_column+=2;}
"<="                                        {if(check) printf("LE\n"); num_column+=2;}
"!="                                        {if(check) printf("NE\n"); num_column+=2;}
"&&"                                        {if(check) printf("AND\n"); num_column+=2;}
"||"                                        {if(check) printf("OR\n"); num_column+=2;}

";"                                         {if(check) printf("SEMICOLON\n"); num_column++;}
","                                         {if(check) printf("COMMA\n"); num_column++;}
"_"                                         {if(check) printf("BLANKID\n"); num_column++;}
"="                                         {if(check) printf("ASSIGN\n"); num_column++;}
"*"                                         {if(check) printf("STAR\n"); num_column++;}
"/"                                         {if(check) printf("DIV\n"); num_column++;}
"-"                                         {if(check) printf("MINUS\n"); num_column++;}
"+"                                         {if(check) printf("PLUS\n"); num_column++;}
">"                                         {if(check) printf("GT\n"); num_column++;}
"{"                                         {if(check) printf("LBRACE\n"); num_column++;}
"("                                         {if(check) printf("LPAR\n"); num_column++;}
"["                                         {if(check) printf("LSQ\n"); num_column++;}
"<"                                         {if(check) printf("LT\n"); num_column++;}
"%"                                         {if(check) printf("MOD\n"); num_column++;}
"!"                                         {if(check) printf("NOT\n"); num_column++;}
"}"                                         {if(check) printf("RBRACE\n"); num_column++;}
")"                                         {if(check) printf("RPAR\n"); num_column++;}
"]"                                         {if(check) printf("RSQ\n"); num_column++;}

[a-zA-Z]{id_characters}*                    {if(check) printf("ID(%s)\n", yytext); num_column += yyleng;}

<<EOF>>                                     {return 0;}
" "                                         {num_column++;}
\r                                          {;}
.                                           {printf("Line %d, column %d: illegal character (%c)\n", num_line, num_column, yytext[0]); num_column++;}
\n                                          {num_line++; num_column = 1;}


<STRING>"\""                                {BEGIN 0;if(check) printf(")\n"); num_column += yyleng;}
<STRING>\\f                                 {if(check) printf("\f"); num_column += yyleng;}
<STRING>\\n                                 {if(check) printf("\n"); num_column += yyleng;}
<STRING>\\r                                 {if(check) printf("\r"); num_column += yyleng;}
<STRING>\\t                                 {if(check) printf("\t"); num_column += yyleng;}
<STRING>\\                                  {if(check) printf("\\"); num_column += yyleng;}     
<STRING>\\\"                                {if(check) printf("\""); num_column += yyleng;} 
<STRING>\\[^fnrt]                           {num_column += yyleng++; printf("Line %d, column %d: invalid escape sequence (\\%c)\n", num_line, num_column, yytext[1]);}
<STRING>.                                   {if(check) ECHO; num_column += yyleng;}
<STRING>\n                                  {printf("Line %d, column %d: unterminated string literal\n", num_line, num_column); num_line++; num_column = 1; BEGIN 0;}         

 
<OCTAL_ERROR>" "                            {num_column++; BEGIN 0;} 
<OCTAL_ERROR>\n                             {num_column = 1; num_line++; BEGIN 0;} 
<OCTAL_ERROR>.                              {num_column++;}

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
