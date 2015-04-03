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

%token   <node> NUMBER VAR EGAL
%token   <node> PLUS MIN MULT DIV POW
%token   <node> DISPLAY SI ALORS SINON
%token   <node> TANTQUE FAIRE
%token   <node> FIN
%token   OP_PAR CL_PAR COLON
%token   <node> VRAI FAUX
%token   EOL

%type   <node> Instlist
%type   <node> Inst
%type   <node> Expr
%type   <node> ExB
%type   <node> Term
%type   <node> Opr

%left OR			// OU
%left AND			// ET
%left EQUAL NEQ                 // ==  et !=
%left GT LT GET LET             // > , < , >= et <=
%left PLUS  MIN			// + et -
%left MULT  DIV                 // * et /
%left NEG NOT			// - unaire et !
%right POW			// ^ (puissance)

%start Input
%%

Input:
               { /* Nothing ... */ }
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
    Expr COLON                                          { $$ = $1; }
    | DISPLAY OP_PAR Expr CL_PAR COLON                  { $$ = nodeChildren($1, createNode(NTEMPTY), $3); }
    | VAR EGAL Expr COLON                               { $$ = nodeChildren($2, $1, $3); }
    | SI ExB ALORS Instlist FIN COLON                   { $$ = nodeChildren($1, $2, nodeChildren($3, $4, $5 ) ); }
    | SI ExB ALORS Instlist SINON Instlist FIN COLON    { $$ = nodeChildren($1, $2, nodeChildren ($3, $4, nodeChildren ($5, $6, $7) ) ); }
    | TANTQUE ExB FAIRE Instlist FIN COLON              { $$ = nodeChildren($1, $2, nodeChildren ($3, $4, $5) ); }
;

Expr:
    NUMBER				   	{ $$ = $1; }
    | VAR                                       
    | Expr PLUS Expr     			{ $$ = nodeChildren($2, $1, $3); }
    | Expr MIN Expr                             { $$ = nodeChildren($2, $1, $3); }
    | Expr MULT Expr    			{ $$ = nodeChildren($2, $1, $3); }
    | Expr DIV Expr      			{ $$ = nodeChildren($2, $1, $3); }
    | MIN Expr %prec NEG 			{ $$ = nodeChildren($1, createNode(NTEMPTY), $2); }
    | Expr POW Expr      			{ $$ = nodeChildren($2, $1, $3); }
    | OP_PAR Expr CL_PAR                        { $$ = $2; }
;

Term:
    VAR                                         { $$ = $1; }
    | NUMBER                                    { $$ = $1; }
;

Opr:
    
;

ExB:
    Term                                        { $$ = $1; }
    | ExB Opr ExB                               { $$ = nodeChildren($2, $1, $3); }
    | VRAI                                      { $$ = $1; }
    | FAUX                                      { $$ = $1; }
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