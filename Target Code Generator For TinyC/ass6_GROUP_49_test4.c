/* Test File - 4 (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

// Program to check if a number is a magic number or not

int printStr(char *c);
int printInt(int i);
int readInt(int *eP);

int main () {
  printStr("\n      ######################################################\n");        
  printStr("      ##                                                  ##\n");        
  printStr("      ##                Fibonacci Numbers                 ##\n");        
  printStr("      ##                                                  ##\n");        
  printStr("      ######################################################\n\n");


  printStr("      Enter the value of N (<= 45): ");
  int i, ep;
  i = readInt(&ep);

  printStr("      The entered value is: ");
  printInt(i);

  printStr("      The first N fibonacci numbers are :\n");

  int j, a = 0, b = 1, c;

  printStr("      ");
  if(i > 0) printInt(a);
  printStr("      ");
  if(i > 1) printInt(b);
  printStr("      ");

  for(j = 2; j < i; j++){
    c = a + b;
    printInt(c);
    printStr("      ");
    a = b;
    b = c;
    int r = j/10;
  }

  printStr("\n");
  return;
}