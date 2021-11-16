//Ficheiro header das funcoes necessárias para a criação da árvore sintatica


#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct node *tree_node;
typedef struct node_list *tree_list;

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


tree_list create_node(enum class_name class, char *symbol, int line, int column );
void addChild(tree_list root, tree_list new_child);
void freeTree(tree_list root);
void printTree(tree_list node, int depth);
void add_next(tree_list new_node, tree_list next_node);
void add_max_next(tree_list new_node, tree_list next_node);
int number_of_children(tree_list node);
void add_child_to_all(tree_list root, tree_list child);
//int[] find_last_node(tree_list root);