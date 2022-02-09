# ProjetoComp
Projeto de Compiladores 2021/2022


Implementation of a GO compiller, that translates the GO language to C language. 


How to use:

Be sure to have a C interpreter (for example clang) and be sure to be in a linux environment!
 
For goal 1 use commands: lex gocompiler.l 
                         clang -o gocompiler lex.yy.c (in some cases you might need to use clang-7 -o gocompiler.l lex.yy.c)
                         ./gocompiler -l

For goals 2-4 use commands: lex gocompiler.l && yacc -d  gocompiler.y && clang-7 lex.yy.c y.tab.c tree.c -o gocompiler
                            ./gocompiler -t (for goal2) ./gocompiler -s (for goal 3) ./gocompiler  (for goal 4)

If you want to use a test case from the tests folder use the following example command (for goal 3): ./gocompiler -s < ../Tests/(name_of_file.dgo)







Implemented by: 
Edgar Filipe Ferreira Duarte |
Rodrigo Francisco Ferreira
