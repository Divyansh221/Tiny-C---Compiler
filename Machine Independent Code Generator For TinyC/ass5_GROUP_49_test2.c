/* Test File - 2 (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

// Loops (while, do-while and for) and arrays (multi-dimensional)

int x = 0;										// global variable

int main(){
	int i, j, n;
	int sum = 0;
	int arr1[5]; 								// 1D integer array
	int arr2[5][5]; 							// 2D integer array
	n = 5, i = 0, j = 100;

	while(i < 5){								// while loop1
		i++;
		++j;
		arr1[i] = i*j;
	}

	do{ 										// do-while loop
		sum = sum + arr1[i];
	}while(i < n);

	for(i = 0; i < n; i++){
		for(j = 0; j < n; j++)  				// nested for loop
			arr2[i][j] = sum + i*j; 			// multi dimensional array
	}

	return 0;
}