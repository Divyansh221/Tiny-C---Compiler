/* Test File - 3 (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

// Function calling and conditional statements (ternery and if-else)

int min(int x, int y){
   int ans;	
   ans = x>y ? y : x; 						// ternery operator
   return ans;
}

int function(int x, int y){
	int i, j, ans;
	i = min(x,y);							// nested function calls
	j = min(x,i);
	ans = i + j;
	return ans;
}

int main(){
	int age = 19, count = 0;
	int x, y, sum = 0;
	x = 2, y = 5;
	char ch = 'c';
	if(age >= 18){							// if-else statement
		count++;
	}
	else{
			count--;
	}
	int sum = function();					// function calling
	return 0;
}