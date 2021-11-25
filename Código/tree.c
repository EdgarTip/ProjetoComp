#include "tree.h"


tab root_table = NULL;
//--Tree--

//Creates a token
id_token create_token(char *value, int line, int col) {
  id_token tok = malloc(sizeof(id_token));
  tok->symbol = value;
  tok->line = line;
  tok->column = col;
  return tok;
}

//Creates a new node
tree_list create_node(enum class_name class, char *symbol, int line, int column, id_token tok){

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

    if(tok == NULL){
        list->node->token = malloc(sizeof(struct token));
        
        //If malloc fails
        if (list->node->token == NULL && sizeof(struct token) > 0){
            printf("MALLOC ERROR TOKEN\n");
            //freeTree();
            exit(0);
    } 

        list->node->token->symbol = symbol;
        list->node->token->line = line;
        list->node->token->column = column;
    }
    else{
        list->node->token = tok;
    }

    list->next = NULL;
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
        tree_list aux2 = create_node(child->node->class, child->node->token->symbol, 0,0, NULL);
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


//--Semantic Tables--

//Returns the root table
void createAllTables(tree_list root, tab current_table){
    if(root = NULL){
        return;
    }
    switch(root->node->class){
        case PROGRAM:
            current_table = createTable(NULL, 1);
            createAllTables(root->node->children, current_table);
            break;

        case FUNCDECL:
            tree_list func_id = root->node->children->node->children;
            tree_list func_type = func_id->next;

            //Params
            char *params;
            tree_list func_param = func_type->next;

            if(func_param->node->children != NULL){
                int first = 1;
                while(func_param != NULL){
                    tree_list param_type = func_param->node->children;
                    tree_list param_id = param_type->next;

                    if(first){
                        params = strcat(params, "(");
                        params = strcat(params, param_type->node->token->symbol);
                    }
                    else{
                        params = strcat(params, ",");
                        params = strcat(params, param_type->node->token->symbol);
                        
                    }
                    first = 0;
                }
                params = strcat(params, ")");
            }
            else{
                params = "none";
            }
            //Insert new value into current table
            if(!checkExists(current_table, func_id->node->token->symbol)){ 

                instertElementTable(root_table, createElem(func_id->node->token->symbol, func_id->node->token->symbol, params));
            }
            else{
                printf("Line %d, column %d: Symbol %s already defined\n", func_id->node->token->line, func_id->node->token->column, func_id->node->token->symbol);
            }
            break;

        case VARDEC:
            //Insert a new value to the table. Get the value of the brother of the child, type of the child and parameters are none
            //VARDEC
            tree_node dad_node = root->node;
            //TYPE
            tree_list child1 = dad_node->children;
            //ID
            tree_list child2 = child1->next;
        
            //Insert new value into current table
            if(!checkExists(current_table, child2->node->token->symbol)){ 

                instertElementTable(current_table, createElem(child2->node->token->symbol, child1->node->token->symbol, ""));
            }

            else{
                printf("Line %d, column %d: Symbol %s already defined\n", child2->node->token->line, child2->node->token->column, child2->node->token->symbol);
            }
            createTable(root->next, current_table);
            break;

    }



}


//Insert a new element to a table
void instertElementTable(tab table, elem_table element){
    if(table->first_elem == NULL){
        table->first_elem = element;
        return;
    }

    elem_table aux = table->first_elem;

    while(aux->next != NULL){
        aux = aux->next;
    }
    aux->next = element;
    
    
}

//Create a new table. If it is the global one starts global table variable
tab createTable(elem_table table_element, int is_global){

    tab new_table = malloc(sizeof(tab));
    if(!is_global){
        new_table->first_elem= createElem("return", "", table_element->type);

        char *str = strcat(table_element->value, table_element->parameters);
        new_table->name = str;
    }

    if(root_table == NULL){
        root_table = new_table;
        return;
    }
    else{
        tab aux = root_table;
        while(aux->next != NULL){
            aux = aux->next;
        }
        aux->next = new_table;
    }
}

//Create a new element
elem_table createElem(char *value,  char *type, char *parameter){
    elem_table elem = malloc(sizeof(elem_table));

    elem->value = value;
    elem->type = type;
    elem->parameters = parameter;
    elem->next = NULL;

    return elem;
}


int checkExists(tab table, char* name){
    elem_table aux = table->first_elem;

    while(aux != NULL){
        if(strcmp(aux->value, name) == 0){
            return 1;
        }
        aux = aux->next;
    }
    
    return 0;
}