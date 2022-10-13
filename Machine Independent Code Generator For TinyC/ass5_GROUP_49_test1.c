/* Test File - 1 (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

// declarations ( variables(int, float, char), functions) and arithmetic operations
// global declarations

float f1 = 2.3;
int a = 4;								
int* p;									// pointer declaration
void quotient(int i, float d); 			//function declaration
char c;

void main(){
	int var1 = 120, var2 = 15;
	int i, j, k, l, m, n, o;
	char ch = 'c', d = 'a'; 			// character definitions
	float f2 = 1.25;

	// Arithmetic Operations
	i = var1+var2;
	j = var1-var2;
	k = var1*var2;
	l = var1/var2;
	m = var1%var2;
	n = var1&var2;
	o = var1|var2;
	var2 = i<<2;
	var1 = i>>1;

	return 0;
}