#	CSE 3666 Lab 2 DIVU
#	TAG: 7e565c9c03f7747a2688
	.text
main:
	#get input for n(numerator)
	addi a7, x0, 0x5
	ecall
	add s0, a0, x0 #put n=r value in s0
	
	#get input for d(denominator)
	addi a7, x0, 0x5
	ecall 
	add s1, a0, x0 #put d value in s1

	slli s1, s1, 0x10 # shift denominator left 16 bits
	add s2, x0, x0 #initialize quotient with 0
	add t0, x0, x0 #initialize i to 0
	addi t2, x0, 0x10 #loop end condition
loopstart:
	bge t0, t2, cont #if i >= 16 skip to cont
		addi t0, t0, 0x1 #increment i
		srli s1, s1, 0x1 #shift d right one bit
		slli s2, s2, 0x1 #shift quotient left one bit
		bltu s0, s1, loopstart #if r !>= d goto loopstart
			sub s0, s0, s1 # r -= d
			ori s2, s2, 0x1 # q |= 1
	beq x0, x0, loopstart #return to loopstart
			
cont:
	#print value
	add a0, s2, x0 #put quotient a0
	addi a7, x0, 0x1
	ecall

	#newline
	addi a0, x0, 0xA
        addi a7, x0, 0xB
        ecall

	#remainder
	add a0, s0, x0 #put remainder in a0
	addi a7, x0, 0x1
	ecall

	#newline
	addi a0, x0, 0xA
        addi a7, x0, 0xB
        ecall

	#exit
	add a0, x0, x0
	addi a7, x0, 10
	ecall
	

