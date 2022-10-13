/* Header file for the translation statements for tinyC (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

#ifndef _TRANSLATOR_H
#define _TRANSLATOR_H

#include <bits/stdc++.h>

extern  char* yytext;
extern  int yyparse();

using namespace std;

#define lsi list<sym>::iterator
#define li list<int>
#define ls list<sym>
#define vec vector

class sym;                          // An entry in ST
class symboltype;                   // Type of a symbol in ST
class symtable;                     // ST
class quad;                         // A single entry in the quadArray
class quadArray;                    // Array of quads

class sym{
    public:
        string name;                // Name of the symbol
        symboltype *type;           // Type of the symbol
        int size;                   // Size of the symbol
        int offset;                 // Offset of symbol in ST
        symtable* nested;           // Pointer to the nested symbol table
        string val;                 // Initial value of the symbol (if specified)
        // Constructor
        sym (string, string t = "int", symboltype* ptr = NULL, int width = 0);
        // Update fields of an entry
        sym* update(symboltype*);
};

class symboltype{
    public:
        string type;                // Type of symbol. 
        int width;                  // Size of Array (if Array), 1 in other cases
        symboltype* arrtype;        // For multidimensional arrays
        // Constructor
        symboltype(string , symboltype* ptr = NULL, int width = 1);
};

class symtable{
    public:
        string name;                // Name of the Table
        ls table;                   // The table of symbols
        int count;                  // Number of temporary variables
        symtable* parent;           // Parent ST
        // Constructor
        symtable (string n = "NULL");
        // Lookup a symbol in ST
        sym* lookup (string);       
        // Print the ST                      
        void print(); 
        // Update the ST                                     
        void update();                                            
};

class quad{
    public:
        string res;                 // Result
        string op;                  // Operator
        string arg1;                // Argument 1
        string arg2;                // Argument 2
        // Constructors                          
        quad (string, string , string op = "=", string arg2 = "");         
        quad (string, int, string op = "=", string arg2 = "");              
        quad (string, float, string op = "=", string arg2 = ""); 
        // Print the Quad
        void print(); 
        void frmt1();               // Frequently printed formats
        void frmt2();
};
class quadArray{
    public:
        vec<quad> Array;            // Array of quads
        void print();               // Print the quadArray
};

class basicType{
    public:
    vec<string> type;               // Type name
        vec<int> size;              // Size
        // Add a new type
        void addType(string,int );
};

extern symtable* ST;                // Current Symbol Table
extern symtable* globalST;          // Global Symbol Table
extern sym* currSymbolPtr;          // Last encountered symbol
extern quadArray Q;                 // quadArray
extern basicType bt;                // Type ST
extern long long int instr_count;   // Count of instruction
extern bool debug_on;               // For printing debug output

void generateSpaces(int );          // Generate spaces for formating output

// Convert int and float to string
string convertIntToString(int );
string convertFloatToString(float );

// Generate temporary variable and insert in current ST
sym* gentemp (symboltype* , string init = "-");  

// Emit Functions
void emit(string, string, string arg1 = "", string arg2 = "");  
void emit(string, string, int, string arg2 = "");       
void emit(string, string, float , string arg2 = "");   

// Backpatching
void backpatch (list <int>, int );
li makelist (int );                 // Create new list contaninig an integer
li merge (list<int> &l1, list <int> &l2);   // Merge two lists
int nextinstr();                    // Get the next instruction number
void debug();                       // Print debugging output

// Type checking and Type conversion
sym* convertType(sym*, string);     // Type conversion
bool compareSymbolType(sym* &s1, sym* &s2);         // Compare two ST entries
bool compareSymbolType(symboltype*, symboltype*);   // Compare two symboltype objects
int computeSize (symboltype *);     // Calculate size of symbol type
string getType(symboltype *);       // Print type of symbol
void changeTable (symtable* );      // Change current table

// Other structures
struct Statement {
    li nextlist;                    // Nextlist for Statement
};

struct Array {
    string atype;                   // Type of Array
    sym* loc;                       // Location used to compute address of Array
    sym* Array;                     // Pointer to the ST entry
    symboltype* type;               // Type of subarray
};

struct Expression {
    sym* loc;                       // Pointer to the ST entry
    string type;                    // Type ofexpression
    li truelist;                    // Truelist for boolean expressions
    li falselist;                   // Falselist for boolean expressions
    li nextlist;                    // For statement expressions
};

Expression* convertIntToBool(Expression*);      // Convert int expression to boolean
Expression* convertBoolToInt(Expression*);      // Convert boolean expression to int

#endif