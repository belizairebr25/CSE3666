#convert c program to assembly
##include <stdio.h>

#int main(){
#        int a;
#        int r;
#        printf("a = ");
#        scanf("%d", &a);
#        printf("r = ");
#        scanf("%d", &r);
#
#        for(int i = 0; i < a; i++){
#                if ((i & 0xA5) != 0){
#                        r ^= i << 8;
#                } else {
#                        r += i >> 4;
#                }
#
#        }
#        printf("\n%d\n", a);
#        printf("%d\n", r);
#       return 0;
#}


	.data
n: .asciz "\n"
	.text
#test vars
#addi s1, x0, 0x5 #a value
#addi s3, x0, 0x6 #r value
main:
	add s2, x0, x0 #i = 0
	loopstart:
		bge s2, s1, cont  # branch to cont if i !< a
		andi t0, s2, 0xA5 #(i & 0xA5)
		beq t0, x0, else  #if prev == 0 skip to else
			slli t1, s2, 0x8 #shift i left 8 bits
			xor s3, s3, t1 #xor prev with r
		else:
			srli t1, s2, 0x4 #shift i right 4 bits
			add s3, s3, t1 #increment r by prev
		addi s2, s2, 0x1 #increment i 
		beq x0, x0, loopstart #return to loop head

cont:
	#print results
#	add a0, x0, s1
#	addi a7, x0, 0x1
#	ecall

#	lui a0, 0x10010
#	addi a7, x0, 0x4
#	ecall

#	add a0, x0, s3
#	addi a7, x0, 0x1
#	ecall

#	lui a0, 0x10010
#	addi a7, x0, 0x4
#	ecall

	#exit program
	add s0, x0, x0
	addi s7, x0, 93
	ecall
		
