assembly: tinyC libass2_GROUP_49.a
	@echo "\n-------------    Generating Quads for the test files   ---------------\n"

	./tinyC 1 > ass6_GROUP_49_quads1.out
	./tinyC 2 > ass6_GROUP_49_quads2.out
	./tinyC 3 > ass6_GROUP_49_quads3.out
	./tinyC 4 > ass6_GROUP_49_quads4.out
	./tinyC 5 > ass6_GROUP_49_quads5.out

	@echo "\n-------------    Generating the object files from assembly code   ---------------\n"

	gcc -c ass6_GROUP_49_1.s
	gcc -c ass6_GROUP_49_2.s
	gcc -c ass6_GROUP_49_3.s
	gcc -c ass6_GROUP_49_4.s
	gcc -c ass6_GROUP_49_5.s

	@echo "\n-------------    Compiling the test files   ---------------\n"

	gcc ass6_GROUP_49_1.o -o test1 -L. -lass2_GROUP_49 -no-pie
	gcc ass6_GROUP_49_2.o -o test2 -L. -lass2_GROUP_49 -no-pie
	gcc ass6_GROUP_49_3.o -o test3 -L. -lass2_GROUP_49 -no-pie
	gcc ass6_GROUP_49_4.o -o test4 -L. -lass2_GROUP_49 -no-pie
	gcc ass6_GROUP_49_5.o -o test5 -L. -lass2_GROUP_49 -no-pie

	@echo "\n###########  Use ./test<i> for testing the ith file  ##########\n"

libass2_GROUP_49.a:
	gcc -c ass2_GROUP_49.c
	ar -rcs libass2_GROUP_49.a ass2_GROUP_49.o

tinyC: lex.yy.o ass6_GROUP_49.tab.o ass6_GROUP_49_translator.o ass6_GROUP_49_target_translator.o
	g++ lex.yy.o ass6_GROUP_49.tab.o ass6_GROUP_49_translator.o \
	ass6_GROUP_49_target_translator.o -lfl -o tinyC

ass6_GROUP_49_target_translator.o: ass6_GROUP_49_target_translator.cxx
	g++ -c ass6_GROUP_49_target_translator.cxx

ass6_GROUP_49_translator.o: ass6_GROUP_49_translator.cxx ass6_GROUP_49_translator.h
	g++ -c ass6_GROUP_49_translator.h
	g++ -c ass6_GROUP_49_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

ass6_GROUP_49.tab.o: ass6_GROUP_49.tab.c
	g++ -c ass6_GROUP_49.tab.c

lex.yy.c: ass6_GROUP_49.l ass6_GROUP_49.tab.h ass6_GROUP_49_translator.h
	flex ass6_GROUP_49.l

ass6_GROUP_49.tab.c: ass6_GROUP_49.y
	bison -dtv ass6_GROUP_49.y -W

ass6_GROUP_49.tab.h: ass6_GROUP_49.y
	bison -dtv ass6_GROUP_49.y -W

clean:
	rm lex.yy.c\
	   ass6_GROUP_49.tab.c\
	   ass6_GROUP_49.tab.h\
	   lex.yy.o\
	   ass6_GROUP_49.tab.o\
	   ass6_GROUP_49.output\
	   ass6_GROUP_49_translator.o\
	   test1\
	   test2\
	   test3\
	   test4\
	   test5\
	   tinyC\
	   ass6_GROUP_49_target_translator.o\
	   ass6_GROUP_49_translator.h.gch\
	   libass2_GROUP_49.a\
	   ass2_GROUP_49.o\
	   ass6_GROUP_49_1.o\
	   ass6_GROUP_49_2.o\
	   ass6_GROUP_49_3.o\
	   ass6_GROUP_49_4.o\
	   ass6_GROUP_49_5.o\