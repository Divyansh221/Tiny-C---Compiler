/*
Check Multi line comment
C program to test the lexer
Group:49
Amartya Mandal
Divyansh Bhatia
*/

#include<stdio.h>

#define group "group_49"

//Testing all the keywords
auto enum restrict unsigned
break extern return void
case float short volatile
char for signed while
const goto sizeof _Bool
continue if static _Complex
default inline struct _Imaginary
do int switch
double long typedef
else register union

inline void fn(int n, char[] s);

enum wday{"mon","tue","wed","thu","fri"};

typedef struct node{
    struct node* next;
    int k = 0;
    int v = 0;
}

main(){
    //Testing identifiers and constants
    _Bool b;
    _Imaginary  i;
    _Complex c1, c2;
    int n0 = 345;
    double pi = 3.14;
    float temp = -40.00;
    char c = 'a';
    str = "Lexer for TinyC";
    static short stsrt0 = 0;
    volatile unsigned long int vuli1 = 10;
    node* root = NULL
    int i=1, j=100;
    
    fn(i, str);
    
    //Testing Punctuators
    for(i=0;i<50;i++) {
        switch(i%2) {
            case(0) : continue;
            case(1) : i*=2;
            default : break;
        }
    }  
    while(1){ 
        if (i==j){
            root = root->next;
            root -> v = i/10;
            i %= 2;
            i>>1;
            i|1;
            i<<1;
        }
        else if(i>=j) {
            i = 2^10;
            i--;
            i = i & root->k;
            i += 1;
            if (i && (j || !i)) i = ~i;
        }

        else if(i <= j) {
            j <<= i;
            j &= (i | j);
            i |= (i & j);
            i ^= 2;
            i = *root.k;
        }
        auto m2 = 0;
        m2 |= 54;
        #define z 2
        m2 ^= z;
    }
    return 0;
}

inline void fn(int n, char[] s){
    printf("The output is : %d \n",n);
}

