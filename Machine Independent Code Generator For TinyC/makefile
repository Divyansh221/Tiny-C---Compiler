test: a.out
	./a.out < ass5_GROUP_49_test1.c > ass5_GROUP_49_quads1.out
	@echo "Test File 1 Successfully Translated !\n"

	./a.out < ass5_GROUP_49_test2.c > ass5_GROUP_49_quads2.out
	@echo "Test File 2 Successfully Translated !\n"

	./a.out < ass5_GROUP_49_test3.c > ass5_GROUP_49_quads3.out
	@echo "Test File 3 Successfully Translated !\n"

	./a.out < ass5_GROUP_49_test4.c > ass5_GROUP_49_quads4.out
	@echo "Test File 4 Successfully Translated !\n"
	
	./a.out < ass5_GROUP_49_test5.c > ass5_GROUP_49_quads5.out
	@echo "Test File 5 Successfully Translated !\n"

	@echo "\nALL TEST FILES SUCCESSFULLY TRANSLATED !!\n"

a.out: lex.yy.o y.tab.o ass5_GROUP_49_translator.o
	g++ lex.yy.o y.tab.o ass5_GROUP_49_translator.o -lfl

ass5_GROUP_49_translator.o: ass5_GROUP_49_translator.cxx ass5_GROUP_49_translator.h
	g++ -c ass5_GROUP_49_translator.h
	g++ -c ass5_GROUP_49_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

y.tab.o: y.tab.c
	g++ -c y.tab.c

lex.yy.c: ass5_GROUP_49.l y.tab.h ass5_GROUP_49_translator.h
	flex ass5_GROUP_49.l

y.tab.c: ass5_GROUP_49.y
	yacc -dtv ass5_GROUP_49.y -Wno

y.tab.h: ass5_GROUP_49.y
	yacc -dtv ass5_GROUP_49.y -Wno

clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o ass5_GROUP_49_translator.o y.output a.out ass5_GROUP_49_translator.h.gch