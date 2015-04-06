#ifndef EVAL
#define EVAL

typedef struct tabVariable {
    double value;
    char * variable;
    struct tabVariable * next;
}tabVariable;

void eval(Node *node);

tabVariable * tabVariable_create(char * variable, float value);
tabVariable * tabVariable_append(tabVariable * tab, char * variable, float value);
void afficheTabVar(tabVariable * tab);
float getVar(tabVariable * tab, char * variable);

#endif