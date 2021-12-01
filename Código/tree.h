//Ficheiro header das funcoes necessárias para a criação da árvore sintatica


#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct node *tree_node;
typedef struct node_list *tree_list;
typedef struct token *id_token;
typedef struct element_table *elem_table;
typedef struct table *tab;
typedef struct parameter *param;

enum class_name{PROGRAM, IDE, DECLARATION, VARDEC, VARSPEC, INTE, FLOAT32E, BOOLE, STRINGE, FUNCDECL, PARAMETERS, INTLITE, FUNCBODY, VARSANDSTAT, VARSANDSTATOPC, STATEMENT, STATESEMI, PARSEARGS, FUNCINVOCATION, REALLITE, STRLITE, FUNCHEADER, CALL, RETURNE, IFE, CONDITIONOPERATOR,
OPERATOR, PARAMDECL, PRINTE, BLOCK, FORE, UNARYE, ASSIGNE, NOTE};

//O first_param existe apenas para caso que um ID seja uma função facilmente consigamos extrair os parametros. Para todos os outros nodos será NULL
struct token{
    char *symbol;
    int line, column;
    param first_param;
};


struct node{
    enum class_name class;
    char *type;
    struct token *token;
    struct node_list *children;
};

struct node_list{
    struct node *node;
    struct node_list *next;
};

struct parameter{
    char *params;

    param next;
};

struct element_table{
    char *value;
    char *type;
    int is_param;
    char is_used;
    int has_been_passed; 
    int line;
    int column;

    param first_param;
    elem_table next;
};

struct table{
    char *name;
    param first_param;
    tab next;
    elem_table first_elem;
};

tree_list create_node(enum class_name class, char *symbol, int line, int column, id_token tok );
id_token create_token(char *value, int  line, int column);
void addChild(tree_list root, tree_list new_child);
void freeTree(tree_list root);
void printTree(tree_list node, int depth, int semantic);
void add_next(tree_list new_node, tree_list next_node);
void add_max_next(tree_list new_node, tree_list next_node);
int number_of_children(tree_list node);
void add_child_to_all(tree_list root, tree_list child);
tab createAllTables(tree_list root);
void checkParams(tab root);
void printTables(tab root);
void createAstAnotated( tree_list root, tab table);
