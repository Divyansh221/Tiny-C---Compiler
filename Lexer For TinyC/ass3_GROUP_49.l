/* Lexer for tinyC (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia */
/* Amartya Mandal */

/* FLEX Specifications */

/* C Declarations and Definitions */
%{			/* This code goes at the top of the generated file, before any FLEX definitions */
#include <stdio.h>			
#include <string.h>
%}

%{
#define AUTO						 1
#define ENUM						 2
#define RESTRICT					 3
#define UNSIGNED					 4
#define BREAK						 5
#define EXTERN						 6
#define RETURN						 7
#define VOID						 8
#define CASE						 9
#define FLOAT						10
#define SHORT						11
#define VOLATILE					12
#define CHAR						13
#define FOR						14
#define SIGNED						15
#define WHILE						16
#define CONST 						17
#define GOTO						18
#define SIZEOF						19
#define _BOOL						20
#define CONTINUE					21
#define IF						22
#define STATIC						23
#define _COMPLEX					24
#define DEFAULT					25
#define INLINE						26
#define STRUCT						27
#define _IMAGINARY					28
#define DO						29
#define INT						30
#define SWITCH						31
#define DOUBLE						32
#define LONG						33
#define TYPEDEF					34
#define ELSE						35
#define REGISTER					36
#define UNION						37

#define DIGIT						38
#define IDENTIFIER_NONDIGIT 				39
#define IDENTIFIER 					40

#define NONZERO_DIGIT					41
#define NONZERO_INTEGER_CONSTANT			42
#define INTEGER_CONSTANT				43
#define DIGIT_SEQUENCE					44
#define SIGN 						45
#define EXPONENT_PART					46
#define FRACTIONAL_CONSTANT				47
#define FLOATING_CONSTANT				48
#define ENUMERATION_CONSTANT				49
#define ESCAPE_SEQUENCE				50
#define C_CHAR 					51
#define C_CHAR_SEQUENCE				52
#define CHARACTER_CONSTANT				53
#define CONSTANT					54

#define S_CHAR  					55
#define S_CHAR_SEQUENCE				56
#define STRING_LITERAL 				57

#define SQ_BRACKET_OPEN				58
#define SQ_BRACKET_CLOSE				59
#define RO_BRACKET_OPEN				60
#define RO_BRACKET_CLOSE				61
#define CUR_BRACKET_OPEN				62
#define CUR_BRACKET_CLOSE				63
#define DOT 						64
#define ACC						65
#define INC 						66
#define DEC 						67
#define AMP 						68
#define MUL 						69
#define ADD 						70
#define SUB 						71
#define NEG 						72
#define EXCLAIM 					73
#define DIV 						74
#define MODULO 					75
#define SHIFT_L 					76
#define SHIFT_R 					77
#define LST						78
#define GRT						79
#define LTE 						80
#define GTE 						81
#define EQ 						82
#define NEQ 						83
#define BIN_XOR 					84
#define BIN_OR 					85
#define AND 						86
#define OR 						87
#define QUESTION    					88
#define COLON 						89
#define SEMICOLON 					90
#define DOTS 						91
#define ASSIGN						92
#define STAR_EQ 					93
#define DIV_EQ 					94
#define MOD_EQ 					95
#define PLUS_EQ					96
#define MINUS_EQ  					97
#define SHIFT_LEQ       				98
#define SHIFT_REQ 					99
#define BIN_AND_EQ 					100
#define BIN_XOR_EQ					101
#define BIN_OR_EQ 					102
#define COMMA 						103
#define HASH 			           		104

#define SINGLE_LINE_COMMENT		   		105
#define MULTI_LINE_COMMENT		   		106
#define COMMENT 				   	107

%}

/* Regular Expression Definitions */
/* KEYWORDS */
AUTO		"auto"
ENUM		"enum"
RESTRICT	"restrict"
UNSIGNED	"unsigned"
BREAK		"break"
EXTERN		"extern"
RETURN		"return"
VOID		"void"
CASE		"case"
FLOAT		"float"
SHORT		"short"
VOLATILE	"volatile"
CHAR		"char"
FOR		"for"
SIGNED		"signed"
WHILE		"while"
CONST		"const"
GOTO		"goto"
SIZEOF		"sizeof"
_BOOL		"_Bool"
CONTINUE	"continue"
IF		"if"
STATIC		"static"
_COMPLEX	"_Complex"
DEFAULT	"default"
INLINE		"inline"
STRUCT		"struct"
_IMAGINARY	"_Imaginary"
DO		"do"
INT		"int"
SWITCH		"switch"
DOUBLE		"double"
LONG		"long"
TYPEDEF	"typedef"
ELSE		"else"
REGISTER	"register"
UNION		"union"

