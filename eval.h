#ifndef EVAL
#define EVAL

typedef struct tabVariable {
    double value;
    char * variable;
    struct tabVariable * next;
}tabVariable;
/*
enum varType {
    INT = 1,
    FLOAT = 2,
    CHAR = 3,
    DOUBLE = 4,
    STRING = 5     
};*/

void eval(Node *node);

tabVariable * tabVariable_create(char * variable, float value);
tabVariable * tabVariable_append(tabVariable * tab, char * variable, float value);
void afficheTabVar(tabVariable * tab);
float getVar(tabVariable * tab, char * variable);

#endif