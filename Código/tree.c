#include "tree.h"

//Creates a new node
tree_list create_node(enum class_name class, char *symbol, int line, int column ){

    tree_list list = malloc(sizeof(tree_list));

     if (list == NULL && sizeof(list) > 0){
            printf("MALLOC ERROR LIST\n");
            //freeTree();
            exit(0);
        } 

    list->node = malloc(sizeof(tree_node));

    //If malloc fails
        if (list->node == NULL && sizeof(list->node) > 0){
            printf("MALLOC ERROR NODE\n");
            //freeTree();
            exit(0);
        } 

    list->node->token = malloc(sizeof(struct token));

    //If malloc fails
    if (list->node->token == NULL && sizeof(struct token) > 0){
        printf("MALLOC ERROR TOKEN\n");
        //freeTree();
        exit(0);
    } 

    list->next = NULL;
    list->node->token->symbol = symbol;
    list->node->token->line = line;
    list->node->token->column = column;
    list->node->class = class;
    list->node->children = NULL;

    return list;

}

void add_next(tree_list new_node, tree_list next_node){
    if(new_node == NULL || next_node == NULL){
        return;
    }

    new_node->next = next_node;
}

void add_max_next(tree_list new_node, tree_list next_node){
    if(new_node == NULL || next_node == NULL){
        return;
    }

    while(new_node->next != NULL){
        new_node = new_node->next;
    }

    new_node->next = next_node;
}

int number_of_children(tree_list node){

    if(node == NULL ) return 0;

    int counter = 1;

    while(node->next != NULL){
        node = node->next;
        counter++;
    }

    return counter;
}



//Adds a new child to the tree
void addChild(tree_list root, tree_list new_child){

    if(new_child == NULL){
        return;
    }
    
    if(root->node->children == NULL){
        root->node->children = new_child;
    }
    else{
        tree_list current_child = root->node->children;
        while (current_child->next != NULL){
            current_child = current_child->next;
        }

        current_child->next = new_child;
    }
}


void addChildStart(tree_list root, tree_list new_child){
    if(new_child == NULL){
        return;
    }

    if(root->node->children == NULL){
        root->node->children = new_child;
    }
    else{
        tree_list current_child = root->node->children;
        root->node->children = new_child;

        new_child->next = current_child;
    }
}


void add_child_to_all(tree_list root, tree_list child){
    if(root == NULL || child == NULL){
        return;
    }


    tree_list aux = root;
    while(aux != NULL){
        tree_list aux2 = create_node(child->node->class, child->node->token->symbol, 0,0);
        addChildStart(aux, aux2);
        aux = aux->next;

    }
}


//Frees the resources allocated during the creation of the program
void freeTree(tree_list root){
    if(root == NULL){
        return;
    }
    //Sees if it has children
    if(root->node->children != NULL){
        freeTree(root->node->children);
    }

    if(root->next != NULL){
        freeTree(root->next);
    }

    free(root->node->token);
    free(root->node);
    free(root);
}

//Prints the tree in the form of the:
/* 
tree:
    node (symbol = "1")
     ||
     ||
    node1 (symbol = "2")---node2 (symbol = "3")
     ||
     ||
node3 (symbol = "4")                       


output:
1
..2
....4
..3
*/
void printTree(tree_list list, int depth){
    for(int i = 0; i < depth; i++){
        printf("..");
    }
    switch(list->node->class){
        case IDE:
            printf("Id(%s)\n", list->node->token->symbol);
            break;
        case REALLITE:
            printf("RealLit(%s)\n", list->node->token->symbol);
            break;
        case STRLITE:
            printf("StrLit(\"%s\")\n", list->node->token->symbol);
            break;
        case INTLITE:
            printf("IntLit(%s)\n", list->node->token->symbol);
            break;
        default:
            printf("%s\n", list->node->token->symbol);
            break;
    }

    //Sees if it has childs
    if(list->node->children != NULL){
        printTree(list->node->children, depth +1);
    }

    if(list->next != NULL){
        printTree(list->next, depth);
    }

}
/*
int find_last_node(tree_list root) {
    for(;root->next != NULL; root = root->next);
    printf("")

}*/