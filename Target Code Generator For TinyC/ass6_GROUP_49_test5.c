/* Test File - 5 (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

// To test recursion and recursive fnctions

int printStr(char *c);
int readInt(int *ep);
int printInt(int i);

int pow(int a, int b){
  int ans;
  if(b == 0)ans = 1;
  else if(b == 1){
    ans = a;
  }
  else ans = a * pow(a, b - 1);
  return ans;
}

int main() {
  int i, j = 5, c;
  int *b = &c;
    
  // Using library functions printStr to print strings 
  printStr("\n      ######################################################\n");        
  printStr("      ##                                                  ##\n");        
  printStr("      ##             Testing Recursive functios           ##\n");        
  printStr("      ##                                                  ##\n");        
  printStr("      ######################################################\n\n");  

  printStr("      Enter the base     : ");
  i = readInt(b);
  printStr("      Enter the exponent : ");
  j = readInt(b);
  c = pow(i,j);

  printStr("      The value of result is : ");
  printInt(c);
  printStr("      Testing result - OK\n");
  printStr("\n");
  
  return 0;
}
 