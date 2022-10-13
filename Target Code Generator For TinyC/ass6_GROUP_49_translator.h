/* Header file for the translation statements for tinyC (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

#ifndef TRANSLATE
#define TRANSLATE

#include <sstream>
#include <bits/stdc++.h>

extern char *yytext;
extern int yyparse();

#define lsi list<sym>::iterator
#define lsti list<symtable*>::iterator
#define ls list

using namespace std;

//Class Declarations
class sym;                          // An entry in ST
class symtype;                      // Type of a symbol in ST
class symtable;                     // ST
class quad;                         // A single entry in the quadArray
class quadArray;                    // Array of quads

class sym{
    public:
        string name;                // Name of the symbol
        symtype * type;             // Type of the Symbol
        int size;                   // Size of the symbol
        int offset;                 // Offset of symbol in ST
        string initial_value;       // Symbol initial valus (if specified)
        string category;            // global, local or param
        symtable * nested;          // Pointer to nested symbol table
        //Constructor
        sym(string, string t = "INTEGER", symtype *ptr = NULL, int width = 0);  
        //Update fields of an entry
        sym* update(symtype*);  
};

class symtype{                      // Type of symbols in symbol table
    public:
        string type;
        int width;                  // Size of Array (if Array)
        symtype * ptr;              // for multidimensional arrays
        //Constructor
        symtype(string, symtype *ptr = NULL, int width = 1);
};

class symtable{ 
    public:
        string name;                // Name of Table
        ls<sym> table;              // The table of symbols
        int count;                  // Number of temporary variables
        symtable *parent;           // Parent ST
        map<string, int> ar;        // Activation Record
        //Constructor
        symtable(string n = "NULL");
        // Lookup a symbol in ST
        sym* lookup(string);
        // Print the ST
        void print();       
        // Update the ST
        void update();        
};

class quad{ 
    public:
        string op;                  // Operator
        string result;              // Result
        string arg1;                // Argument 1
        string arg2;                // Argument 2
        //Constructors
        quad(string, string, string op = "EQUAL", string arg2 = "");
        quad(string, int, string op = "EQUAL", string arg2 = "");
        quad(string, float, string op = "EQUAL", string arg2 = ""); 
        // Print Quad
        void print();                      
};

class quadArray{
    public:
        vector<quad> Array;         // Array of quads
        void print();               // Print the quadArray
};

//Global variables
extern quadArray q;                 // Array of Quads
extern symtable *table;             // Current Symbol Table
extern symtable * globalTable;      // Global Symbbol Table
extern sym *currentSymbol;          // Last encountered symbol

//Other structures
struct statement{
    ls<int> nextlist;               // Nextlist for statement
};

struct Array{
    string cat;
    sym *loc;                       // Used to compute Array address
    sym *Array;                     // Pointer to ST entry
    symtype *type;                  // Type of SubArray
};

struct expr{
    sym *loc;                       // Pointer to ST entry
    string type;                    // Type of expression
    ls<int> truelist;               // Truelist for boolean expressions
    ls<int> falselist;              // Falselist for boolean expressions
    ls<int> nextlist;               // For statement expressions
};

// Generate temporary variable and insert in current ST
sym* gentemp(symtype*, string init = "");

//Emit functions
void emit(string, string, string arg1 = "", string arg2 = "");
void emit(string, string, int arg1, string arg2 = "");
void emit(string, string, float arg1, string arg2 = "");

//Backpatching
void backpatch(ls<int>, int);
ls<int> makelist(int);              // Make a new list with an integer
ls<int> merge(ls<int>&, ls<int>&);  // Merge two lists

int nextinstr();                    // Returns the next instruction number
//Typechecking and conversion
sym* conv(sym*, string);            // Type conversion
bool typecheck(sym*&, sym*&);       // Compare two symbols
bool typecheck(symtype*, symtype*); // Compare two symtype objects

expr* convertInt2Bool(expr*);       // Convert int expression to bool
expr* convertBool2Int(expr*);       // Convert bool to int expression

void changeTable(symtable*);        // Change the current ST

int size_type(symtype*);            // Calculate size of symbol type 
string print_type(symtype*);        // Print type of symbol

#endif