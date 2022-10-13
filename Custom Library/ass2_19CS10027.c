#include "myl.h"				// Including myl.h header file to use its input/output functions

#define BUFF 50					// Max length of string allowed including null and end characters.
#define PRECISION 7				// Precision on how many digits after decimals to follow after decimal.
#define ERR 0
#define OK 1

int printStr(char *s){			// To print a string
    char buff[BUFF];
    int i = 0, bytes;

    while(s[i] != '\0'){
    	buff[i] = s[i];
    	i++;
    }
    buff[i]= '\0';			// String of characters to end with null character
    bytes = i + 1;			// bytes represent length of string of characters

    __asm__ __volatile__ (				// Print char* via syscall
          "movl $1, %%eax \n\t"
          "movq $1, %%rdi \n\t"
          "syscall \n\t"
          :
          :"S"(buff), "d"(bytes)
    );  // $1: write, $:1 on stdin

    return bytes;				// Returning number of characters printed
}

int readInt(int *n){				// Reads a signed integer in %d format
	char buff[BUFF] = {}, zero = '0';
	int i = 0, bytes = 0, flag = 0;

	__asm__ __volatile__ (			// Read char* via syscall
		"movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
		"syscall \n\t"
		:
		:"S"(buff), "d"(BUFF)
	);

	while(buff[bytes] != '\0' && buff[bytes] != '\n'){
		bytes++;
	}
	buff[bytes] = '\0';
	if(buff[0] == '-') i = 1;		// Case when integer is negative
	else i = 0;
	int number = 0;		

	while(i < bytes){			// bytes represent length of string of characters
		char ch = buff[i];
		if(ch >= zero && ch <= zero + 9){
			number = 10*number + (ch - zero);
		}
		else{
			flag = 1;			// Unexpected character
			break;
		}
		i++;
	}
	if(buff[0] == '-'){				// If number is negative, storing negative number in *n 
		*n = -number;
	}
	else *n = number;

	if(flag == 0) return OK;		// Return value is OK (success)
	return ERR;						// Return value is ERR (Failure)
}

int printInt(int n){		// Prints the signed integer (n) with left-alignment
    char buff[BUFF], zero = '0';
    int i = 0, j, k, bytes;

    if(n == 0) buff[i++] = zero;		// Case when integer is 0
    else{
       	if(n < 0) {
          	buff[i++] = '-';		// Case when integer is negative
          	n = -n;
       	}
       	while(n){
          	int dig = n%10;
          	buff[i++] = (char)(zero + dig);
          	n /= 10;
       	}
       	if(buff[0] == '-') j = 1;		// Case when integer is negative
       	else j = 0;
       	k = i - 1;
       	while(j < k){
          	char temp = buff[j];			// Reversing buff
          	buff[j++] = buff[k];
          	buff[k--] = temp;
       	}
    } 
    buff[i]= '\n';
    bytes = i + 1;			// bytes represent length of string of characters

    __asm__ __volatile__ (			// Print char* via syscall
          "movl $1, %%eax \n\t"
          "movq $1, %%rdi \n\t"
          "syscall \n\t"
          :
          :"S"(buff), "d"(bytes)
    );  // $1: write, $:1 on stdin

    return bytes;			// Returning number of characters printed
}

int readFlt(float *f){				// Reads a floating point number in %f format 
	char buff[BUFF] = {}, zero = '0';
	int i = 0, bytes = BUFF, flag1 = 0, flag2 = 0;

	__asm__ __volatile__ (			// Read char* via syscall
		"movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
		"syscall \n\t"
		:
		:"S"(buff), "d"(bytes)
	);
	bytes = 0;
	while(buff[bytes] != '\0' && buff[bytes] != '\n'){
		bytes++;
	}
	buff[bytes] = '\0';
	if(buff[0] == '-') i = 1;		// Case when floating point number is negative
	else i = 0;
	float number = 0.0, decimal = 1.0;		// number represents final floating point number

	while(i < bytes){				// bytes represent length of string of characters
		char ch = buff[i];
		if(ch >= zero && ch <= zero + 9 && flag1 == 0){			// Before decimal
			number = 10*number + (ch - zero);
		}
		else if(ch >= zero && ch <= zero + 9 && flag1 == 1){		// After decimal
			number = number + (ch - zero)*decimal;
			decimal /= 10;
		}
		else if(ch == '.'){
			if(flag1 == 1){			// If more than 1 decimal, ERR to be returned
				flag2 = 1;
				break;
			}
			flag1 = 1;
			decimal /= 10;
		}
		else if(ch == 'e' || ch == 'E'){		//For Scientific notation
			int exp = 0, negative = 0;
			if(buff[++i] == '-'){			//For negative exponent
				negative = 1;
				i++;
			}
			while(i != bytes){
				if(buff[i] >= zero && buff[i] <= zero + 9){
					exp *= 10;
					exp += buff[i] - zero;
				}
				else{					// Unexpected character
					flag2 = 1;
					i = bytes;
					break;
				}
				i++;
			}
			if(negative == 1) exp *= -1;		// For negative exponent
			if(exp < 0){
				while(exp++) number /= 10.0;		// Negative exponent
			}
			else{
				while(exp--){				// Size limit
					if(number > 2e8){
						flag2 = 1;
						i = bytes;
						break;
					}
					number *= 10.0;				// Positive exponent
				}
			}
		}
		else{			// Unexpected character
			flag2 = 1;
			break;
		}
		i++;
	}
	if(buff[0] == '-'){			// If number is negative, storing negative number in *n 
		*f = -number;
	}
	else *f = number;

	if(flag2 == 0) return OK;		// Return value is OK (Success)
	return ERR;						// Return value is ERR (Failure)
}

int printFlt(float f){				// Prints the floating point number (f) with left-alignment
    char buff[BUFF], zero = '0';
    int i = 0, j, k, bytes;

    if(f == 0) buff[i++] = '0';			// Case when floating point number is 0
	else{
		int n = (int) f;		// Integer part of floating point number
		if(n == 0) buff[i++] = '0';
		else{
			if(n < 0){			// Case when floating point number is negative
				buff[i++] = '-';
				n = -n;
				f = -f;
			}
			f = f - (float) n;			// Fraction part of floating point number
			while(n){
				int dig = n%10; 
				buff[i++] = (char)(zero + dig);
				n /= 10;
			}
			if(buff[0] == '-') j = 1;		// Case when floating point number is negative
			else j = 0;
			k = i - 1;
			while(j < k){
				char temp = buff[j];		// Reversing buff
				buff[j++] = buff[k];
				buff[k--] = temp;
			} 
		}
		buff[i++] = '.';
		for(j = 0; j < PRECISION; j++){		// Printing floating point number upto set precision
			f *= 10; 
			int dig = (int) f;
			buff[i++] = (zero + dig);
			f -= (float) dig;
		}
	}
	buff[i] = '\n';
	bytes = i + 1;			// bytes represent length of string of characters

    __asm__ __volatile__ (			// Print char* via syscall
          "movl $1, %%eax \n\t"
          "movq $1, %%rdi \n\t"
          "syscall \n\t"
          :
          :"S"(buff), "d"(bytes)
    );  // $1: write, $:1 on stdin

    return bytes;			// Returning number of characters printed
}