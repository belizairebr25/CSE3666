#collatz conj. program prints stopping time for an input value
#if n is even n=n/2
#if n is odd n=3n+1
	.data
prompt: .asciz "Input n >"
output: .asciz "Stopping time: "

	.text
	#print prompt
	la a0, prompt
	addi a7, x0, 0x4
	ecall
#program goes here
	#print result from s0
	la a0, output
	addi a7, x0, 0x4
	ecall
	add a0, s4, x0
	addi a7, x0, 0x1
	ecall

	#terminate
	add a0, x0, x0
	addi a7, x0, 93
	ecall
main:

