q1:
	flex q1_lexer.l
	cc lex.yy.c -ll -o q1
q2:
	flex q2_lex.l
	bison -d q2_yacc.y
	gcc -o compiler q2_yacc.tab.c lex.yy.c -ly -ll
q3:
	flex q3_lex.l
	bison -d q3_yacc.y
	gcc -o compiler q3_yacc.tab.c lex.yy.c -ly -ll