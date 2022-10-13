/* Parser for tinyC (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

%{

// Header Files Needed

#include <iostream>
#include <sstream>  
#include <stdio.h>            
#include <cstdlib>
#include <string>

#include "ass5_GROUP_49_translator.h"		// Translator file

extern int yylex();							// yylex for lexer
void yyerror(string s);						// yyerror for error recovery
extern string var_type;						// var_type for last encountered type

using namespace std;
%}

%union {            						// yylval is a union of all these types
	char unaryOp;							// unary operator		
	char* char_value;						// char value

	int instr_number;						// instruction number: for backpatching
	int int_val;							// integer value	
	int num_params;							// number of parameters

	Expression* expr;						// expression
	Statement* stat;						// statement		
	symboltype* sym_type;					// symbol type  
	sym* symp;								// symbol
	Array* A;  								// Array type
} 

//Tokens

%token _BOOL _COMPLEX _IMAGINARY AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO INLINE IF INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE 
			
%token <symp> IDENTIFIER 		 		
%token <int_val> INTEGER_CONSTANT			
%token <char_value> FLOATING_CONSTANT			
%token <char_value> CHARACTER_CONSTANT				
%token <char_value> STRING_LITERAL 		

%token SQUARE_BRACKET_OPEN SQUARE_BRACKET_CLOSE
%token ROUND_BRACKET_OPEN ROUND_BRACKET_CLOSE
%token CURLY_BRACKET_OPEN CURLY_BRACKET_CLOSE			
%token DOT IMPLIES INC DEC BITWISE_AND MUL ADD SUB BITWISE_NOT EXCLAIM DIV MOD 
%token SHIFT_LEFT SHIFT_RIGHT BIT_SL BIT_SR 
%token LTE GTE EQ NEQ BITWISE_XOR BITWISE_OR OR AND 
%token QUESTION COLON SEMICOLON DOTS ASSIGN 
%token STAR_EQ DIV_EQ MOD_EQ ADD_EQ SUB_EQ SL_EQ SR_EQ BITWISE_AND_EQ BITWISE_XOR_EQ BITWISE_OR_EQ 
%token COMMA HASH 

%start translation_unit

%right "then" ELSE 							// to remove dangling else problem

%type <unaryOp> unary_operator 				// unary operator

//number of parameters
%type <num_params> argument_expression_list argument_expression_list_opt

%type <expr> 								// Expressions
	expression
	primary_expression 
	multiplicative_expression
	additive_expression
	shift_expression
	relational_expression
	equality_expression
	and_expression
	exclusive_or_expression
	inclusive_or_expression
	logical_and_expression
	logical_or_expression
	conditional_expression
	assignment_expression
	expression_statement

%type <stat>  statement 					// Statements
	compound_statement
	selection_statement
	iteration_statement
	labeled_statement 
	jump_statement
	block_item
	block_item_list
	block_item_list_opt

%type <sym_type> pointer

%type <symp> initializer
%type <symp> direct_declarator init_declarator declarator

%type <A> postfix_expression
	unary_expression
	cast_expression

// Auxillary non-terminals M and N
%type <instr_number> M
%type <stat> N

%%

M
	: %empty 
	{
		// backpatching, stores the index of the next quad to be generated
		// Used in various control statements
		$$ = nextinstr();
	}   
	;

N
	: %empty
	{
		// For backpatching, which inserts a goto
		// it stores the index of the next goto statement to guard against fallthrough
		$$ = new Statement();
		$$->nextlist = makelist(nextinstr());
		emit("goto", "");
	}
	;

primary_expression
	: IDENTIFIER               			    // identifier
	{ 
		debug();
		$$ = new Expression();              // create new expression, store pointer to ST entry in the location
		$$->loc = $1;
		$$->type = "not-boolean";
		debug();
	}
	| INTEGER_CONSTANT          			// create new expression and store the constant value in a temporary
	{ 
		debug();   
		$$ = new Expression();	
		string p = convertIntToString($1);
		$$->loc = gentemp(new symboltype("int"), p);
		emit("=", $$->loc->name, p);
		debug();
	}
	| FLOATING_CONSTANT        	  			// create new expression and store the constant value in a temporary
	{    
		debug();
		$$ = new Expression();
		$$->loc = gentemp(new symboltype("float"), $1);
		emit("=", $$->loc->name, string($1));
		debug();
	}
	| CHARACTER_CONSTANT       	  			// create new expression and store the constant value in a temporary
	{    
		debug();
		$$ = new Expression();
		$$->loc = gentemp(new symboltype("char"), $1);
		emit("=", $$->loc->name, string($1));
		debug();
	}
	| STRING_LITERAL        				// create new expression and store the constant value in a temporary 
	{   
		debug();
		$$ = new Expression();
		$$->loc = gentemp(new symboltype("ptr"), $1);
		$$->loc->type->arrtype = new symboltype("char");
		debug();
	}
	| ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE        		//simply equal to expression
	{ 
		$$ = $2;
	}
	;

postfix_expression
	: primary_expression      				// create new Array, store the location of primary expression in it
	{ 
		debug();
		$$ = new Array();
		$$->Array = $1->loc;	
		$$->type = $1->loc->type;	
		$$->loc = $$->Array;
		debug();
	}
	| postfix_expression SQUARE_BRACKET_OPEN expression SQUARE_BRACKET_CLOSE 
	{ 	
		debug();
		$$ = new Array();
		$$->type = $1->type->arrtype;								// type = type of element				
		$$->Array = $1->Array;										// copy the base
		$$->loc = gentemp(new symboltype("int"));					// store computed address
		$$->atype = "arr";											// atype is arr.
		if($1->atype == "arr") 
		{									// multiply the size of the sub-type of Array with the expression 
			debug();						// value and add
			sym* t = gentemp(new symboltype("int"));
			int p = computeSize($$->type);
			string str = convertIntToString(p);
			emit("*", t->name, $3->loc->name, str);	
			debug();
			emit("+", $$->loc->name, $1->loc->name, t->name);
			debug();
		}
		else 
		{                        			// if a 1D Array, simply calculate size
			int p = computeSize($$->type);
			string str = convertIntToString(p);
			emit("*", $$->loc->name, $3->loc->name, str);
			debug();
		}
	}
	| postfix_expression ROUND_BRACKET_OPEN argument_expression_list_opt ROUND_BRACKET_CLOSE       
	// call the function with number of parameters from argument_expression_list_opt
	{
		debug();
		$$ = new Array();
		$$->Array = gentemp($1->type);
		string str = convertIntToString($3);
		emit("call", $$->Array->name, $1->Array->name, str);
		debug();
	}
	| postfix_expression DOT IDENTIFIER {   }
	| postfix_expression IMPLIES IDENTIFIER  {   }
	| postfix_expression INC               // generate new temporary, equate it to old one and then add 1
	{ 
		debug();
		$$ = new Array();
		$$->Array = gentemp($1->Array->type);	
		emit("=", $$->Array->name, $1->Array->name);
		debug();
		emit("+", $1->Array->name, $1->Array->name, "1");
		debug();
	}
	| postfix_expression DEC                // generate new temporary, equate it to old one and then subtract 1
	{
		debug();
		$$ = new Array();	
		$$->Array = gentemp($1->Array->type);
		emit("=", $$->Array->name, $1->Array->name);
		debug();
		emit("-", $1->Array->name, $1->Array->name, "1");
		debug();
	}
	| ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN initializer_list CURLY_BRACKET_CLOSE {   }
	| ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN initializer_list COMMA CURLY_BRACKET_CLOSE {   }
	;

argument_expression_list_opt
	: argument_expression_list    			// Equate $$ and $1
	{ 
		$$ = $1; 
	}   
	| %empty 
	{ 										// No arguments
		$$ = 0; 
	}            
	;

argument_expression_list
	: assignment_expression    
	{
		debug();
		$$ = 1;                             // one argument and emit param
		emit("param", $1->loc->name);	
		debug();
	}
	| argument_expression_list COMMA assignment_expression     
	{
		debug();
		$$ = $1 + 1;                        // one more argument and emit param		 
		emit("param", $3->loc->name);
		debug();
	}
	;

unary_expression
	: postfix_expression   					
	{ 
		$$ = $1; 
	} 					  
	| INC unary_expression                  // simply add 1
	{  	
		debug();
		emit("+", $2->Array->name, $2->Array->name, "1");
		debug();
		$$ = $2;
	}
	| DEC unary_expression                  // simply subtract 1
	{
		debug();
		emit("-", $2->Array->name, $2->Array->name, "1");
		debug();
		$$ = $2;
	}
	| unary_operator cast_expression        // if it is of this type, where unary operator is involved
	{			
		debug();		  	
		$$ = new Array();
		switch($1)
		{	  
			case '&':                       // address of something, then generate a pointer temporary and emit the quad
				$$->Array = gentemp((new symboltype("ptr")));
				$$->Array->type->arrtype = $2->Array->type; 
				emit("=&", $$->Array->name, $2->Array->name);
				debug();
				break;
			case '*':                       // value of something, then generate a temporary of the corresponding type and emit the quad	
				$$->atype = "ptr";
				$$->loc = gentemp($2->Array->type->arrtype);
				$$->Array = $2->Array;
				emit("=*", $$->loc->name, $2->Array->name);
				debug();
				break;
			case '+':  
				$$ = $2;
				debug();
				break;                    	// unary plus, do nothing
			case '-':				   		// unary minus, generate new temporary of the same base type and make it negative of current one
				$$->Array = gentemp(new symboltype($2->Array->type->type));
				emit("uminus", $$->Array->name, $2->Array->name);
				debug();
				break;
			case '~':                   	// bitwise not, generate new temporary of the same base type and make it negative of current one
				$$->Array = gentemp(new symboltype($2->Array->type->type));
				emit("~", $$->Array->name, $2->Array->name);
				debug();
				break;
			case '!':						// logical not, generate new temporary of the same base type and make it negative of current one
				$$->Array = gentemp(new symboltype($2->Array->type->type));
				emit("!", $$->Array->name, $2->Array->name);
				debug();
				break;
		}
	}
	| SIZEOF unary_expression  {   }
	| SIZEOF ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE   {   }
	;

unary_operator
	: BITWISE_AND 	
	{ 
		$$ = '&';
		debug();
	}
	| MUL  		
	{
		$$ = '*'; 
		debug();
	}
	| ADD  		
	{ 
		$$ = '+'; 
		debug();
	}
	| SUB  		
	{ 
		$$ = '-'; 
		debug();
	}
	| BITWISE_NOT  
	{ 
		$$ = '~'; 
		debug();
	} 
	| EXCLAIM  
	{
		$$ = '!'; 
		debug();
	}
	;

cast_expression
	: unary_expression  
	{ 
		$$ = $1; 
	}                       				// unary expression, simply equate
	| ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE cast_expression          	// if cast type is given
	{ 
		debug();
		$$ = new Array();	
		$$->Array = convertType($4->Array, var_type);             					// generate a new symbol of the given type
		debug();
	}
	;

multiplicative_expression
	: cast_expression  
	{
		debug();
		$$ = new Expression();             	// generate new expression							    
		if($1->atype == "arr") 			   	// if it is of type arr
		{
			$$->loc = gentemp($1->loc->type);	
			emit("=[]", $$->loc->name, $1->Array->name, $1->loc->name);     		// emit with Array right
			debug();
		}
		else if($1->atype == "ptr")        	// if it is of type ptr
		{ 
			$$->loc = $1->loc;        		// equate the locs
			debug();
		}
		else
		{
			$$->loc = $1->Array;
			debug();
		}
	}
	| multiplicative_expression MUL cast_expression           						// if we have multiplication
	{ 
		debug();
		if(!compareSymbolType($1->loc, $3->Array))
		{         
			cout<<"Type Error in Program"<< endl;									// error
		}
		else 								// if types are compatible, generate new temporary and equate to the product
		{
			$$ = new Expression();	
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit("*", $$->loc->name, $1->loc->name, $3->Array->name);
			debug();
		}
	}
	| multiplicative_expression DIV cast_expression      							// if we have division
	{
		debug();
		if(!compareSymbolType($1->loc, $3->Array))
		{
			cout<<"Type Error in Program"<<endl;
		}
		else    							// if types are compatible, generate new temporary and equate to the quotient
		{
			$$ = new Expression();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit("/", $$->loc->name, $1->loc->name, $3->Array->name);	
			debug();						
		}
	}
	| multiplicative_expression MOD cast_expression    								// if we have mod
	{
		debug();
		if(!compareSymbolType($1->loc, $3->Array))
		{
			cout<<"Type Error in Program"<<endl;		
		}
		else 		 						// if types are compatible, generate new temporary and equate to the quotient
		{
			$$ = new Expression();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit("%", $$->loc->name, $1->loc->name, $3->Array->name);		
			debug();	
		}
	}
	;

additive_expression
	: multiplicative_expression 			   
	{ 
		$$ = $1; 
	}            
	| additive_expression ADD multiplicative_expression      						// if we have addition
	{
		debug();
		if(!compareSymbolType($1->loc, $3->loc))
		{
			cout<<"Type Error in Program"<<endl;
		}
		else    							// if types are compatible, generate new temporary and equate to the sum
		{
			$$ = new Expression();	
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit("+", $$->loc->name, $1->loc->name, $3->loc->name);
			debug();
		}
	}
	| additive_expression SUB multiplicative_expression    							// if we have subtraction
	{
		debug();
		if(!compareSymbolType($1->loc, $3->loc))
		{
			cout<<"Type Error in Program"<<endl;		
		}
		else        						// if types are compatible, generate new temporary and equate to the difference
		{	
			$$ = new Expression();	
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit("-", $$->loc->name, $1->loc->name, $3->loc->name);
			debug();
		}
	}
;

shift_expression
	: additive_expression 					   
	{ 
		$$ = $1; 
	}              
	| shift_expression SHIFT_LEFT additive_expression   
	{ 
		debug();
		if(!($3->loc->type->type == "int"))
		{
			cout<<"Type Error in Program"<<endl; 		
		}
		else            					// if base type is int, generate new temporary and equate to the shifted value
		{		
			$$ = new Expression();	
			$$->loc = gentemp(new symboltype("int"));
			emit("<<", $$->loc->name, $1->loc->name, $3->loc->name);
			debug();
		}
	}
	| shift_expression SHIFT_RIGHT additive_expression
	{ 	
		if(!($3->loc->type->type == "int"))
		{
			debug();
			cout<<"Type Error in Program"<<endl; 		
		}
		else  								// if base type is int, generate new temporary and equate to the shifted value
		{		
			debug();
			$$ = new Expression();	
			$$->loc = gentemp(new symboltype("int"));
			emit(">>", $$->loc->name, $1->loc->name, $3->loc->name);
			debug();
		}
	}
	;

relational_expression 
	: shift_expression    					
	{ 
		$$ = $1; 
	}              
	| relational_expression BIT_SL shift_expression
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
			debug();
			cout<<"Type Error in Program"<<endl;
		}
		else 
		{      								// check compatible types		
			debug();							
			$$ = new Expression();
			$$->type = "bool";                         								// new type is boolean		
			$$->truelist = makelist(nextinstr());     								// makelist for truelist and falselist
			$$->falselist = makelist(nextinstr() + 1);
			emit("<", "", $1->loc->name, $3->loc->name);     						// emit statement if a<b goto .. 
			debug();
			emit("goto", "");	//emit statement goto ..
			debug();
		}
	}
	| relational_expression BIT_SR shift_expression          	// similar to above, check compatible types,make new lists and emit
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
			debug();
			cout<<"Type Error in Program"<<endl;
		}
		else 
		{
			debug();
			$$ = new Expression();	
			$$->type = "bool";
			$$->truelist = makelist(nextinstr());
			$$->falselist = makelist(nextinstr()+1);
			emit(">", "", $1->loc->name, $3->loc->name);
			debug();
			emit("goto", "");
			debug();
		}	
	}
	| relational_expression LTE shift_expression			 	// similar to above, check compatible types,make new lists and emit
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
			debug();
			cout<<"Type Error in Program"<<endl;
		}
		else 
		{
			debug();
			$$ = new Expression();		
			$$->type = "bool";
			$$->truelist = makelist(nextinstr());
			$$->falselist = makelist(nextinstr()+1);
			emit("<=", "", $1->loc->name, $3->loc->name);
			debug();
			emit("goto", "");
			debug();
		}		
	}
	| relational_expression GTE shift_expression 			 	// similar to above, check compatible types,make new lists and emit
	{
		if(!compareSymbolType($1->loc, $3->loc))
		{
			debug(); 
			cout<<"Type Error in Program"<<endl;
		}
		else 
		{
			debug();
			$$ = new Expression();
			$$->type = "bool";
			$$->truelist = makelist(nextinstr());
			$$->falselist = makelist(nextinstr()+1);
			emit(">=", "", $1->loc->name, $3->loc->name);
			debug();
			emit("goto", "");
			debug();
		}
	}
	;

equality_expression
	: relational_expression  				
	{ 
		$$ = $1; 
	}						
	| equality_expression EQ relational_expression 
	{
		if(!compareSymbolType($1->loc, $3->loc))                // check compatible types
		{
			debug();
			cout<<"Type Error in Program"<<endl;
		}
		else 
		{
			debug();
			convertBoolToInt($1);                  				// convert bool to int	
			convertBoolToInt($3);
			$$ = new Expression();
			$$->type = "bool";
			$$->truelist = makelist(nextinstr());            	// make lists for new expression
			$$->falselist = makelist(nextinstr()+1); 
			emit("==", "", $1->loc->name, $3->loc->name);      	// emit if a == b goto
			debug();
			emit("goto", "");									// emit goto
			debug();
		}
	}

	| equality_expression NEQ relational_expression   			// check compatibility, convert bool to int, make list and emit
	{
		if(!compareSymbolType($1->loc, $3->loc)) 
		{
			debug();
			cout<<"Type Error in Program"<<endl;
		}
		else 
		{			
			debug();
			convertBoolToInt($1);	
			convertBoolToInt($3);
			$$ = new Expression();                 				// result is boolean
			$$->type = "bool";
			$$->truelist = makelist(nextinstr());
			$$->falselist = makelist(nextinstr()+1);
			emit("!=", "", $1->loc->name, $3->loc->name);
			debug();
			emit("goto", "");
			debug();
		}
	}
	;

and_expression
	: equality_expression 										  
	{ 
		$$ = $1; 
	}			
	| and_expression BITWISE_AND equality_expression 
	{
		if(!compareSymbolType($1->loc, $3->loc))         		// check compatible types 
		{
			debug();		
			cout<<"Type Error in Program"<<endl;
		}
		else 
		{
			debug();              
			convertBoolToInt($1);                             	// convert bool to int
			convertBoolToInt($3);
			$$ = new Expression();
			$$->type = "not-boolean";                   		// result is not boolean
			$$->loc = gentemp(new symboltype("int"));
			emit("&", $$->loc->name, $1->loc->name, $3->loc->name);               // emit the quad
			debug();
		}
	}
	;

exclusive_or_expression
	: and_expression  
	{ 
		$$ = $1; 
	}				
	| exclusive_or_expression BITWISE_XOR and_expression    
	{
		if(!compareSymbolType($1->loc, $3->loc))    	// check compatible types, make non-boolean expression and convert bool to int and emit
		{
			debug();
			cout<<"Type Error in Program"<<endl;
		}
		else 
		{
			debug();
			convertBoolToInt($1);	
			convertBoolToInt($3);
			$$ = new Expression();
			$$->type = "not-boolean";
			$$->loc = gentemp(new symboltype("int"));
			emit("^", $$->loc->name, $1->loc->name, $3->loc->name);
			debug();
		}
	}
	;

inclusive_or_expression
	: exclusive_or_expression 
	{ 
		$$ = $1; 
	}			
	| inclusive_or_expression BITWISE_OR exclusive_or_expression          
	{ 
		if(!compareSymbolType($1->loc, $3->loc))   // check compatible types, make non-boolean expression and convert bool to int and emit
		{
			debug();
			cout<<"Type Error in Program"<<endl;
		}
		else 
		{
			debug();
			convertBoolToInt($1);		
			convertBoolToInt($3);
			$$ = new Expression();
			$$->type = "not-boolean";
			$$->loc = gentemp(new symboltype("int"));
			emit("|", $$->loc->name, $1->loc->name, $3->loc->name);
			debug();
		} 
	}
	;

logical_and_expression
	: inclusive_or_expression  
	{ 
		$$ = $1; 
	}				
	| logical_and_expression N AND M inclusive_or_expression   	// backpatching involved here
	{ 
		debug();
		convertIntToBool($5);         							// convert inclusive_or_expression int to bool
		backpatch($2->nextlist, nextinstr());        			// $2->nextlist goes to next instruction
		convertIntToBool($1);                  					// convert logical_and_expression to bool
		$$ = new Expression();     								// make new boolean expression 
		$$->type = "bool";
		backpatch($1->truelist, $4);        					// if $1 is true, we move to $5
		$$->truelist = $5->truelist;        					// if $5 is also true, we get truelist for $$
		$$->falselist = merge($1->falselist, $5->falselist);    // merge their falselists
		debug();
	}
	;

logical_or_expression
	: logical_and_expression   
	{ 
		$$ = $1; 
	}				
	| logical_or_expression N OR M logical_and_expression      	// backpatching involved here
	{ 
		debug();
		convertIntToBool($5);			 						// convert logical_and_expression int to bool
		backpatch($2->nextlist, nextinstr());					// $2->nextlist goes to next instruction
		convertIntToBool($1);									// convert logical_or_expression to bool
		$$ = new Expression();									// make new boolean expression
		$$->type = "bool";
		backpatch($1->falselist, $4);							// if $1 is true, we move to $5
		$$->truelist = merge($1->truelist, $5->truelist);		// merge their truelists
		$$->falselist = $5->falselist;		 					// if $5 is also false, we get falselist for $$
		debug();
	}
	;

conditional_expression 
	: logical_or_expression 
	{
		$$ = $1;
	}       
	| logical_or_expression N QUESTION M expression N COLON M conditional_expression 
	{
		debug();
		$$->loc = gentemp($5->loc->type);       				// generate temporary for expression
		$$->loc->update($5->loc->type);
		emit("=", $$->loc->name, $9->loc->name);      			// make it equal to sconditional_expression
		debug();
		list<int> l = makelist(nextinstr());        			// makelist next instruction
		emit("goto", "");              							// prevent fallthrough
		debug();
		backpatch($6->nextlist, nextinstr());        			// after N, go to next instruction
		emit("=", $$->loc->name, $5->loc->name);
		debug();
		list<int> m = makelist(nextinstr());         			// makelist next instruction
		l = merge(l, m);										// merge the two lists
		emit("goto", "");										// prevent fallthrough
		debug();
		backpatch($2->nextlist, nextinstr());   				// backpatching
		convertIntToBool($1);                   				// convert expression to boolean
		backpatch($1->truelist, $4);           					// $1 true goes to expression
		backpatch($1->falselist, $8);          					// $1 false goes to conditional_expression
		backpatch(l, nextinstr());
		debug();
	}
	;

assignment_expression
	: conditional_expression 
	{
		$$ = $1;
	}         
	| unary_expression assignment_operator assignment_expression 
	 {
		if($1->atype == "arr")       							// if type is arr, simply check if we need to convert and emit
		{
			debug();
			$3->loc = convertType($3->loc, $1->type->type);
			emit("[]=", $1->Array->name, $1->loc->name, $3->loc->name);		
			debug();
		}
		else if($1->atype == "ptr")     						// if type is ptr, simply emit
		{
			debug();
			emit("*=", $1->Array->name, $3->loc->name);		
			debug();
		}
		else                              						// otherwise assignment
		{
			debug();
			$3->loc = convertType($3->loc, $1->Array->type->type);
			emit("=", $1->Array->name, $3->loc->name);
			debug();
		}
		$$ = $3;
		debug();
	}
	;

assignment_operator
	: ASSIGN   			{   }
	| STAR_EQ    		{   }
	| DIV_EQ    		{   }
	| MOD_EQ    		{   }
	| ADD_EQ    		{   }
	| SUB_EQ    		{   }
	| SL_EQ    			{   }
	| SR_EQ    			{   }
	| BITWISE_AND_EQ    {   }
	| BITWISE_XOR_EQ    {   }
	| BITWISE_OR_EQ    	{   }
	;

expression
	: assignment_expression 
	{  
		$$ = $1;  
	}
	| expression COMMA assignment_expression {   }
	;

constant_expression
	: conditional_expression {   }
	;

declaration
	: declaration_specifiers init_declarator_list SEMICOLON {	}
	| declaration_specifiers SEMICOLON {   }
	;

declaration_specifiers
	: storage_class_specifier declaration_specifiers {	 }
	| storage_class_specifier {   }
	| type_specifier declaration_specifiers {	}
	| type_specifier {	 }
	| type_qualifier declaration_specifiers {	}
	| type_qualifier {	 }
	| function_specifier declaration_specifiers {	}
	| function_specifier {   }
	;

init_declarator_list
	: init_declarator {   }
	| init_declarator_list COMMA init_declarator {   }
	;

init_declarator
	: declarator 
	{
		$$ = $1;
	}
	| declarator ASSIGN initializer 
	{
		debug();
		if($3->val != "") $1->val = $3->val;        			// get the initial value and  emit it
		emit("=", $1->name, $3->name);
		debug();
	}
	;

storage_class_specifier
	: EXTERN  	{   }
	| STATIC  	{   }
	| AUTO   	{   }
	| REGISTER  {   }
	;

type_specifier
	: VOID   
	{ 
		var_type = "void"; 
	}
	| CHAR   
	{ 
		var_type = "char"; 
	}
	| SHORT  {   }
	| INT   
	{ 	
		var_type = "int"; 
	}
	| LONG   {   }
	| FLOAT   
	{ 
		var_type = "float"; 
	}
	| DOUBLE   			{   }
	| SIGNED   			{   }
	| UNSIGNED   		{   }
	| _BOOL   			{   }
	| _COMPLEX   		{   }
	| _IMAGINARY   		{   }
	| enum_specifier   	{   }
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list_opt   {   }
	| type_qualifier specifier_qualifier_list_opt  	{   }
	;

specifier_qualifier_list_opt
	: %empty {   }
	| specifier_qualifier_list  {   }
	;

enum_specifier
	: ENUM identifier_opt CURLY_BRACKET_OPEN enumerator_list CURLY_BRACKET_CLOSE   {   }
	| ENUM identifier_opt CURLY_BRACKET_OPEN enumerator_list COMMA CURLY_BRACKET_CLOSE   {   }
	| ENUM IDENTIFIER {   }
	;

identifier_opt
	: %empty  {   }
	| IDENTIFIER   {   }
	;

enumerator_list
	: enumerator   {   }
	| enumerator_list COMMA enumerator   {   }
	;			  						    							  
enumerator
	: IDENTIFIER   {   }
	| IDENTIFIER ASSIGN constant_expression   {   }
	;

type_qualifier
	: CONST   		{   }
	| RESTRICT   	{   }
	| VOLATILE   	{   }
	;

function_specifier
	: INLINE   {   }
	;

declarator
	: pointer direct_declarator 
	{
		debug();
		symboltype *t = $1;
		while(t->arrtype!=NULL) t = t->arrtype;           		// for multidimensional arr1s, move in depth till you get the base type
		t->arrtype = $2->type;                					// add the base type 
		$$ = $2->update($1);                  					// update
		debug();
	}
	| direct_declarator {   }
	;

direct_declarator
	: IDENTIFIER                 								// if ID, simply add a new variable of var_type
	{
		debug();
		$$ = $1->update(new symboltype(var_type));
		currSymbolPtr = $$;
		debug();
		
	}
	| ROUND_BRACKET_OPEN declarator ROUND_BRACKET_CLOSE 
	{
		$$ = $2;
	}        
	| direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list assignment_expression SQUARE_BRACKET_CLOSE {	}
	| direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list SQUARE_BRACKET_CLOSE {   }
	| direct_declarator SQUARE_BRACKET_OPEN assignment_expression SQUARE_BRACKET_CLOSE 
	{
		debug();
		symboltype *t = $1 -> type;
		symboltype *prev = NULL;
		while(t->type == "arr") 
		{
			prev = t;	
			t = t->arrtype;      								// keep moving recursively to get basetype
		}
		if(prev==NULL) 
		{
			debug();
			int temp = atoi($3->loc->val.c_str());      		// get initial value
			symboltype* s = new symboltype("arr", $1->type, temp);        				// create new symbol with that initial value
			$$ = $1->update(s);   								// update the symbol table
			debug();
		}
		else 
		{
			debug();
			prev->arrtype =  new symboltype("arr", t, atoi($3->loc->val.c_str()));     	// similar arguments as above		
			$$ = $1->update($1->type);
			debug();
		}
	}
	| direct_declarator SQUARE_BRACKET_OPEN SQUARE_BRACKET_CLOSE 
	{
		debug();
		symboltype *t = $1 -> type;
		symboltype *prev = NULL;
		while(t->type == "arr") 
		{
			prev = t;	
			t = t->arrtype;         							// keep moving recursively to base type
		}
		if(prev==NULL) 
		{
			debug();
			symboltype* s = new symboltype("arr", $1->type, 0);    						// no initial values, simply keep 0
			$$ = $1->update(s);
			debug();	
		}
		else 
		{
			debug();
			prev->arrtype =  new symboltype("arr", t, 0);
			$$ = $1->update($1->type);
			debug();
		}
	}
	| direct_declarator SQUARE_BRACKET_OPEN STATIC type_qualifier_list assignment_expression SQUARE_BRACKET_CLOSE {   }
	| direct_declarator SQUARE_BRACKET_OPEN STATIC assignment_expression SQUARE_BRACKET_CLOSE {   }
	| direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list MUL SQUARE_BRACKET_CLOSE {   }
	| direct_declarator SQUARE_BRACKET_OPEN MUL SQUARE_BRACKET_CLOSE {   }
	| direct_declarator ROUND_BRACKET_OPEN changetable parameter_type_list ROUND_BRACKET_CLOSE 
	{
		debug();
		ST->name = $1->name;
		if($1->type->type != "void") 
		{
			sym *s = ST->lookup("return");         				// lookup for return value	
			s->update($1->type);
			debug();
		}
		$1->nested=ST;       	
		ST->parent = globalST;
		changeTable(globalST);									// Come back to globalsymbol table
		currSymbolPtr = $$;
		debug();
	}
	| direct_declarator ROUND_BRACKET_OPEN identifier_list ROUND_BRACKET_CLOSE {   }
	| direct_declarator ROUND_BRACKET_OPEN changetable ROUND_BRACKET_CLOSE 
	{   
		debug();
		ST->name = $1->name;
		if($1->type->type != "void") 
		{
			sym *s = ST->lookup("return");
			s->update($1->type);
			debug();			
		}
		$1->nested=ST;
		ST->parent = globalST;
		changeTable(globalST);									// Come back to globalsymbol table
		currSymbolPtr = $$;
		debug();
	}
	;

changetable
	: %empty 
	{ 															// Used for changing to symbol table for a function
		if(currSymbolPtr->nested == NULL) 
		{
			debug();
			changeTable(new symtable(""));						// Function symbol table doesn't already exist
		}
		else 
		{
			debug();
			changeTable(currSymbolPtr->nested);					// Function symbol table already exists
			emit("label", ST->name);
			debug();
		}
	}
	;

type_qualifier_list_opt
	: %empty   {   }
	| type_qualifier_list      {   }
	;

pointer
	: MUL type_qualifier_list_opt   
	{ 
		$$ = new symboltype("ptr");
		debug();  
	}       
	| MUL type_qualifier_list_opt pointer 
	{ 
		$$ = new symboltype("ptr", $3);
		debug(); 
	}
	;

type_qualifier_list
	: type_qualifier   {   }
	| type_qualifier_list type_qualifier   {   }
	;

parameter_type_list
	: parameter_list   {   }
	| parameter_list COMMA DOTS   {   }
	;

parameter_list
	: parameter_declaration   {   }
	| parameter_list COMMA parameter_declaration    {   }
	;

parameter_declaration
	: declaration_specifiers declarator   {   }
	| declaration_specifiers    {   }
	;

identifier_list
	: IDENTIFIER	{   }		  
	| identifier_list COMMA IDENTIFIER   {   }
	;

type_name
	: specifier_qualifier_list   {   }
	;

initializer
	: assignment_expression   
	{ 
		$$ = $1->loc; 
	}   
	| CURLY_BRACKET_OPEN initializer_list CURLY_BRACKET_CLOSE  {   }
	| CURLY_BRACKET_OPEN initializer_list COMMA CURLY_BRACKET_CLOSE  {   }
	;

initializer_list
	: designation_opt initializer  {   }
	| initializer_list COMMA designation_opt initializer   {   }
	;

designation_opt
	: %empty   {   }
	| designation   {   }
	;

designation
	: designator_list ASSIGN   {   }
	;

designator_list
	: designator    {   }
	| designator_list designator   {   }
	;

designator
	: SQUARE_BRACKET_OPEN constant_expression SQUARE_BRACKET_CLOSE   {   }
	| DOT IDENTIFIER {   }
	;

// Statements

statement
	: labeled_statement   {   }
	| compound_statement   
	{ 
		$$ = $1; 
	}
	| expression_statement   
	{ 
		$$ = new Statement();              // create new statement with same nextlist
		$$->nextlist = $1->nextlist; 
	}
	| selection_statement   
	{ 
		$$ = $1; 
	}
	| iteration_statement   
	{ 
		$$ = $1; 
	}
	| jump_statement   
	{ 
		$$ = $1; 
	}
	;

labeled_statement
	: IDENTIFIER COLON statement   {   }
	| CASE constant_expression COLON statement   {   }
	| DEFAULT COLON statement   {   }
	;

compound_statement
	: CURLY_BRACKET_OPEN block_item_list_opt CURLY_BRACKET_CLOSE   
	{ 
		$$ = $2; 
	} 
	;

block_item_list_opt
	: %empty  
	{ 
		$$ = new Statement(); 
	}   
	| block_item_list   
	{ 
		$$ = $1; 
	}        
	;

block_item_list
	: block_item   
	{ 
		$$ = $1; 
	}			
	| block_item_list M block_item    
	{ 
		$$ = $3;	
		backpatch($1->nextlist,$2);     	// after $1, move to block_item via $2
	}
	;

block_item
	: declaration   
	{ 
		$$ = new Statement(); 
	}       
	| statement   
	{ 
		$$ = $1; 
	}				
	;

expression_statement
	: expression SEMICOLON 
	{
		$$ = $1;
	}			
	| SEMICOLON {$$ = new Expression();}      // new  expression
	;

selection_statement
	: IF ROUND_BRACKET_OPEN expression N ROUND_BRACKET_CLOSE M statement N %prec "then"      // if statement without else
	{
		debug();
		backpatch($4->nextlist, nextinstr());        			// nextlist of N goes to nextinstr
		convertIntToBool($3);         							// convert expression to bool
		$$ = new Statement();        							// make new statement
		backpatch($3->truelist, $6);        					// is expression is true, go to M i.e just before statement body
		list<int> temp = merge($3->falselist, $7->nextlist);   	// merge falselist of expression, nextlist of statement and second N
		$$->nextlist = merge($8->nextlist, temp);
		debug();
	}
	| IF ROUND_BRACKET_OPEN expression N ROUND_BRACKET_CLOSE M statement N ELSE M statement   // if statement with else
	{
		debug();
		backpatch($4->nextlist, nextinstr());					// nextlist of N goes to nextinstr
		convertIntToBool($3);        							// convert expression to bool
		$$ = new Statement();       							// make new statement
		backpatch($3->truelist, $6);    						// when expression is true, go to M1 else go to M2
		backpatch($3->falselist, $10);
		list<int> temp = merge($7->nextlist, $8->nextlist);     // merge the nextlists of the statements and second N
		$$->nextlist = merge($11->nextlist,temp);	
		debug();	
	}
	| SWITCH ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE statement {   }       		// not to be modelled
	;

iteration_statement	
	: WHILE M ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE M statement      			// while statement
	{
		debug();
		$$ = new Statement();    								// create statement
		convertIntToBool($4);     								// convert expression to bool
		backpatch($7->nextlist, $2);							// M1 to go back to expression again
		backpatch($4->truelist, $6);							// M2 to go to statement if the expression is true
		$$->nextlist = $4->falselist;   						// when expression is false, move out of loop
		string str = convertIntToString($2);			
		emit("goto", str);
		debug();
			
	}
	| DO M statement M WHILE ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE SEMICOLON      // do statement
	{
		debug();
		$$ = new Statement();     //create statement
		convertIntToBool($7);      //convert to bool
		backpatch($7->truelist, $2);							// M1 to go back to statement if expression is true
		backpatch($3->nextlist, $4);							// M2 to go to check expression if statement is complete
		$$->nextlist = $7->falselist;                       	// move out if statement is false
		debug();		
	}
	| FOR ROUND_BRACKET_OPEN expression_statement M expression_statement ROUND_BRACKET_CLOSE M statement      // for loop
	{
		debug();
		$$ = new Statement();   								// create new statement
		convertIntToBool($5);    								// convert check expression to boolean
		backpatch($5->truelist,$7);        						// if expression is true, go to M2
		backpatch($8->nextlist,$4);        						// after statement, go back to M1
		string str=convertIntToString($4);
		emit("goto", str);                 						// prevent fallthrough
		debug();
		$$->nextlist = $5->falselist;      						// move out if statement is false
		debug();
	}
	| FOR ROUND_BRACKET_OPEN expression_statement M expression_statement M expression N ROUND_BRACKET_CLOSE M statement
	{
		debug();
		$$ = new Statement();		 							// create new statement
		convertIntToBool($5);  									// convert check expression to boolean
		backpatch($5->truelist, $10);							// if expression is true, go to M2
		backpatch($8->nextlist, $4);							// after N, go back to M1
		backpatch($11->nextlist, $6);							// statement go back to expression
		string str = convertIntToString($6);
		emit("goto", str);										// prevent fallthrough
		debug();
		$$->nextlist = $5->falselist;							// move out if statement is false	
		debug();	
	}
	;

jump_statement
	: GOTO IDENTIFIER SEMICOLON { $$ = new Statement(); }       // not to be modelled
	| CONTINUE SEMICOLON { $$ = new Statement(); }			   	// not to be modelled
	| BREAK SEMICOLON { $$ = new Statement(); }				 	// not to be modelled
	| RETURN expression SEMICOLON               
	{
		debug();
		$$ = new Statement();
		emit("return",$2->loc->name);               			// emit return with the name of the return value
		debug();
		
	}
	| RETURN SEMICOLON 
	{
		debug();
		$$ = new Statement();
		emit("return", "");                         			// simply emit return
		debug();
	}
	;

// External Definitions

translation_unit
	: external_declaration {   }
	| translation_unit external_declaration {   } 
	;

external_declaration
	: function_definition {   }
	| declaration   {   }
	;

function_definition
	:declaration_specifiers declarator declaration_list_opt changetable compound_statement  
	{
		debug();
		int next_instr = 0;	 
		ST->parent = globalST;
		changeTable(globalST);                     	// once we come back to this at the end, change the table to global Symbol table
		debug();
	}
	;

declaration_list
	: declaration   {   }
	| declaration_list declaration    {   }
	;				   										  				   

declaration_list_opt
	: %empty {   }
	| declaration_list   {   }
	;

%%
 
void yyerror(string s) {        					// print syntax error
    cout<<s<<endl;
}