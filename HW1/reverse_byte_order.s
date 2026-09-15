#reverse byte order in register s2
#save result in s4

main:
	#test values
	#lui s2, 0xABCDE
	#addi s2, s2, 0x123

	#get last byte and move to front
	lui t3, 0x0000
	addi t3, t3, 0x0FF
	and t3, t3, s2
	slli t3, t3, 0x18

	#get third byte and move to second byte
	addi t2, x0, 0xFF
	slli t2, t2, 0x8
	and t2, t2, s2
	slli t2, t2, 0x8

	#get second byte and move to third byte
	lui t1, 0x00FF0
	addi t1, t1, 0x000
	and t1, t1, s2
	srli t1, t1, 0x8
 
	#get first byte
	lui t0, 0xFF000
	addi t0, t0, 000
	and t0, t0, s2
	srli t0, t0, 0x18
	
	#add t registers and leave result in s4
	add s4, t3, t2
	add s4, s4, t1
	add s4, s4, t0

	#end program
	add a0, x0, x0
	addi a7, x0, 93
	ecall

