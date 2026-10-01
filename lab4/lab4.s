#       CSE 3666 Lab 4
#	TAG: EEE007ACD8D766FC885C6393268

	.data
	.align	2	
word_array:     .word
        0,   10,   20,  30,  40,  50,  60,  70,  80,  90, 
        100, 110, 120, 130, 140, 150, 160, 170, 180, 190,
        200, 210, 220, 230, 240, 250, 260, 270, 280, 290,
        300, 310, 320, 330, 340, 350, 360, 370, 380, 390,
        400, 410, 420, 430, 440, 450, 460, 470, 480, 490,
        500, 510, 520, 530, 540, 550, 560, 570, 580, 590,
        600, 610, 620, 630, 640, 650, 660, 670, 680, 690,
        700, 710, 720, 730, 740, 750, 760, 770, 780, 790,
        800, 810, 820, 830, 840, 850, 860, 870, 880, 890,
        900, 910, 920, 930, 940, 950, 960, 970, 980, 990

        # code
        .text
main:   
        # s1, s2, and s3 are set later
	addi	s0, sp, 0
	addi	s4, x0, -4
	addi	s5, x0, -5
	addi	s6, x0, -6
	addi	s7, x0, -7
	addi	s8, x0, -8
	addi	s9, x0, -9
	addi	s10, x0, -20
	addi	s11, x0, -25

        lui     s1, 0x10010      # starting addr of word_array in standard memory config
        addi    s2, x0, 100      # 100 elements in the array

        # read an integer from the console
        addi    a7, x0, 5
        ecall

        addi    s3, a0, 0       # keep a copy of v in s3
        
        # call binary search
        addi	a0, s1, 0
        addi	a1, s2, 0
        addi	a2, s3, 0
        jal	ra, binary_search

		#addi a7, x0, 1
		#ecall

exit:   addi    a7, x0, 10      
        ecall

#### Do not change lines above
binary_search:
		#pass a[] (&word_array ie a0), n (len[word_array ie a1), v (target value ie a2)
        # TODO
		#t0 = rv, t1 = half, t2 = half_index, t5= half offset t3 = left
		addi sp, sp, -16 #allocate space on the stack
		sw ra, 0(sp) #store return address on the stack
				
con0:
		bne a1, x0, con1 # if (n==0)
			addi a0, x0, -1 # rv = -1
			beq x0, x0, f_exit
con1:	
		#get middle element
		add t1, a1, x0 #t1 = n
		srli t1, t1, 0x1 # half /= 2
		slli t5, t1, 0x2 #multiply to get offset
		add t2, a0, t5 #add offset 
		lw t2, 0(t2) #get middle element and store in t2
		
		bne t2, a2, con2 #if half_v == v
			add t0, t1, x0 # rv = half
			add a0, t1, x0 #return value in a0
			beq x0, x0, f_exit	
con2:								
		bge a2, t2, con3 # if v < half_v
			add a1, t1, x0 #half in a1
			jal ra, binary_search
			beq x0, x0, f_exit
con3:
		addi t3, t1, 0x1 #left = half + 1(index)
		sw t3, 4(sp) #save left on the stack
		slli t5, t3, 0x2 #multiply ofsett by bytes in word
		add a0, a0, t5 #&a[left]
		sub a1, a1, t3 #n -= left
		
		jal ra, binary_search
		blt a0, x0, f_exit
			lw t3, 4(sp) #restore left
			add a0, a0, t3 # add offset
			add t0, a0, x0 #rv = return value
		
			
		
f_exit:
		lw ra, 0(sp) #bring original return address back
		addi sp, sp, 16 #bring sack pointer back to unwind recursion
		jalr x0, ra, 0 #return rv







