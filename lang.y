%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "tree.h"
#include "eval.h"

extern FILE *yyin;
extern int  yyparse();
Node root;
%}

%union {
    struct Node *node;
}

%token   <node> NUMBER VAR AFF
%token   <node> PLUS MIN MULT DIV POW
%token   <node> PLUSPLUS
%token   <node> NON NOT EQUAL NEQUAL GT LT GET LET
%token   <node> INT FLOAT CHAR DOUBLE STRING
%token   <node> OU ET
%token   <node> DISPLAY SI ALORS SINON
%token   <node> POUR TANTQUE FAIRE FIN
%token   <node> VRAI FAUX
%token   OP_PAR CL_PAR COLON
%token   EOL

%type   <node> Instlist
%type   <node> Inst
%type   <node> Expr
%type   <node> ExB
%type   <node> Term
%type   <node> Incr
%type   <node> Type

%left INT FLOAT CHAR DOUBLE STRING  // Les noms de types pour la déclaration de variables.
%left AFF                           // =
%left OU                            // OU Logique
%left ET                            // ET Logique
%left EQUAL NEQUAL                  // ==  et !=
%left GT LT GET LET                 // > , < , >= et <=
%left PLUS  MIN                     // + et -
%left MULT  DIV                     // * et /
%left NEG NOT                       // - unaire et !
%right POW                          // ^ (puissance)
%right PLUSPLUS                     // ++ (incrémentation)

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
    | VAR AFF Expr COLON                                { $$ = nodeChildren($2, $1, $3); }
    | Type VAR AFF Expr COLON                           { $$ = nodeChildren($1, createNode(NTEMPTY), nodeChildren($3, $2, $4) ); }
    | SI ExB ALORS Instlist FIN COLON                   { $$ = nodeChildren($1, $2, $4); }
    | SI ExB ALORS Instlist SINON Instlist FIN COLON    { $$ = nodeChildren($5, nodeChildren($1, $2, $4), $6); }
    | POUR VAR AFF Expr COLON ExB COLON Incr FAIRE Instlist FIN COLON { $$ = nodeChildren($1, nodeChildren($3, $2, $4), nodeChildren($9, $6, nodeChildren(createNode(NTEMPTY), $8, $10) ) ); }
    | TANTQUE ExB FAIRE Instlist FIN COLON              { $$ = nodeChildren($1, $2, $4 ); }
    | Incr                                              { $$ = $1; }
;

Type:
    INT                                         { $$ = $1; }
    | FLOAT                                     { $$ = $1; }
    | CHAR                                      { $$ = $1; }
    | DOUBLE                                    { $$ = $1; }
    | STRING                                    { $$ = $1; }
;

Incr:
    VAR PLUSPLUS COLON                          { $$ = nodeChildren($2, createNode(NTEMPTY), $1); }
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

ExB:
    Term                                        { $$ = $1; }
    | VRAI                                      { $$ = $1; }
    | FAUX                                      { $$ = $1; }
    | Term EQUAL Term                           { $$ = nodeChildren($2, $1 ,$3); }
    | Term NEQUAL Term                          { $$ = nodeChildren($2, $1 ,$3); }
    | Term GT Term                              { $$ = nodeChildren($2, $1 ,$3); }
    | Term LT Term                              { $$ = nodeChildren($2, $1 ,$3); }
    | Term GET Term                             { $$ = nodeChildren($2, $1 ,$3); }
    | Term LET Term                             { $$ = nodeChildren($2, $1 ,$3); }
    | NOT ExB %prec NON                         { $$ = nodeChildren($1, createNode(NTEMPTY), $2); }
    | OP_PAR ExB OU ExB CL_PAR                  { $$ = nodeChildren($3, $2, $4); }
    | OP_PAR ExB ET ExB CL_PAR                  { $$ = nodeChildren($3, $2, $4); }
;

%%

int exec(Node *node) {
  eval(node);
}

int yyerror(char *s) {
  printf("%s\n", s);
}

int main(int arc, char **argv) {

    FILE * fp = NULL;

    if ( (arc == 3) && (strcmp(argv[1], "-f") == 0) ) {
        fp = fopen( argv[2], "r" );
    }
    if ( fp != NULL ) {
        yyin = fp;
        yyparse();
    }
    else {
        yyin = stdin;
        printf("Bonjour, veuillez saisir vos instructions :\n");
        yyparse();
    }
    exit(0);
}