#include <stdio.h>
#include "myl.h"		// Including myl.h header file to use its input/output functions

int main(){
	int n;
	float f;
	int check;
	char ch;

	printStr("Testing printStr : \n");		// Testing printstr
	printStr("Enter the string of characters : ");
	char str[50];
	scanf("%[^\n]s", str);
	printStr("String : ");
	printStr(str);
	printStr("\n\n");

	printStr("Testing printInt : \n");		// Testing printInt
	printStr("Enter integer : ");
	scanf("%d", &n);
	printStr("Integer = ");
	printInt(n);
	printStr("\n");

	printStr("Testing readInt : \n");			// Testing readInt
	printStr("Enter the integer: ");
	check = readInt(&n);
	if(check == 0){
		printStr("Failure of readInt : ERR Returned\n\n");
		scanf("%c", &ch);
	}
	else{
		printStr("Integer = ");
		printInt(n);
		printStr("\n");
	}

	printStr("Testing printFlt : \n");			// Testing printFlt
	printStr("Enter floating point number : ");
	scanf("%f", &f);
	printStr("Floating point number = ");
	printFlt(f);
	printStr("\n");

	printStr("Testing readFlt : \n");			// Testing readFlt
	printStr("Enter the float: ");
	check = readFlt(&f);
	if(check == 0){
		printStr("Failure of readFlt : ERR Returned\n");
	}
	else{
		printStr("Floating point number = ");
		printFlt(f);	
	}
	return 0;
}