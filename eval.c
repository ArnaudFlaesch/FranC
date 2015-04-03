#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <setjmp.h>
#include "tree.h"
#include "eval.h"

double tabVar[26]={0.0};

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
 * Parcourt les instructions saisies
 * Si le programme trouve une liste d'instructions, elle évalue chacune d'entre elles.
 * Si c'est une expression (signalée par un opérateur), il évalue l'expression avec la fonction evalExpr au dessus et affiche le résultat.
 */
void evalInst(Node* node) {
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
        case NTEGAL:
            rang=(node->children[0]->var)[0]-'a';
            valeur = evalExpr(node->children[1]);
            printf("%c vaut %f.2\n",(node->children[0]->var)[0], valeur);
            tabVar[rang] = valeur;
            return;
        case NTDISPLAY:
            printf ("Affichage : %.2f \n", evalExpr(node->children[1]));
            return;
	default:
            printf("Error in evalInst ... Wrong node type: %s\n", node2String(node));
            exit(1);
    };
}

void eval(Node *node) {
    evalInst(node);
}