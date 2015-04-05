#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <setjmp.h>
#include "tree.h"
#include "eval.h"

double tabVar[26]={0.0};

tabVariable * tab = NULL;

int printDepth = 0;
int funcDepth = 0;
int rang=0;
double valeur=0.0;

/**
 * Parcourt récursivement une expression et retourne le résultat.
 * Si elle rencontre un opérateur, elle calcule le résultat des 2 valeurs de ses expressions (4 + 1 + x) ou variables (x, y, etc.)
 * Si elle recontre un nombre ou une variable, elle retourne sa valeur.
 */
double evalExpr(Node *node) {
    switch ( node->type ) {
        case NTEMPTY:  return 0.0;
        case NTNUM: return node->val;
        case NTVAR : return tabVar[(node->var)[0]-'a'];
        case NTPLUS: return evalExpr(node->children[0])
                        + evalExpr(node->children[1]);
        case NTMIN: return evalExpr(node->children[0])
                        - evalExpr(node->children[1]);
        case NTMULT: return evalExpr(node->children[0])
                        * evalExpr(node->children[1]);
        case NTDIV: return evalExpr(node->children[0])
                        / evalExpr(node->children[1]);
        case NTPOW: return pow(evalExpr(node->children[0]),
                        evalExpr(node->children[1]));
        default: 
            printf("Error in evalExpr ... Wrong node type: %s\n", node2String(node));
            exit(1);
    };
}

/**
 * Cette fonction renvoie un booléen (0 ou 1).
 * Elle est utilisée dans le cas d'un SI ou encore d'un TANTQUE pour vérifier si la condition est vraie ou fausse.
 */
int evalExpB(Node* node) {
    switch ( node->type ) {
        case NTVRAI: return(1);
        case NTFAUX: return(0);
        case NTEQUAL: return( evalExpr(node->children[0]) == evalExpr(node->children[1]) );
        case NTNEQUAL: return( evalExpr(node->children[0]) != evalExpr(node->children[1]) );
        case NTNOT: return( !evalExpB(node->children[1]) );
        case NTGT: return( evalExpr(node->children[0]) > evalExpr(node->children[1]) );
        case NTLT: return( evalExpr(node->children[0]) < evalExpr(node->children[1]) );
        case NTGET: return( evalExpr(node->children[0]) >= evalExpr(node->children[1]) );
        case NTLET: return( evalExpr(node->children[0]) <= evalExpr(node->children[1]) );
        case NTOU: return( evalExpB(node->children[0]) || evalExpB(node->children[1]) );
        case NTET: return( evalExpB(node->children[0]) && evalExpB(node->children[1]) );
        default:
            printf ("Erreur lors de l'évaluation de l'expression booléenne, %s non reconnu", node2String(node));
            exit(1);    
    };
}

/**
 * Parcourt les instructions saisies.
 * Si le programme trouve une liste d'instructions, elle évalue chacune d'entre elles.
 * Si c'est une expression (signalée par un opérateur), il évalue l'expression avec la fonction evalExpr au dessus et affiche le résultat.
 * Cette fonction peut renvoyer un 0 ou un 1 si elle rencotre un NTSI pour dire si la condition du SI est vraie et donc ne pas exécuter le SINON.
 */
int evalInst(Node* node) {
    double val;
    switch ( node->type ) {
	case NTEMPTY: return;
	case NTINSTLIST:
            evalInst(node->children[0]);
            evalInst(node->children[1]);
            return; 
	 
	case NTPLUS:
	case NTNUM:
	case NTMIN:
	case NTMULT:
	case NTDIV:
	case NTPOW:
            printf("%.2f\n", evalExpr(node));
            return;
            
        case NTAFF:
            rang=(node->children[0]->var)[0]-'a';
            valeur = evalExpr(node->children[1]);
            printf("%s vaut %.2f\n",(node->children[0]->var), valeur);
            tabVar[rang] = valeur;
            tab = tabVariable_append(tab, node->children[0]->var, valeur );
            return;
            
        case NTDISPLAY:
            printf ("Affichage : %.2f \n", evalExpr(node->children[1]));
            return;
            
        case NTSINON:
            if (evalInst(node->children[0]) == 0) {
                evalInst(node->children[1]);
            }
            return;
            
        case NTSI:
            if ( evalExpB(node->children[0]) == 1) {
                evalInst(node->children[1]->children[0]);
                return(1);
            }
            return(0);
            
        case NTTANTQUE:
            if (evalExpB(node->children[0]) == 1) {
                evalInst(node->children[1]);
                evalInst(node);
            }
            return;
	default:
            printf("Error in evalInst ... Wrong node type: %s\n", node2String(node));
            exit(1);
    };
}

void eval(Node *node) {
    evalInst(node);
    afficheTabVar(tab);
}

tabVariable * tabVariable_create(char * variable, float value) {
    tabVariable * tab = (tabVariable *)malloc(sizeof(tabVariable));
    tab->variable = variable;
    tab->value = value;
    tab->next = NULL;
    return (tab);
}

tabVariable * tabVariable_append(tabVariable * tab, char * variable, float value) {
    tabVariable * tabNode = tabVariable_create(variable, value);
    if (tab) {
        tabVariable * save = tab;
        while (tab->next != NULL) {
            if (strcmp(tab->variable, variable) == 0) {
                tab->value = value;
                return (save);
            }
            else {
               tab = tab->next; 
            }
        }
        tab->next = tabNode;
        return save;
    }
    else {
        return tabNode;
    }
}

void afficheTabVar(tabVariable * tab) {
    while (tab != NULL) {
        printf("%s = %.2f \n", tab->variable, tab->value);
        tab = tab->next;
    }
}