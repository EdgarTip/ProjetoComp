  //Edgar Duarte 2019216077 Rodrigo Ferreira   2019220060 .
%X  STRINGT COMMENT OCTAL_ERROR REALLYEND SEMICOLOEND
%{
    #include <stdlib.h>
    #include "y.tab.h"

    int num_line = 1;
    int num_column = 1;  
    int check = 0;
    int check2 = 0;
    int last = 0;
    int initial_line = 0;
    int initial_column = 0;
    

    char *ptr = NULL;

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

0                                           {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1; yylval.letters = strdup(yytext); if(check2)return INTLIT;}
0*[1-9]((_)?{numbers})*                       {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1; yylval.letters = strdup(yytext); if(check2)return INTLIT;}
0[oO]?((_)?[0-7])*                          {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1; yylval.letters = strdup(yytext); if(check2)return INTLIT;}
0[xX]((_)?{numbers_Hexa})+                  {if(check) printf("INTLIT(%s)\n", yytext); num_column += yyleng; last = 1; yylval.letters = strdup(yytext); if(check2)return INTLIT;}  

[0-9]{nums_c}*{exp}{nums_c}                                      {if(check) printf("REALLIT(%s)\n", yytext);    num_column += yyleng; last = 1;yylval.letters = strdup(yytext); if(check2)return REALLIT;}
0*{nums_c}"."({numbers}*)?({exp}{nums_c})?                             {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1; yylval.letters = strdup(yytext); if(check2)return REALLIT;}
"."{numbers}+({exp}{nums_c})?                                       {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1; yylval.letters = strdup(yytext); if(check2)return REALLIT;}


0[xX](({hexaNum}+("."{hexaN}*)?)|({hexaNum}*"."{hexaN}+))({expHexa}{nums_c})?                                    {if(check) printf("REALLIT(%s)\n", yytext); num_column += yyleng; last = 1; yylval.letters = strdup(yytext); if(check2)return REALLIT;}   
 


\"                                          {BEGIN STRINGT; initializeBlock(); initial_column = num_column; num_column += yyleng; last = 1;}
"/""/".*                                    {num_column += yyleng; if(last && check){ printf("SEMICOLON\n");} if(last){last = 0; if(check2)return SEMICOLON;} }
"/""*"                                      {BEGIN COMMENT; initial_column = num_column; initial_line = num_line; num_column += yyleng;}

"package"                                   {if(check) printf("PACKAGE\n"); num_column += yyleng; last = 0; if(check2)return PACKAGE;}
"return"                                    {if(check) printf("RETURN\n"); num_column += yyleng; last = 1; if(check2)return RETURN;}
"else"                                      {if(check) printf("ELSE\n"); num_column += yyleng; last = 0; if(check2)return ELSE;}
"for"                                       {if(check) printf("FOR\n"); num_column += yyleng; last = 0; if(check2)return FOR;}
"if"                                        {if(check) printf("IF\n"); num_column += yyleng; last = 0; if(check2)return IF;}
"var"                                       {if(check) printf("VAR\n"); num_column += yyleng; last = 0; if(check2)return VAR;}
"int"                                       {if(check) printf("INT\n"); num_column += yyleng; last = 0; if(check2)return INT;}
"float32"                                   {if(check) printf("FLOAT32\n"); num_column += yyleng; last = 0; if(check2)return FLOAT32;}
"bool"                                      {if(check) printf("BOOL\n"); num_column += yyleng; last = 0; if(check2)return BOOL;}
"string"                                    {if(check) printf("STRING\n"); num_column += yyleng; last = 0; if(check2)return STRING;}
"fmt.Println"                               {if(check) printf("PRINT\n"); num_column += yyleng; last = 0; if(check2)return PRINT;}
"strconv.Atoi"                              {if(check) printf("PARSEINT\n"); num_column += yyleng; last = 0; if(check2)return PARSEINT;}
"func"                                      {if(check) printf("FUNC\n"); num_column += yyleng; last = 0; if(check2)return FUNC;}
"os.Args"                                   {if(check) printf("CMDARGS\n"); num_column += yyleng; last = 0; if(check2)return CMDARGS;}

{reserved}                                  {if(check) printf("RESERVED(%s)\n", yytext); num_column += yyleng; last = 0; if (check2 && strcmp(yytext, "++")== 0) {return PLUSPLUS;}; if (check2 && strcmp(yytext, "--")== 0) {return MINUSMINUS;}}

"=="                                        {if(check) printf("EQ\n"); num_column+=2; last = 0; if(check2)return EQ;}
">="                                        {if(check) printf("GE\n"); num_column+=2; last = 0; if(check2)return GE;}
"<="                                        {if(check) printf("LE\n"); num_column+=2; last = 0; if(check2)return LE;}
"!="                                        {if(check) printf("NE\n"); num_column+=2; last = 0; if(check2)return NE;}
"&&"                                        {if(check) printf("AND\n"); num_column+=2; last = 0; if(check2)return AND;}
"||"                                        {if(check) printf("OR\n"); num_column+=2; last = 0; if(check2)return OR;}

";"                                         {if(check) printf("SEMICOLON\n"); num_column++; last = 0; if(check2)return SEMICOLON;}
","                                         {if(check) printf("COMMA\n"); num_column++; last = 0; if(check2)return COMMA;}
"_"                                         {if(check) printf("BLANKID\n"); num_column++; last = 0; if(check2)return BLANKID;}
"="                                         {if(check) printf("ASSIGN\n"); num_column++; last = 0; if(check2)return ASSIGN;}
"*"                                         {if(check) printf("STAR\n"); num_column++; last = 0; if(check2)return STAR;}
"/"                                         {if(check) printf("DIV\n"); num_column++; last = 0; if(check2)return DIV;}
"-"                                         {if(check) printf("MINUS\n"); num_column++; last = 0; if(check2)return MINUS;}
"+"                                         {if(check) printf("PLUS\n"); num_column++; last = 0; if(check2)return PLUS;}
">"                                         {if(check) printf("GT\n"); num_column++; last = 0; if(check2)return GT;}
"{"                                         {if(check) printf("LBRACE\n"); num_column++; last = 0; if(check2)return LBRACE;}
"("                                         {if(check) printf("LPAR\n"); num_column++; last = 0; if(check2)return LPAR;}
"["                                         {if(check) printf("LSQ\n"); num_column++; last = 0; if(check2)return LSQ;}
"<"                                         {if(check) printf("LT\n"); num_column++; last = 0; if(check2)return LT;}
"%"                                         {if(check) printf("MOD\n"); num_column++; last = 0; if(check2)return MOD;}
"!"                                         {if(check) printf("NOT\n"); num_column++; last = 0; if(check2)return NOT;}
"}"                                         {if(check) printf("RBRACE\n"); num_column++; last = 1; if(check2)return RBRACE;}
")"                                         {if(check) printf("RPAR\n"); num_column++; last = 1; if(check2)return RPAR;}
"]"                                         {if(check) printf("RSQ\n"); num_column++; last = 1; if(check2)return RSQ;}

[a-zA-Z_]{id_characters}*                    {if(check) printf("ID(%s)\n", yytext); num_column += yyleng; last = 1;
yylval.letters = strdup(yytext); if(check2)return ID;}

" "                                         {num_column++;}
\t                                          {num_column+= yyleng;}
\r                                          {num_column = 1;}
.                                           {printf("Line %d, column %d: illegal character (%s)\n", num_line, num_column, yytext); num_column+= yyleng; last = 0;}
\n                                          {num_line++; num_column = 1; if(last && check){printf("SEMICOLON\n");} if(last){ last = 0; if(check2)return SEMICOLON;} }
<INITIAL><<EOF>>                            {if(check && last) {printf("SEMICOLON\n");} if(last && check2){BEGIN(SEMICOLOEND); return SEMICOLON;} if(check2){BEGIN(REALLYEND); return END;} return 0;}
<SEMICOLOEND><<EOF>>                               {BEGIN(REALLYEND); return END;}
<REALLYEND><<EOF>>                          {return 0;}

<STRINGT>"\""                                {BEGIN 0; if(check && string_error == 0) { printf("STRLIT(\"%s\")\n", ptr); }
                                                        ptr[counter++] = '\0';
                                                    if(string_error == 0){
                                                        yylval.letters = strdup(ptr);
                                                        if(check2)return STRLIT;
                                                    }
                                                    freeBlock();
                                                    num_column+= yyleng; }

<STRINGT>\\f                                 {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 'f'; checkBlock(); num_column+= yyleng;}
<STRINGT>\\n                                 {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 'n'; checkBlock(); num_column+= yyleng;}
<STRINGT>\\r                                 {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 'r'; checkBlock(); num_column+= yyleng;}
<STRINGT>\\t                                 {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 't'; checkBlock(); num_column+= yyleng;}
<STRINGT>\\\r                                 {printf("Line %d, column %d: invalid escape sequence (%c)\n", num_line, num_column, *yytext); string_error = 1; num_column += yyleng;}

<STRINGT>\\\"                                {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = '\"'; checkBlock(); num_column+= yyleng;}
<STRINGT>"\\\\"                              {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = '\\'; checkBlock(); num_column+= yyleng;}                                                    
<STRINGT>\\[^fnrt]?                          {printf("Line %d, column %d: invalid escape sequence (%c%c)\n", num_line, num_column, *yytext, *(yytext+1)); string_error = 1; num_column += yyleng; last = 0;}

<STRINGT>.                                   {ptr[counter++] = *yytext; checkBlock(); num_column++;}

<STRINGT>\n                                  {printf("Line %d, column %d: unterminated string literal\n", num_line, initial_column);     
                                                num_line++; 
                                                num_column = 1; 
                                                freeBlock();
                                                BEGIN 0; 
                                                if(last && check){
                                                    printf("SEMICOLON\n");
                                                }
                                                if(last && check2){
                                                    return SEMICOLON;
                                                }   
                                                last = 0;
                                                }

<STRINGT><<EOF>>                             {printf("Line %d, column %d: unterminated string literal\n", num_line, initial_column); freeBlock(); if(last && check){printf("SEMICOLON");} if(last && check2){ BEGIN(SEMICOLOEND); return SEMICOLON;} if(check2){BEGIN(REALLYEND); return END;} return 0;}




<COMMENT>"*""/"                             {BEGIN 0; num_column+= yyleng;}
<COMMENT><<EOF>>                            {printf("Line %d, column %d: unterminated comment\n", initial_line, initial_column); if(check2){BEGIN(REALLYEND); return END;} return 0;}
<COMMENT>.                                  {num_column++;}
<COMMENT>\n                                 {last = 0; num_line++; num_column = 1; if(check && last){ printf("SEMICOLON\n");} if(last && check2){return SEMICOLON;} }



%%

void yyerror ( char *s) { 
     printf ("Line %d, column %d: %s: %s\n", num_line, num_column, s, yytext);
}


int yywrap()
{
    return 1;
}

int main(int argc, char* argv[])
{
    if (argc == 2 && argv[1][0] == '-') {
        int counter = 0;
        while (argv[1][counter] != 0 && counter < 10) {
            switch (argv[1][counter]) {
                case 'l':
                    check = 1;
                    break;
                case 't':
                    check2 = 1;
                    break;

            }
            counter++;
        }

    }
    if (check2) {
        yyparse();
       
    } else if (check) {
         yylex();
    }

    return 0;
}

