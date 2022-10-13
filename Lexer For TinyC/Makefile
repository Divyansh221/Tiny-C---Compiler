output.txt: a.out ass3_GROUP_49_test.c
	./a.out < ass3_GROUP_49_test.c > output.txt

a.out: lex.yy.o
	gcc lex.yy.o -lfl

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c -lfl

lex.yy.c: ass3_GROUP_49.l ass3_GROUP_49.c
	flex ass3_GROUP_49.l ass3_GROUP_49.c

clean:
	rm -rf output.txt a.out lex.yy.c lex.yy.o
