%option noyywrap

%{
#include "lang.h"
#include <stdlib.h>
#include <string.h>
#include "tree.h"
%}

blank [ \t]+

chiffre     [0-9]
nombre      {chiffre}+
mot         [a-zA-Z]
exposant    [eE][+-]?{nombre}
real        {nombre}("."{nombre})?{exposant}?

%%

{blank}  { /* Nothing */ } 

"("   return(OP_PAR);
")"   return(CL_PAR);

{real} {
    yylval.node = createNode(NTNUM);
    yylval.node->val = atof(yytext);
    return(NUMBER);
}

{mot} {
    yylval.node = createNode(NTVAR); printf("Affectation d'une variable : \n");
    yylval.node->var = strdup(yytext);
    return(VAR);
}

AFFICHER { yylval.node = createNode(NTDISPLAY); return (DISPLAY); }

SI { yylval.node = createNode(NTSI); return (SI); }
ALORS { yylval.node = createNode(NTALORS); return (ALORS); }
SINON { yylval.node = createNode(NTSINON); return (SINON); }
FIN { yylval.node = createNode(NTFIN); return (FIN); }

TANTQUE { yylval.node = createNode(NTTANTQUE); return (TANTQUE); }
FAIRE { yylval.node = createNode(NTFAIRE); return (FAIRE); }

VRAI { yylval.node = createNode(NTVRAI); return (VRAI); }
FAUX { yylval.node = createNode(NTFAUX); return (FAUX); }

"+"   { yylval.node = createNode(NTPLUS); return(PLUS); }
"-"   { yylval.node = createNode(NTMIN); return(MIN); }
"*"   { yylval.node = createNode(NTMULT); return(MULT); }
"/"   { yylval.node = createNode(NTDIV); return(DIV); }
"^"   { yylval.node = createNode(NTPOW); return(POW); }
"="   { yylval.node = createNode(NTEGAL); return(EGAL); }
"=="  { yylval.node = createNode(NTEQUAL); return (EQUAL); }
";"    { return(COLON); }

"\n"   { return(EOL); }
