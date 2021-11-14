
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "tree.h"



int main(int argc, char **argv){
    tree_list root = create_node(PROGRAM, "Program", 2,3);
    tree_list node1 = create_node(FUNCDECL, "FuncDecl", 4, 5);
    tree_list node2 = create_node(FUNCDECL, "FuncDecl2", 9 ,10);
    tree_list node3 = create_node(IDE, "factorial", 9 ,10);
    tree_list node4 = create_node(INTE, "int", 9 ,10);
    tree_list node5 = create_node(PARAMETERS, "FuncParams", 9 ,10);
    tree_list node6 = create_node(PARAMETERS, "Parameters2", 9 ,10);
    tree_list node7 = create_node(INTE, "int", 9 ,10);
    tree_list node8 = create_node(IDE, "n", 9 ,10);
    tree_list node9 = create_node(FUNCBODY, "Func Body", 0,0);
    tree_list node10 = create_node(FUNCBODY, "If", 0,0);
    tree_list node11 = create_node(FUNCBODY, "EQ", 0,0);
    tree_list node12 = create_node(IDE, "n", 0,0);

    addChild(root, node1);
    addChild(node1, node2);
    addChild(node2, node3);
    addChild(node2, node4);
    addChild(node2, node5);
    addChild(node5, node6);
    addChild(node6, node7);
    addChild(node6, node8);
    addChild(node1, node9);
    addChild(node9, node10);
    addChild(node10, node11);
    addChild(node11, node12);

    printTree(root, 0);

    freeTree(root);
    return 0;
}