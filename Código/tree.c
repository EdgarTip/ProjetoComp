#include "tree.h"
#include <string.h>
#include <ctype.h>

tab root_table = NULL;
//--Tree--

//Creates a token
id_token create_token(char *value, int line, int col) {
  id_token tok = (struct token *)malloc(sizeof(struct token));
  tok->symbol = value;
  tok->line = line;
  tok->column = col;
  return tok;
}

//Creates a new node
tree_list create_node(enum class_name class, char *symbol, int line, int column, id_token tok){

    tree_list list = (struct node_list *)malloc(sizeof(struct node_list));

     if (list == NULL && sizeof(list) > 0){
            printf("MALLOC ERROR LIST\n");
            //freeTree();
            exit(0);
        } 

    list->node = (struct node *)malloc(sizeof(struct node));

    //If malloc fails
        if (list->node == NULL && sizeof(list->node) > 0){
            printf("MALLOC ERROR NODE\n");
            //freeTree();
            exit(0);
        } 

    if(tok == NULL){
        list->node->token = (struct token*)malloc(sizeof(struct token));
        
        //If malloc fails
        if (list->node->token == NULL && sizeof(id_token) > 0){
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
void printTree(tree_list list, int depth, int semantic){
    for(int i = 0; i < depth; i++){
        printf("..");
    }
    switch(list->node->class){
        case IDE:
        {
            if(!semantic || list->node->type == NULL)printf("Id(%s)\n", list->node->token->symbol);
            else printf("Id(%s) - %s\n", list->node->token->symbol, list->node->type);
            break;
        }
        case REALLITE:
        {
            if(!semantic || list->node->type == NULL) printf("RealLit(%s)\n", list->node->token->symbol);
            else printf("RealLit(%s) - %s\n", list->node->token->symbol, list->node->type);
            break;
        }
        case STRLITE:
        {
             if(!semantic || list->node->type == NULL)printf("StrLit(\"%s\")\n", list->node->token->symbol);
             else printf("StrLit(\"%s\") - %s\n", list->node->token->symbol, list->node->type);
            break;
        }
        case INTLITE:
        {
            if(!semantic || list->node->type == NULL) printf("IntLit(%s)\n", list->node->token->symbol);
            else printf("IntLit(%s) - %s\n", list->node->token->symbol, list->node->type);
            break;
        }
        case INTE:
        {
            printf("Int\n");
            break;
        }
        default:
        {
            if(!semantic || list->node->type == NULL)printf("%s\n", list->node->token->symbol);
            else printf("%s - %s\n", list->node->token->symbol, list->node->type);
            break;
        }
    }

    //Sees if it has childs
    if(list->node->children != NULL){
        printTree(list->node->children, depth +1, semantic);
    }

    if(list->next != NULL){
        printTree(list->next, depth, semantic);
    }

}


//--Semantic Tables--
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

void printParams(param params){
    param aux2 = params;

    while( aux2 != NULL){

        char *lower = calloc(strlen(aux2->params)+1, sizeof(char));

        int i = 0;
        for(; i<strlen(aux2->params); i++){
            lower[i] = tolower((unsigned char)aux2->params[i]);
        }

        lower[i++] = '\0';
        if(aux2->next != NULL)printf("%s, ", lower);
        else printf("%s", lower);
        
        free(lower);
        aux2 = aux2->next;
    }
    return;
}

//Finds a table by its name. Returns NULL if table is not found
tab findTable(tab root, char *name){

    tab aux = root;

    while(aux != NULL){
        if(strcmp(aux->name, name) == 0){
            return aux;
        }

        aux = aux->next;
    }
    return NULL;
}

void printElems(elem_table element){

    elem_table aux1 = element; 
    while(aux1 != NULL){
        printf("%s\t", aux1->value);

        tab is_table= findTable(root_table, aux1->value);

        //If table doesn't exist then we pass the table element
        if(is_table!=NULL){
            
            printf("(");
            printParams(aux1->first_param); 
            printf(")");
        }
        
        printf("\t%s", aux1->type);
        if(aux1->is_param){
            printf("\tparam\n");
        }
        else{
            printf("\n");
        }
        aux1 = aux1->next;
    }    
    printf("\n");

}




void printTables(tab root){
    if(root == NULL) return;

    if(strcmp(root->name, "global") == 0){
        printf("===== Global Symbol Table =====\n");
    }
    else{
        printf("===== Function %s(", root->name);
        printParams(root->first_param);
        printf(") Symbol Table =====\n");

    }

    if(root->first_elem !=NULL){
        printElems(root->first_elem);
    } 

    printTables(root->next);

}

param addParameter( param root,param new_param){

    if(root == NULL){
        return new_param;
        
    }

    param aux = root;
    while(aux->next != NULL){
        aux = aux->next;
    }
    aux->next = new_param;
    return root;
}


param createParam(char *value){
    param parameter = (struct parameter *) malloc(sizeof(struct parameter));

    parameter->params = value;
    parameter->next = NULL;

    return parameter; 
}



//Insert a new element to a table
void insertElementTable(tab table, elem_table element){

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

//Create a new element
elem_table createElem(char *value,  char *type, param parameter, int is_param){
    elem_table elem = (struct element_table*)malloc(sizeof(struct element_table));

    elem->value = value;
    elem->type = type;
    elem->first_param = parameter;
    elem->is_param = is_param;
    elem->next = NULL;
  
    return elem;
}



//Create a new table. If it is the global one starts global table variable
tab createTable(elem_table table_element, int is_global){

    tab new_table = (struct table*)malloc(sizeof(struct table));
    if(!is_global){
        new_table->first_elem= createElem("return", table_element->type, NULL, 0);


        new_table->first_param = table_element->first_param;
        new_table->name = table_element->value;
    }

    //If there is still no root table
    if(root_table == NULL){
        new_table->name = "global";
        new_table->first_elem = NULL;
        new_table->first_param = NULL;
        new_table->next = NULL; 
        root_table = new_table;
        return root_table;
    }
    //If there is a root table then we add to the next *next avaiable
    else{
        tab aux = root_table;
        while(aux->next != NULL){
            aux = aux->next;
        }
        aux->next = new_table;
    }

    return new_table;
}


//Checks for variables in function body
void funcBodyTable(tree_list root, tab table){

    if(root == NULL) return;

    switch(root->node->class){
        case VARDEC:
        {
            tree_list var_type = root->node->children;
            tree_list var_id = var_type->next;
            //Insert new value into current table
            if(!checkExists(table, var_id->node->token->symbol)){ 
                
                insertElementTable(table, createElem(var_id->node->token->symbol, var_type->node->token->symbol, NULL, 0));
            }
            else{


                printf("Line %d, column %d: Symbol %s already defined\n", var_id->node->token->line, var_id->node->token->column, var_id->node->token->symbol);
            }
            if(root->next != NULL){
                funcBodyTable(root->next, table);
            }
            break;
            
        }
        default:
        {   
            if(root->node->children != NULL){
                funcBodyTable(root->node->children, table); 
            }

            if(root->next != NULL){
                funcBodyTable(root->next, table);
            }
            break;
        }
    }

    return;

    
}
    

//Creates all tables and anotaded tree (in function body)
tab createAllTables(tree_list root){
    
    tab current_table = NULL;
    
    if(root == NULL){
        return root_table;
    }

    switch(root->node->class){
        case PROGRAM:
        {
            current_table = createTable(NULL, 1);
            createAllTables(root->node->children);
            return root_table;
            break;
        }
        case FUNCDECL:
        {
            tree_list func_header = root->node->children;
            tree_list func_id = func_header->node->children;
            
            tree_list func_type;
            tree_list func_param;

            
            if(func_id->next->node->class != PARAMETERS){
                 func_type = func_id->next;
                 func_param = func_type->next;
            }
            //In case a node type does not exist
            else{
                func_type = NULL;
                func_param = func_id->next;
            }
            //Params
            param param_root = NULL;
             
            tree_list func_param_dec = func_param->node->children;
            
            //Sees if function has parameters
            if(func_param_dec != NULL){
                //Add all parameters
                
                while(func_param_dec != NULL){
                    tree_list param_type = func_param_dec->node->children;

                    param aux = createParam(param_type->node->token->symbol);
                    param_root = addParameter(param_root, aux);

                    func_param_dec = func_param_dec->next;
                }

            }
            
            else{
                
                param_root = NULL;
            }

            //Insert new value into root table and create a new table
            if(!checkExists(root_table, func_id->node->token->symbol)){ 
                
                char *type;

                if(func_type != NULL){
                    type =  func_type->node->token->symbol;
                }
                else{
                    type = "none";
                }

                elem_table func_elem = createElem(func_id->node->token->symbol, type, param_root, 0);

                insertElementTable(root_table, func_elem);
                current_table = createTable(func_elem, 0);

                //add all parameters as elements in new table  
                func_param_dec =  func_param->node->children;

                if(func_param_dec != NULL){

                    //Add all parameters
                    while(func_param_dec != NULL){
                        //Param Type
                        tree_list param_type = func_param_dec->node->children;
                        //Param Id
                        tree_list param_id = param_type->next;
                        if(!checkExists(current_table, param_id->node->token->symbol)){
                            insertElementTable(current_table, createElem(param_id->node->token->symbol, param_type->node->token->symbol, NULL, 1));
                       
                        }
                        else{
                            printf("Line %d, column %d: Symbol %s already defined\n", param_id->node->token->line, param_id->node->token->column, param_id->node->token->symbol);
                        }
                        
                        func_param_dec = func_param_dec->next;
                    }
                }   
                
                funcBodyTable(func_header->next, current_table);

            }
            else{
                
                printf("Line %d, column %d: Symbol %s already defined\n", func_id->node->token->line, func_id->node->token->column, func_id->node->token->symbol);
            }

            
            break;
        }
        case VARDEC:
        {
            //Insert a new value to the root table. Get the value of the brother of the child, type of the child and parameters are none
            //VARDEC
            tree_node dad_node = root->node;
            //TYPE
            tree_list child1 = dad_node->children;
            //ID
            tree_list child2 = child1->next;
        
            //Insert new value into current table
            if(!checkExists(root_table, child2->node->token->symbol)){ 
                insertElementTable(root_table, createElem(child2->node->token->symbol, child1->node->token->symbol, NULL, 0));
            }

            else{
                printf("Line %d, column %d: Symbol %s already defined\n", child2->node->token->line, child2->node->token->column, child2->node->token->symbol);
            }
            
            break;
        }

        default:
        {
            break;
        }

    }

    createAllTables(root->next);
    return root_table;


}

//Checks if there is a element either in the current function table or the global table. Returns type
//TODO: VER SE TEM 2 REPETIDOS
elem_table findElement(tab table, char *value){
    
    //See if variable is in local table
    elem_table aux1 = table->first_elem;
    while(aux1 != NULL){
        if(strcmp(aux1->value, value) == 0){
            return aux1;
        }

        aux1 = aux1->next;
    }

    //See if variable is in global table
    elem_table aux2 = root_table->first_elem;
    while(aux2 != NULL){
        if(strcmp(aux2->value, value) == 0){
            return aux2;
        }

        aux2 = aux2->next;
    }
    return NULL;
}


//Logic for the semantic tree inside a function
void createAstAnotatedInsideFunc(tree_list root, tab table){

    if(root == NULL) return;

    if(root->next != NULL){
        createAstAnotatedInsideFunc(root->next, table);
    }

    if(root->node->children != NULL){
        createAstAnotatedInsideFunc(root->node->children, table);
    } 

    switch(root->node->class){
        case INTLITE:
        {
            root->node->type = "int";
            break;
        }
        case IDE:
        {   
            
            //Sees if element exists and if it does then gets the type as a return parameter. If it receives no value it means it does not exist
            elem_table elem = findElement(table, root->node->token->symbol);
            if(elem == NULL){
                printf("Line %d, column %d: Cannot find symbol %s\n", root->node->token->line, root->node->token->column, root->node->token->symbol);
                root->node->type = "undef";
            }
            else{
                root->node->type = elem->type;
            }
            
            
            break;
        }
        case REALLITE:
        {
            root->node->type = "float32";
            break;
        }
        case STRLITE:
        {
            root->node->type = "string";
            break;
        }
        //In this case we need to reset the type of the ID to null because we do not want declarated variables to show their type on the final tree
        case VARDEC:
        {
            root->node->children->next->node->type = NULL;
            break;
        }
        //We have to check if second child is type INTLIT and parse args gets type of first child
        case PARSEARGS:
        {   
            

            if(root->node->children->next->node->class != INTLITE){
                printf("Erro parse args invalido dentro parentises\n");            
                root->node->type = "undef";

            }
            if(strcmp(root->node->children->node->type, "int")!= 0){
                printf("Erro parse args invalido la fora\n");

            }
            
            root->node->type = "int";
            
            break;
        }
        // TODO HAVE INFINITE PARAMETERS (IN CASE FUNCTION HAS INFINITE PARAMETERS)
        case CALL:
        {
            tree_list function = root->node->children;
            tree_list parameter = function->next; 

            //See if parameters piut in the function are correct and in the correct order
            
            tab table = findTable(root_table, function->node->token->symbol);

            if(table == NULL){
                printf("ERRO tabela não exite\n");
                return;
            }

            param func_params = table->first_param;

            
            while(func_params != NULL){
                if(parameter == NULL){
                    printf("Missing parameters\n");
                    root->node->type = "undef";
                    root->node->children->node->type = "undef";
                    return;
                }

                if(strcmp(func_params->params, parameter->node->type) != 0){
                    printf("ERROR\n");
                }

                func_params = func_params->next;
                parameter = parameter->next;
            }
    
            if(parameter != NULL){
                printf("ERROR too many parameters\n");
                root->node->type = "undef";
                root->node->children->node->type = "undef";
                return;
            }

            //Creates the string in format "(value)"
            char *string = malloc(strlen(root->node->children->node->type) +3 );
            strcpy(string, "(");
            strcat(string, root->node->children->node->type);
            strcat(string, ")");


            
            root->node->type = table->first_elem->type;
            root->node->children->node->type = string;
            break;
        }
        case OPERATOR:
        {

            tree_list child1 = root->node->children;

            tree_list child2 = child1->next;
            
            if(strcmp(child1->node->type, child2->node->type) == 0){
                root->node->type = child2->node->type;
            }
            else{
                printf("ERRO DE TIPOS DIFERENTES EM OPERADORES\n");
            }
            break;
        }
        case CONDITIONOPERATOR:
        {
            tree_list child1 = root->node->children;

            tree_list child2 = child1->next;

            if(strcmp(child1->node->type, child2->node->type) == 0){
                root->node->type = "bool";
            }
            else{
                printf("ERRO DE TIPOS DIFERENTES EM OPERADORES\n");
                root->node->type = "undef";
            }
        
            break;
        }
        default:
        {
            break;
        }
    }

    
    return;


}


void createAstAnotated( tree_list root, tab table){
    if(root == NULL) return;
    switch(root->node->class){
        case FUNCDECL:
        {
            tree_list func_head = root->node->children;
            tree_list func_id  = func_head->node->children;

            tab current_table = findTable(root_table, func_id->node->token->symbol);

            if(current_table != NULL){

                createAstAnotatedInsideFunc(func_head->next, current_table);

                
            }
            else{
                printf("Line %d, column %d: Cannot find symbol %s\n", func_id->node->token->line, func_id->node->token->column, func_id->node->token->symbol);
            }

            if(root->next != NULL){

                createAstAnotated(root->next, root_table);
            } 
            break;
        }



        default:
        {   
            
            if(root->node->children != NULL){
                createAstAnotated(root->node->children, root_table); 
                
            }

            if(root->next != NULL){
                createAstAnotated(root->next, root_table);
            }
            
        }
    }

    return;


}

