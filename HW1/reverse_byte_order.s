#reverse byte order in register s2
#save result in s4

main:
	#get last byte and move to front
	andi t3, s2, 0x000000FF
	slli t3, t3, 0x6
	#get third byte and move to second byte
	andi t2, s2, 0x0000FF00
	slli t2, t2, 0x2
	#get second byte and move to third byte
	andi t1, s2, 0x00FF0000
	srli t1, t1, 0x2 
	#get first byte
	andi t0, s2, 0xFF000000
	srli t0, t0, 0x6
	
	#add t registers and leave result in s4
	add s4, t3, t2
	add s4, s4, t1
	add s4, s4, t0
	#end program
	addi a0, x0, x0
	addi a7, x0, 93
	ecall

