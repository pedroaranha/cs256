#include <stdio.h>

int main(){
	int sum = 0;
	int done = 0;
	for (int i=0; i<5000; i++)
		if (i % 3 > 0 && i % 5 > 0 && i % 7 > 0){
			sum += i;
			printf("%d\n", i);
		}
	printf("%d\n", sum);
	return 0;
}

//result: 5715723