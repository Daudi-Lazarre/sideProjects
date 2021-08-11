#include <stdio.h>

int main()
{
	int accumulator;
	int num2;
	char ASMD;

// Tell the user what to do.
	printf("Hey there, user! Type in all the maths.\n");

// Hold space for the user to enter that math.
	scanf("%i %c %i", &accumulator, &ASMD, &num2);

// Think of switch statements as if statements
// If the user types in a plus operator, print the sum.
	switch(ASMD)
	{
	case '+':
		printf("The sum of your entry is %i.\n", accumulator + num2);
		break;

// If the user types in a minus operator, print the difference.
	case '-':
		printf("The difference of your ");
		printf("entry is %i.\n", accumulator - num2);
		break;

// If the user types in an asterisk, print the product.
	case '*':
		printf("The product of your entry is ");
		printf("%i.\n", accumulator * num2);
		break;

// If the user types in a forward slash, print the quotient.
	case '/':
		printf("The quotient of your entry is ");
		printf("%i.\n", accumulator / num2);
		break;
	}
	return(0);
}
