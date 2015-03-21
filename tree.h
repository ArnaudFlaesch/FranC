#ifndef TREE
#define TREE
    
enum NodeType {
    NTEMPTY = 0,
    NTINSTLIST = 1,

    NTNUM   = 201,
    NTCAR   = 202, 

    NTPLUS  = 321,
    NTMIN   = 322,
    NTMULT  = 323,
    NTDIV   = 324,
    NTPOW   = 325,	
	
};
   
typedef struct Node {
    enum NodeType type;
    union { 
        double val;
        char* var;
        struct Node** children;
    } ;
} Node;

typedef struct Variables {
    int value;
    char * name;
} Variables;

Node* createNode(int type);

Node* nodeChildren(Node* father, Node *child1, Node *child2);

const char* node2String(Node *node);

void printGraph(Node *root);

#endif