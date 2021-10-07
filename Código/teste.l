 //Edgar Duarte 
%X ERRORS
%{
    int check = 0;
%}
%%
.                           {;}
\n                          {;}
<ERRORS>a                    {printf("Yo\n");}
<ERRORS>.                    {;}
<ERRORS>\n                    {;}
%%
int main(int argc, char* argv[])
{
    
    if(argc == 2){
        if(strcmp(argv[1], "-l") == 0){
            BEGIN ERRORS;
        }
    }
    yylex();
    return 0;
}

int yywrap()
{
return 1;
}



