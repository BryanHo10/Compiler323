hellomakefile:
	flex q3_lex.l
	bison -d q3_yacc.y
	gcc -o compiler q3_yacc.tab.c lex.yy.c -ly -ll