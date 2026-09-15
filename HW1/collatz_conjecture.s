#collatz conj. program prints stopping time for an input value
#if n is even n=n/2
#if n is odd n=3n+1
	.data
prompt: .asciz "Input n >"
output: .asciz "Stopping time: "

	.text
main:
	#print prompt
	lui a0, 0x10010
	addi a7, x0, 0x4
	ecall

#program goes here
	addi a7, x0, 0x5 #get input
	ecall
	add s0, a0, x0 #put input in s0
	add s2, x0, x0 #stopping time
parity:
	#base case check
	addi t0, x0, 0x1 #parity mask
	beq s0, x0, end
	beq s0, t0, end
	#parity check
	and t1, t0, s0 #1 if odd
	beq t1, t0, odd #branch to odd if t1 == 1
even:
	srai s0, s0, 0x1 #divide s0 by 2
	add s2, s2, t0 #increment stopping time
	beq x0, x0, parity
odd:
	slli s1, s0, 0x1 #multiply by 2
	add s0, s1, s0 #add original to multiply by 3
	addi s0, s0, 0x1 #add one
	add s2, s2, t0 #increment stopping time
	beq x0, x0, parity #back to check for next iteration
end:	
	#print result from s0
	lui a0, 0x10010
	addi a0, a0, 0x00A
	addi a7, x0, 0x4
	ecall

	add a0, s2, x0
	addi a7, x0, 0x1
	ecall

	#terminate
	add a0, x0, x0
	addi a7, x0, 93
	ecall


