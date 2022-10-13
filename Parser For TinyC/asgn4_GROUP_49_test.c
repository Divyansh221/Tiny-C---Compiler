/* Parser for tinyC (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia */
/* Amartya Mandal */

static varA = 0;
register varB = 9;
static varC = 12;
extern varD = 34;

enum week{ MON, TUE, WED, THU, FRI, SAT, SUN};

int main()
{
   int a = 1, b = 2, c = 3;
   a++;
   b--;
   b = ++a;
   b = a++;
   a = b--;
   a = --b;
   a = b & 1;
   a = a | 1;
   a = a ^ 2;
   a = !a;
   a = a * c;
   a = a / b;
   a = a + b;
   a = a % 3;
   a += 2;
   b -= 3;
   c *= d;
   c /= 5;
   c %= 1;
   c <<= 2;
   c >>= z;
   c &= 2;
   c |= 1;
   c ^= 0;

   float f = 0.025;
   double d = 0.0125;
   char ch = 'A';

   f += 2.000;
   ch++;

   enum week day;

   char y;
   scanf("%c", &y);

   switch(y){
      case 'A':
         day = MON;
         break;

      case 'B':
         day = TUE;
         break;

      case 'C':
         day = WED;
         break;

      case 'D':
         day = THU;
         break;

      case 'E':
         day = FRI;
         break;

      case 'F':
         day = SAT;
         break;

      case 'G':
         day = SUN;
         break;
   }

   int first, last, middle, search, array[100];
   unsigned int n;
 
   printf("Enter number of elements\n");
   scanf("%d",&n);

   int n1 = sizeof(n);
 
   printf("Enter %d integers\n", n);
 
   for (c = 0; c < n; c++)
      scanf("%d",&array[c]);
 
   printf("Enter value to find\n");
   scanf("%d", &search);
 
   first = 0;
   last = n - 1;
   middle = (first+last)/2;
 
   while (first <= last) {
      if (array[middle] < search)
         first = middle + 1;    
      else if (array[middle] == search) {
         printf("%d found at location %d.\n", search, middle+1);
         break;
      }
      else
         last = middle - 1;
 
      middle = (first + last)/2;
   }
   if (first > last)
      printf("Not found! %d isn't present in the list.\n", search);
 
   return 0;   
}