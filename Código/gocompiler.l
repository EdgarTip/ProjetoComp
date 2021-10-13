  //Edgar Duarte 2019216077 Rodrigo Ferreira   2019220060 .
%X  STRING COMMENT OCTAL_ERROR
%{
    #include <stdlib.h>
    
    int num_line = 1;
    int num_column = 1;  
    int check = 0;
    int last = 0;
    int initial_line = 0;
    int initial_column = 0;

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
numbers_Hexa                    [0-9A-Fa-f]
legal_after                     [a-zA-Z0-9]*[^" "\n\r"=="">=""<=""!=""&&""||"";"",""_""\-""=""*""/""+"">""{""(""[""<""%""!""}"")""\]""\t"]
exp                             [eE][+-]?
expHexa                         [pP][+-]?

hexaN                           [0-9a-fA-F]
octalN                          [0-7]

nums_c                          ((_)?{numbers})+
hexaNum                         ((_)?{hexaN})+
octalNum                        ((_)?{octalN})+


reserved                         "break"|"default"|"interface"|"select"|"case"|"defer"|"go"|"map"|"struct"|"chan"|"goto"|"switch"|"const"|"fallthrough"|"range"|"type"|"continue"|"import"|"++"|"--"

%%

0[0-7]*(8|9)[0-9]*                   {printf("Line %d, column %d: invalid octal constant (%s)\n", num_line, num_column, yytext);num_column += yyleng;}

0                                           {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
0*[1-9]((_)?{numbers})*                       {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
0[oO]?((_)?[0-7])*                          {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
0[xX]((_)?{numbers_Hexa})+                  {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1;}  

[0-9]{nums_c}*{exp}{nums_c}                                      {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
0*{nums_c}"."({numbers}*)?({exp}{nums_c})?                             {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1;}
"."{numbers}+({exp}{nums_c})?                                       {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1;}




0[xX](({hexaNum}+("."{hexaN}*)?)|({hexaNum}*"."{hexaN}+))({expHexa}{nums_c})?                                    {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1;}   
 





\"                                          {BEGIN STRING; initializeBlock(); initial_column = num_column; num_column += yyleng; last = 1;}
"/""/".*                                    {if(last && check) printf("SEMICOLON\n"); num_column += yyleng; last = 0;}
"/""*"                                      {BEGIN COMMENT; initial_column = num_column; initial_line = num_line; num_column += yyleng;}

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

" "                                         {num_column++;}
\t                                          {num_column+= yyleng;}
\r                                          {num_column = 1;}
.                                           {printf("Line %d, column %d: illegal character (%s)\n", num_line, num_column, yytext); num_column+= yyleng; last = 0;}
\n                                          {num_line++; num_column = 1; if(last && check) printf("SEMICOLON\n"); last = 0;}
<INITIAL><<EOF>>                            {if(check && last) printf("SEMICOLON\n"); return 0;}


<STRING>"\""                                {BEGIN 0; if(check && string_error == 0) {
                                                        ptr[counter++] = '\0';
                                                        printf("STRLIT(\"%s\")\n", ptr);}
                                                    freeBlock();
                                                    num_column+= yyleng;}



<STRING>\\f                                 {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 'f'; checkBlock();} num_column+= yyleng;}
<STRING>\\n                                 {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 'n'; checkBlock();} num_column+= yyleng;}
<STRING>\\r                                 {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 'r'; checkBlock();} num_column+= yyleng;}
<STRING>\\t                                 {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 't'; checkBlock();} num_column+= yyleng;}
<STRING>\\\r                                 {printf("Line %d, column %d: invalid escape sequence (%c)\n", num_line, num_column, *yytext); string_error = 1; num_column += yyleng;}

<STRING>\\\"                                {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = '\"'; checkBlock();} num_column+= yyleng;}
<STRING>"\\\\"                              {if(check) { ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = '\\'; checkBlock();} num_column+= yyleng;}                                                    
<STRING>\\[^fnrt]?                          {printf("Line %d, column %d: invalid escape sequence (%c%c)\n", num_line, num_column, *yytext, *(yytext+1)); string_error = 1; num_column += yyleng; last = 0;}


<STRING>.                                   {if(check) ptr[counter++] = *yytext; checkBlock(); num_column++;}

<STRING>\n                                  {printf("Line %d, column %d: unterminated string literal\n", num_line, initial_column);     
                                                num_line++; 
                                                num_column = 1; 
                                                freeBlock(); 
                                                BEGIN 0; last = 0;}   

<STRING><<EOF>>                             {printf("Line %d, column %d: unterminated string literal\n", num_line, initial_column); freeBlock(); return 0;}


<COMMENT>"*""/"                             {BEGIN 0; num_column+= yyleng;}
<COMMENT><<EOF>>                            {printf("Line %d, column %d: unterminated comment\n", initial_line, initial_column); return 0;}
<COMMENT>.                                  {num_column++;}
<COMMENT>\n                                 {if(check && last) printf("SEMICOLON\n"); last = 0; num_line++; num_column = 1;}



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
