#include "tree.h"

//Adds a node to the tree
tree_node add_node(char type[SIZE]){

    tree_node node = malloc(sizeof(tree_node));

    //If malloc fails
    if (node == NULL && sizeof(tree_node) > 0){
        printf("MALLOC ERROR\n");
        //freeTree();
        exit(0);
    } 

    //If malloc is sucessfull then we create the new node
    strcpy(node->type, type);
    return node;

}

//Function that frees all the elements in the tree
void freeTree(tree_node root){
    
    //If the tree is empty
    if(root == NULL) return;

    //Get current node
    tree_node current_node = root;

    //Go through all the children and free them
    for(int i = 0; i < sizeof(current_node->children) / sizeof(tree_node); i++){
        freeTree(current_node->children[i]);
    } 

    free(current_node);
}