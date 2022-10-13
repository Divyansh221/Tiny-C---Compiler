/* Test File - 3 (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

// This test file extensively checks the expressions both boolean and algebraic
// It also tests conditional statements (if-else) and global variables

int printStr(char *c);
int printInt(int i);
int readInt(int *eP);

int a;
int b = 1;                                                 // global variable
char c;
char d = 'a';


int main (){
  int age;
  int *e;
  int n = 8;
  int var1 = 120, var2 = 15;
  int i, j, k, l;
  char ch = 'c', d = 'a';                                 // character definitions

  printStr("\n      ######################################################\n");        
  printStr("      ##                                                  ##\n");        
  printStr("      ##          Testing conditional statements          ##\n");        
  printStr("      ##                                                  ##\n");        
  printStr("      ######################################################\n\n");

  printStr("      Enter your age : ");
  e = &age;
  age = readInt(e);
  if(age >= 18){                                          // if-else statement
    printStr("      Greater than or equal to 18\n");
  }
  else{
    printStr("      Smaller than 18\n");
  }
  printStr("      Testing result - OK\n");

  printStr("\n      ######################################################\n");        
  printStr("      ##                                                  ##\n");        
  printStr("      ##          Testing Arithmetic operations           ##\n");        
  printStr("      ##                                                  ##\n");        
  printStr("      ######################################################\n\n");

  // Arithmetic Operations
  i = var1 + var2;
  j = var1 - var2;
  k = var1 * var2;
  l = var1 / var2;
  printStr("      Addition (var1 and var2) : ");
  printInt(i);
  printStr("      Subtraction (var1 and var2) : ");
  printInt(j);
  printStr("      Multiplication (var1 and var2) : ");
  printInt(k);
  printStr("      Division (var1 and var2) : ");
  printInt(l);
  printStr("      Testing result - OK\n");
  
  printStr("\n");
  return 0;
}