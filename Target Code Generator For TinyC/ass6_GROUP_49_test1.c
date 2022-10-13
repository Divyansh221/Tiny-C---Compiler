/* Test File - 1 (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

// global declarations
// This testfile checks the functioning of the library functions printInt, readInt and printStr

int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int main(){
    int i, num;
    int *e;
    int n;

    // Using library functions printStr to print strings 
    printStr("\n      ######################################################\n");        
    printStr("      ##                                                  ##\n");        
    printStr("      ##          Print first n natural numbers           ##\n");        
    printStr("      ##                   (LOOP)                         ##\n");        
    printStr("      ##                                                  ##\n");        
    printStr("      ######################################################\n\n");

    num = 1;
    e = &num;

    printStr("      Enter the value of n (an integer) : ");
    n = readInt(e);                                                         // Using library functions readint to read integer 

    for(i = 0; i < n; i++){
        printStr("      ");                                                 // Using library functions printStr to print strings 
        printInt(num);                                                      // Using library functions printInt to print integer 
        num = num + 1;
    }

    printStr("\n");
    return 0;
}