%X  STRING

%%

\"                          {BEGIN STRING;printf("STRLIT(");}
"<="                        {printf("LE\n");}
"!="                        {printf("NE\n");}

">"                         {printf("GT\n");}
"{"                         {printf("LBRACE\n");}
"("                         {printf("LPAR\n");}
"["                         {printf("LSQ\n");}
"<"                         {printf("LT\n");}
"%"                         {printf("MOD\n");}
"!"                         {printf("NOT\n");}

<STRING>"\""                {BEGIN 0;printf(")\n");}
<STRING>\\f                 {printf("\f");}
<STRING>\\n                 {printf("\n");}
<STRING>\\r                 {printf("\r");}
<STRING>\\t                 {printf("\t");}
<STRING>\\                  {printf("\\");}     
<STRING>\\\"                {printf("\"");} 
<STRING>.                   {ECHO;}         

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
