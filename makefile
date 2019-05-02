hellomake:
	lex brendan_lex.l
	cc lex.yy.c -ll
	./a.out