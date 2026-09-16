#include <stdio.h>
int d;
int q;
int r; //n

int main(){
	q = 0;
	scanf("%d", &r);
	scanf("%d", &d);
	//divide
	d <<= 16;
	for(int i = 0; i < 16; i++){
		d >>= 1; //shift d right one bit
		q <<= 1; //shift q left one bit
		if(r >= d){
			r -= d;
			q |= 1;
		}
	}
	printf("%d", q);
	return 0;
}
