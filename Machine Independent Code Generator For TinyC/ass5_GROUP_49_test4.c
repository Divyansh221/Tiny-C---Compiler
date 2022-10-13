/* Test File - 4 (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

// To check typecasting, static and nested blocks

static int varA = 0;              // static
register int varB = 9;            // register
static const int varC = 12;             
extern int varD = 34;             // extern

int fun(int a){               // nested blocks
   int m;
   m = 1;
   {
      int n;
      n = 2;
      {
         int o;
         o = 3;
         {
            int p;
            p = 4;
            {
               int q;
               q = 1<2?1:2;
            }
         }
      }
   }
}

int main(){
   unsigned int u = 2;
   int a = 2, b;
   float f = 8.75;
   double d = 1.125;
   a = f/2;                   // typecasting
   b = fun(a);
   return 0;   
}