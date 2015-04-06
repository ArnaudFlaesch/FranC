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
variable    [a-z]+[a-zA-Z0-9]*
exposant    [eE][+-]?{nombre}
real        {nombre}("."{nombre})?{exposant}?

%%

{blank}  { /* Nothing */ } 

"("   return(OP_PAR);
")"   return(CL_PAR);

{variable} {
    yylval.node = createNode(NTVAR);
    yylval.node->var = strdup(yytext);
    return(VAR);
}

{real} {
    yylval.node = createNode(NTNUM);
    yylval.node->val = atof(yytext);
    return(NUMBER);
}

AFFICHER { yylval.node = createNode(NTDISPLAY); return (DISPLAY); }

SI { yylval.node = createNode(NTSI); return (SI); }
ALORS { yylval.node = createNode(NTALORS); return (ALORS); }
SINON { yylval.node = createNode(NTSINON); return (SINON); }
FIN { yylval.node = createNode(NTFIN); return (FIN); }

POUR { yylval.node = createNode(NTPOUR); return (POUR); }
TANTQUE { yylval.node = createNode(NTTANTQUE); return (TANTQUE); }
FAIRE { yylval.node = createNode(NTFAIRE); return (FAIRE); }

VRAI { yylval.node = createNode(NTVRAI); return (VRAI); }
FAUX { yylval.node = createNode(NTFAUX); return (FAUX); }

INT { yylval.node = createNode(NTINT); return (INT); }
FLOAT { yylval.node = createNode(NTFLOAT); return (FLOAT); }
CHAR { yylval.node = createNode(NTCHAR); return (CHAR); }
DOUBLE { yylval.node = createNode(NTDOUBLE); return (DOUBLE); }
STRING { yylval.node = createNode(NTSTRING); return (STRING); }

"+"   { yylval.node = createNode(NTPLUS); return(PLUS); }
"-"   { yylval.node = createNode(NTMIN); return(MIN); }
"*"   { yylval.node = createNode(NTMULT); return(MULT); }
"/"   { yylval.node = createNode(NTDIV); return(DIV); }
"^"   { yylval.node = createNode(NTPOW); return(POW); }
"="   { yylval.node = createNode(NTAFF); return(AFF); }

"!"   { yylval.node = createNode(NTNOT); return (NOT); }
"=="  { yylval.node = createNode(NTEQUAL); return (EQUAL); }
"!="  { yylval.node = createNode(NTNEQUAL); return (NEQUAL); }
">"   { yylval.node = createNode(NTGT); return (GT); }
"<"   { yylval.node = createNode(NTLT); return (LT); }
">="  { yylval.node = createNode(NTGET); return (GET); }
"<="  { yylval.node = createNode(NTLET); return (LET); }
"OU"  { yylval.node = createNode(NTOU); return (OU); }
"ET"  { yylval.node = createNode(NTET); return (ET); }

"++"  { yylval.node = createNode(NTPLUSPLUS); return(PLUSPLUS); }

";"    { return(COLON); }

"\n"   { return(EOL); }
