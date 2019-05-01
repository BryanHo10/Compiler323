hellomake:
	lex lex.l
	cc lex.yy.c -ll
	./a.out