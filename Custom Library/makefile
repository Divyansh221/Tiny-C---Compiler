a.out: main.o libass2_19CS10027.a
	gcc main.o -L. -lass2_19CS10027

main.o: main.c myl.h
	gcc -Wall -c main.c

libass2_19CS10027.a: ass2_19CS10027.o
	ar -rcs libass2_19CS10027.a ass2_19CS10027.o

ass2_19CS10027.o: ass2_19CS10027.c myl.h
	gcc -Wall -c ass2_19CS10027.c

clean:
	rm a.out main.o libass2_19CS10027.a ass2_19CS10027.o