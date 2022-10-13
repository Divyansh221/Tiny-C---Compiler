/* Test File - 2 (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

// This testfile checks the Loops (while, do-while and for) and arrays (multi-dimensional)
// Function calling testing and ternary operators

int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int x = 0;                                      // global variable

int minimum(int x, int y){
   int ans; 
   ans = x>y ? y : x;                           // ternery operator
   return ans;
}

int main(){
    int i, j, n1, n2, n;
    int a,b;
    int *e;
    int sum = 0;
    int arr1[5];                                // 1D integer array
    int arr2[5][5];                             // 2D integer array
    n = 5, i = 0, j = 100;

    printStr("\n      ######################################################\n");        
    printStr("      ##                                                  ##\n");        
    printStr("      ##             Testing loops and arrays             ##\n");        
    printStr("      ##                                                  ##\n");        
    printStr("      ######################################################\n\n");

    while(i < 5){                               // while loop1
        i++;
        ++j;
        arr1[i] = i*j;
    }

    do{                                         // do-while loop
        sum = sum + arr1[i];
    }while(i < n);

    for(i = 0; i < n; i++){
        for(j = 0; j < n; j++)                  // nested for loop
            arr2[i][j] = sum + i*j;             // multi dimensional array
    }
    printStr("      Sum of all array elements is : ");
    printInt(sum);
    printStr("      Testing result - OK\n");
    
    // Using library functions printStr to print strings 
    printStr("\n      ######################################################\n");        
    printStr("      ##                                                  ##\n");        
    printStr("      ##             Testing function calls               ##\n");        
    printStr("      ##                                                  ##\n");        
    printStr("      ######################################################\n\n");

    b = 3;
    e = &b;

    printStr("      Enter 1st integer : ");
    n1 = readInt(e);
    printStr("      Enter 2nd integer : ");
    n2 = readInt(e);

    n = minimum(n1, n2);
    printStr("      Minimum of the two numbers is : ");
    printInt(n);
    printStr("      Testing result - OK\n");
    printStr("\n");
    return 0;
}