/* IDENTIFIERS */
DIGIT						[0-9]
IDENTIFIER_NONDIGIT 				[a-zA-Z]|"_"
IDENTIFIER 					{IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*

/* CONSTANTS */
NONZERO_DIGIT					[1-9]
NONZERO_INTEGER_CONSTANT			{NONZERO_DIGIT}({NONZERO_DIGIT}|{DIGIT})*
INTEGER_CONSTANT				{NONZERO_INTEGER_CONSTANT}|"0"
DIGIT_SEQUENCE					{DIGIT}+
SIGN 						"+"|"-"
EXPONENT_PART					("e"{SIGN}?{DIGIT_SEQUENCE})|("E"{SIGN}?{DIGIT_SEQUENCE})
FRACTIONAL_CONSTANT				({DIGIT_SEQUENCE}?"."{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}".")
FLOATING_CONSTANT				({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})
ENUMERATION_CONSTANT				{IDENTIFIER}

ESCAPE_SEQUENCE				"\'"|"\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
C_CHAR 						{ESCAPE_SEQUENCE}|[^("\'"|"\\"|"\n")]
C_CHAR_SEQUENCE				{C_CHAR}+
CHARACTER_CONSTANT				"\'"{C_CHAR_SEQUENCE}"\'"

CONSTANT					{INTEGER_CONSTANT}|{FLOATING_CONSTANT}|{ENUMERATION_CONSTANT}|{CHARACTER_CONSTANT}

/* STRING LITERALS */
S_CHAR  					{ESCAPE_SEQUENCE}|[^("\""|"\\"|"\n")]
S_CHAR_SEQUENCE				{S_CHAR}+
STRING_LITERAL 				"\""{S_CHAR_SEQUENCE}?"\""

/* PUNCTUATORS */
PUNCTUATOR_A					"["|"]"|"("|")"|"{"|"}"|"."|"->"
PUNCTUATOR_B					"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"
PUNCTUATOR_C					"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"
PUNCTUATOR_D					"?"|":"|";"|"..."
PUNCTUATOR_E					"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="
PUNCTUATOR_F					","|"#"
PUNCTUATOR 					{PUNCTUATOR_A}|{PUNCTUATOR_B}|{PUNCTUATOR_C}|{PUNCTUATOR_D}|{PUNCTUATOR_E}|{PUNCTUATOR_F}

/* COMMMENTS */
SINGLE_LINE_COMMENT				"//"[^("\n")]*
MULTI_LINE_COMMENT				"/*"([^*]|\*+[^*/])*\*+"/"
COMMENT 					{SINGLE_LINE_COMMENT}|{MULTI_LINE_COMMENT}

/* WHITE SPACE */
WS 						[ \t\n]

/* Definitions of Rules & Actions */
%%
{AUTO}					{ return AUTO; }
{ENUM}					{ return ENUM; }
{RESTRICT}				{ return RESTRICT; }
{UNSIGNED}				{ return UNSIGNED; }
{BREAK}				{ return BREAK; }
{EXTERN}				{ return EXTERN; }
{RETURN}				{ return RETURN; }
{VOID}					{ return VOID; }
{CASE}					{ return CASE; }
{FLOAT}				{ return FLOAT; }
{SHORT}				{ return SHORT; }
{VOLATILE}				{ return VOLATILE; }
{CHAR}					{ return CHAR; }
{FOR}					{ return FOR; }
{SIGNED}				{ return SIGNED; }
{WHILE}				{ return WHILE; }
{CONST}				{ return CONST; }
{GOTO}					{ return GOTO; }
{SIZEOF}				{ return SIZEOF; }
{_BOOL}				{ return _BOOL; }
{CONTINUE}				{ return CONTINUE; }
{IF}					{ return IF; }
{STATIC}				{ return STATIC; }
{_COMPLEX}				{ return _COMPLEX; }
{DEFAULT}				{ return DEFAULT; }
{INLINE}				{ return INLINE; }
{STRUCT}				{ return STRUCT; }
{_IMAGINARY}				{ return _IMAGINARY; }
{DO}					{ return DO; }
{INT}					{ return INT; }
{SWITCH}				{ return SWITCH; }
{DOUBLE}				{ return DOUBLE; }
{LONG}					{ return LONG; }
{TYPEDEF}				{ return TYPEDEF; }
{ELSE}					{ return ELSE; }
{REGISTER}				{ return REGISTER; }
{UNION}				{ return UNION; }

{IDENTIFIER}				{ return IDENTIFIER; }
{INTEGER_CONSTANT}			{ return INTEGER_CONSTANT; }
{FLOATING_CONSTANT}			{ return FLOATING_CONSTANT; }
{CHARACTER_CONSTANT} 			{ return CHARACTER_CONSTANT; }
{STRING_LITERAL} 			{ return STRING_LITERAL; }

{PUNCTUATOR}			{
	if(strcmp(yytext,"[") == 0) return SQ_BRACKET_OPEN;
	if(strcmp(yytext,"]") == 0) return SQ_BRACKET_CLOSE;
	if(strcmp(yytext,"(") == 0) return RO_BRACKET_OPEN;
	if(strcmp(yytext,")") == 0) return RO_BRACKET_CLOSE;
	if(strcmp(yytext,"{") == 0) return CUR_BRACKET_OPEN;
	if(strcmp(yytext,"}") == 0) return CUR_BRACKET_CLOSE;
	if(strcmp(yytext,".") == 0) return DOT;
	if(strcmp(yytext,"->") == 0) return ACC;

	if(strcmp(yytext,"++") == 0) return INC;
	if(strcmp(yytext,"--") == 0) return DEC;
	if(strcmp(yytext,"&") == 0) return AMP;
	if(strcmp(yytext,"*") == 0) return MUL;
	if(strcmp(yytext,"+") == 0) return ADD;
	if(strcmp(yytext,"-") == 0) return SUB;
	if(strcmp(yytext,"~") == 0) return NEG;
	if(strcmp(yytext,"!") == 0) return EXCLAIM;

	if(strcmp(yytext,"/") == 0) return DIV;
	if(strcmp(yytext,"%") == 0) return MODULO;
	if(strcmp(yytext,"<<") == 0) return SHIFT_L;
	if(strcmp(yytext,">>") == 0) return SHIFT_R;
	if(strcmp(yytext,"<") == 0) return LST;
	if(strcmp(yytext,">") == 0) return GRT;
	if(strcmp(yytext,"<=") == 0) return LTE;
	if(strcmp(yytext,">=") == 0) return GTE;
	if(strcmp(yytext,"==") == 0) return EQ;
	if(strcmp(yytext,"!=") == 0) return NEQ;
	if(strcmp(yytext, "^") == 0) return BIN_XOR;
	if(strcmp(yytext, "|") == 0) return BIN_OR;
	if(strcmp(yytext,"&&") == 0) return AND;
	if(strcmp(yytext,"||") == 0) return OR;

	if(strcmp(yytext,"?") == 0) return QUESTION;
	if(strcmp(yytext,":") == 0) return COLON;
	if(strcmp(yytext,";") == 0) return SEMICOLON;
	if(strcmp(yytext,"...") == 0) return DOTS;
	if(strcmp(yytext,"=") == 0) return ASSIGN;
	if(strcmp(yytext,"*=") == 0) return STAR_EQ;
	if(strcmp(yytext,"/=") == 0) return DIV_EQ;
	if(strcmp(yytext,"%=") == 0) return MOD_EQ;
	if(strcmp(yytext,"+=") == 0) return PLUS_EQ;
	if(strcmp(yytext,"-=") == 0) return MINUS_EQ;
	if(strcmp(yytext,"<<=") == 0) return SHIFT_LEQ;
	if(strcmp(yytext,">>=") == 0) return SHIFT_REQ;
	if(strcmp(yytext,"&=") == 0) return BIN_AND_EQ;
	if(strcmp(yytext,"^=") == 0) return BIN_XOR_EQ;
	if(strcmp(yytext,"|=") == 0) return BIN_OR_EQ;

	if(strcmp(yytext,",") == 0) return COMMA;
	if(strcmp(yytext,"#") == 0) return HASH;
}

{SINGLE_LINE_COMMENT}	{ return SINGLE_LINE_COMMENT; }
{MULTI_LINE_COMMENT} 	{ return MULTI_LINE_COMMENT; }

{WS}					{/* Ignore whitespace */}
%%
