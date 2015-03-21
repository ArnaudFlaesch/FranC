%option noyywrap

%{
#include "lang.h"
#include <stdlib.h>
#include <string.h>
#include "tree.h"
%}

blank [ \t]+

chiffre [0-9]
nombre {chiffre}+
mot [a-zA-Z]
exposant  [eE][+-]?{nombre}
real      {nombre}("."{nombre})?{exposant}?

%%

{blank}  { /* Nothing */ } 

"("   return(OP_PAR);
")"   return(CL_PAR);

{real} {
    yylval.node = createNode(NTNUM);
    yylval.node->val = atof(yytext);
    return(NUMBER);
}

"+"   { yylval.node = createNode(NTPLUS); return(PLUS); }
"-"   { yylval.node = createNode(NTMIN); return(MIN); }
"*"   { yylval.node = createNode(NTMULT); return(MULT); }
"/"   { yylval.node = createNode(NTDIV); return(DIV); }
"^"   { yylval.node = createNode(NTPOW); return(POW); }

";"    { return(COLON); }

"\n"   { return(EOL); }
