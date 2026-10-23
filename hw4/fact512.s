# factorial

        .text
main:
        # enough space from the stack to save the result
        addi    sp, sp, -256

        addi    a0, sp, 0
        addi    a1, x0, 94      # this is n
        jal     ra, factorial

        addi    a0, sp, 0
        jal     ra, print_512

        addi    a7, x0, 10
        ecall

# print a large number
print_512:
        addi    a1, a0, 0

        # from i = 15 to 0 
        addi    t5, zero, 15
print_loop:
        slli    t0, t5, 2
        add     t0, t0, a1
        lw      a0, 0(t0)

        addi    a7, zero, 34
        ecall

        addi    a0, zero, ' '
        addi    a7, zero, 11
        ecall

        addi    t5, t5, -1
        bge     t5, zero, print_loop

        addi    a0, zero, '\n'
        addi    a7, zero, 11
        ecall

        jalr    x0, ra, 0

### 
# void clear_512(unsigned int r[16])
# a0 = r

clear_512:
        addi    t5, zero, 0
        addi    t6, zero, 16
clear_loop:
        slli    t0, t5, 2
        add     t0, t0, a0
        sw      zero, 0(t0)
        addi    t5, t5, 1
        bne     t5, t6, clear_loop
        jalr    x0, ra, 0

# void copy_512(unsigned int r[16], unsigned int a[16])
# a0 = r
# a1 = a
copy_512:
        addi    t5, zero, 0     # i
        addi    t6, zero, 16
copy_loop:
        slli    t2, t5, 2       # offset
        add     t1, t2, a1      # &a[i]
        lw      t3, 0(t1)
        add     t0, t2, a0      # &r[i]
        sw      t3, 0(t0)
        addi    t5, t5, 1
        bne     t5, t6, copy_loop
        jalr    x0, ra, 0

# void mul_512_32(unsigned int r[17],
#                 unsigned int a[16],
#                 unsigned int b)
#
# a0 = r
# a1 = a
# a2 = b
mul_512_32:
        # TODO
		addi sp, sp, -32 #move sp 32 bytes
		sw ra, 0(sp)
		sw a0, 4(sp)
		sw a1, 8(sp)
		sw a2, 12(sp)
		sw s0, 16(sp)
		sw s1, 20(sp)

		add a0, x0, x0 #old_hi = 0
		add s0, x0, x0 #int i
		add s1, x0, 16 
L1:
		beq s0, s1, L2 #if i == 16 jmp
			lw t0, 12(sp) #t0 = &a
			lw t1, 16(sp) #t1 = b
			slli t2, s0, 2 #multiply i by 4
			add t2, t2, t0 #offset + base address
			lw t2, 0(t2) #get element from a
		 	mulhu t2, t2, t1 #multiply half unsigned b and a[i]
			
		
	
        jalr    x0, ra, 0


# void factorial(unsigned int r[16], unsigned int n)
#
# a0 = r
# a1 = n
factorial:
        # TODO 
        # solutions use three saved registers
        # A total of four registers are saved on stack
        # the local array is also placed on stack  

        jalr    x0, ra, 0

