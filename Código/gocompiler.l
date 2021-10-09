  //Edgar Duarte 2019216077 Rodrigo Ferreira   2019220060 .
%X  STRING COMMENT 
%{
    #include <stdlib.h>
    
    int num_line = 1;
    int num_column = 1;  
    int check = 0;
    int last = 0;

    char *ptr = NULL;

    char string_error = 0;
    int ini_str_line = 0;
    int ini_str_column = 0;

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
        if (string_error) {
            printf("Line %d, column %d: invalid escape sequence (\"%s\")\n", ini_str_line, ini_str_column, ptr); 
            last = 0;
        } else last = 1;

        free(ptr); 
        ptr = NULL;
        block = 256;
        counter = 0;
    }

    void initializeBlock() {
        string_error = 0;
        ini_str_line = num_line;
        ini_str_column = num_column;
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
illegal_octals                  [89a-zA-Z]
legal_after                     [a-zA-Z0-9]*[^" "\n\r"=="">=""<=""!=""&&""||"";"",""_""\-""=""*""/""+"">""{""(""[""<""%""!""}"")""\]""\t"]
reserved                        "break"|"default"|"interface"|"select"|"case"|"defer"|"go"|"map"|"struct"|"chan"|"goto"|"switch"|"const"|"fallthrough"|"range"|"type"|"continue"|"import"|"++"|"--"|"int64"|"float64"|"byte"|"complex64"|"complex128"|"error"|"int8"|"int16"|"int32"|"rune"|"uint"|"uint8"|"uint16"|"uint32"|"uint64"|"uintptr"|"true"|"false"|"iota"|"nil"|"append"|"cap"|"close"|"complex"|"copy"|"delete"|"imag"|"len"|"make"|"new"|"panic"|"print"|"println"|"real"|"recover"|"&"|"\|"|"^"|":"|"."|"..."

%%  

[1-9]((_{numbers})|({numbers}))*            {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
0[oO]?((_)?[0-7])*[0-7]                          {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
0[xX]((_{numbers_Hexa}|{numbers_Hexa}))*  {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1;}   

0[0-7{illegal_octals}]*                    { printf("Line %d, column %d: invalid octal constant (%s)\n", num_line, num_column, yytext);num_column += yyleng;}


{numbers}+"."({numbers}*?([eE][+-]?{numbers}+)?)?   {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
"."{numbers}+([eE][+-]?{numbers}+)?        {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
[1-9]{numbers}*[eE][+-]?{numbers}+              {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1;}


\"                                          {BEGIN STRING; initializeBlock(); num_column += yyleng;}
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

{reserved}                                  {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0;}

"=="                                        {if(check) printf("EQ\n"); num_column+=2; last = 0;}
">="                                        {if(check) printf("GE\n"); num_column+=2; last = 0;}
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

[a-zA-Z_]{id_characters}*                    {if(check) printf("ID(%s)\n", yytext); num_column += yyleng; last = 1;}

<<EOF>>                                     {return 0;}
" "                                         {num_column++;}
\t                                          {;}
\r                                          {;}
{legal_after}                                 {printf("Line %d, column %d: illegal character (%s)\n", num_line, num_column, yytext); num_column += yyleng; last = 0;}
\n                                          {num_line++; num_column = 1; if(last){ if(check) printf("SEMICOLON\n");} last = 0;}


<STRING>"\""                                {BEGIN 0; if(check) {
                                                        ptr[counter++] = '\0';
                                                        printf("STRLIT(%s)\n", ptr);}
                                                    freeBlock();
                                                    num_column++;}
<STRING>\\f                                 {if(check) ptr[counter++] = '\f'; checkBlock(); num_column++;}
<STRING>\\n                                 {if(check) ptr[counter++] = '\n'; checkBlock(); num_column++;}
<STRING>\\r                                 {if(check) ptr[counter++] = '\r'; checkBlock(); num_column++;}
<STRING>\\t                                 {if(check) ptr[counter++] = '\t'; checkBlock(); num_column++;}
<STRING>\\                                  {if(check) ptr[counter++] = '\\'; checkBlock(); num_column++;}     
<STRING>\\\"                                {if(check) ptr[counter++] = '\"'; checkBlock(); num_column++;} 
<STRING>\\[^fnrt]                           {num_column++; string_error = 1;}
<STRING>.                                   {if(check) ptr[counter++] = *yytext; checkBlock(); num_column++;}
<STRING>\n                                  {printf("Line %d, column %d: unterminated string literal\n", num_line, num_column); 
                                                num_line++; 
                                                num_column = 1; 
                                                freeBlock(); 
                                                BEGIN 0; last = 0;}         


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
