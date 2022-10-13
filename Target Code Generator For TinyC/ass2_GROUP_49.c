/* Library for input/output for tinyC (Compiler Lab) */
/* Group - 49 */
/* Divyansh Bhatia 19CS10027*/
/* Amartya Mandal  19CS10009*/

#include "myl.h"                                                // Including myl.h header file to use its input/output functions
#define BUFF 100                                                // Max length of string allowed including null and end characters.

int printStr(char *ch){                                         // printStr function it inputs strings till the first whitespace or '\0'
    int i = 0;
    for(i = 0; ch[i] != '\0'; i++);

    __asm__ __volatile__ (
        "syscall"                                               // Print char* via syscall
        :
        : "a"(1), "D"(1), "S"(ch), "d"(i)
    );
    return(i);
}

int readInt(int *ep){                                           // function to read int from STDIN and return the read int
    char buff[1];
    char n[20];
    int number = 0;
    int length = 0, i;

    while(1){
        __asm__ __volatile__ (                                  // readIntng inputs one by one from STDIN to buff
            "syscall"
            :
            : "a"(0), "D"(0), "S"(buff), "d"(1)
        );

        if(buff[0] == '\t' || buff [0] == '\n' || buff[0] == ' '){
            break;                                                                          // breaks at the first encounter of whitespace
        }   
        else if(((int) buff[0] - '0' > 9 || (int) buff [0] - '0' < 0) && buff[0] != '-'){
            *ep = 1;                                                                        // only '-' or digits are allowed, else error
        } 
        else{
            n[length++] = buff[0]; 
        }
    }
    if(length > 9 || length == 0){                              // less than 9 bits allowed, keeping in mind the range of int in C
        *ep = 1;
        return 0;
    }
    if(n[0] == '-') {
        if(length == 1) {
            *ep = 1;
            return 0;
        }
        for(i = 1; i < length; i++) {
            if(n[i] == '-') *ep = 1;                            // a number can contain '-' only at the starting of the number
            number *= 10;
            number += (int) n[i] - '0';
        }
        number =- number;
    }
    else{
        for(i = 0; i < length; i++) {
            if(n[i] == '-') *ep = 1;                           // a number can contain '-' only at the starting of the number
            number *= 10;
            number += (int) n[i] - '0';
        }
    }

    return number;                                              // number (integer read) is returned
}

int printInt(int n){                                            // Prints the signed integer (n) with left-alignment
    char buff[BUFF], zero = '0';
    int i = 0, j, k, bytes;

    if(n == 0) buff[i++] = zero;                                // Case when integer is 0
    else{
        if(n < 0){
            buff[i++] = '-';                                    // Case when integer is negative
            n = -n;
        }
        while(n){
            int dig = n%10;
            buff[i++] = (char)(zero + dig);
            n /= 10;
        }
        if(buff[0] == '-') j = 1;                               // Case when integer is negative
        else j = 0;
        k = i - 1;
        while(j < k){
            char temp = buff[j];                                // Reversing buff
            buff[j++] = buff[k];
            buff[k--] = temp;
        }
    } 
    buff[i]= '\n';
    bytes = i + 1;                                              // bytes represent length of string of characters

    __asm__ __volatile__ (                                      // Print char* via syscall
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(bytes)
    ); 

    return bytes;                                               // Returning number of characters printed
}

int readFloat(float *ep){                                       // function to read floats from STDIN into *ep
    char buff[1];
    char n[20];
    float number = 0.0;
    int length = 0, i, flag = 0;

    while (1) {
        __asm__ __volatile__(                                   // readIntng inputs one by one from STDIN to buff
            "syscall"
            :
            : "a"(0), "D"(0), "S"(buff), "d"(1)
        );
        if(buff[0] == '\t' || buff[0] == '\n' || buff[0] == ' '){
            break;                                                              // breaks at the first encounter of whitespace
        } 
        else if(((int) buff[0] - '0' > 9 || (int) buff[0] - '0' < 0) && buff[0] != '-' && buff [0] != '.'){
            return 1;                                           // only '-', '.' or digits are allowed, else error
        } 
        else{
            n[length++] = buff[0]; 
        }
    }

    float mul = 1.0;
    if(length > 12 || length == 0){                             // floating point number is limited to 12 bits to avoid overflow
        *ep = 0.0;
        return 1;
    }

    if(n[0] == '.') return 1;
    if(n[0] == '-'){
        if(length == 1) {
            *ep = 0.0;
            return 1;
        }
        if(n[1] == '.') return 1;
        
        for(i = 1; i < length; i++) {
            if(n[i] == '-') return 1;                           // a floating point number can contain '-' only at the starting of the number
            if(n[i] == '.' && flag == 1) return 1;              // a floating point number can contain '.' only once
            if(n[i] == '.' && flag == 0){
                flag = 1;
                continue;
            }
            if(flag){
                mul *= 10.0;
                number += (float) ((int) n[i] - '0')/mul;
            }
            else{
                number *= 10;
                number += (float) ((int) n[i] - '0');
            }
        }
        number =- number;
    }

    else{
        for(i = 0; i < length; i++) {
            if(n[i] == '-') return 1;                           // a floating point number can contain '-' only at the starting of the number
            if(n[i] == '.' && flag == 1) return 1;              // a floating point number can contain '.' only once
            if(n[i] == '.' && flag == 0) {
                flag = 1;
                continue;
            }
            if(flag){
                mul *= 10.0;
                number += (float) ((int) n[i] - '0')/mul;
            }
            else{
                number *= 10;
                number += (float) ((int) n[i] - '0');
            }
        }
    }
    *ep = number;                                               // The decimal is stored in *ep

    return 0;
}

int printFloat(float f){                                        // function to print floating point number to STDOUT
    char buff[BUFF];
    int i = 0, j, count = 0, k, bytes;
    if(f == 0){ 
        buff[i++] = '0';
    }
    else{
        if(f < 0) {
            buff[i++] = '-';
            f =- f;
        }
        while (f != (int) f) {                                  // checking if the decimal point is reached in our iteration
            f *= 10;
            count++;                                            // stores the distance of the decimal point from right hand side
        }
        int digit = 0;
        int n = (int) f;
        if(count == 0){
            count =- 2;
        }
        while(n){
            if(count == 0) {
                buff[i++] = '.';                                // placing the decimal at its correct locaiton*/
                count =- 2;
            }
            else{
                digit = n%10;
                buff[i++] = (char) (digit + '0');
                n /= 10;
                count--;
            }
        }
        if(buff[0] == '-') j = 1;
        else j = 0;
        k = i - 1;
        char temp;

        while (j < k) {                                         // Reversing buff
            temp = buff[j];
            buff[j++] = buff[k];
            buff[k--] = temp;
        }
    }
    bytes = i;                                                  // bytes represent length of string of characters

    __asm__ __volatile__ (                                      // Print char* via syscall
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff),"d"(bytes)
    );

    return bytes;                                               // Returning number of characters printed
}