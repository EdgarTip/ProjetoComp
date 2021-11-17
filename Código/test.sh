#  Utilização
#  Adicionar gocompiler (compilado) ao PATH
#  (uma boa opção é adicionar a directoria da meta1 ao PATH)
#  Após compilar executar este script
#
#  Funcionalidade
#  Compara todos os casos de teste na pasta meta1
#  Cria o ficheiro *casoteste*.out_temp com resultado de correr cada caso de teste
#
#  Flags
#  -c apagar os ficheiros *casotest*.out_temp após correr cada caso de teste

#   Comandos:
#       lex gocompiler.l && yacc -d -v  gocompiler.y && clang-7 lex.yy.c y.tab.c tree.c -o gocompiler
#       ./test.sh

dgos=`ls ./meta2/*.dgo`
for ef in $dgos
do
   echo "$ef"
   A=${ef//\.dgo/.out_temp}
   B=${ef//\.dgo/.out}
   ./gocompiler -t < $ef > $A
   diff $A $B
   if test ! -z $1 && test $1 = "-c"; then
      rm -Rf $A
   fi
done