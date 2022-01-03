  //Edgar Duarte 2019216077 Rodrigo Ferreira   2019220060 .
%X  STRINGT COMMENT OCTAL_ERROR REALLYEND SEMICOLOEND 
%{
    #include <stdlib.h>
    #include "y.tab.h"
    #include "tree.h"

    int num_line = 1;
    int num_column = 1;  
    int check = 0;
    int check2 = 0;
    int check3 = 0;
    int last = 0;
    int initial_line = 0;
    int initial_column = 0;

    int last_num_column = 0;
    int last_num_line = 0;
    
    
    extern tree_list start_node;
    extern int error;

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

    /* update the num_line, num_column, last_num_line and last_num_column
       option chooses the behavior: option=
       0 -> num_column += yylength;
       1 -> num_line++;
       2 -> num_column = 1;
       3 -> num_line++; num_column = 1;*/
    void update_position(int yylength, int option) {
        
        last_num_line = num_line;
        last_num_column = num_column;
        
        if (option == 0) num_column += yylength;
        else if (option == 1) num_line++;
        else if (option == 2) num_column = 1;
        else if (option == 3) {
            num_line++; 
            num_column = 1;
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

newLine                         ["\r\n""\n""\r"]

%%

0[0-7]*(8|9)[0-9]*                   {printf("Line %d, column %d: invalid octal constant (%s)\n", num_line, num_column, yytext); update_position(yyleng, 0);}

0                                           {if(check) printf("INTLIT(%s)\n", yytext); update_position(yyleng, 0); last = 1; yylval.id_token = create_token(strdup(yytext), last_num_line, last_num_column); if(check2)return INTLIT;}
0*[1-9]((_)?{numbers})*                       {if(check) printf("INTLIT(%s)\n", yytext); update_position(yyleng, 0); last = 1; yylval.id_token = create_token(strdup(yytext), last_num_line, last_num_column); if(check2)return INTLIT;}
0[oO]?((_)?[0-7])*                          {if(check) printf("INTLIT(%s)\n", yytext); update_position(yyleng, 0); last = 1;yylval.id_token = create_token(strdup(yytext), last_num_line, last_num_column); if(check2)return INTLIT;}
0[xX]((_)?{numbers_Hexa})+                  {if(check) printf("INTLIT(%s)\n", yytext); update_position(yyleng, 0); last = 1; yylval.id_token = create_token(strdup(yytext), last_num_line, last_num_column); if(check2)return INTLIT;}  

[0-9]{nums_c}*{exp}{nums_c}                                      {if(check) printf("REALLIT(%s)\n", yytext); update_position(yyleng, 0); last = 1; yylval.id_token = create_token(strdup(yytext), last_num_line, last_num_column); if(check2)return REALLIT;}
0*{nums_c}"."({numbers}*)?({exp}{nums_c})?                             {if(check) printf("REALLIT(%s)\n", yytext); update_position(yyleng, 0); last = 1; yylval.id_token = create_token(strdup(yytext), last_num_line, last_num_column); if(check2)return REALLIT;}
"."{numbers}+({exp}{nums_c})?                                       {if(check) printf("REALLIT(%s)\n", yytext); update_position(yyleng, 0); last = 1; yylval.id_token = create_token(strdup(yytext), last_num_line, last_num_column); if(check2)return REALLIT;}


0[xX](({hexaNum}+("."{hexaN}*)?)|({hexaNum}*"."{hexaN}+))({expHexa}{nums_c})?                                    {if(check) printf("REALLIT(%s)\n", yytext); update_position(yyleng, 0); last = 1; yylval.id_token = create_token(strdup(yytext), last_num_line, last_num_column); if(check2)return REALLIT;}   
 


\"                                          {BEGIN STRINGT; initializeBlock(); initial_line = num_line; initial_column = num_column; update_position(yyleng, 0);}
"/""/".*                                    {update_position(yyleng, 0); if(last && check){ printf("SEMICOLON\n");} if(last){last = 0; if(check2)return SEMICOLON;} }
"/""*"                                      {BEGIN COMMENT; initial_column = num_column; initial_line = num_line; update_position(yyleng, 0);}

"package"                                   {if(check) printf("PACKAGE\n"); update_position(yyleng, 0); last = 0; if(check2)return PACKAGE;}
"return"                                    {if(check) printf("RETURN\n"); update_position(yyleng, 0); yylval.id_token = create_token("Return", last_num_line, last_num_column); last = 1; if(check2)return RETURN;}
"else"                                      {if(check) printf("ELSE\n"); update_position(yyleng, 0); last = 0; if(check2)return ELSE;}
"for"                                       {if(check) printf("FOR\n"); update_position(yyleng, 0); yylval.id_token = create_token("For", last_num_line, last_num_column); last = 0; if(check2)return FOR;}
"if"                                        {if(check) printf("IF\n"); update_position(yyleng, 0); yylval.id_token = create_token("If", last_num_line, last_num_column); last = 0; if(check2)return IF;}
"var"                                       {if(check) printf("VAR\n"); update_position(yyleng, 0); last = 0; if(check2)return VAR;}
"int"                                       {if(check) printf("INT\n"); update_position(yyleng, 0); last = 0; if(check2)return INT;}
"float32"                                   {if(check) printf("FLOAT32\n"); update_position(yyleng, 0); last = 0; if(check2)return FLOAT32;}
"bool"                                      {if(check) printf("BOOL\n"); update_position(yyleng, 0); last = 0; if(check2)return BOOL;}
"string"                                    {if(check) printf("STRING\n"); update_position(yyleng, 0); last = 0; if(check2)return STRING;}
"fmt.Println"                               {if(check) printf("PRINT\n"); update_position(yyleng, 0); last = 0; if(check2)return PRINT;}
"strconv.Atoi"                              {if(check) printf("PARSEINT\n"); update_position(yyleng, 0); yylval.id_token = create_token("ParseArgs", last_num_line, last_num_column);last = 0; if(check2)return PARSEINT;}
"func"                                      {if(check) printf("FUNC\n"); update_position(yyleng, 0); last = 0; if(check2)return FUNC;}
"os.Args"                                   {if(check) printf("CMDARGS\n"); update_position(yyleng, 0); last = 0; if(check2)return CMDARGS;}

{reserved}                                  {if(check) printf("RESERVED(%s)\n", yytext); update_position(yyleng, 0); last = 0; if (check2 && strcmp(yytext, "++")== 0) {return PLUSPLUS;}; if (check2 && strcmp(yytext, "--")== 0) {return MINUSMINUS;}}

"=="                                        {if(check) printf("EQ\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Eq", last_num_line, last_num_column); if(check2)return EQ;}
">="                                        {if(check) printf("GE\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Ge", last_num_line, last_num_column); if(check2)return GE;}
"<="                                        {if(check) printf("LE\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Le", last_num_line, last_num_column); if(check2)return LE;}
"!="                                        {if(check) printf("NE\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Ne", last_num_line, last_num_column); if(check2)return NE;}
"&&"                                        {if(check) printf("AND\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("And", last_num_line, last_num_column); if(check2)return AND;}
"||"                                        {if(check) printf("OR\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Or", last_num_line, last_num_column); if(check2)return OR;}

";"                                         {if(check) printf("SEMICOLON\n"); update_position(yyleng, 0); last = 0; if(check2)return SEMICOLON;}
","                                         {if(check) printf("COMMA\n"); update_position(yyleng, 0); last = 0; if(check2)return COMMA;}
"_"                                         {if(check) printf("BLANKID\n"); update_position(yyleng, 0); last = 0; if(check2)return BLANKID;}
"="                                         {if(check) printf("ASSIGN\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Assign", last_num_line, last_num_column); if(check2)return ASSIGN;}
"*"                                         {if(check) printf("STAR\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Mul", last_num_line, last_num_column); if(check2)return STAR;}
"/"                                         {if(check) printf("DIV\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Div", last_num_line, last_num_column); if(check2)return DIV;}
"-"                                         {if(check) printf("MINUS\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Sub", last_num_line, last_num_column); if(check2)return MINUS;}
"+"                                         {if(check) printf("PLUS\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Add", last_num_line, last_num_column); if(check2)return PLUS;}
">"                                         {if(check) printf("GT\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Gt", last_num_line, last_num_column); if(check2)return GT;}
"{"                                         {if(check) printf("LBRACE\n"); update_position(yyleng, 0); last = 0; if(check2)return LBRACE;}
"("                                         {if(check) printf("LPAR\n"); update_position(yyleng, 0); last = 0; if(check2)return LPAR;}
"["                                         {if(check) printf("LSQ\n"); update_position(yyleng, 0); last = 0; if(check2)return LSQ;}
"<"                                         {if(check) printf("LT\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Lt", last_num_line, last_num_column); if(check2)return LT;}
"%"                                         {if(check) printf("MOD\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Mod", last_num_line, last_num_column); if(check2)return MOD;}
"!"                                         {if(check) printf("NOT\n"); update_position(yyleng, 0); last = 0; yylval.id_token = create_token("Not", last_num_line, last_num_column); if(check2)return NOT;}
"}"                                         {if(check) printf("RBRACE\n"); update_position(yyleng, 0); last = 1; if(check2)return RBRACE;}
")"                                         {if(check) printf("RPAR\n"); update_position(yyleng, 0); last = 1; if(check2)return RPAR;}
"]"                                         {if(check) printf("RSQ\n"); update_position(yyleng, 0); last = 1; if(check2)return RSQ;}

[a-zA-Z_]{id_characters}*                    {if(check) printf("ID(%s)\n", yytext); update_position(yyleng, 0); last = 1; yylval.id_token = create_token(strdup(yytext), last_num_line, last_num_column); if(check2)return ID;}

" "                                         {update_position(yyleng, 0);}
\t                                          {update_position(yyleng, 0);}
\r                                          {;}
.                                           {printf("Line %d, column %d: illegal character (%s)\n", num_line, num_column, yytext); update_position(yyleng, 0);}
\r\n|\r|\n                                 {if(last && check){printf("SEMICOLON\n");} 
                                            if(last){ last = 0; 
                                                if(check2) {update_position(yyleng, 3); 
                                                    return SEMICOLON;
                                                }
                                            } 
                                            update_position(yyleng, 3);}
<INITIAL><<EOF>>                            {if(check && last) {printf("SEMICOLON\n");} if(last && check2){BEGIN(SEMICOLOEND); return SEMICOLON;} if(check2){BEGIN(REALLYEND); return END;} return 0;}
<SEMICOLOEND><<EOF>>                               {BEGIN(REALLYEND); return END;}
<REALLYEND><<EOF>>                          {return 0;}

<STRINGT>"\""                                {BEGIN 0;ptr[counter++] = '\0';
                                                    if(check && string_error == 0) { 
                                                        last = 1;
                                                        printf("STRLIT(\"%s\")\n", ptr); }
                                                        
                                                    if(string_error == 0 && check2){
                                                        last = 1;
                                                        
                                                        yylval.id_token = create_token(strdup(ptr), initial_line, initial_column);
                                                        freeBlock();
                                                        update_position(yyleng, 0);
                                                        return STRLIT;
                                                    }
                                                    
                                                    freeBlock();
                                                    update_position(yyleng, 0); }

<STRINGT>\\f                                 {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 'f'; checkBlock(); update_position(yyleng, 0);}
<STRINGT>\\n                                 {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 'n'; checkBlock(); update_position(yyleng, 0);}
<STRINGT>\\r                                 {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 'r'; checkBlock(); update_position(yyleng, 0);}
<STRINGT>\\t                                 {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = 't'; checkBlock(); update_position(yyleng, 0);}
<STRINGT>\\\r                                 {printf("Line %d, column %d: invalid escape sequence (%c)\n", num_line, num_column, *yytext); string_error = 1; update_position(yyleng, 0);}

<STRINGT>\\\"                                {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = '\"'; checkBlock(); update_position(yyleng, 0);}
<STRINGT>"\\\\"                              {ptr[counter++] = '\\'; checkBlock(); ptr[counter++] = '\\'; checkBlock(); update_position(yyleng, 0);}                                                    
<STRINGT>\\[^fnrt]?                          {printf("Line %d, column %d: invalid escape sequence (%c%c)\n", num_line, num_column, *yytext, *(yytext+1)); string_error = 1; update_position(yyleng, 0);}

<STRINGT>.                                   {ptr[counter++] = *yytext; checkBlock(); update_position(yyleng, 0);}

<STRINGT>\n                                  {printf("Line %d, column %d: unterminated string literal\n", num_line, initial_column);     
                                                update_position(yyleng, 3);
                                                freeBlock();
                                                BEGIN 0;
                                                last = 0;}

<STRINGT><<EOF>>                             {printf("Line %d, column %d: unterminated string literal\n", num_line, initial_column); freeBlock(); if(last && check){printf("SEMICOLON");} if(last && check2){ BEGIN(SEMICOLOEND); return SEMICOLON;} if(check2){BEGIN(REALLYEND); return END;} return 0;}




<COMMENT>"*""/"                             {BEGIN 0; update_position(yyleng, 0);}
<COMMENT><<EOF>>                            {printf("Line %d, column %d: unterminated comment\n", initial_line, initial_column); if(check2){BEGIN(REALLYEND); return END;} return 0;}
<COMMENT>.                                  {update_position(yyleng, 0);}
<COMMENT>\n                                 {last = 0; update_position(yyleng, 3); if(check && last){ printf("SEMICOLON\n");} if(last && check2){return SEMICOLON;} }



%%

void yyerror ( char *s) { 
    error = 1;
    if (strcmp(yytext, "\"") == 0) {
        // syntax error: "
        printf ("Line %d, column %d: %s: \"%s\"\n", initial_line, initial_column, s, yylval.id_token->symbol);
    } else printf ("Line %d, column %d: %s: %s\n", last_num_line, last_num_column, s, yytext);
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
                case 's':
                    check3 = 1;
                    check2 = 1;
                    break;

            }
            counter++;
        }

    }
    if (check3) {
        yyparse();

        if(!error){
            tab root_table = createAllTables(start_node);
                        
            createAstAnotated(start_node, root_table, 0);

            checkParams(root_table);
            printTables(root_table); 
            printTree(start_node,0, 1);  
            freeTables(root_table);
        }
        
        freeTree(start_node);
        
        check2 = 0;

    } else if (check2) {
        yyparse();

        if(!error){
            printTree(start_node,0, 0);  
        }
        
        freeTree(start_node);

    } else if (check) {
         yylex();
    } else {
        check2 = 1;
        yyparse();

        if(!error){
            tab root_table = createAllTables(start_node);
            createAstAnotated(start_node, root_table, 1);
            int error_occured = checkParams(root_table);
            
            if(!error_occured){
                string_glob root_strings = globalStrings(start_node, NULL, 1);
                printStrings(root_strings);
                printGlobals(root_table);
                createAssembly(start_node, root_strings);

                freeTables(root_table);
                freeStrings(root_strings);

            }


        }
        
        freeTree(start_node);
        
        check2 = 0;
    }

    return 0;
}

