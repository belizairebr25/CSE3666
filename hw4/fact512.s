# factorial

        .text
main:
        # enough space from the stack to save the result
        addi    sp, sp, -256

        addi    a0, sp, 0
        addi    a1, x0, 96      # this is n
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
        addi    t6, zero, 17
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
        addi    t6, zero, 17
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
		sw a0, 4(sp) #r
		sw a1, 8(sp) #a
		sw a2, 12(sp) #b
		sw s0, 16(sp)
		sw s1, 20(sp) 

		add a0, x0, x0 #old_hi = 0
		add s0, x0, x0 #int i
		addi s1, x0, 16 
L1:
		beq s0, s1, L2 #if i == 16 jmp
			lw t0, 8(sp) #t0 = &a
			lw t1, 12(sp) #t1 = b
			slli t2, s0, 2 #multiply i by 4
			add t2, t2, t0 #offset + base address
			lw t2, 0(t2) #get element from a
		 	mulhu t3, t2, t1 #upper a[i] * b
			mul t2, t2, t1 #lower a[i] * b
			add t4, t2, a0 #sum = lo + old_hi
			bgeu t4, a0, LA #if sum < old_hi
				addi t3, t3, 1 #hi++ ie carry
LA:
			add a0, t3, x0 #update old_hi
			lw t0, 4(sp)
			slli t2, s0, 2 # i * 4
			add t2, t2, t0 #add offset
			sw t4, 0(t2) #store sum in r[i]
			addi s0, s0, 1 #i++
		beq, x0, x0, L1 #goto L1
L2:
		lw t0, 4(sp)
		sw a0, 64(t0)			
		lw ra, 0(sp)
		lw s0, 16(sp)
		lw s1, 20(sp)
		addi sp, sp, 32
	
        jalr    x0, ra, 0


# void factorial(unsigned int r[16], unsigned int n)
#
# a0 = r
# a1 = n
factorial:
        # TODO 
        # solutions use three saved registers
        # A total of four registers are saved on stack
		addi sp, sp, -128 
		sw ra, 0(sp)
		sw a0, 4(sp) #r
		sw a1, 8(sp) #n
		sw s0, 12(sp) #i
		sw s1, 16(sp) #n later
		sw x0, 32(sp) # &t
		
		lw a0, 4(sp)#pass r
		jal ra, clear_512

		addi s0, x0, 1
		sw s0, 0(a0) #r[0] = 1
		add s0, s0, s0 #s0 = i = 2
		lw s1, 8(sp) # s1 = n
L3: 
		blt s1, s0, L4 # for i < n
			addi a0, sp, 32 #add sp offset and load &t to t2
			lw a1, 4(sp) #pass r
			add a2, s0, x0 #pass i
			jal ra, mul_512_32 	
			
			lw a0, 4(sp) # pass r
			addi a1, sp, 32 #sp offset for &t 
			jal ra, copy_512		
			
			addi s0, s0, 1 #i++
			beq x0, x0, L3
L4:
		#replace stack
		lw ra, 0(sp)  
		lw s0, 12(sp)
		lw s1, 16(sp)
		addi sp, sp, 128
        jalr    x0, ra, 0

