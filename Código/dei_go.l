
%X  STRING OCTAL_ERROR COMMENT
%{
    int num_line = 1;
    int num_column = 1;  
%}


id_characters                   [a-zA-Z0-9_]
letters                         [a-zA-Z] 
numbers                         [0-9]
numbers_Hexa                    [0-9ABCDEFabcdef]
illegal_octals                  [89a-zA-Z]

%%

-?[1-9]{numbers}*                           {printf("INTLIT\n"); num_column += yyleng;}
0[0-7]*                                     {printf("INTLIT\n"); num_column += yyleng;}
0[xX]{numbers_Hexa}*                        {printf("INTLIT\n"); num_column += yyleng;}    

0[0-7]*{illegal_octals}                     {num_column += yyleng; printf("Line %d, column %d: invalid octal constant (%c)\n", num_line, num_column, yytext[yyleng-1]); BEGIN OCTAL_ERROR; }

{numbers}+"."{numbers}*[eE][+-]{numbers}+   {printf("REALLIT\n"); num_column += yyleng;}
{numbers}+"."{numbers}+                     {printf("REALLIT\n"); num_column += yyleng;}

\"                                          {BEGIN STRING;printf("STRLIT("); num_column += yyleng;}
"/""/".*                                    {num_column += yyleng;}
"/""*"                                      {BEGIN COMMENT; num_column += yyleng;}

\"                                          {BEGIN STRING;printf("STRLIT("); num_column += yyleng;}

"package"                                   {printf("PACKAGE\n"); num_column += yyleng;}
"return"                                    {printf("RETURN\n"); num_column += yyleng;}
"else"                                      {printf("ELSE\n"); num_column += yyleng;}
"for"                                       {printf("FOR\n"); num_column += yyleng;}
"if"                                        {printf("IF\n"); num_column += yyleng;}
"var"                                       {printf("VAR\n"); num_column += yyleng;}
"int"                                       {printf("INT\n"); num_column += yyleng;}
"float32"                                   {printf("FLOAT32\n"); num_column += yyleng;}
"bool"                                      {printf("BOOL\n"); num_column += yyleng;}
"string"                                    {printf("STRING\n"); num_column += yyleng;}
"fmt.Println"                               {printf("PRINT\n"); num_column += yyleng;}
"strconv.Atoi"                              {printf("PARSEINT\n"); num_column += yyleng;}
"func"                                      {printf("FUNC\n"); num_column += yyleng;}
"os.Args"                                   {printf("CMDARGS\n"); num_column += yyleng;}

"break"                                     {printf("RESERVED\n"); num_column += yyleng;}
"default"                                   {printf("RESERVED\n"); num_column += yyleng;}
"interface"                                 {printf("RESERVED\n"); num_column += yyleng;}
"select"                                    {printf("RESERVED\n"); num_column += yyleng;}
"case"                                      {printf("RESERVED\n"); num_column += yyleng;}
"defer"                                     {printf("RESERVED\n"); num_column += yyleng;}
"go"                                        {printf("RESERVED\n"); num_column += yyleng;}
"map"                                       {printf("RESERVED\n"); num_column += yyleng;}
"struct"                                    {printf("RESERVED\n"); num_column += yyleng;}
"chan"                                      {printf("RESERVED\n"); num_column += yyleng;}
"goto"                                      {printf("RESERVED\n"); num_column += yyleng;}
"switch"                                    {printf("RESERVED\n"); num_column += yyleng;}
"const"                                     {printf("RESERVED\n"); num_column += yyleng;}
"fallthrough"                               {printf("RESERVED\n"); num_column += yyleng;}
"range"                                     {printf("RESERVED\n"); num_column += yyleng;}
"type"                                      {printf("RESERVED\n"); num_column += yyleng;}
"continue"                                  {printf("RESERVED\n"); num_column += yyleng;}
"import"                                    {printf("RESERVED\n"); num_column += yyleng;}

"=="                                        {printf("EQ\n"); num_column+=2;}
">="                                        {printf("GQ\n"); num_column+=2;}
"<="                                        {printf("LE\n"); num_column+=2;}
"!="                                        {printf("NE\n"); num_column+=2;}
"&&"                                        {printf("AND\n"); num_column+=2;}
"||"                                        {printf("OR\n"); num_column+=2;}

";"                                         {printf("SEMICOLON\n"); num_column++;}
","                                         {printf("COMMA\n"); num_column++;}
"_"                                         {printf("BLANKID\n"); num_column++;}
"="                                         {printf("ASSIGN\n"); num_column++;}
"*"                                         {printf("STAR\n"); num_column++;}
"/"                                         {printf("DIV\n"); num_column++;}
"-"                                         {printf("MINUS\n"); num_column++;}
"+"                                         {printf("PLUS\n"); num_column++;}
">"                                         {printf("GT\n"); num_column++;}
"{"                                         {printf("LBRACE\n"); num_column++;}
"("                                         {printf("LPAR\n"); num_column++;}
"["                                         {printf("LSQ\n"); num_column++;}
"<"                                         {printf("LT\n"); num_column++;}
"%"                                         {printf("MOD\n"); num_column++;}
"!"                                         {printf("NOT\n"); num_column++;}
"}"                                         {printf("RBRACE\n"); num_column++;}
")"                                         {printf("RPAR\n"); num_column++;}
"]"                                         {printf("RSQ\n"); num_column++;}

[a-zA-Z]{id_characters}*                    {printf("ID(%s)\n", yytext); num_column += yyleng;}

" "                                         {num_column++;}
\r                                          {;}
.                                           {printf("Line %d, collumn %d: illegal character (%c)\n", num_line, num_column, yytext[0]); num_column++;}
\n                                          {num_line++; num_column = 1;}

<STRING>"\""                                {BEGIN 0;printf(")\n"); num_column += yyleng;}
<STRING>\\f                                 {printf("\f"); num_column += yyleng;}
<STRING>\\n                                 {printf("\n"); num_column += yyleng;}
<STRING>\\r                                 {printf("\r"); num_column += yyleng;}
<STRING>\\t                                 {printf("\t"); num_column += yyleng;}
<STRING>\\                                  {printf("\\"); num_column += yyleng;}     
<STRING>\\\"                                {printf("\""); num_column += yyleng;} 
<STRING>\\[^fnrt]                           {num_column += yyleng++; printf("Line %d, column %d: invalid escape sequence (%c)\n", num_line, num_column, yytext[1]);}
<STRING>.                                   {ECHO; num_column += yyleng;}
<STRING>\n                                  {printf("Line %d, column %d: unterminated string literal\n", num_line, num_column); num_line++; num_column = 1; BEGIN 0;}         

 
<OCTAL_ERROR>" "                                  {num_column++; BEGIN 0;} 
<OCTAL_ERROR>\n                                   {num_column = 1; num_line++; BEGIN 0;} 
<OCTAL_ERROR>.                                    {num_column++;}


<COMMENT>"*""/"                             {BEGIN 0;}
<COMMENT>EOF                                {;}     //TODO
<COMMENT>.                                  {num_column++;}
<COMMENT>\n                                 {num_lines++; num_column = 1;}

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
