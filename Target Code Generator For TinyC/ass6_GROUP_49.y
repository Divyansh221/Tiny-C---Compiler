/* Parser for tinyC (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

%{
#include <iostream>
#include <stdio.h>
#include <cstdlib>
#include <string>
#include <sstream>

#include "ass6_GROUP_49_translator.h"

extern int yylex();                                     // yylex for lexer
void yyerror(string s);                                 // yyerror for error recovery
extern string Type;                                     // Type for last encountered type
vector <string> allstrings;

using namespace std;
%}

%union {
  int intval;
  char* charval;
  int instr;
  sym* symp;
  symtype* symtp;
  expr* E;
  statement* S;
  Array* A;
  char unaryOperator;
} 
%token AUTO ENUM RESTRICT UNSIGNED BREAK EXTERN RETURN VOID CASE FLOAT SHORT VOLATILE CHAR FOR SIGNED WHILE CONST GOTO SIZEOF BOOL 
%token CONTINUE IF STATIC COMPLEX DEFAULT INLINE STRUCT IMAGINARY DO INT SWITCH DOUBLE LONG TYPEDEF ELSE REGISTER UNION

%token<symp>        IDENTIFIER
%token<intval>      INTEGER_CONSTANT
%token<charval>     FLOATING_CONSTANT
%token<charval>     CHARACTER_CONSTANT ENUMERATION_CONSTANT
%token<charval>     STRING_LITERAL

%token SQUARE_BRACKET_OPEN SQUARE_BRACKET_CLOSE ROUND_BRACKET_OPEN ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN CURLY_BRACKET_CLOSE 
%token DOT IMPLIES INC DEC BITWISE_AND MUL ADD SUB BITWISE_NOT EXCLAIM DIV MOD 
%token SHIFT_LEFT SHIFT_RIGHT BIT_SL BIT_SR LTE GTE EQ NEQ BITWISE_XOR BITWISE_OR OR AND 
%token QUESTION COLON SEMICOLON DOTS ASSIGN STAR_EQ DIV_EQ MOD_EQ ADD_EQ SUB_EQ SL_EQ SR_EQ BITWISE_AND_EQ BITWISE_XOR_EQ BITWISE_OR_EQ 
%token COMMA HASH

%start translation_unit

%right "then" ELSE                                      // to remove dangling else problem

%type <E>                                               // Expressions
    expression
    primary_expression 
    multiplicative_expression
    additive_expression
    shift_expression
    relational_expression
    equality_expression
    AND_expression
    exclusive_OR_expression
    inclusive_OR_expression
    logical_AND_expression
    logical_OR_expression
    conditional_expression
    assignment_expression
    expression_statement

%type <intval> argument_expression_list

%type <A> postfix_expression                            // Array to be used later
    unary_expression
    cast_expression

%type <unaryOperator> unary_operator
%type <symp> constant initializer
%type <symp> direct_declarator init_declarator declarator
%type <symtp> pointer

%type <instr> M                                         // Auxillary non terminals M and N
%type <S> N

%type <S>  statement                                    // Statements
    labeled_statement 
    compound_statement
    selection_statement
    iteration_statement
    jump_statement
    block_item
    block_item_list

%%

primary_expression: 
    IDENTIFIER                                          // identifier
    {
        $$ = new expr();                                // create new expression and store pointer to ST entry in the location
        $$->loc = $1;
        $$->type = "NONBOOL";
    }
    | constant                                          // create new expression and store the value of the constant in a temporary
    {
        $$ = new expr();
        $$->loc = $1;
    }
    | STRING_LITERAL                                    // create new expression and store the value of the constant in a temporary
    {
        $$ = new expr();
        symtype* tmp = new symtype("PTR");
        $$->loc = gentemp(tmp, $1);
        $$->loc->type->ptr = new symtype("CHAR");
        allstrings.push_back($1);
        stringstream strs;
        strs << allstrings.size()-1;
        string temp_str = strs.str();
        char* intStr = (char*) temp_str.c_str();
        string str = string(intStr);
        emit("EQUALSTR", $$->loc->name, str);
    }
    | ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE 
    {
        $$ = $2;
    }
    ;

constant:
    INTEGER_CONSTANT 
    {
        stringstream strs;
        strs << $1;
        string temp_str = strs.str();
        char* intStr = (char*) temp_str.c_str();
        string str = string(intStr);
        $$ = gentemp(new symtype("INTEGER"), str);
        emit("EQUAL", $$->name, $1);
    }
    |FLOATING_CONSTANT 
    {
        $$ = gentemp(new symtype("DOUBLE"), string($1));
        emit("EQUAL", $$->name, string($1));
    }
    |ENUMERATION_CONSTANT  
    {                                      
    }
    |CHARACTER_CONSTANT 
    {
        $$ = gentemp(new symtype("CHAR"), $1);
        emit("EQUALCHAR", $$->name, string($1));
    }
    ;

postfix_expression:
    primary_expression                                  // create new Array and store the location of primary expression in it
    {
        $$ = new Array ();
        $$->Array = $1->loc;
        $$->loc = $$->Array;
        $$->type = $1->loc->type;
    }
    |postfix_expression SQUARE_BRACKET_OPEN expression SQUARE_BRACKET_CLOSE 
    {
        $$ = new Array();
        $$->Array = $1->loc;                            // copy the base
        $$->type = $1->type->ptr;                       // type = type of element
        $$->loc = gentemp(new symtype("INTEGER"));      // store computed address
        
        if ($1->cat=="ARR")                             // New address = (if only) already computed + $3 * new width
        {                                               // multiply the size of the sub-type of Array with the expression value and add
            sym* t = gentemp(new symtype("INTEGER"));
            stringstream strs;
            strs << size_type($$->type);
            string temp_str = strs.str();
            char* intStr = (char*) temp_str.c_str();
            string str = string(intStr);                
            emit ("MULT", t->name, $3->loc->name, str);
            emit ("ADD", $$->loc->name, $1->loc->name, t->name);
        }
        else                                            // simply calculate size
        {   
            stringstream strs;
            strs << size_type($$->type);
            string temp_str = strs.str();
            char* intStr1 = (char*) temp_str.c_str();
            string str1 = string(intStr1);      
            emit("MULT", $$->loc->name, $3->loc->name, str1);
        }       
        $$->cat = "ARR";                                // Mark that it contains Array address and first time computation is done
    }
    |postfix_expression ROUND_BRACKET_OPEN ROUND_BRACKET_CLOSE 
    {
    }
    |postfix_expression ROUND_BRACKET_OPEN argument_expression_list ROUND_BRACKET_CLOSE 
    {                                                   // call the function with number of parameters from argument_expression_list_opt
        $$ = new Array();
        $$->Array = gentemp($1->type);
        stringstream strs;
        strs << $3;
        string temp_str = strs.str();
        char* intStr = (char*) temp_str.c_str();
        string str = string(intStr);        
        emit("CALL", $$->Array->name, $1->Array->name, str);
    }
    |postfix_expression DOT IDENTIFIER 
    {
    }
    |postfix_expression IMPLIES IDENTIFIER 
    {
    }
    |postfix_expression INC 
    {                                                   // generate new temporary, equate it to old one and then add 1
        $$ = new Array();
        $$->Array = gentemp($1->Array->type);
        emit ("EQUAL", $$->Array->name, $1->Array->name);
        emit ("ADD", $1->Array->name, $1->Array->name, "1");                    // Increment $1
    }
    |postfix_expression DEC 
    {                                                   // generate new temporary, equate it to old one and then subtract 1
        $$ = new Array();
        $$->Array = gentemp($1->Array->type);           // copy $1 to $$
        emit ("EQUAL", $$->Array->name, $1->Array->name);
        emit ("SUB", $1->Array->name, $1->Array->name, "1");                    // Decrement $1
    }
    |ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN initializer_list CURLY_BRACKET_CLOSE 
    {
        $$ = new Array();
        $$->Array = gentemp(new symtype("INTEGER"));
        $$->loc = gentemp(new symtype("INTEGER"));
    }
    |ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN initializer_list COMMA CURLY_BRACKET_CLOSE 
    {
        $$ = new Array();
        $$->Array = gentemp(new symtype("INTEGER"));
        $$->loc = gentemp(new symtype("INTEGER"));
    }
    ;

argument_expression_list:
    assignment_expression 
    {
        emit ("PARAM", $1->loc->name);                  // one argument and emit param
        $$ = 1;
    }
    |argument_expression_list COMMA assignment_expression 
    {
        emit ("PARAM", $3->loc->name);                  // one more argument and emit param
        $$ = $1 + 1;
    }
    ;

unary_expression:
    postfix_expression 
    {
        $$ = $1;
    }
    |INC unary_expression 
    {
        emit ("ADD", $2->Array->name, $2->Array->name, "1");                    // Increment $2
        $$ = $2;
    }
    |DEC unary_expression 
    {
        emit ("SUB", $2->Array->name, $2->Array->name, "1");                    // Decrement $2
        $$ = $2;
    }
    |unary_operator cast_expression 
    {                                                   // if it is of this type, where unary operator is involved{
        $$ = new Array();
        switch ($1) {
            case '&':                                   // address of something 
                // generate a pointer temporary and emit the quad
                $$->Array = gentemp((new symtype("PTR")));
                $$->Array->type->ptr = $2->Array->type; 
                emit ("ADDRESS", $$->Array->name, $2->Array->name);
                break;
            case '*':                                   // value of something 
                // generate a temporary of the corresponding type and emit the quad
                $$->cat = "PTR";
                $$->loc = gentemp ($2->Array->type->ptr);
                emit ("PTRR", $$->loc->name, $2->Array->name);
                $$->Array = $2->Array;
                break;
            case '+':                                   // unary plus
                $$ = $2;
                break;
            case '-':                                   // unary minus 
                $$->Array = gentemp(new symtype($2->Array->type->type));
                emit ("UMINUS", $$->Array->name, $2->Array->name);
                break;
            case '~':                                   // bitwise not
                // generate new temporary of the same base type and make it BITWISE_NOT of current one
                $$->Array = gentemp(new symtype($2->Array->type->type));
                emit ("BNOT", $$->Array->name, $2->Array->name);
                break;
            case '!':                                   // logical not 
                // generate new temporary of the same base type and make it BITWISE_NOT of current one
                $$->Array = gentemp(new symtype($2->Array->type->type));
                emit ("LNOT", $$->Array->name, $2->Array->name);
                break;
            default:
                break;
        }
    }
    |SIZEOF unary_expression 
    {
    }
    |SIZEOF ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE 
    {
    }
    ;

unary_operator:                                         // simply equate to the corresponding operator
    BITWISE_AND                                         
    {
        $$ = '&';
    }
    |MUL 
    {
        $$ = '*';
    }
    |ADD 
    {
        $$ = '+';
    }
    |SUB 
    {
        $$ = '-';
    }
    |BITWISE_NOT 
    {
        $$ = '~';
    }
    |EXCLAIM 
    {
        $$ = '!';
    }
    ;

cast_expression:
    unary_expression 
    {
        $$ = $1;
    }
    |ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE cast_expression 
    {
        $$ = $4;
    }
    ;

multiplicative_expression:
    cast_expression 
    {
        $$ = new expr();                                // generate new expression
        if ($1->cat=="ARR") 
        {                                               // Array
            $$->loc = gentemp($1->loc->type);
            emit("ARRR", $$->loc->name, $1->Array->name, $1->loc->name);            // emit with Array right
        }
        else if ($1->cat=="PTR")                        // if it is of type ptr
        { 
            $$->loc = $1->loc;
        }
        else 
        { 
            $$->loc = $1->Array;
        }
    }
    |multiplicative_expression MUL cast_expression      // if we have multiplication
    {
        if (typecheck ($1->loc, $3->Array) )            // if types are compatible
        { 
            // generate new temporary and equate to the product
            $$ = new expr();
            $$->loc = gentemp(new symtype($1->loc->type->type));
            emit ("MULT", $$->loc->name, $1->loc->name, $3->Array->name);
        }
        else cout << "Type Error"<< endl;               // error
    }
    |multiplicative_expression DIV cast_expression      // if we have division
    {
        if (typecheck ($1->loc, $3->Array) )            //if types are compatible
        {   
            // generate new temporary and equate to the quotient
            $$ = new expr();
            $$->loc = gentemp(new symtype($1->loc->type->type));
            emit ("DIVIDE", $$->loc->name, $1->loc->name, $3->Array->name);
        }
        else cout << "Type Error"<< endl;               // error
    }
    |multiplicative_expression MOD cast_expression      // if we have mod
    {
        if (typecheck ($1->loc, $3->Array) )            // if types are compatible 
        {
        // generate new temporary and equate to the quotient
            $$ = new expr();
            $$->loc = gentemp(new symtype($1->loc->type->type));
            emit ("MODOP", $$->loc->name, $1->loc->name, $3->Array->name);
        }
        else cout << "Type Error"<< endl;               // error
    }
    ;

additive_expression:
    multiplicative_expression 
    {
        $$ = $1;
    }
    |additive_expression ADD multiplicative_expression                              
    {   
        if (typecheck ($1->loc, $3->loc) )              // if types are compatible
        {
            // generate new temporary and equate to the sum
            $$ = new expr();
            $$->loc = gentemp(new symtype($1->loc->type->type));
            emit ("ADD", $$->loc->name, $1->loc->name, $3->loc->name);
        }
        else cout << "Type Error"<< endl;               // error
    }
    |additive_expression SUB multiplicative_expression 
    {
        // for subtraction
        if (typecheck ($1->loc, $3->loc) ) 
        {
            // if types are compatible, generate new temporary and equate to the difference
            $$ = new expr();
            $$->loc = gentemp(new symtype($1->loc->type->type));
            emit ("SUB", $$->loc->name, $1->loc->name, $3->loc->name);
        }
        else cout << "Type Error"<< endl;               // error
    }
    ;

shift_expression:
    additive_expression 
    {
        $$ = $1;
    }
    |shift_expression SHIFT_LEFT additive_expression    // if base type is int 
    {
    // generate new temporary and equate to the shifted value
        if ($3->loc->type->type == "INTEGER") 
        {
            $$ = new expr();
            $$->loc = gentemp (new symtype("INTEGER"));
            emit ("LEFTOP", $$->loc->name, $1->loc->name, $3->loc->name);
        }
        else cout << "Type Error"<< endl;               // error
    }
    |shift_expression SHIFT_RIGHT additive_expression   // if base type is int 
    {
        // generate new temporary and equate to the shifted value
        if ($3->loc->type->type == "INTEGER") 
        {
            $$ = new expr();
            $$->loc = gentemp (new symtype("INTEGER"));
            emit ("RIGHTOP", $$->loc->name, $1->loc->name, $3->loc->name);
        }
        else cout << "Type Error"<< endl;               // error
    }
    ;

relational_expression:
    shift_expression 
    {
        $$ = $1;
    }   
    |relational_expression BIT_SL shift_expression                  // check compatible types
    {
        if (typecheck ($1->loc, $3->loc) ) 
        {
            $$ = new expr();
            $$->type = "BOOL";
            $$->truelist = makelist (nextinstr());                  // make truelist
            $$->falselist = makelist (nextinstr()+1);               // make falselist
            emit("LT", "", $1->loc->name, $3->loc->name);           // emit statement if a < b goto
            emit ("GOTOOP", "");                                    // emit goto
        }
        else cout << "Type Error"<< endl;                           // error
    }
    |relational_expression BIT_SR shift_expression                  // check compatible types
    {
        if (typecheck ($1->loc, $3->loc) ) 
        {
            $$ = new expr();
            $$->type = "BOOL";
            $$->truelist = makelist (nextinstr());                  // make truelist
            $$->falselist = makelist (nextinstr()+1);               // make falselist
            emit("GT", "", $1->loc->name, $3->loc->name);           // emit statement if a > b goto
            emit ("GOTOOP", "");                                    // emit goto
        }
        else cout << "Type Error"<< endl;                           // error
    }
    |relational_expression LTE shift_expression                     // check compatible types 
    {
        // make truelist and falselist, emit the required statement
        if (typecheck ($1->loc, $3->loc) ) 
        {
            $$ = new expr();
            $$->type = "BOOL";
            $$->truelist = makelist (nextinstr());
            $$->falselist = makelist (nextinstr()+1);
            emit("LE", "", $1->loc->name, $3->loc->name);
            emit ("GOTOOP", "");
        }
        else cout << "Type Error"<< endl;                           // error
    }
    |relational_expression GTE shift_expression                     // check compatible types
    {
        // make truelist and falselist, emit the required statement
        if (typecheck ($1->loc, $3->loc) ) 
        {
            $$ = new expr();
            $$->type = "BOOL";
            $$->truelist = makelist (nextinstr());
            $$->falselist = makelist (nextinstr()+1);
            emit("GE", "", $1->loc->name, $3->loc->name);
            emit ("GOTOOP", "");
        }
        else cout << "Type Error"<< endl;                            // error
    }
    ;

equality_expression:
    relational_expression 
    {
        $$ = $1;
    }
    |equality_expression EQ relational_expression 
    {
        // check compatibility, make list and emit
        if (typecheck ($1->loc, $3->loc))         
        {   
            convertBool2Int ($1);                                   // convert bool to int
            convertBool2Int ($3);                                   // convert bool to int
            $$ = new expr();
            $$->type = "BOOL";
            $$->truelist = makelist (nextinstr());
            $$->falselist = makelist (nextinstr()+1);
            emit("EQOP", "", $1->loc->name, $3->loc->name);
            emit ("GOTOOP", "");
        }
        else cout << "Type Error"<< endl;                           // error
    }
    |equality_expression NEQ relational_expression 
    {
        // check compatibility, convert bool to int, make list and emit
        if (typecheck ($1->loc, $3->loc) ) 
        {
            convertBool2Int ($1);                                   // convert bool to int
            convertBool2Int ($3);                                   // convert bool to int
            $$ = new expr();
            $$->type = "BOOL";
            $$->truelist = makelist (nextinstr());
            $$->falselist = makelist (nextinstr()+1);
            emit("NEOP", "", $1->loc->name, $3->loc->name);
            emit ("GOTOOP", "");
        }
        else cout << "Type Error"<< endl;                           // error
    }
    ;

AND_expression:
    equality_expression 
    {
        $$ = $1;
    }
    |AND_expression BITWISE_AND equality_expression 
    {
        // check compatible types
        // make non-boolean expression and convert bool to int and emit
        if (typecheck ($1->loc, $3->loc) ) 
        {
            convertBool2Int ($1);                                   // convert bool to int
            convertBool2Int ($3);                                   // convert bool to int
            $$ = new expr();
            $$->type = "NONBOOL";
            $$->loc = gentemp (new symtype("INTEGER"));
            emit ("BAND", $$->loc->name, $1->loc->name, $3->loc->name);
        }
        else cout << "Type Error"<< endl;                           // error
    }
    ;

exclusive_OR_expression:
    AND_expression 
    {
        $$ = $1;
    }
    |exclusive_OR_expression BITWISE_XOR AND_expression 
    {
        // check compatible types, make non-boolean expression and convert bool to int and emit
        if (typecheck ($1->loc, $3->loc) ) 
        {
            convertBool2Int ($1);                                   // convert bool to int
            convertBool2Int ($3);                                   // convert bool to int
            $$ = new expr();
            $$->type = "NONBOOL";
            $$->loc = gentemp (new symtype("INTEGER"));
            emit ("XOR", $$->loc->name, $1->loc->name, $3->loc->name);
        }
        else cout << "Type Error"<< endl;                           // error
    }
    ;

inclusive_OR_expression:
    exclusive_OR_expression 
    {
        $$ = $1;
    }
    |inclusive_OR_expression BITWISE_OR exclusive_OR_expression 
    {
        // check compatible types, make non-boolean expression and convert bool to int and emit
        if (typecheck ($1->loc, $3->loc) ) 
        {
            convertBool2Int ($1);                                   // convert bool to int
            convertBool2Int ($3);                                   // convert bool to int
            $$ = new expr();
            $$->type = "NONBOOL";
            $$->loc = gentemp (new symtype("INTEGER"));
            emit ("INOR", $$->loc->name, $1->loc->name, $3->loc->name);
        }
        else cout << "Type Error"<< endl;                           // error
    }
    ;

logical_AND_expression:
    inclusive_OR_expression 
    {
        $$ = $1;
    }
    |logical_AND_expression N AND M inclusive_OR_expression 
    {
        // involves back-patching
        convertInt2Bool($5);                                        // convert int to bool
        backpatch($2->nextlist, nextinstr());                       // convert $1 to bool and backpatch using N
        convertInt2Bool($1);                                        // convert int to bool
        $$ = new expr();
        $$->type = "BOOL";
        backpatch($1->truelist, $4);                                // standard back-patching principles
        $$->truelist = $5->truelist;
        $$->falselist = merge ($1->falselist, $5->falselist);
    }
    ;

logical_OR_expression:
    logical_AND_expression 
    {
        $$ = $1;
    }
    |logical_OR_expression N OR M logical_AND_expression 
    {
        convertInt2Bool($5);                                        // convert int to bool
        backpatch($2->nextlist, nextinstr());                       // convert $1 to bool and backpatch using N
        convertInt2Bool($1);
        $$ = new expr();
        $$->type = "BOOL";
        backpatch ($1->falselist, $4);                              // standard back-patching principles involved
        $$->truelist = merge ($1->truelist, $5->truelist);
        $$->falselist = $5->falselist;
    }
    ;

M: 
    %empty
    {                                                               // To store the address of the next instruction
        $$ = nextinstr();
    };

N: 
    %empty 
    {                                                               // guard against fallthrough by emitting a goto
        $$  = new statement();
        $$->nextlist = makelist(nextinstr());
        emit ("GOTOOP","");
    };

conditional_expression:
    logical_OR_expression 
    {
        $$ = $1;
    }
    |logical_OR_expression N QUESTION M expression N COLON M conditional_expression 
    {
        $$->loc = gentemp($5->loc->type);                           // generate temporary for expression
        $$->loc->update($5->loc->type);
        emit("EQUAL", $$->loc->name, $9->loc->name);                // make it equal to the conditional expression
        list<int> l = makelist(nextinstr());
        emit ("GOTOOP", "");                                        // prevent fallthrough
        backpatch($6->nextlist, nextinstr());                       // necessary back-patching 
        emit("EQUAL", $$->loc->name, $5->loc->name);
        list<int> m = makelist(nextinstr());
        l = merge (l, m);                                           // merge the next instruction list
        emit ("GOTOOP", "");                                        // prevent fallthrough
        backpatch($2->nextlist, nextinstr());                       // necessary back-patching w.r.t logical_OR_expression
        convertInt2Bool($1);
        backpatch ($1->truelist, $4);
        backpatch ($1->falselist, $8);
        backpatch (l, nextinstr());
    }
    ;

assignment_expression:
    conditional_expression 
    {
        $$ = $1;
    }
    |unary_expression assignment_operator assignment_expression 
    {
        if($1->cat == "ARR")                                        // if type is arr, simply check if we need to convert and emit
        {
            $3->loc = conv($3->loc, $1->type->type);
            emit("ARRL", $1->Array->name, $1->loc->name, $3->loc->name);    
        }
        else if($1->cat == "PTR")                                   // if type is ptr, simply emit
        {
            emit("PTRL", $1->Array->name, $3->loc->name);   
        }
        else
        {
            $3->loc = conv($3->loc, $1->Array->type->type);
            emit("EQUAL", $1->Array->name, $3->loc->name);
        }
        $$ = $3;
    }
    ;

assignment_operator:
    ASSIGN      {}
    |STAR_EQ    {}
    |DIV_EQ     {}
    |MOD_EQ     {}
    |ADD_EQ     {}
    |SUB_EQ     {}
    |SL_EQ      {}
    |SR_EQ      {}
    |BITWISE_AND_EQ     {}
    |BITWISE_XOR_EQ     {}
    |BITWISE_OR_EQ      {}
    ;

expression:
    assignment_expression 
    {
        $$ = $1;
    }
    |expression COMMA assignment_expression {}
    ;

constant_expression:
    conditional_expression {}
    ;

declaration:
    declaration_specifiers init_declarator_list SEMICOLON {}
    |declaration_specifiers SEMICOLON {}
    ;


declaration_specifiers:
    storage_class_specifier declaration_specifiers  {}
    |storage_class_specifier                        {}
    |type_specifier declaration_specifiers          {}
    |type_specifier                                 {}
    |type_qualifier declaration_specifiers          {}
    |type_qualifier                                 {}
    |function_specifier declaration_specifiers      {}
    |function_specifier                             {}
    ;

init_declarator_list:
    init_declarator {}
    |init_declarator_list COMMA init_declarator {}
    ;

init_declarator:
    declarator {$$ = $1;}
    |declarator ASSIGN initializer 
    {
        
        if ($3->initial_value != "") $1->initial_value = $3->initial_value;             // get the initial value and emit it
        emit ("EQUAL", $1->name, $3->name);
    }
    ;

storage_class_specifier:
    EXTERN      {}
    | STATIC    {}
    | AUTO      {}
    | REGISTER  {}
    ;

type_specifier: 
    VOID        {Type = "VOID";}
    | CHAR      {Type = "CHAR";}
    | SHORT     {}
    | INT       {Type = "INTEGER";}
    | LONG      {}
    | FLOAT     {}
    | DOUBLE    {Type = "DOUBLE";}
    | SIGNED    {}
    | UNSIGNED  {}
    | BOOL      {}
    | COMPLEX   {}
    | IMAGINARY {}
    | enum_specifier {}
    ;

specifier_qualifier_list:
    type_specifier specifier_qualifier_list     {}
    | type_specifier                            {}
    | type_qualifier specifier_qualifier_list   {}
    | type_qualifier                            {}
    ;

enum_specifier:
    ENUM IDENTIFIER CURLY_BRACKET_OPEN enumerator_list CURLY_BRACKET_CLOSE          {}
    |ENUM CURLY_BRACKET_OPEN enumerator_list CURLY_BRACKET_CLOSE                    {}
    |ENUM IDENTIFIER CURLY_BRACKET_OPEN enumerator_list COMMA CURLY_BRACKET_CLOSE   {}
    |ENUM CURLY_BRACKET_OPEN enumerator_list COMMA CURLY_BRACKET_CLOSE              {}
    |ENUM IDENTIFIER                                                                {}
    ;

enumerator_list:
    enumerator  {}
    |enumerator_list COMMA enumerator {}
    ;

enumerator:
    IDENTIFIER  {}
    |IDENTIFIER ASSIGN constant_expression {}
    ;

type_qualifier:
    CONST       {}
    |RESTRICT   {}
    |VOLATILE   {}
    ;

function_specifier:
    INLINE      {}
    ;

declarator:
    pointer direct_declarator                                       // for multidimensional arrays
    {   
        symtype * t = $1;                                           // move in depth till you get the base type
        while (t->ptr != NULL) t = t->ptr;
        t->ptr = $2->type;
        $$ = $2->update($1);
    }
    |direct_declarator {}
    ;


direct_declarator:
    IDENTIFIER                                                      // if identifier, simply add a new variable of var_type
    {
        $$ = $1->update(new symtype(Type));
        currentSymbol = $$;
    }
    | ROUND_BRACKET_OPEN declarator ROUND_BRACKET_CLOSE 
    {
        $$ = $2;
    }
    | direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list assignment_expression SQUARE_BRACKET_CLOSE  {}
    | direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list SQUARE_BRACKET_CLOSE                        {}
    | direct_declarator SQUARE_BRACKET_OPEN assignment_expression SQUARE_BRACKET_CLOSE 
    {
        symtype * t = $1 -> type;
        symtype * prev = NULL;
        while (t->type == "ARR")                                    // keep moving recursively to get basetype
        {
            prev = t;
            t = t->ptr;
        }
        if (prev == NULL) 
        {
            int temp = atoi($3->loc->initial_value.c_str());        // get initial value
            symtype* s = new symtype("ARR", $1->type, temp);        // create new symbol table with that initial value
            $$ = $1->update(s);                                     // update the symbol table 
        }
        else                                                        // similar arguments as above 
        {  
            prev->ptr =  new symtype("ARR", t, atoi($3->loc->initial_value.c_str()));
            $$ = $1->update ($1->type);
        }
    }
    | direct_declarator SQUARE_BRACKET_OPEN SQUARE_BRACKET_CLOSE 
    {
        symtype * t = $1 -> type;
        symtype * prev = NULL;
        while (t->type == "ARR")                                    // keep moving recursively to get basetype
        {
            prev = t;
            t = t->ptr;
        }
        if (prev == NULL)                                           
        {
            symtype* s = new symtype("ARR", $1->type, 0);           // no initial value - simply keep zero
            $$ = $1->update(s);
        }
        else 
        {
            prev->ptr =  new symtype("ARR", t, 0);
            $$ = $1->update ($1->type);
        }
    }
    | direct_declarator SQUARE_BRACKET_OPEN STATIC type_qualifier_list assignment_expression SQUARE_BRACKET_CLOSE   {}
    | direct_declarator SQUARE_BRACKET_OPEN STATIC assignment_expression SQUARE_BRACKET_CLOSE                       {}
    | direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list MUL SQUARE_BRACKET_CLOSE                            {}
    | direct_declarator SQUARE_BRACKET_OPEN MUL SQUARE_BRACKET_CLOSE                                                {}
    | direct_declarator ROUND_BRACKET_OPEN CT parameter_type_list ROUND_BRACKET_CLOSE 
    {
        table->name = $1->name;
        if ($1->type->type !="VOID") 
        {
            sym *s = table->lookup("return");                       // lookup for return value
            s->update($1->type);        
        }
        $1->nested=table;
        $1->category = "function";
        table->parent = globalTable;
        changeTable (globalTable);                                  // Come back to globalsymbol table        
        currentSymbol = $$;
    }
    | direct_declarator ROUND_BRACKET_OPEN identifier_list ROUND_BRACKET_CLOSE {}
    | direct_declarator ROUND_BRACKET_OPEN CT ROUND_BRACKET_CLOSE 
    {
        table->name = $1->name;
        if ($1->type->type != "VOID") 
        {
            sym *s = table->lookup("return");                       // lookup for return value
            s->update($1->type);        
        }
        $1->nested = table;
        $1->category = "function";
        table->parent = globalTable;
        changeTable (globalTable);                                  // Come back to globalsymbol table             
        currentSymbol = $$;
    }
    ;

CT: 
    %empty 
    {                                                           
        // Used for changing to symbol table for a function
        // Function symbol table doesn't already exist
        if (currentSymbol->nested == NULL) changeTable(new symtable("")); 
        else                                                        // Function symbol table already exists
        {
            changeTable (currentSymbol ->nested);                       
            emit ("FUNC", table->name);
        }
    }
    ;

pointer:
    MUL type_qualifier_list {}
    |MUL 
    {
        $$ = new symtype("PTR");                                    // create new pointer
    }
    |MUL type_qualifier_list pointer {}
    |MUL pointer 
    {
        $$ = new symtype("PTR", $2);                                // create new pointer
    }
    ;

type_qualifier_list:
    type_qualifier {}
    |type_qualifier_list type_qualifier {}
    ;

parameter_type_list:
    parameter_list {}
    |parameter_list COMMA DOTS {}
    ;

parameter_list:
    parameter_declaration {}
    |parameter_list COMMA parameter_declaration {}
    ;

parameter_declaration:
    declaration_specifiers declarator 
    {
        $2->category = "param";
    }
    |declaration_specifiers {}
    ;

identifier_list:
    IDENTIFIER {}
    |identifier_list COMMA IDENTIFIER {}
    ;

type_name:
    specifier_qualifier_list {}
    ;

initializer:
    assignment_expression 
    {
        $$ = $1->loc;
    }
    |CURLY_BRACKET_OPEN initializer_list CURLY_BRACKET_CLOSE        {}
    |CURLY_BRACKET_OPEN initializer_list COMMA CURLY_BRACKET_CLOSE  {}
    ;


initializer_list:
    designation initializer                         {}
    |initializer                                    {}
    |initializer_list COMMA designation initializer {}
    |initializer_list COMMA initializer             {}
    ;

designation:
    designator_list ASSIGN {}
    ;

designator_list:
    designator {}
    |designator_list designator {}
    ;

designator:
    SQUARE_BRACKET_OPEN constant_expression SQUARE_BRACKET_CLOSE {}
    |DOT IDENTIFIER {}
    ;

statement:
    labeled_statement {}
    |compound_statement 
    {
        $$ = $1;
    }
    |expression_statement 
    {
        $$ = new statement();                                       // create new statement with same nextlist
        $$->nextlist = $1->nextlist;
    }
    |selection_statement 
    {
        $$ = $1;
    }
    |iteration_statement 
    {
        $$ = $1;
    }
    |jump_statement 
    {
        $$ = $1;
    }
    ;

labeled_statement:
    IDENTIFIER COLON statement 
    {
        $$ = new statement();                                       // create new statement
    }
    |CASE constant_expression COLON statement 
    {
        $$ = new statement();                                       // create new statement
    }
    |DEFAULT COLON statement 
    {
        $$ = new statement();                                       // create new statement
    }
    ;

compound_statement:
    CURLY_BRACKET_OPEN block_item_list CURLY_BRACKET_CLOSE 
    {
        $$ = $2;
    }
    |CURLY_BRACKET_OPEN CURLY_BRACKET_CLOSE 
    {
        $$ = new statement();                                       // create new statement
    }
    ;

block_item_list:
    block_item 
    {
        $$ = $1;
    }
    |block_item_list M block_item 
    {
        $$ = $3;                                                    // after $1, move to block_item via $2
        backpatch ($1->nextlist, $2);
    }
    ;

block_item:
    declaration 
    {
        $$ = new statement();
    }
    |statement 
    {
        $$ = $1;
    }
    ;

expression_statement:
    expression SEMICOLON 
    {
        $$ = $1;
    }
    |SEMICOLON 
    {
        $$ = new expr();
    }
    ;

selection_statement:
    IF ROUND_BRACKET_OPEN expression N ROUND_BRACKET_CLOSE M statement N %prec "then"
    {
        // if statement without else
        backpatch ($4->nextlist, nextinstr());                      // nextlist of N goes to nextinstr
        convertInt2Bool($3);                                        // convert expression to bool    
        $$ = new statement();                                       // make new statement
        backpatch ($3->truelist, $6);                               // is expression is true, go to M i.e just before statement body
        list<int> temp = merge ($3->falselist, $7->nextlist);       // merge falselist of expression, nextlist of statement and second N
        $$->nextlist = merge ($8->nextlist, temp);
    }
    |IF ROUND_BRACKET_OPEN expression N ROUND_BRACKET_CLOSE M statement N ELSE M statement 
    {
        // if statement with else
        backpatch ($4->nextlist, nextinstr());                      // nextlist of N goes to nextinstr
        convertInt2Bool($3);                                        // convert expression to bool
        $$ = new statement();                                       // create new statement
        backpatch ($3->truelist, $6);                               // when expression is true, go to M1 else go to M2
        backpatch ($3->falselist, $10);
        list<int> temp = merge ($7->nextlist, $8->nextlist);        // merge the nextlists of the statements and second N
        $$->nextlist = merge ($11->nextlist,temp);
    }
    |SWITCH ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE statement {}
    ;

iteration_statement:
    WHILE M ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE M statement 
    {
        $$ = new statement();                                       // create new statement
        convertInt2Bool($4);                                        // convert int expression to bool
        // M1 to go back to boolean again
        // M2 to go to statement if the boolean is true
        backpatch($7->nextlist, $2);
        backpatch($4->truelist, $6);
        $$->nextlist = $4->falselist;
        stringstream strs;
        strs << $2;
        string temp_str = strs.str();
        char* intStr = (char*) temp_str.c_str();
        string str = string(intStr);
        emit ("GOTOOP", str);                                       // Emit to prevent fallthrough
    }
    |DO M statement M WHILE ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE SEMICOLON 
    {
        $$ = new statement();                                       // create new statement
        convertInt2Bool($7);                                        // convert int expression to bool
        // M1 to go back to statement if expression is true
        // M2 to go to check expression if statement is complete
        backpatch ($7->truelist, $2);
        backpatch ($3->nextlist, $4);
        $$->nextlist = $7->falselist;
    }
    |FOR ROUND_BRACKET_OPEN expression_statement M expression_statement ROUND_BRACKET_CLOSE M statement
    {
        $$ = new statement();                                       // create new statement
        convertInt2Bool($5);                                        // convert int expression to bool
        backpatch ($5->truelist, $7);                               // standard back-patching principles
        backpatch ($8->nextlist, $4);                               // standard back-patching principles
        stringstream strs;
        strs << $4;
        string temp_str = strs.str();
        char* intStr = (char*) temp_str.c_str();
        string str = string(intStr);
        emit ("GOTOOP", str);                                       // prevent fallthrough
        $$->nextlist = $5->falselist;
    }
    |FOR ROUND_BRACKET_OPEN expression_statement M expression_statement M expression N ROUND_BRACKET_CLOSE M statement
    {
        $$ = new statement();                                       // create new statement
        convertInt2Bool($5);                                        // convert int expression to bool
        backpatch ($5->truelist, $10);                              // simple back-patching principles
        backpatch ($8->nextlist, $4);                               // simple back-patching principles
        backpatch ($11->nextlist, $6);                              // simple back-patching principles
        stringstream strs;
        strs << $6;
        string temp_str = strs.str();
        char* intStr = (char*) temp_str.c_str();
        string str = string(intStr);
        emit ("GOTOOP", str);                                        // prevent fallthrough
        $$->nextlist = $5->falselist;
    }
    ;

jump_statement:
    GOTO IDENTIFIER SEMICOLON {$$ = new statement();}
    |CONTINUE SEMICOLON {$$ = new statement();}
    |BREAK SEMICOLON {$$ = new statement();}
    |RETURN expression SEMICOLON                                    // emit return with the name of the return value
    {
        $$ = new statement();
        emit("RETURN", $2->loc->name);
    }
    |RETURN SEMICOLON                                               // simply emit return
    {   
        $$ = new statement();
        emit("RETURN", "");
    }
    ;

translation_unit:
    external_declaration                    {}
    |translation_unit external_declaration  {}
    ;

external_declaration:
    function_definition {}
    |declaration        {}
    ;

function_definition:
    declaration_specifiers declarator declaration_list CT compound_statement {}
    |declaration_specifiers declarator CT compound_statement 
    {
        emit ("FUNCEND", table->name);
        table->parent = globalTable;
        changeTable (globalTable);                      // once we come back to this at the end, change the table to global Symbol table
    }
    ;

declaration_list:
    declaration {}
    |declaration_list declaration {}
    ;

%%

void yyerror(string s) {
    cout << s << endl;
}