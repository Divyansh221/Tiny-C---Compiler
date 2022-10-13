/* Function definations file for the translation statements for tinyC (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

#include<iostream>
#include<sstream>
#include<string>

#include "ass5_GROUP_49_translator.h"

using namespace std;

symtable* globalST;
quadArray Q;      
string var_type;  
symtable* ST;     
sym* currSymbolPtr;
basicType bt;      
long long int instr_count;
bool debug_on;        
    
sym::sym(string n, string t, symboltype* ptr, int width){  
    this->name = n;
    type=new symboltype(t, ptr, width); 
    size=computeSize(type);           
    offset = 0;                         
    val = "-";                                  // No initial value
    nested = NULL;                              // No nested tables
}

sym* sym::update(symboltype* t){
    type = t;                                    
    this->size = computeSize(t);                 
    return this;                               
}

symboltype::symboltype(string t, symboltype* ptr, int width){
    this->type = t;
    this->width = width;
    this->arrtype = ptr;
}

symtable::symtable(string n){
    this->name = n;
    count = 0;                                  // count is initialised to 0
}

sym* symtable::lookup(string n){
    sym* symbol;
    lsi i;                      
    i = table.begin();
    while(i != table.end()){
        if(i->name == n) return &(*i);          // Find the name of symbol in ST and return if found
        i++;
    }
    symbol = new sym(n);                        // Else add new symbol to ST
    table.push_back(*symbol);           
    return &table.back();               
}

void symtable::print(){
    int next_instr=0;
    list<symtable*> nt;                       
    for(int t1 = 0; t1 < 55; t1++) cout<<"__";        // For design
    cout<<endl;
    cout<<"\n\tTable Name: "<<this->name<<"\t\t\t\t\tParent Name: "; 
    if((this->parent == NULL)) cout<<"NULL"<<endl;
    else cout<<this->parent->name<<endl; 
    for(int ti = 0; ti < 55; ti++) cout<<"__";
    cout<<endl;
    cout<<"\nName";                             // Name
    generateSpaces(16);
    cout<<"Type";                               // Type
    generateSpaces(21);
    cout<<"Initial Value";                      // Initial Value
    generateSpaces(7);
    cout<<"Size";                               // Size
    generateSpaces(6);
    cout<<"Offset";                             // Offset
    generateSpaces(9);
    cout<<"Nested"<<endl;                       // Nested symbol table
    generateSpaces(100);
    cout<<endl;
    ostringstream os;
    for(lsi it = table.begin(); it != table.end(); it++) {  
        cout<<it->name;                                 // Print name
        generateSpaces(20-it->name.length());
        string typ=getType(it->type);                   // Use gettType to print type
        cout<<typ;
        generateSpaces(25-typ.length());
        cout<<it->val;                                  // Print initial value
        generateSpaces(20-it->val.length());
        cout<<it->size;                                 // Print size
        os<<it->size;
        generateSpaces(10-os.str().length());
        os.str("");
        os.clear();
        cout<<it->offset;                               // Print offset
        os<<it->offset;
        generateSpaces(15-os.str().length());
        os.str("");
        os.clear();
        if(it->nested == NULL) cout<<"NULL"<<endl;
        else{
            cout<<it->nested->name<<endl;
            nt.push_back(it->nested);
        }
    }
    for(int i = 0; i < 110; i++) 
        cout<<"-";
    cout<<"\n\n";
    for(list<symtable*>::iterator j = nt.begin(); j != nt.end(); j++) (*j)->print();    // Print nested ST
}

void symtable::update(){
    list<symtable*> nt;           
    int off = 0;
    lsi i;
    i = table.begin();
    while(i != table.end()){
    i->offset = off;
        off = i->offset+i->size;
        if(i->nested != NULL) nt.push_back(i->nested);
        i++;
    }
    list<symtable*>::iterator j;
    j = nt.begin();
    while(j != nt.end()){
        (*j)->update();                         // Update nested ST
        j++;
    }
}

quad::quad(string res, string arg1, string op, string arg2){
    this->res = res;
    this->arg1 = arg1;
    this->op = op;
    this->arg2 = arg2;
}

quad::quad(string res, int arg1, string op, string arg2){
    this->res = res;
    this->arg2 = arg2;
    this->op = op;
    this->arg1 = convertIntToString(arg1);
}

quad::quad(string res, float arg1, string op, string arg2){
    this->res = res;
    this->arg2 = arg2;
    this->op = op;
    this->arg1 = convertFloatToString(arg1);
}

void quad::print(){
    // Binary Operations
    int next_instr = 0;   
    if(op == "+") this->frmt1();
    else if(op == "-") this->frmt1();
    else if(op == "*") this->frmt1();
    else if(op == "/") this->frmt1();
    else if(op == "%") this->frmt1();
    else if(op == "|") this->frmt1();
    else if(op == "^") this->frmt1();
    else if(op == "&") this->frmt1();
    // Relational Operations
    else if(op == "==") this->frmt2();
    else if(op == "!=") this->frmt2();
    else if(op == "<=") this->frmt2();
    else if(op == "<") this->frmt2();
    else if(op == ">") this->frmt2();
    else if(op == ">=") this->frmt2();
    else if(op == "goto") cout<<"goto "<<res;
    // Shift Operations
    else if(op == ">>") this->frmt1();
    else if(op == "<<") this->frmt1();
    else if(op == "=") cout<<res<<" = "<<arg1 ;
    // Unary Operators..
    else if(op == "=&") cout<<res<<" = &"<<arg1;
    else if(op == "=*") cout<<res<<" = *"<<arg1 ;
    else if(op == "*=") cout<<"*"<<res<<" = "<<arg1 ;
    else if(op == "uminus") cout<<res<<" = -"<<arg1;
    else if(op == "~") cout<<res<<" = ~"<<arg1;
    else if(op == "!") cout<<res<<" = !"<<arg1;
    // Other operations
    else if(op == "=[]") cout<<res<<" = "<<arg1<<"["<<arg2<<"]";
    else if(op == "[]=") cout<<res<<"["<<arg1<<"]"<<" = "<< arg2;
    else if(op == "return") cout<<"return "<<res;
    else if(op == "param") cout<<"param "<<res;
    else if(op == "call") cout<<res<<" = "<<"call "<<arg1<<", "<<arg2;
    else if(op == "label") cout<<res<<": ";
    else cout<<"Can't find "<<op;
    cout<<endl;
}

void quad::frmt1(){
    cout<<res<<" = "<<arg1<<" "<<op<<" "<<arg2;   
}

void quad::frmt2(){
    cout<<"if "<<arg1<< " "<<op<<" "<<arg2<<" goto "<<res;
}

void quadArray::print(){
    for(int i = 0; i < 50; i++) cout<<"__";
    cout<<endl;
    cout<<"\nThree Address Code:"<<endl;
    for(int i = 0; i < 55; i++) cout<<"__";
    cout<<endl;
    int j = 0;
    vector<quad>::iterator it;
    it = Array.begin();
    while(it != Array.end()){
        if(it->op == "label"){                  // Single tab before labels
            cout<<endl<<"L"<<j<<":\t";
            it->print();
        }
        else{                                   // Double tab otherwise
            cout<<"L"<<j<<":\t\t";
            it->print();
        }
        it++;
        j++;
    }
    for(int i = 0; i < 55; i++) cout<<"--"; 
    cout<<endl;
}

void basicType::addType(string n, int x){
    type.push_back(n);
    size.push_back(x);
}

void generateSpaces(int n){
    while(n--) cout<<" ";
}

string convertIntToString(int a){
    stringstream ss;                            // Using buffer stringstream
    ss<<a; 
    string temp = ss.str();
    char* integer = (char*) temp.c_str();
    string s = string(integer);
    return s;                       
}

string convertFloatToString(float x){
    std::ostringstream os;
    os<<x;
    return os.str();
}

sym* gentemp(symboltype* t, string init){ 
    string tmp_name = "t"+convertIntToString(ST->count++);             // Generate name of temp variable
    sym* s = new sym(tmp_name);
    s->type = t;
    s->size=computeSize(t);
    s->val = init;
    ST->table.push_back(*s);   
    return &ST->table.back();
}

void emit(string op, string res, string arg1, string arg2){ 
    quad *q = new quad(res, arg1, op, arg2);
    Q.Array.push_back(*q);
}

void emit(string op, string res, int arg1, string arg2) {
    quad *q = new quad(res, arg1, op, arg2);
    Q.Array.push_back(*q);
}

void emit(string op, string res, float arg1, string arg2){
    quad *q = new quad(res, arg1, op, arg2);
    Q.Array.push_back(*q);
}

void backpatch(list<int> l1, int x){
    string str = convertIntToString(x); 
    list<int>::iterator i;
    i = l1.begin();
    while(i != l1.end()){
        Q.Array[*i].res = str;
        i++;
    }
}

list<int> makelist(int x){ 
    list<int> newlist(1, x); 
    return newlist;
}

list<int> merge(list<int> &l1, list<int> &l2){
    l1.merge(l2);   
    return l1;
}

int nextinstr(){
    return Q.Array.size();                      // Next instruction will be 1+(size-1)
}

void debug(){
    if(debug_on == 1) cout<<instr_count<<endl;
}

sym* convertType(sym* s, string t){
    sym* temp = gentemp(new symboltype(t)); 
    if(s->type->type == "float"){               // Input float
        if(t == "int"){                                             // output int
            emit("=", temp->name, "float2int("+s->name+")");
            return temp;
        }
        else if(t == "char"){                                       // Output char
            emit("=", temp->name, "float2char("+s->name+")");
            return temp;
        }
        return s;
    }
    else if(s->type->type == "int"){                                // Input int
        if(t == "float"){                                           // Output float
            emit("=", temp->name, "int2float("+s->name+")");
            return temp;
        }
        else if(t == "char"){                                       // Output char
            emit("=", temp->name, "int2char("+s->name+")");
            return temp;
        }
        return s;
    }
    else if(s->type->type == "char"){                               // Input char
        if(t == "int"){                                             // Output int
            emit("=", temp->name, "char2int("+s->name+")");
            return temp;
        }
        if(t == "float"){                                           // Output float
            emit("=", temp->name, "char2float("+s->name+")");
            return temp;
        }
        return s;
    }
    return s;
}

bool compareSymbolType(sym*& s1, sym*& s2){                         // Check if the symbols have same type or not
    symboltype* t1 = s1->type;                       
    symboltype* t2 = s2->type;
    int flag = 0;
    if(compareSymbolType(t1, t2)) flag = 1;       
    else if(s1 = convertType(s1,t2->type)) flag = 1;                // Check if one can be converted to the other
    else if(s2 = convertType(s2,t1->type)) flag = 1;
    if(flag) return true;
    else return false;
}

bool compareSymbolType(symboltype* t1, symboltype* t2){             // Check if the symbol types are same or not
    int flag = 0; 
    if(t1 == NULL && t2 == NULL) flag = 1;                          // If two symboltypes are NULL
    else if(t1 == NULL || t2 == NULL || t1->type != t2->type) flag = 2;     // if one of them is NULL or base type isn't same
    if(flag == 1) return true;
    else if(flag == 2) return false;
    else return compareSymbolType(t1->arrtype, t2->arrtype);        // Check their Array type
}

int computeSize(symboltype* t){
    if(t->type.compare("void") == 0) return bt.size[1];
    else if(t->type.compare("char") == 0) return bt.size[2];
    else if(t->type.compare("int") == 0) return bt.size[3];
    else if(t->type.compare("float") == 0) return  bt.size[4];
    else if(t->type.compare("arr") == 0) return t->width*computeSize(t->arrtype);     // Recursion for arrays
    else if(t->type.compare("ptr") == 0) return bt.size[5];
    else if(t->type.compare("func") == 0) return bt.size[6];
    else return -1;
}

string getType(symboltype* t){ 
    if(t == NULL) return bt.type[0];
    if(t->type.compare("void") == 0)  return bt.type[1];
    else if(t->type.compare("char") == 0) return bt.type[2];
    else if(t->type.compare("int") == 0) return bt.type[3];
    else if(t->type.compare("float") == 0) return bt.type[4];
    else if(t->type.compare("ptr") == 0) return bt.type[5]+"("+getType(t->arrtype)+")";   // Recursion for pointers
    else if(t->type.compare("arr") == 0) {
        string str = convertIntToString(t->width);                                        //Recursion for arrays
        return bt.type[6]+"("+str+","+getType(t->arrtype)+")";
    }
    else if(t->type.compare("func") == 0) return bt.type[7];
    else return "NA";
}

void changeTable(symtable* nt){
    ST = nt;
}

Expression* convertIntToBool(Expression* e){  
    if(e->type != "bool"){
        e->falselist = makelist(nextinstr());                       // Update the falselist, truelist and emit goto statements
        emit("==", "", e->loc->name, "0");
        e->truelist = makelist(nextinstr());
        emit("goto", "");
    }
    return e;
}

Expression* convertBoolToInt(Expression* e){ 
    if(e->type == "bool"){
        e->loc = gentemp(new symboltype("int"));                    // use goto statements and standard procedure
        backpatch(e->truelist, nextinstr());
        emit("=", e->loc->name, "true");
        int p = nextinstr() + 1;
        string str = convertIntToString(p);
        emit("goto", str);
        backpatch(e->falselist, nextinstr());
        emit("=", e->loc->name, "false");
    }
    return e;
}

int main(){
    bt.addType("null",0);                                           // Add base types initially
    bt.addType("void",0);
    bt.addType("char",1);
    bt.addType("int",4);
    bt.addType("float",8);
    bt.addType("ptr",4);
    bt.addType("arr",0);
    bt.addType("func",0);
    instr_count = 0;                                                // count of instructions initialised to 0
    debug_on = 0;                                                   // debugging is off
    globalST = new symtable("Global");                              // Global ST
    ST = globalST;
    yyparse();                                                      // Parsing
    globalST->update();                            
    Q.print();  
    globalST->print();                                              // Print STs                                          
    // Print TACs
};