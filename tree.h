#ifndef TREE
#define TREE
    
enum NodeType {
    NTEMPTY = 0,
    NTINSTLIST = 1,

    NTNUM   = 201,
    NTVAR   = 202,
    
    NTDISPLAY = 203,

    NTPLUS  = 321,
    NTMIN   = 322,
    NTMULT  = 323,
    NTDIV   = 324,
    NTPOW   = 325,
    NTEGAL  = 326,
    
    NTVRAI  = 331,
    NTFAUX  = 332,
    
    NTEQUAL = 340,
    
    NTSI = 350,
    NTALORS = 351,
    NTSINON = 352,
    
    NTTANTQUE = 360,
    NTFAIRE = 361,
    
    NTFIN = 370
};
   
typedef struct Node {
    enum NodeType type;
    union { 
        double val;
        char* var;
        struct Node** children;
    } ;
} Node;

Node* createNode(int type);

Node* nodeChildren(Node* father, Node *child1, Node *child2);

const char* node2String(Node *node);

void printGraph(Node *root);

#endif