/* Lexer for tinyC (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

%{
	#include <stdio.h>
	#include <string.h>

	#include "ass6_GROUP_49_translator.h"
	#include "ass6_GROUP_49.tab.h"

    extern YYSTYPE yylval;
    extern int line;
    int line = 1;
%}

%option noyywrap

/* Regular Expression Definations */

/*KEYWORDS*/

KEYWORD 					"_bool"|"_complex"|"_imaginary"|"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"inline"|"if"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"
	
LETTER          			[a-zA-Z]
DIGIT           			[0-9]
NON_ZERO        			[1-9]
DIGIT_SEQ       			{DIGIT}{DIGIT}*
ESCAPE_SEQ      			"\\\'"|"\\\""|"\\\?"|"\\\\"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"
C_CHAR          			[^\'\\\n]|{ESCAPE_SEQ}
S_CHAR          			[^\"\\\n]|{ESCAPE_SEQ}
CHAR_SEQ        			{C_CHAR}{C_CHAR}*
STRING_SEQ      			{S_CHAR}{S_CHAR}*

IDENTIFIER      			({LETTER}|"_")({LETTER}|{DIGIT}|"_")*

FRAC            			{DIGIT_SEQ}\.|\.{DIGIT_SEQ}|{DIGIT_SEQ}\.{DIGIT_SEQ}
FLOAT_CONST     			({FRAC}|{DIGIT_SEQ})([Ee]([-+]{DIGIT_SEQ}|{DIGIT_SEQ}))|{FRAC}|"0"*\."0"*
INT_CONST       			{NON_ZERO}{DIGIT}*|"0"+
CHAR_CONST      			\'{CHAR_SEQ}\'

STRING          			\"{STRING_SEQ}\"|\"\"
COMMENT_LINE    			"//".*
COMMENT_MULTI   			"/*"([^*]|\*+[^/*])*\**(\*"/")? 

/*PUNCTUATORS*/

PUNCTUATOR 					"["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"

WS              			[ \t]
NEWLINE         			[\n]

%%
{COMMENT_LINE}          	{ /*printf("This single line comment will be ignored by the parser\n");*/ }
{COMMENT_MULTI}         	{ /*printf("This multi line comment will be ignored by the parser\n");*/  }

{KEYWORD}				{
	if(strcmp(yytext, "_bool") == 0)		{ return BOOL; }
	if(strcmp(yytext, "_complex") == 0)		{ return COMPLEX; }
	if(strcmp(yytext, "_imaginary") == 0)	{ return IMAGINARY; }
	if(strcmp(yytext, "auto") == 0)			{ return AUTO; }
	if(strcmp(yytext, "break") == 0)		{ return BREAK; }
	if(strcmp(yytext, "case") == 0)			{ return CASE; }
	if(strcmp(yytext, "char") == 0)		  	{ return CHAR; }
	if(strcmp(yytext, "const") == 0)		{ return CONST; }
	if(strcmp(yytext, "continue") == 0)		{ return CONTINUE; }
	if(strcmp(yytext, "default") == 0)		{ return DEFAULT; }
	if(strcmp(yytext, "do") == 0)			{ return DO; }
	if(strcmp(yytext, "double") == 0)		{ return DOUBLE; }
	if(strcmp(yytext, "else") == 0)			{ return ELSE; }
	if(strcmp(yytext, "enum") == 0)			{ return ENUM; }
	if(strcmp(yytext, "extern") == 0)		{ return EXTERN; }
	if(strcmp(yytext, "float") == 0)		{ return FLOAT; }
	if(strcmp(yytext, "for") == 0)			{ return FOR; }
	if(strcmp(yytext, "goto") == 0)			{ return GOTO; }
	if(strcmp(yytext, "inline") == 0)		{ return INLINE; }
	if(strcmp(yytext, "if") == 0)			{ return IF; }
	if(strcmp(yytext, "int") == 0)			{ return INT; }
	if(strcmp(yytext, "long") == 0)			{ return LONG; }
	if(strcmp(yytext, "register") == 0)		{ return REGISTER; }
	if(strcmp(yytext, "restrict") == 0)		{ return RESTRICT; } 
	if(strcmp(yytext, "return") == 0)		{ return RETURN; }
	if(strcmp(yytext, "short") == 0)		{ return SHORT; }
	if(strcmp(yytext, "signed") == 0)		{ return SIGNED; }
	if(strcmp(yytext, "sizeof") == 0)		{ return SIZEOF; }
	if(strcmp(yytext, "static") == 0)		{ return STATIC; }
	if(strcmp(yytext, "struct") == 0)		{ return STRUCT; }
	if(strcmp(yytext, "switch") == 0)		{ return SWITCH; }
	if(strcmp(yytext, "typedef") == 0)		{ return TYPEDEF; }
	if(strcmp(yytext, "union") == 0)		{ return UNION; }
	if(strcmp(yytext, "unsigned") == 0)		{ return UNSIGNED; }
	if(strcmp(yytext, "void") == 0)			{ return VOID; }
	if(strcmp(yytext, "volatile") == 0)		{ return VOLATILE; }
	if(strcmp(yytext, "while") == 0)		{ return WHILE; }
}

{PUNCTUATOR}			{
	if(strcmp(yytext,"[") == 0) 	return SQUARE_BRACKET_OPEN;
	if(strcmp(yytext,"]") == 0) 	return SQUARE_BRACKET_CLOSE;
	if(strcmp(yytext,"(") == 0) 	return ROUND_BRACKET_OPEN;
	if(strcmp(yytext,")") == 0) 	return ROUND_BRACKET_CLOSE;
	if(strcmp(yytext,"{") == 0) 	return CURLY_BRACKET_OPEN;
	if(strcmp(yytext,"}") == 0) 	return CURLY_BRACKET_CLOSE;
	if(strcmp(yytext,".") == 0) 	return DOT;
	if(strcmp(yytext,"->") == 0) 	return IMPLIES;
	if(strcmp(yytext,"++") == 0) 	return INC;
	if(strcmp(yytext,"--") == 0) 	return DEC;
	if(strcmp(yytext,"&") == 0) 	return BITWISE_AND;
	if(strcmp(yytext,"*") == 0) 	return MUL;
	if(strcmp(yytext,"+") == 0) 	return ADD;
	if(strcmp(yytext,"-") == 0) 	return SUB;
	if(strcmp(yytext,"~") == 0) 	return BITWISE_NOT;
	if(strcmp(yytext,"!") == 0) 	return EXCLAIM;
	if(strcmp(yytext,"/") == 0) 	return DIV;
	if(strcmp(yytext,"%") == 0) 	return MOD;
	if(strcmp(yytext,"<<") == 0) 	return SHIFT_LEFT;
	if(strcmp(yytext,">>") == 0) 	return SHIFT_RIGHT;
	if(strcmp(yytext,"<") == 0) 	return BIT_SL;
	if(strcmp(yytext,">") == 0) 	return BIT_SR;
	if(strcmp(yytext,"<=") == 0) 	return LTE;
	if(strcmp(yytext,">=") == 0) 	return GTE;
	if(strcmp(yytext,"==") == 0) 	return EQ;
	if(strcmp(yytext,"!=") == 0) 	return NEQ;
	if(strcmp(yytext,"^") == 0) 	return BITWISE_XOR;
	if(strcmp(yytext,"|") == 0) 	return BITWISE_OR;
	if(strcmp(yytext,"||") == 0) 	return OR;
	if(strcmp(yytext,"&&") == 0) 	return AND;
	if(strcmp(yytext,"?") == 0) 	return QUESTION;
	if(strcmp(yytext,":") == 0) 	return COLON;
	if(strcmp(yytext,";") == 0) 	return SEMICOLON;
	if(strcmp(yytext,"...") == 0) 	return DOTS;
	if(strcmp(yytext,"=") == 0) 	return ASSIGN;
	if(strcmp(yytext,"*=") == 0) 	return STAR_EQ;
	if(strcmp(yytext,"/=") == 0) 	return DIV_EQ;
	if(strcmp(yytext,"%=") == 0) 	return MOD_EQ;
	if(strcmp(yytext,"+=") == 0) 	return ADD_EQ;
	if(strcmp(yytext,"-=") == 0) 	return SUB_EQ;
	if(strcmp(yytext,"<<=") == 0) 	return SL_EQ;
	if(strcmp(yytext,">>=") == 0) 	return SR_EQ;
	if(strcmp(yytext,"&=") == 0) 	return BITWISE_AND_EQ;
	if(strcmp(yytext,"^=") == 0) 	return BITWISE_XOR_EQ;
	if(strcmp(yytext,"|=") == 0) 	return BITWISE_OR_EQ;
	if(strcmp(yytext,",") == 0) 	return COMMA;
	if(strcmp(yytext,"#") == 0) 	return HASH;
}

{IDENTIFIER}            { 
    yylval.symp = table->lookup(yytext);
	return IDENTIFIER; 
}

{INT_CONST}             { 
    yylval.intval = atoi(yytext);
	return INTEGER_CONSTANT;  
}

{CHAR_CONST}            { 
    yylval.charval = yytext;
	return CHARACTER_CONSTANT;  
}

{FLOAT_CONST}           { 
    yylval.charval = yytext;
    return FLOATING_CONSTANT;  
}

{STRING}                { 
    yylval.charval = yytext;
	return STRING_LITERAL; 
}

{WS}                    { /*White-space Rule*/ }
{NEWLINE}               { /* printf("\n\n============================== Parsing line %d ============================== \n\n", ++line ); */ }
%%