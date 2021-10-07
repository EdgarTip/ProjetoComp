 //Edgar Duarte 
%{
    int check = 0;
%}
%%
["case""break"]             {printf("gay\n");}
%%
int main(int argc, char* argv[])
{
    

    yylex();
    return 0;
}

int yywrap()
{
return 1;
}



