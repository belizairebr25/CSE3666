#for i in range(16):
#	for j in range(8):
#		T[i][j] = (256 * i) + j
#
#for i in range(16):
#	for j in range(8):
#		D[j][i] = T[i][j]

	.data
	.align 2
	#reserve 512 bytes in data segment for each 2d array
T:	.space 512
D: 	.space 512

	.text
main:
	lui s1, 0x10010 #hard code address of T
	addi s2, s1, 512 #addr of D

	addi t1, x0, 0 #i=0
f_loop_i1:
	beq t1, 16, cont1
	addi t2, x0, 0 #j=0
f_loop_j1:
	beq t2, 8, next_i1
	#value to put in cell
	slli t3, t1, 8 #i*256
	add t3, t3, t2 #add j

	#cell address
	slli t4, t1, 3 #i * 8
	add t4, t4, t2 # add j
	slli t4, t4, 2 #multiply by 4
	add t4, s1, t4 #final memory address

	sw t3, 0(t4) #store value in memory
	
	addi t2, t2, 1 # increment j
next_i1:
	addi t1, t1, 1 # increment i
	beq x0, x0, f_loop_i1

cont1:	
	addi a1, x0, 16 #number of rows
	addi a2, x0, 8 #number of columns
	addi t1, x0, 0 #i=0
	
	#print t
	addi a0, s1, 0
	addi a1, x0, 16
	addi a2, x0, 8
	jal print_array

	add t1, 
f_loop_i2:
	beq t1, 16, cont2
	
	addi a1, x0, 16
	addi a2, x0, 8
	addi t1, x0, 0 #i = 0

	#print D and exit
	addi a0, s2, 0
	addi a1, x0, 8
	addi a2, x0, 16
	jal print_array


exit: 
	addi a7, x0, 10
	ecall

	#print array
print_array:
	addi t0, a0, 0 #the pointer
	addi t1, x0, 0 # i = 0

f_loop_i:
	addi t2, x0, 0 #j = 0;
f_loop_j:
	lw a0, 0(t0)
	addi a7, x0, 34 # 34 for hex
	ecall

	addi a0, x0, ' ' # seperate words
	addi a7, x0, 11
	ecall

	addi t0, t0, 4 # move to next word
	
	addi t2, t2, 1
	blt t2, a2, f_loop_j
	
	addi a0, x0, '\n'
	addi a7, x0, 11
	ecall

	addi t1, t1, 1
	blt t1, a1, f_loop_i

f_ret:
	jalr x0, ra, 0
