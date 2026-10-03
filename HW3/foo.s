#       CSE 3666: HW3
#       Function call

        .data
        .align  2       

buf:    .word                   # 200 words
         -1, -56, -64, -26, -27, -74, -18, -90,  39,  19,
        -74, -64,  78,  85,  59, -71,  80, -63,  70,  86,
         32, -87, -53,  54,  61,  94,  99,   2, -57,  64,
        -96, -33, -57, -89, -61,  40,  49,  41, -87, -67,
         26, -11,  19,   7,   4,  68,  39,  86, -51,  20,
        -33,  99, -70, -66,  -1, -69, -63,   8, -76,  80,
         -4, -99,  21,  35, -83,  34, -62, -95, -38, -86,
         87,  -5,  85,  32,  48,  77,  31,  11, -40, -74,
          7, -57,  68,  -5,  29, -48, -93,  43, -27,  -5,
        -50, -53,  69, -88,  36, -52, -51,  74,  72,  54,
        -84, -85,  39, -54, -51,  59, -63, -24, -63, -25,
         62,  25, -33,  22,  90,   4,  90,  81, -83,  51,
          6, -90,  39,  97, -52,  76, -28,  49,  12,  -4,
         36, -13,  56,  67,  63, -61,  19,  85, -87, -47,
         81,  86,  69, -24, -35,  78, -18, -69,  20,  26,
          5, -34,  80,  82, -26,  92, -32,  88,  88, -41,
        -16, -73, -42,  97,  22,  56, -40,  90,  95, -55,
        -56,  94,  74,  48,  59, -41, -72, -53, -92,  81,
        -33,   4, -25,  36,  44, -17,  87, -91, -31,  89,
        -81,  82, -10,  55, -85, -55,  55,  87,   7,  48,

        # code
        .text
main:   
        # help to check if any saved registers are changed during the function call
        # could add more...
        addi    s0, sp, 0
        addi    s1, x0, -1
        addi    s2, x0, -1
        addi    s3, x0, -1
        addi    s4, x0, -1
        addi    s5, x0, -1
        addi    s6, x0, -1
        addi    s7, x0, -1
        addi    s8, x0, -1
        addi    s9, x0, -1

	# here are a few expected return values:
	#    a1   return value
	#    10   8
	#    50   24
	#   100   52
	#   200   97

        lui     a0, 0x10010     # hard code the address of buf
        addi    a1, x0, 200     # addr of src1 (dst has 256 words)

        jal     ra, foo

exit:   addi    a7, x0, 10 
        ecall

#### start of myabs
#### Although you know t0 and t1 are changed in this implementation,
#### you cannot assume it is always the case
myabs:
        lw      t0, 0(a0)
        addi    t1, x0, 0       # set the default value to 0
        bge     t0, x0, myabs_ret
        sub     t0, x0, t0
        sw      t0, 0(a0)
        addi    t1, x0, 1
myabs_ret:
        addi    a0, t1, 0
        jalr    x0, ra, 0
#### end of myabs

#### Assume you do not know how myabs is implemented
#### and other lines above

#### start of foo
foo: 	
        # TODO
        # Implement foo
        #register dump
        addi sp, sp, -16 #space for 4 saved registers
        	sw s1, 0(sp)
        	sw s2, 4(sp)
        	sw s3, 8(sp)
        	sw s4, 12(sp)
        	
        # s1: count
        # s2: i
		# a0 = d[], a1 = n,
		add s3, a0, x0 #store d[] in s3
		add s4, a1, x0 #store n in s4
		addi sp, sp, -16 # move stack pointer down for ra
		sw ra, 0(sp) #save return address on stack
		add s1, x0, x0 #count = 0
		add s2, x0, x0 #i = 0
L1:
		bge s2, s4, exL1 # if i >= n skip
			slli t5, s2, 0x2 #multiply index by word size
			add a0, s3, t5 #calculate address with index offset
			jal ra, myabs #jump to myabs
			add t5, a0, x0 #put return value in t5
			bge x0, t5, L2 # if t > 0 cont
				addi s1, s1, 0x1 #count++
L2:
		addi s2, s2, 0x1 #i++
		beq x0, x0, L1 #go back
exL1:
		add a0, s1, x0 #put count in value to return
		lw ra 0(sp) #get the return address back
		addi sp, sp, 16 #set sp back to saved registers
		#undump saved registers
			lw s1, 0(sp)
			lw s2, 4(sp)
			lw s3, 8(sp)
			lw s4, 12(sp)
		addi sp, sp, 16 #return sp
		
		jalr x0, ra, 0 #return with no offset







