//Criado por Edgar Duarte e Rodrigo Ferreira
#include "tree.h"
#include <string.h>
#include <ctype.h>

tab root_table = NULL;
int first_time_int = 1;
int first_time_float = 1;
int first_time_assign = 0;
int error_ast = 0;
int returned = 0;
//--Tree--

//Creates a token
id_token create_token(char *value, int line, int col) {
  id_token tok = (struct token *)malloc(sizeof(struct token));
  tok->symbol = value;
  tok->line = line;
  tok->column = col;
  tok->first_param = NULL;
  return tok;
}

//Creates a new node
tree_list create_node(enum class_name class,int parent_is_call, char *symbol, int line, int column, id_token tok){

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
        list->node->token->first_param = NULL;
    }
    else{
        list->node->token = tok;
    }

    list->next = NULL;
    list->node->class = class;
    list->node->children = NULL;
    list->node->parent_is_call = parent_is_call;

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
        tree_list aux2 = create_node(child->node->class, 0, child->node->token->symbol, 0,0, NULL);
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

char * lowerString(char *string){

    char *lower = calloc(strlen(string)+1, sizeof(char));

        int i = 0;
        for(; i<strlen(string); i++){
            lower[i] = tolower((unsigned char)string[i]);
        }

        lower[i++] = '\0';
        return lower;
        
}

void printParams(param params){
    param aux2 = params;
    
    while( aux2 != NULL){

        char *lower = lowerString(aux2->params);
        if(aux2->next != NULL)printf("%s,", lower);
        else printf("%s", lower);
        
        free(lower);
        aux2 = aux2->next;
    }
    return;
}

void printParamsWithAssembly(tab table, param params){

    param aux2 = params;
    
    elem_table aux = table->first_elem->next;
    
    int counter = 0;
    while( aux2 != NULL){

        printf("i32 %%%c",(char)((int)'a'+counter));
        aux->variable_value = (char)((int)'a'+counter); 
        counter++;
        aux2 = aux2->next;
        aux = aux->next;
    }
    return;
}

