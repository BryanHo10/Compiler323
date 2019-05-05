hellomakefile:
	flex q2_lex.l
	bison -d q2_yacc.y
	gcc -o compiler q2_yacc.tab.c lex.yy.c -ly -ll