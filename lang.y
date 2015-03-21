%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "tree.h"
#include "eval.h"

extern int  yyparse();
extern FILE *yyin;
Node root;
%}

%union {
    struct Node *node;
}

%token   <node> NUMBER 
%token   <node> PLUS MIN MULT DIV POW
%token   OP_PAR CL_PAR COLON
%token   EOL

%type   <node> Instlist
%type   <node> Inst
%type   <node> Expr

%left OR			// OU
%left AND			// ET
%left EQ NEQ   			// ==  et !=
%left GT LT GET LET             // > , < , >= et <=
%left PLUS  MIN			// + et -
%left MULT  DIV                 // * et /
%left NEG NOT			// - unaire et !
%right POW			// ^ (puissance)

%start Input
%%

Input:
               {/* Nothing ... */ }
  | Line Input { /* Nothing ... */ }


Line:
    EOL {  }
  | Instlist EOL { exec($1); }
; 

Instlist:
    Inst { $$ = nodeChildren(createNode(NTINSTLIST), $1, createNode(NTEMPTY)); } 
  | Instlist Inst { $$ = nodeChildren(createNode(NTINSTLIST), $1, $2); }
;

Inst:
    Expr COLON { $$ = $1; } 
;

Expr:
    NUMBER				   	{ $$ = $1; }
  | Expr PLUS Expr     			{ $$ = nodeChildren($2, $1, $3); }
  | Expr MIN Expr   			{ $$ = nodeChildren($2, $1, $3); }
  | Expr MULT Expr    			{ $$ = nodeChildren($2, $1, $3); }
  | Expr DIV Expr      			{ $$ = nodeChildren($2, $1, $3); }
  | MIN Expr %prec NEG 			{ $$ = nodeChildren($1, createNode(NTEMPTY), $2); }
  | Expr POW Expr      			{ $$ = nodeChildren($2, $1, $3); }
  | OP_PAR Expr CL_PAR { $$ = $2; }
  ;

%%

int exec(Node *node) {
  printGraph(node);
  eval(node);
} 

int yyerror(char *s) {
  printf("%s\n", s);
} 

int main(int arc, char **argv) {
    if ((arc == 3) && (strcmp(argv[1], "-f") == 0)) {
        FILE *fp=fopen(argv[2],"r");
        if(!fp) {
            printf("Impossible d'ouvrir le fichier à executer.\n");
            exit(0);
        }      
        yyin=fp;
        yyparse();
    }
    exit(0);
}