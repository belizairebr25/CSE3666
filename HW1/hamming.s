lui s0, 0xFFFF0
	
addi s1, x0, 0 # s1 = 0
add t0, x0, s0 # make a copy so s0 is not changed
addi t1, x0, 0x1 #mask

bge t0, x0, loop #if t0 >= 0 skip to loop
addi s1, s1, 0x1 #else add one bc t0 is negative implying leading 1

loop:
	and t2, s0, t1 #extract bit
	beq t2, x0, skip
	addi s1, s1, 1
	
skip:
	slli t1 t1, 0x1
	bne t1, x0, loop
