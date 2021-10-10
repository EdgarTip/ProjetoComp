  //Edgar Duarte 2019216077 Rodrigo Ferreira   2019220060 .
%X  STRING COMMENT 
%{
    #include <stdlib.h>
    
    int num_line = 1;
    int num_column = 1;  
    int check = 0;
    int last = 0;
    int initial_line = 0;

    char *ptr = NULL;
    char *ptr_erro = NULL;

    int string_error = 0;

    int block = 256;
    int counter = 0;

    void checkBlock() {
        if (counter == block) {
            block *= 2;

            void *new_ptr = realloc(ptr, block * sizeof(char));
            if (new_ptr == NULL) {
                exit(-1);
            }
            ptr = new_ptr;
        }
    }

    void freeBlock() {
        free(ptr); 
        ptr = NULL;
        block = 256;
        counter = 0;
    }

    void initializeBlock() {
        string_error = 0;
        ptr = (char*)malloc(block*sizeof(char));
        if (ptr == NULL) {
                exit(-1);
        }
    }

%}


id_characters                   [a-zA-Z0-9_]
letters                         [a-zA-Z] 
numbers                         [0-9]
numbers_Hexa                    [0-9ABCDEFabcdef]
legal_after                     [a-zA-Z0-9]*[^" "\n\r"=="">=""<=""!=""&&""||"";"",""_""\-""=""*""/""+"">""{""(""[""<""%""!""}"")""\]""\t"]
reserved                         "break"|"default"|"interface"|"select"|"case"|"defer"|"go"|"map"|"struct"|"chan"|"goto"|"switch"|"const"|"fallthrough"|"range"|"type"|"continue"|"import"|"++"|"--"|"int64"|"float64"|"byte"|"complex64"|"complex128"|"error"|"int8"|"int16"|"int32"|"rune"|"uint"|"uint8"|"uint16"|"uint32"|"uint64"|"uintptr"|"true"|"false"|"iota"|"nil"|"append"|"cap"|"close"|"complex"|"copy"|"delete"|"imag"|"len"|"make"|"new"|"panic"|"print"|"println"|"real"|"recover"

%%
0                                           {if(check) printf("INTLIT(%s)\r\n", yytext); num_column += yyleng; last = 1;}
[1-9]((_)?{numbers})*            {if(check) printf("INTLIT(%s)\r\n", yytext); num_column += yyleng; last = 1;}
0[oO]?((_)?[0-7])*                          {if(check) printf("INTLIT(%s)\r\n", yytext); num_column += yyleng; last = 1;}
0[xX]((_)?{numbers_Hexa})*  {if(check) printf("INTLIT(%s)\r\n", yytext); num_column += yyleng; last = 1;}  

0([0-7]*[89a-zA-Z]+[0-7]*)+                    { printf("Line %d, column %d: invalid octal constant (%s)\r\n", num_line, num_column, yytext);num_column += yyleng;}


{numbers}((_)?{numbers})*"."({numbers}*?([eE][+-]?{numbers}((_)?{numbers})*)?)?   {if(check) printf("REALLIT(%s)\r\n", yytext); num_column += yyleng; last = 1;}
"."{numbers}+([eE][+-]?{numbers}+)?                 {if(check) printf("REALLIT(%s)\r\n", yytext); num_column += yyleng; last = 1;}
[1-9]{numbers}*[eE][+-]?{numbers}+                  {if(check) printf("REALLIT(%s)\r\n", yytext); num_column += yyleng; last = 1;}


\"                                          {BEGIN STRING; initializeBlock(); num_column += yyleng;}
"/""/".*                                    {if(last) printf("SEMICOLON\r\n"); num_column += yyleng; last = 0;}
"/""*"                                      {BEGIN COMMENT; initial_line = num_line;}

"package"                                   {if(check) printf("PACKAGE\r\n"); num_column += yyleng; last = 0;}
"return"                                    {if(check) printf("RETURN\r\n"); num_column += yyleng; last = 1;}
"else"                                      {if(check) printf("ELSE\r\n"); num_column += yyleng; last = 0;}
"for"                                       {if(check) printf("FOR\r\n"); num_column += yyleng; last = 0;}
"if"                                        {if(check) printf("IF\r\n"); num_column += yyleng; last = 0;}
"var"                                       {if(check) printf("VAR\r\n"); num_column += yyleng; last = 0;}
"int"                                       {if(check) printf("INT\r\n"); num_column += yyleng; last = 0;}
"float32"                                   {if(check) printf("FLOAT32\r\n"); num_column += yyleng; last = 0;}
"bool"                                      {if(check) printf("BOOL\r\n"); num_column += yyleng; last = 0;}
"string"                                    {if(check) printf("STRING\r\n"); num_column += yyleng; last = 0;}
"fmt.Println"                               {if(check) printf("PRINT\r\n"); num_column += yyleng; last = 0;}
"strconv.Atoi"                              {if(check) printf("PARSEINT\r\n"); num_column += yyleng; last = 0;}
"func"                                      {if(check) printf("FUNC\r\n"); num_column += yyleng; last = 0;}
"os.Args"                                   {if(check) printf("CMDARGS\r\n"); num_column += yyleng; last = 0;}

