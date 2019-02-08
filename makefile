# State Nicolae 333CC
build:
	flex tema.l
	gcc lex.yy.c 
run:
	flex tema.l
	gcc lex.yy.c 
	./a.out example1
clean:
	rm a.out
	rm lex.yy.c    
