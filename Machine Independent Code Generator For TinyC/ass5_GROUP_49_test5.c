/* Test File - 5 (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

// A recursive C++ program to find the nth fibonacci number

int fib(int n){
    if (n <= 1){
        return n;
    }
    return fib(n-1) + fib(n-2);                 // recursion
}
 
int main(){
    int n = 12;
    int* p;
    int ans = 0;
    ans = fib(n);                               // function calling
    return 0;
}