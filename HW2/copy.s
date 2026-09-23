	.data
#set up test arrays
A: .asciz "1234"
B: .asciz "0000"
	.text
# for(i=0; i < 100; i += 1){
# 	B[i] = A[i] + 4;}
#s1: i
#s2: &A[0]
#s3: &B[0]

main:
	add s1, x0, x0 #initialize i
	lui s2, x0, 0x10010 #load &A[0]
	add s3, s2, 0x005 #load &B[0] if B is 5 bytes from A (4 chars and a newline)
	
loopstart:	
	lw t0, 0(s2) #load element in A
	addi s1, s1, 0x1 #increment i
	bne s1, 4, loopstart #if i ain't 100 go to loopstart	

