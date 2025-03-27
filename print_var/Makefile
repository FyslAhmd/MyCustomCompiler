main:
	bison -d parser.y
	flex lexer.l
	gcc lex.yy.c parser.tab.c -o cCompiler
	cCompiler < input.txt > output.txt