void printTree(tree_list list, int depth, int semantic){
    for(int i = 0; i < depth; i++){
        printf("..");
    }
    switch(list->node->class){
        case IDE:
        {
            if(!semantic){
                printf("Id(%s)\n", list->node->token->symbol);

            }
            else{
                if(list->node->token->first_param != NULL || (list->node->type != NULL && strcmp(list->node->type,"func") == 0 )){
                    printf("Id(%s) - (", list->node->token->symbol);
                    printParams(list->node->token->first_param);
                    printf(")\n");
                }
                else if(list->node->type == NULL){
                    printf("Id(%s)\n", list->node->token->symbol);
                }
                else{
                    char* string = lowerString(list->node->type);
                    printf("Id(%s) - %s\n", list->node->token->symbol, string);
                    free(string);
                }
            }
            break;
        }
        case REALLITE:
        {
            if(!semantic || list->node->type == NULL) printf("RealLit(%s)\n", list->node->token->symbol);
            else{
                char* string = lowerString(list->node->type);
                printf("RealLit(%s) - %s\n", list->node->token->symbol, string);
                free(string);
            } 
            break;
        }
        case STRLITE:
        {
             if(!semantic || list->node->type == NULL)printf("StrLit(\"%s\")\n", list->node->token->symbol);
             else{
                 char* string = lowerString(list->node->type);
                 printf("StrLit(\"%s\") - %s\n", list->node->token->symbol, string);
                 free(string);
             } 
            break;
        }
        case INTLITE:
        {
            if(!semantic || list->node->type == NULL) printf("IntLit(%s)\n", list->node->token->symbol);
            else{
                char* string = lowerString(list->node->type);
                printf("IntLit(%s) - %s\n", list->node->token->symbol, string);
                free(string);
            } 
            break;
        }
        case INTE:
        {
            printf("Int\n");
            break;
        }
        case CALL:
        {
            if(!semantic || strcmp(list->node->type,"none")==0){
                printf("Call\n");
            }
            else{
                char* string = lowerString(list->node->type);
                printf("Call - %s\n", string);
                free(string);
            }
            break;
        }
        default:
        {

            if(!semantic || list->node->type == NULL){

                printf("%s\n", list->node->token->symbol);
            }
            else{
                char* string = lowerString(list->node->type);
                printf("%s - %s\n", list->node->token->symbol, string);
                free(string);
            } 
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

        char *lower = lowerString(aux1->type);

        printf("\t%s", lower);
        free(lower);
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

int checkParams(tab root) {

    if(root == NULL) return error_ast;

    elem_table aux = root->first_elem;

    while(aux != NULL) {

        tab is_table= findTable(root_table, aux->value);

        if(is_table==NULL && aux->is_used == 0 && strcmp(aux->value, "return")!=0 && strcmp(root->name,"global")!=0) {
            printf("Line %d, column %d: Symbol %s declared but never used\n", aux->line, aux->column, aux->value);
            error_ast = 1;
        }
        aux = aux->next;
    }

    checkParams(root->next);
    return error_ast;
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
elem_table createElem(char *value,  char *type, param parameter, int is_param, int line, int column){
    elem_table elem = (struct element_table*)malloc(sizeof(struct element_table));

    elem->value = value;
    elem->type = type;
    if (is_param) elem->is_used = -1;
    else elem->is_used = 0;
    elem->line = line;

    elem->column = column;
    elem->first_param = parameter;
    elem->is_param = is_param;
    elem->next = NULL;
    elem->has_been_passed = 0;
    elem->variable_value = 0;
    elem->was_used_assembly = 0;
    elem->previous_variable_value = 0;
    elem->is_global = 0;

  
    return elem;
}

//Create a new table. If it is the global one starts global table variable
tab createTable(elem_table table_element, int is_global){

    tab new_table = (struct table*)malloc(sizeof(struct table));
    if(!is_global){
        new_table->first_elem= createElem("return", table_element->type, NULL, 0, 0, 0);


        new_table->first_param = table_element->first_param;
        new_table->name = table_element->value;
        new_table->current_index_variables=0;
    }

    //If there is still no root table
    if(root_table == NULL){
        new_table->name = "global";
        new_table->first_elem = NULL;
        new_table->first_param = NULL;
        new_table->next = NULL; 
        new_table->current_index_variables=0;
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
                
                insertElementTable(table, createElem(var_id->node->token->symbol, var_type->node->token->symbol, NULL, 0, var_id->node->token->line, var_id->node->token->column));
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

                elem_table func_elem = createElem(func_id->node->token->symbol, type, param_root, 0, func_id->node->token->line, func_id->node->token->column);

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
                            insertElementTable(current_table, createElem(param_id->node->token->symbol, param_type->node->token->symbol, NULL, 1, func_id->node->token->line, func_id->node->token->column));
                       
                        }
                        else{
                            printf("Line %d, column %d: Symbol %s already defined\n", param_id->node->token->line, param_id->node->token->column, param_id->node->token->symbol);
                            error_ast = 1;
                        }
                        
                        func_param_dec = func_param_dec->next;
                    }
                }   
                
                funcBodyTable(func_header->next, current_table);

            }
            else{
                
                printf("Line %d, column %d: Symbol %s already defined\n", func_id->node->token->line, func_id->node->token->column, func_id->node->token->symbol);
                error_ast = 1;
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
                elem_table elem = createElem(child2->node->token->symbol, child1->node->token->symbol, NULL, 0, root->node->token->line, root->node->token->column);
                elem->is_global =1;
                insertElementTable(root_table, elem);
            }

            else{
                printf("Line %d, column %d: Symbol %s already defined\n", child2->node->token->line, child2->node->token->column, child2->node->token->symbol);
                error_ast = 1;
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
elem_table findElement(tab table, char *value, int assembly){
    
    //See if variable is in local table
    elem_table aux1 = table->first_elem;
    while(aux1 != NULL){

        if(strcmp(aux1->value, value) == 0 && (assembly || !aux1->has_been_passed)){
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
void createAstAnotatedInsideFunc(tree_list root, tab table, int error){


    if(root == NULL) return;
    
    if(root->next != NULL){
        createAstAnotatedInsideFunc(root->next, table, error);
    }

    
    if(root->node->children != NULL){
        createAstAnotatedInsideFunc(root->node->children, table, error);
    } 

    switch(root->node->class){
        case INTLITE:
        {
            root->node->type = "int";
            break;
        }
        case IDE:
        {   

            //See if it is a function
            tab aux = findTable(root_table, root->node->token->symbol);
            
            //Its a table
            if(aux != NULL){
                
                if(root->node->parent_is_call){
                    root->node->token->first_param = aux->first_param;
                    root->node->type = "func";
                }
                else{
                    printf("Line %d, column %d: Cannot find symbol %s\n", root->node->token->line, root->node->token->column, root->node->token->symbol);
                    root->node->type  = "undef";
                    error_ast = 1;
                }
                
            }

            else{

                //Sees if element exists and if it does then gets the type as a return parameter. If it receives no value it means it does not exist
                elem_table elem = findElement(table, root->node->token->symbol, 0);

                if(elem == NULL){
                    if(!root->node->parent_is_call && error) printf("Line %d, column %d: Cannot find symbol %s\n", root->node->token->line, root->node->token->column, root->node->token->symbol);
                    root->node->type = "undef";
                    error_ast = 1;
                }
                else{
                    
                    root->node->type = elem->type;
                    if (elem->is_used >= 0) elem->is_used++;

                }
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

            elem_table elem = findElement(table, root->node->children->next->node->token->symbol, 0);
            if(elem != NULL){
                elem->has_been_passed=1;
                elem->is_used--;    
            }
            
            break;
        }
        //We have to check if second child is type INTLIT and parse args gets type of first child
        case PARSEARGS:
        {   
            
            char *string1 = lowerString(root->node->children->next->node->type);
            char *string2 = lowerString(root->node->children->node->type);
            if(strcmp(string1, "int") != 0 ){
                printf("Line %d, column %d: Operator strconv.Atoi cannot be applied to types %s, %s\n",root->node->token->line, root->node->token->column,string2, string1 );            
                root->node->type = "undef";
                error_ast = 1;

            }
            else if(strcmp(string2, "int")!= 0){
                printf("Line %d, column %d: Operator strconv.Atoi cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,string2, string1);    
                root->node->type = "undef";
                error_ast = 1;
            }
            else{
                root->node->type = "int";
            }

            free(string1);
            free(string2);
            break;
        }
        case PRINTE:
        {   

            if(root->node->children->node->type != NULL && strcmp(root->node->children->node->type, "undef")==0){
                printf("Line %d, column %d: Incompatible type undef in fmt.Println statement\n",root->node->children->node->children->node->token->line, root->node->children->node->children->node->token->column);
                error_ast = 1;
            } 
            break;
        }

        // TODO HAVE INFINITE PARAMETERS (IN CASE FUNCTION HAS INFINITE PARAMETERS)
        case UNARYE:
        {  
            char *string1 = lowerString(root->node->children->node->type);
            if(strcmp(string1, "float32") == 0 || strcmp(string1, "int") == 0){
                root->node->type = root->node->children->node->type;
            }
            else{
                root->node->type = "undef";
                if(strcmp(root->node->token->symbol, "Minus") == 0){
                    printf("Line %d, column %d: Operator - cannot be applied to type %s\n", root->node->token->line, root->node->token->column,\
                     lowerString(root->node->children->node->type));
                     error_ast = 1;
                }
                else{
                    printf("Line %d, column %d: Operator + cannot be applied to type %s\n", root->node->token->line, root->node->token->column,\
                     lowerString(root->node->children->node->type));
                     error_ast = 1;
                }
                
            }
            free(string1);
            break;
        }
        case CALL:
        {

            tree_list function = root->node->children;
            tree_list parameter = function->next; 


            //See if parameters piut in the function are correct and in the correct order
            
            tab table = findTable(root_table, function->node->token->symbol);
            if(table == NULL){

                printf("Line %d, column %d: Cannot find symbol %s(", root->node->children->node->token->line, root->node->children->node->token->column, root->node->children->node->token->symbol);
                

                while(parameter != NULL){
                    printf("%s", lowerString(parameter->node->type));
                    parameter = parameter->next;
                    if(parameter != NULL) printf(",");
                }
                printf(")\n");
                function->node->type = "undef";
                root->node->type = "undef";
                error_ast = 1;
                return;
            }

 
            param func_params = table->first_param;
            tree_list aux_params = parameter;

            while(func_params != NULL){
                if(aux_params == NULL){

                    printf("Line %d, column %d: Cannot find symbol %s(", root->node->children->node->token->line, root->node->children->node->token->column, root->node->children->node->token->symbol);

                    while(parameter != NULL){
                        printf("%s", lowerString(parameter->node->type));
                        parameter = parameter->next;
                        if(parameter != NULL) printf(",");
                    }
                    
                    printf(")\n");
                    function->node->type = "undef";
                    root->node->type = "undef";
                    error_ast = 1;
                    return;
                }
                
                char *string1 =lowerString(aux_params->node->type);
                char *string2 =lowerString(func_params->params);
                
                if(strcmp(string1,string2) != 0){
                    printf("Line %d, column %d: Cannot find symbol %s(", root->node->children->node->token->line, root->node->children->node->token->column, root->node->children->node->token->symbol);

                    while(parameter != NULL){
                        printf("%s", lowerString(parameter->node->type));
                        parameter = parameter->next;
                        if(parameter != NULL) printf(",");
                    }
                    printf(")\n");
                    function->node->type = "undef";
                    root->node->type = "undef";
                    error_ast = 1;
                    return;
                }
               

                free(string1);
                free(string2);
                func_params = func_params->next;
                aux_params = aux_params->next;

            }

            if(aux_params != NULL){
                printf("Line %d, column %d: Cannot find symbol %s(", root->node->children->node->token->line, root->node->children->node->token->column, root->node->children->node->token->symbol);

                    while(parameter != NULL){
                        printf("%s", lowerString(parameter->node->type));
                        parameter = parameter->next;
                        if(parameter != NULL) printf(",");
                    }
                    
                    printf(")\n");
                    function->node->type = "undef";
                    root->node->type = "undef";
                    error_ast = 1;
                    return;
            }

            //Creates the string in format "(value)"
         

            
            root->node->type = table->first_elem->type;
            function->node->type = "func";

 
            
            break;
        }
        case ASSIGNE:
        {

            tree_list child_left = root->node->children;
            tree_list child_right = child_left->next;

            char *string1 = lowerString(child_right->node->type);
            char *string2 = lowerString(child_left->node->type);


            if(strcmp(string1, string2) == 0 && strcmp(string1, "undef") != 0){
                root->node->type = child_left->node->type;  
            }
            else{
                root->node->type = "undef";
                printf("Line %d, column %d: Operator = cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                    lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                    error_ast = 1;
            }

            free(string1);
            free(string2);
            break;
        }
        case OPERATOR:
        {

            tree_list child1 = root->node->children;
            tree_list child2 = child1->next;

            char* string1 = lowerString(child1->node->type);
            char* string2 = lowerString(child2->node->type);

            if(strcmp(string1, string2) == 0 && (strcmp(string1, "int") == 0 || strcmp(string1, "float32") == 0 || strcmp(string1, "string") == 0)){
                root->node->type = child2->node->type;
            }
            else{
                root->node->type = "undef";
                error_ast = 1;
                
                
               
                if(strcmp(root->node->token->symbol, "Add") == 0){
                    printf("Line %d, column %d: Operator + cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                        lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                else if(strcmp(root->node->token->symbol, "Minus") == 0){
                    printf("Line %d, column %d: Operator - cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                        lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                else if(strcmp(root->node->token->symbol, "Mul") == 0){
                    printf("Line %d, column %d: Operator * cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                        lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                else if(strcmp(root->node->token->symbol, "Div") == 0){
                    printf("Line %d, column %d: Operator / cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                        lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                else if(strcmp(root->node->token->symbol, "Mod") == 0){
                    printf("Line %d, column %d: Operator %% cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                        lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                else{
                    printf("Something went wrong\n");
                }
            }
                    
            
            free(string1);
            free(string2);
            break;
        }
        case LOGICALOPERATOR:
        {
            tree_list child1 = root->node->children;
            tree_list child2 = child1->next;

            char* string1 = lowerString(child1->node->type);
            char* string2 = lowerString(child2->node->type);

            if (strcmp(string1,"bool")==0 && strcmp(string2,"bool")==0) {
                root->node->type = child2->node->type;
            } else {
                root->node->type = "bool";
                error_ast = 1;
                if(strcmp(root->node->token->symbol,"And")==0){
                    printf("Line %d, column %d: Operator && cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                     lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                else{
                    printf("Line %d, column %d: Operator || cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                     lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                
            }

            break;
        }


        case FORE:
        case IFE:
        {
            if(strcmp(root->node->children->node->token->symbol,"Block")==0){
                root->node->type = "bool";
                return;
            }
            char *string1 = lowerString(root->node->children->node->type);
            
            if (strcmp(string1, "bool" ) != 0) {
                error_ast = 1;
                if(root->node->class == IFE){
                    printf("Line %d, column %d: Incompatible type %s in if statement\n", root->node->children->node->token->line, root->node->children->node->token->column, lowerString(root->node->children->node->type));
                }
                else{
                    printf("Line %d, column %d: Incompatible type %s in for statement\n",root->node->children->node->token->line, root->node->children->node->token->column,lowerString(root->node->children->node->type));
                }
            }
            free(string1);

            break;
        }

        case NOTE:
        {   
            char *string1 = lowerString(root->node->children->node->type);
            if(strcmp(string1 ,"bool") == 0){
                root->node->type = "bool";
            }
            else{
                error_ast = 1;
                root->node->type = "bool";
                printf("Line %d, column %d: Operator ! cannot be applied to type %s\n", root->node->token->line, root->node->token->column,\
                     lowerString(root->node->children->node->type));
            }
            free(string1);




            break;
        }
        case CONDITIONOPERATOR1:
        {
            tree_list child1 = root->node->children;

            tree_list child2 = child1->next;

            if(strcmp(child1->node->type, child2->node->type) == 0){
                root->node->type = "bool";
            }
            else{
                error_ast = 1;
                if(strcmp(root->node->token->symbol, "Eq")  == 0){
                    printf("Line %d, column %d: Operator == cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                     lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                else if(strcmp(root->node->token->symbol, "Ne")  == 0){
                    printf("Line %d, column %d: Operator != cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                     lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                

                
                root->node->type = "bool";
            }   
        
            break;
        }
        case CONDITIONOPERATOR2:
        {

            tree_list child1 = root->node->children;
            tree_list child2 = child1->next;

            char *string1 = lowerString(child1->node->type);
            char *string2 = lowerString(child2->node->type);

            if(strcmp(string1, string2) == 0 && (strcmp(string1, "bool") != 0)){
                root->node->type = "bool";
            }
            else{
                error_ast = 1;
                if(strcmp(root->node->token->symbol, "Lt")  == 0){
                    printf("Line %d, column %d: Operator < cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                     lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                else if(strcmp(root->node->token->symbol, "Gt")  == 0){
                    printf("Line %d, column %d: Operator > cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                     lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                else if(strcmp(root->node->token->symbol, "Le")  == 0){
                    printf("Line %d, column %d: Operator <= cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                     lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                else if(strcmp(root->node->token->symbol, "Ge")  == 0){
                    printf("Line %d, column %d: Operator >= cannot be applied to types %s, %s\n", root->node->token->line, root->node->token->column,\
                     lowerString(root->node->children->node->type), lowerString(root->node->children->next->node->type));
                }
                else{
                    printf("Something went wrong\n");
                }
            }

            root->node->type = "bool";
            break;
        }
        case RETURNE:
        {   
            if(root->node->children == NULL){
                if(strcmp(table->first_elem->type, "none") != 0 && error){
                    error_ast = 1;

                    printf("Line %d, column %d: Incompatible type %s in return statement\n", root->node->token->line, root->node->token->column, lowerString(root->node->children->node->type));
                } 
            }
            else{
                if(strcmp(table->first_elem->type, root->node->children->node->type)!=0 && error){
                    error_ast = 1;
                    printf("Line %d, column %d: Incompatible type %s in return statement\n", root->node->children->node->token->line, root->node->children->node->token->column, lowerString(root->node->children->node->type));
                }
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

void createAstAnotated( tree_list root, tab table, int error){
    if(root == NULL) return;
    switch(root->node->class){
        case FUNCDECL:
        {
            tree_list func_head = root->node->children;
            tree_list func_id  = func_head->node->children;

            tab current_table = findTable(root_table, func_id->node->token->symbol);

            if(current_table != NULL && current_table->first_elem->has_been_passed == 0){


                createAstAnotatedInsideFunc(func_head->next, current_table, error);
                elem_table first_elem = current_table->first_elem;

                first_elem->has_been_passed = 1;

                
            }
            else{
                if(!checkExists(root_table, func_id->node->token->symbol)){
                    printf("Line %d, column %d: Cannot find symbol %s()\n", func_id->node->token->line, func_id->node->token->column, func_id->node->token->symbol);
                    error_ast = 1;
                }
            }

            if(root->next != NULL){

                createAstAnotated(root->next, root_table, error);
            } 
            break;
        }



        default:
        {   
            
            if(root->node->children != NULL){
                createAstAnotated(root->node->children, root_table, error); 
                
            }

            if(root->next != NULL){
                createAstAnotated(root->next, root_table, error);
            }
            
        }
    }

    return;


}

string_glob findStringElem(string_glob root, char* value){
    string_glob aux = root;

    while(aux != NULL){
        if(strcmp(aux->node->token->symbol, value) == 0){
            return aux;
        }
        aux = aux->next;
    }

    return NULL;
}

void freeElem(elem_table  elem){
    if(elem == NULL) return;

    freeElem(elem->next);
    
    free(elem);
    return;
}       

void freeParameters(param root){
    if(root == NULL) return;

    freeParameters(root->next);

    free(root);
    return;
}

void freeTables(tab root){
    if(root == NULL) return;

    freeElem(root->first_elem);
    freeParameters(root->first_param);
    freeTables(root->next);

    free(root);

    return;
}

void freeStrings(string_glob root){
    if(root == NULL) return;

    freeStrings(root->next);

    free(root);

    return;
}




int calculateValueOpInt(tree_list root, int previous_value, char* operation ){
    if(root == NULL) return 0;

    int value;
    
    if(root->node->children != NULL){
        if(root->node->class == OPERATOR){
            value = calculateValueOpInt(root->node->children, previous_value, root->node->token->symbol);
        }
        else{
            value = calculateValueOpInt(root->node->children, previous_value, operation);
        }
       
        previous_value = value;
    }
    
    if(root->next != NULL){
        if(root->node->class == OPERATOR){
            value = calculateValueOpInt(root->next, previous_value, root->node->token->symbol);
            
        }
        else{
            value = calculateValueOpInt(root->next, atoi(root->node->token->symbol), operation);
        }
    }

    if(root->next ==NULL && root->node->children == NULL){
        if(strcmp(lowerString(operation), "add")==0){
            value = previous_value + atoi(root->node->token->symbol);
        }
        else if(strcmp(lowerString(operation), "sub")==0){
            value = previous_value - atoi(root->node->token->symbol);
        }
        else if(strcmp(lowerString(operation), "mul")==0){
            value = previous_value * atoi(root->node->token->symbol);
        }
        else if(strcmp(lowerString(operation), "div")==0){
            value = previous_value / atoi(root->node->token->symbol);

        }
        else if(strcmp(lowerString(operation), "mod")==0){
            value = previous_value % atoi(root->node->token->symbol);
        }
        else{
            printf("Erro%s\n",operation);
        }

        return value;
    }
    else{
        return value;
    }
    
}
float calculateValueOpFloat(tree_list root, float previous_value, char* operation ){
    if(root == NULL) return 0;

    float value;

    if(root->node->children != NULL){
        if(root->node->class == OPERATOR){
            
            value = calculateValueOpFloat(root->node->children, previous_value, root->node->token->symbol);
        }
        else{
            value = calculateValueOpFloat(root->node->children, previous_value, operation);
        }
       
        previous_value = value;
    }
  
    if(root->next != NULL){

        if(root->node->class == OPERATOR){
            value = calculateValueOpFloat(root->next, previous_value, root->node->token->symbol);
            
        }
        else{

            value = calculateValueOpFloat(root->next, atof(root->node->token->symbol), operation);
        }
    }

    if(root->next ==NULL && root->node->children == NULL){
        
        if(strcmp(lowerString(operation), "add")==0){
            
            value = previous_value + atof(root->node->token->symbol);
        }
        else if(strcmp(lowerString(operation), "sub")==0){
            value = previous_value - atof(root->node->token->symbol);
        }
        else if(strcmp(lowerString(operation), "mul")==0){
            value = previous_value * atof(root->node->token->symbol);
        }
        else if(strcmp(lowerString(operation), "div")==0){
            value = previous_value / atof(root->node->token->symbol);

        }
        else{
            printf("Erro%s\n",operation);
        }

        return value;
    }
    else{
        return value;
    }
    
}

void createAssemblyInsideFunc(tree_list root, tab current_table, string_glob string_root, int after_assign){

    if(root == NULL) return;
    switch(root->node->class){

        case VARDEC:
        {

            tree_list child = root->node->children->next;
            elem_table elem = findElement(current_table, child->node->token->symbol, 1);
            elem->has_been_passed = 0;

            if(elem != NULL){
                current_table->current_index_variables++;
                elem->variable_value = current_table->current_index_variables;
                
                if(strcmp(lowerString(elem->type), "float32")==0){
                    printf("%%%d = alloca double, align 4\n", current_table->current_index_variables);
                }
                else if(strcmp(lowerString(elem->type), "int")==0){
                    printf("%%%d = alloca i32, align 4\n",  current_table->current_index_variables);
                }
                else{
                    printf("ERRO NAO TRATADO\n");
                }
                
            }
            else{
                printf("BUG!\n");
            }
            after_assign = 0;
            first_time_assign = 0;
            break;
        }

        case PRINTE:
        {
            switch(root->node->children->node->class){
                case STRLITE:
                {
                    string_glob string_elem = findStringElem(string_root, root->node->children->node->token->symbol);
                    if(string_elem != NULL){
                        current_table->current_index_variables++;
                        printf("%%%d = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([%ld x i8], [%ld x i8]* @.str.%d, i32 0, i32 0))\n", current_table->current_index_variables, strlen(string_elem->node->token->symbol) +2,strlen(string_elem->node->token->symbol) +2,string_elem->value);
                        
                    }
                    else{
                        printf("BUG\n");
                    }
                    break;
                }
                case INTLITE:
                {
                        
                    current_table->current_index_variables++;
                    printf("%%%d = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %s)\n", current_table->current_index_variables , root->node->children->node->token->symbol);
                        break;
                }
                case REALLITE:
                {
                    current_table->current_index_variables++;
                    printf("%%%d = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %.8s)\n", current_table->current_index_variables , root->node->children->node->token->symbol);
                    break;
                }
                case IDE:
                {
                    tree_list child = root->node->children;
                    elem_table elem = findElement(current_table, child->node->token->symbol, 0);
                    
                    if(!elem->is_global){
                        if(strcmp(lowerString(child->node->type), "float32") == 0){

                            
                            current_table->current_index_variables++;
                            printf("%%%d = load double, double* %%%d, align 4\n", current_table->current_index_variables, elem->variable_value);
                            current_table->current_index_variables++;
                            printf("%%%d = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %%%d)\n", current_table->current_index_variables, current_table->current_index_variables -1 );
                        }
                        else if(strcmp(lowerString(child->node->type), "int") == 0){

                            current_table->current_index_variables++;
                            printf("%%%d = load i32, i32* %%%d, align 4\n", current_table->current_index_variables, elem->variable_value);
                            current_table->current_index_variables++;
                            printf("%%%d = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %%%d)\n", current_table->current_index_variables, current_table->current_index_variables -1);
                        }
                        else if(strcmp(lowerString(child->node->type), "bool") == 0){

                        }
                        else if(strcmp(lowerString(child->node->type), "string") == 0){

                        }
                        else{
                            printf("NODE %s\n", lowerString(child->node->type));
                        }
                    }
                    else{
                        if(strcmp(lowerString(child->node->type), "float32") == 0){
                            current_table->current_index_variables++;
                            printf("%%%d = load double, double* @%s, align 4\n", current_table->current_index_variables, elem->value);
                            current_table->current_index_variables++;
                            printf("%%%d = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %%%d)\n", current_table->current_index_variables, current_table->current_index_variables -1);
                        }
                        else if(strcmp(lowerString(child->node->type), "int") == 0){
                            current_table->current_index_variables++;
                            printf("%%%d = load i32, i32* @%s, align 4\n", current_table->current_index_variables, elem->value);
                            current_table->current_index_variables++;
                            printf("%%%d = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %%%d)\n", current_table->current_index_variables, current_table->current_index_variables -1);
                        }
                        else if(strcmp(lowerString(child->node->type), "bool") == 0){

                        }
                        else if(strcmp(lowerString(child->node->type), "string") == 0){

                        }
                        else{
                            printf("NODE %s\n", lowerString(child->node->type));
                        }

                    }
                    break;
                }
                case BOOLE:
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            after_assign = 0;
            first_time_assign = 0;
            break;
        }

        case RETURNE:
        {   
            returned = 1;
            if(strcmp(current_table->first_elem->type, "none") == 0){
                printf("ret void\n");
            }
            else{
                elem_table aux = findElement(current_table, root->node->children->node->token->symbol, 0);
                if(aux == NULL){
                    printf("ret i32 %s\n", root->node->children->node->token->symbol);
                }
                else{
                    printf("ret i32 %%%d\n", aux->variable_value);
                }
                
                
            }
            after_assign = 0;
            first_time_assign = 0;
            break;
        }
        case ASSIGNE:
        {
            //tree_list id = root->node->children;

            
            //elem_table elem = findElement(current_table, id->node->token->symbol, 1);
            
            /*if(elem->is_global){
                if(strcmp(lowerString(elem->type), "float32") == 0){
                    printf("store double ");
                }
                else{
                    printf("store i32 ");
                }
            }
            else{

                elem->previous_variable_value = elem->variable_value;
                current_table->current_index_variables++;
                elem->variable_value = 48 + current_table->current_index_variables;
                printf("%%%c = ",(char)elem->variable_value);
                    
                
                
                
            }*/
            after_assign = 1;
            first_time_assign = 1;
            
            
            break;
        }
        
        case IDE: 
        {
            
                if(after_assign ){

                    elem_table elem = findElement(current_table, root->node->token->symbol, 0);

                    if(!elem->is_global){
                        switch(root->next->node->class){
                            case IDE:
                            {
                                elem_table elem = findElement(current_table, root->node->token->symbol, 0);

                                
                                current_table->current_index_variables++;
                                elem_table elem2 = findElement(current_table, root->next->node->token->symbol, 0);
                                if(strcmp(lowerString(elem->type),"float32") == 0){
                                    if(elem2->is_global){
                                        printf("%%%d = load double, double* @%s, align 4\n",current_table->current_index_variables, elem2->value);
                                    }
                                    else{
                                            printf("%%%d = load double, double* %%%d, align 4\n",current_table->current_index_variables, elem2->variable_value);
                                        }
                                }
                                else if(strcmp(lowerString(elem->type), "int")== 0){
                                     if(elem2->is_global){
                                        printf("%%%d = load i32, i32* @%s, align 4\n",current_table->current_index_variables, elem2->value);
                                    }
                                    else{
                                        printf("%%%d = load i32, i32* %%%d, align 4\n",current_table->current_index_variables, elem2->variable_value);
                                        }
                                }
                                else{
                                    printf("NAO IMPLEMENTADO 2\n");
                                }

                                if(strcmp(lowerString(elem->type),"float32") == 0){
                                    printf("store double %%%d, double* %%%d, align 4\n", current_table->current_index_variables, elem->variable_value);
                                }
                                else if(strcmp(lowerString(elem->type), "int")== 0){
                                    printf("store i32 %%%d, i32* %%%d, align 4\n", current_table->current_index_variables, elem->variable_value);
                                }
                                else{
                                    printf("NAO IMPLEMENTADO 3\n");
                                }

                            
                                elem->previous_variable_value = 0;
                                break;
                            }
                                
                            
                            case INTLITE:
                            {
                                printf("store i32 %s, i32* %%%d, align 4\n",root->next->node->token->symbol, elem->variable_value);
                                break;
                            }
                            case REALLITE:
                            {
                                printf("store double %s, double* %%%d, align 4\n",root->next->node->token->symbol, elem->variable_value);
                                break;
                            }
                            case OPERATOR:
                            {
                                tree_list current_op = root->next;
                                if(strcmp(lowerString(current_op->node->type), "int") == 0){
                                    
                                    int value = calculateValueOpInt(current_op, 0, current_op->node->token->symbol);
                                    printf("store i32 %d, i32* %%%d\n",value, elem->variable_value);
                                    
                                    
                                }
                                else if(strcmp(lowerString(current_op->node->type), "float32") == 0){
                                    float value = calculateValueOpFloat(current_op, 0, current_op->node->token->symbol);
                                    printf("store double %f, double* %%%d\n",value, elem->variable_value);
                                }
                                else{
                                    printf("CASO NAO TRATADO 4\n");
                                }
                                break;
                            }
                            default:
                            {
                                break;
                            }
                            

                        }
                        after_assign = 0;
                    }

                    else{
                        switch(root->next->node->class){
                        
                        case IDE:
                        {
                            elem_table elem2 = findElement(current_table, root->next->node->token->symbol, 0);


                            if(strcmp(lowerString(elem->type),"float32") == 0){
                                if(elem2->is_global){
                                    current_table->current_index_variables++;
                                    printf("%%%d = load double, double* @%s, align 4\n", current_table->current_index_variables, elem2->value);
                                    printf("store double %%%d, double* @%s, align 4\n", current_table->current_index_variables, root->node->token->symbol);
                                }
                                else{
                                    current_table->current_index_variables++;
                                    printf("%%%d = load double, double* %%%d, align 4\n", current_table->current_index_variables, elem2->variable_value);
                                    printf("store double %%%d, double* @%s, align 4\n", current_table->current_index_variables, root->node->token->symbol);
                                }
                            }
                            else if(strcmp(lowerString(elem->type),"float32") == 0){
                                if(elem2->is_global){
                                    current_table->current_index_variables++;
                                    printf("%%%d = load i32, i32* @%s, align 4\n", current_table->current_index_variables, elem2->value);
                                    printf("store i32 %%%d, i32* @%s, align 4\n", current_table->current_index_variables, root->node->token->symbol);
                                }
                                else{
                                    current_table->current_index_variables++;
                                    printf("%%%d = load i32, i32* %%%d, align 4\n", current_table->current_index_variables, elem2->variable_value);
                                    printf("store i32 %%%d, i32* @%s, align 4\n", current_table->current_index_variables, root->node->token->symbol);
                                }
                            }
                          


                            break;
                        }
                        case INTLITE:
                        {
                            printf("store i32 %s, i32* @%s, align 4\n", root->next->node->token->symbol, root->node->token->symbol);
                            break;
                        }

                        case REALLITE:
                        {
                            printf("store double %s, double* @%s, align 4\n", root->next->node->token->symbol, root->node->token->symbol);
                            break;
                        }

                        case OPERATOR:
                        {
                                    
                             break;
                        }
                                        
                         default:
                        {
                            printf("NAO TRATADO!\n");
                            break;
                        }
                    }
                    current_table->current_index_variables++;

                    if(strcmp(lowerString(root->node->type),"float32") == 0){                
                        printf("%%%d = load double, double* @%s, align 4\n", current_table->current_index_variables, root->node->token->symbol);
                    }
                    else{
                        printf("%%%d = load i32, i32* @%s, align 4\n", current_table->current_index_variables, root->node->token->symbol);
                    }
                                    
                    after_assign = 0;
                }
            }
                
        
            
                
            first_time_assign = 0;
            
            break;
        }
        case OPERATOR:
        {
            
            if(after_assign){
                //calculateOperatorValue();
                tree_list child1 = root->node->children;
                tree_list child2 = child1->next;

                if(strcmp(root->node->token->symbol, "Add") == 0){
                    printf("add i32 ");

                }
                else if(strcmp(root->node->token->symbol, "Minus") == 0){
                    printf("sub i32 ");
                }
                else if(strcmp(root->node->token->symbol, "Mul") == 0){
                    printf("mul i32 ");
                }
                else if(strcmp(root->node->token->symbol, "Div") == 0){
                    printf("sdiv i32 ");
                    }
                else if(strcmp(root->node->token->symbol, "Mod") == 0){
                    printf("srem i32 ");
                }
                

                elem_table elem1 = findElement(current_table, child1->node->token->symbol, 0);



                if(elem1 == NULL){
                    printf("%s,", child1->node->token->symbol);
                }
                else{
                    if(elem1->previous_variable_value == 0){
                        printf("%%%d, ",(elem1->variable_value));
                    }
                    else{
                        printf("%%%d, ",(elem1->previous_variable_value));
                        elem1->previous_variable_value = 0;
                    }
                }

                elem_table elem2 = findElement(current_table, child2->node->token->symbol, 0);

                if(elem2 == NULL){
                    printf("%s\n", child2->node->token->symbol);
                }
                else{
                    if(elem2->previous_variable_value == 0){
                        printf("%%%d\n",elem2->variable_value);
                    }
                    else{
                        printf("%%%d\n",(elem2->previous_variable_value));
                        elem2->previous_variable_value = 0;
                    }
                }
            }

            first_time_assign = 0;
            after_assign = 0;    
            break;
        }
        default:
        {
            break;
        }
        

    }

    if(root->node->children != NULL){
        createAssemblyInsideFunc(root->node->children, current_table, string_root,after_assign);          
    }

    if(root->next != NULL){
        createAssemblyInsideFunc(root->next, current_table, string_root,after_assign);
    }



}

void createAssembly(tree_list root, string_glob string_root){

    
    if(root == NULL) return;
    switch(root->node->class){
        case FUNCDECL:
        {
            tree_list func_head = root->node->children;
            tree_list func_id  = func_head->node->children;

            tab current_table = findTable(root_table, func_id->node->token->symbol);



            printf("define dso_local i32 @%s(",func_id->node->token->symbol);
            printParamsWithAssembly(current_table, current_table->first_param);

            printf("){\n");
            
            returned = 0;
            createAssemblyInsideFunc(func_head->next, current_table, string_root, 0);

            if(!returned) printf("ret i32 0");
            printf("}\n");

            if(root->next != NULL){

                createAssembly(root->next, string_root);
            } 
            break;
        }


        default:
        {   
            
            if(root->node->children != NULL){
                createAssembly(root->node->children, string_root); 
                
            }

            if(root->next != NULL){
                createAssembly(root->next, string_root);
            }
            
        }
    }

    return;
}

void printStrings(string_glob string_list_root){
    string_glob aux = string_list_root;
    while(aux != NULL){
        printf("@.str.%d = private unnamed_addr constant [ %lu x i8] c\"%s\\0A\\00\", align 1\n",aux->value, strlen(aux->node->token->symbol) +2 , aux->node->token->symbol);
        aux = aux->next;
    }
}

void printGlobals(tab global_table){
    elem_table aux = global_table->first_elem;

    while(aux != NULL){
        if(!aux->is_param && findTable(global_table, aux->value) == NULL){
            if(strcmp(lowerString(aux->type), "float32") == 0){
                printf("@%s = common dso_local global double 0.0, align 4\n", aux->value);
            }
            else{
                printf("@%s = common dso_local global i32 0, align 4\n", aux->value);
            }

        }
        aux = aux->next;
    }
}

string_glob globalStrings(tree_list root, string_glob string_list_root, int first_time){

        if(root == NULL) return string_list_root;

        if(root->node->class == STRLITE){
            string_glob string_element = (struct string_list *) malloc(sizeof(struct string_list));

            string_element->next = NULL;
            string_element->node = root->node;

            if(string_list_root == NULL){
                string_element->value = 3;
                string_list_root = string_element;
                

            }
            
            else{
                string_glob aux = string_list_root;
                int counter = 4;

                while(aux->next != NULL){
                    aux = aux->next;
                    counter++;
                }

                string_element->value = counter;
                aux->next = string_element;
            }
        }
        else if(root->node->class == PRINTE){
            if(first_time){
                printf("declare dso_local i32 @printf(i8*, ...) #1\n");
                first_time = 0;
                
            }
            
            if(first_time_int){
                first_time_int = 0;
                printf("@.str.1 = private unnamed_addr constant [4 x i8] c\"%%d\\0A\\00\", align 1\n");
            }
            if(first_time_float){  
                first_time_float = 0;
                printf("@.str.2 = private unnamed_addr constant [7 x i8] c\"%%.08f\\0A\\00\", align 1\n");
            }
        }
        if(root->node->children != NULL){
            string_list_root = globalStrings(root->node->children, string_list_root, first_time);        
        }
        if(root->next != NULL){
            string_list_root = globalStrings(root->next, string_list_root, first_time);
        }    

        return string_list_root;
}