{reserved}                                  {if(check) printf("RESERVED(%s)\r\n", yytext); num_column += yyleng; last = 0;}

"=="                                        {if(check) printf("EQ\r\n"); num_column+=2; last = 0;}
">="                                        {if(check) printf("GE\r\n"); num_column+=2; last = 0;}
"<="                                        {if(check) printf("LE\r\n"); num_column+=2; last = 0;}
"!="                                        {if(check) printf("NE\r\n"); num_column+=2; last = 0;}
"&&"                                        {if(check) printf("AND\r\n"); num_column+=2; last = 0;}
"||"                                        {if(check) printf("OR\r\n"); num_column+=2; last = 0;}

";"                                         {if(check) printf("SEMICOLON\r\n"); num_column++; last = 0;}
","                                         {if(check) printf("COMMA\r\n"); num_column++; last = 0;}
"_"                                         {if(check) printf("BLANKID\r\n"); num_column++; last = 0;}
"="                                         {if(check) printf("ASSIGN\r\n"); num_column++; last = 0;}
"*"                                         {if(check) printf("STAR\r\n"); num_column++; last = 0;}
"/"                                         {if(check) printf("DIV\r\n"); num_column++; last = 0;}
"-"                                         {if(check) printf("MINUS\r\n"); num_column++; last = 0;}
"+"                                         {if(check) printf("PLUS\r\n"); num_column++; last = 0;}
">"                                         {if(check) printf("GT\r\n"); num_column++; last = 0;}
"{"                                         {if(check) printf("LBRACE\r\n"); num_column++; last = 0;}
"("                                         {if(check) printf("LPAR\r\n"); num_column++; last = 0;}
"["                                         {if(check) printf("LSQ\r\n"); num_column++; last = 0;}
"<"                                         {if(check) printf("LT\r\n"); num_column++; last = 0;}
"%"                                         {if(check) printf("MOD\r\n"); num_column++; last = 0;}
"!"                                         {if(check) printf("NOT\r\n"); num_column++; last = 0;}
"}"                                         {if(check) printf("RBRACE\r\n"); num_column++; last = 1;}
")"                                         {if(check) printf("RPAR\r\n"); num_column++; last = 1;}
"]"                                         {if(check) printf("RSQ\r\n"); num_column++; last = 1;}

[a-zA-Z_]{id_characters}*                    {if(check) printf("ID(%s)\r\n", yytext); num_column += yyleng; last = 1;}

" "                                         {num_column++;}
\t                                          {;}
\r                                          {;}
.                                           {printf("Line %d, column %d: illegal character (%s)\r\n", num_line, num_column, yytext); num_column += yyleng; last = 0;}
\n                                          {num_line++; num_column = 1; if(last){ if(check) printf("SEMICOLON\r\n");} last = 0;}
<INITIAL><<EOF>>                            {if(last) printf("SEMICOLON\r\n"); return 0;}


<STRING>"\""                                {BEGIN 0; if(check && string_error == 0) {
                                                        ptr[counter++] = '\0';
                                                        printf("STRLIT(\"%s\")\r\n", ptr);}
                                                    freeBlock();
                                                    num_column++;}

<STRING>"carriage return"                   {string_error = 1; num_column += yyleng;}
<STRING>"newline"                           {string_error = 1; num_column += yyleng;}
<STRING>"\"\""                              {string_error = 1; num_column += yyleng;}

<STRING>\\f                                 {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 'f'; checkBlock();} num_column++;}
<STRING>\\n                                 {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 'n'; checkBlock();} num_column++;}
<STRING>\\r                                 {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 't'; checkBlock();} num_column++;}
<STRING>\\t                                 {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 't'; checkBlock();} num_column++;}

<STRING>\\\r                                 {printf("Line %d, column %d: invalid escape sequence (%c)\r\n", num_line, num_column, *yytext); string_error = 1; num_column += yyleng;}
<STRING>\\\"                                {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = '\"'; checkBlock();} num_column++;}
<STRING>"\\\\"                              {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = '\\'; checkBlock();} num_column++;}                                                    
<STRING>\\[^fnrt]?                          {printf("Line %d, column %d: invalid escape sequence (%c%c)\r\n", num_line, num_column, *yytext, *(yytext+1)); string_error = 1; num_column += yyleng;}


<STRING>.                                   {if(check) ptr[counter++] = *yytext; checkBlock(); num_column++;}

<STRING>\n                                  {printf("Line %d, column 1: unterminated string literal\r\n", num_line); 
                                                num_line++; 
                                                num_column = 1; 
                                                freeBlock(); 
                                                BEGIN 0; last = 0;}   

<STRING><<EOF>>                             {printf("Line %d, column 1: unterminated string literal\r\n", num_line); freeBlock(); return 0;}


<COMMENT>"*""/"                             {BEGIN 0;}
<COMMENT><<EOF>>                            {printf("Line %d, column %d: unterminated comment\r\n", initial_line, num_column); return 0;}
<COMMENT>.                                  {;}
<COMMENT>\n                                 {if(last) printf("SEMICOLON\r\n"); last = 0; num_line++; num_column = 1;}


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
