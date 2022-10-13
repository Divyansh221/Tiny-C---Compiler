/* Parser for tinyC (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia */
/* Amartya Mandal */

#include <stdio.h>
#include "y.tab.h"

extern int yyparse();

int main() {
  int i = yyparse();
  printf("++++++++++++ Parser results ++++++++++++\n\n");
  if(i) printf("Failure!\n");
  else printf("Success!\n");
  return 0;
}