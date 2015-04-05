del FranC.exe
del tree.o
del eval.o
del lang.lex.c
del lang.lex.o
del lang.h
del lang.y.c
del lang.y.o
CLS
pause
win_bison -d lang.y
rename  lang.tab.c lang.y.c
rename lang.tab.h lang.h
win_flex lang.l
rename  lex.yy.c lang.lex.c
gcc -c tree.c -o tree.o
gcc -c eval.c -o eval.o
gcc -c lang.lex.c -o lang.lex.o
gcc -c lang.y.c -o lang.y.o
gcc -o FranC lang.lex.o lang.y.o tree.o eval.o 
FranC -f "test.txt"
pause