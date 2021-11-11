//Ficheiro header das funcoes necessárias para a criação da árvore sintatica


#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#define SIZE 120



typedef struct node *tree_node;

/**
 * type : type implemented
 * children: all the children that can appear from a production
 * parent: parent of current node
 * collumn : collumn where found
 * line : line where found
 */
struct node{

    char type[SIZE];
    tree_node *children;
    tree_node parent;
    
    int line;
    int collumn;
};