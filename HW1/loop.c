#include <stdio.h>

int main(){
	int a;
	int r;
	printf("a = ");
	scanf("%d", &a);
	printf("r = ");
	scanf("%d", &r);

	for(int i = 0; i < a; i++){
		if ((i & 0xA5) != 0){
			r ^= i << 8;
		} else {
			r += i >> 4;
		}
	
	}
	printf("\n%d\n", a);
	printf("%d\n", r);
	return 0;
}

