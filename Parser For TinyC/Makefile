asgn4_GROUP_49.txt: a.out asgn4_GROUP_49_test.c
	./a.out < asgn4_GROUP_49_test.c > asgn4_GROUP_49.txt

a.out: lex.yy.o asgn4_GROUP_49_main.o y.tab.o
	gcc lex.yy.o asgn4_GROUP_49_main.o y.tab.o -lfl 

lex.yy.c: asgn4_GROUP_49.l y.tab.h
	flex asgn4_GROUP_49.l

y.tab.c: asgn4_GROUP_49.y 
	yacc -dtv asgn4_GROUP_49.y -Wno

asgn4_GROUP_49.o: asgn4_GROUP_49.c 
	gcc -c asgn4_GROUP_49.c 

y.tab.h: asgn4_GROUP_49.y
	yacc -dtv asgn4_GROUP_49.y -Wno

lex.yy.o: lex.yy.c 
	gcc -c lex.yy.c 

y.tab.o: y.tab.c 
	gcc -c y.tab.c

clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o asgn4_GROUP_49_main.o y.output asgn4_GROUP_49.txt a.out
