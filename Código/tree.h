//Ficheiro header das funcoes necessárias para a criação da árvore sintatica


#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct node *tree_node;
typedef struct node_list *tree_list;
typedef struct token *id_token;
typedef struct element_table *elem_table;
typedef struct table *tab;

enum class_name{PROGRAM, IDE, DECLARATION, VARDEC, VARSPEC, INTE, FLOAT32E, BOOLE, STRINGE, FUNCDECL, PARAMETERS, INTLITE, FUNCBODY, VARSANDSTAT, VARSANDSTATOPC, STATEMENT, STATESEMI, PARSEARGS, FUNCINVOCATION, REALLITE, STRLITE, FUNCHEADER, CALL, RETURNE, IFE,
OPERATOR, PARAMDECL, PRINTE, BLOCK, FORE};

struct token{
    char *symbol;
    int line, column;
};


struct node{
    enum class_name class;
    struct token *token;
    struct node_list *children;
};

struct node_list{
    struct node *node;
    struct node_list *next;
};



struct element_table{
    char *value;
    char *type;
    char *parameters;

    elem_table *next;
};

struct table{
    char *name;

    tab *next;
    elem_table *first_elem;
};

tree_list create_node(enum class_name class, char *symbol, int line, int column, id_token tok );
id_token create_token(char *value, int  line, int column);
void addChild(tree_list root, tree_list new_child);
void freeTree(tree_list root);
void printTree(tree_list node, int depth);
void add_next(tree_list new_node, tree_list next_node);
void add_max_next(tree_list new_node, tree_list next_node);
int number_of_children(tree_list node);
void add_child_to_all(tree_list root, tree_list child);
