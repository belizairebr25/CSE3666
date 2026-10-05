

        # code
        .text
main:   

        # allocate space for array a from the stack
        # the numbers in the array are the location of the queen in each row
        # we can place the queen in row 0 in a different column
        # by changing the immediate in the first instruction below
		
		#Macros
		addi s9, x0, 0x2a # '*' ascii number: 0x2a
		addi s10, x0, 0x2d# '-' ascii number: 0x2d
		addi s11, x0, 8 #boardsize
		
		#Given
		#change this immediate for different row starting position
        addi    s1, x0, 0          # location of the queen in row 0

        addi    sp, sp, -32
        addi    a0, sp, 0           # put a's address in a0

        sw      s1, 0(a0)           # store location of the queen into the array

        addi    a1, x0, 1           # number of queens already placed
        jal     ra, solve_8queens

        beq     x0, x0, exit

# print a string stored in a word array, and a newline
my_puts:
        addi    a7, x0, 11      # system call printing a character 
        addi    t0, a0, 0       # copy a0 to t0, which is the address of the array
mp_loop:
        lw      a0, 0(t0)
        beq     a0, x0, mp_exit
        ecall
        addi    t0, t0, 4
        beq     x0, x0, mp_loop
mp_exit:
        # print newline
        addi    a0, x0, '\n'
        ecall
        jalr    x0, ra, 0

#######################
### put your code here
difference:
	#if i < j return j - i else return i - j
	# do the subtraction
	sub a2, a1, a0 #j - i
	add a4, a2, x0 #store diff
	srli a2, a2, 31 #put msb in lsb
	addi a3, x0, 1 #1
	beq a2, a3, d2 #if subtraction was negative skip
		add a0, a4, x0 #if non-negative return sub
		jalr x0, ra, 0
d2:
	sub a0, a0, a1 # i - j
	jalr x0, ra, 0
	
	#select msb
	#check if negative
	#if negative do other subtraction
	#return
is_valid:
	#check if queen placed threatened
	#stack frame
	addi sp, sp, -32
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw a0, 12(sp) #a
	sw a1, 16(sp) #row
	sw a2, 20(sp) #column
	sw ra, 28(sp)

	add s0, x0, x0 #i = 0
is_valid_lp:
	lw a0, 12(sp) #reload a
    lw a1, 16(sp) # reload row
    lw a2, 20(sp) #reload column
	beq s0, a1, is_valid_exit# whole i < row
		#a[i]
		add s1, s0, x0 # put i in s1
		slli s1, s1, 0x2 #multiply offset by word size
		add s1, s1, a0 # add offset to base
		lw s1, 0(s1)
 
		beq a2, s1, is_valid_false #if column == a[i] skip
			#difference(i, row)
			add a0, s0, x0 # a0 = i
			#a1 is already row
			jal ra, difference
			
			add s2, a0, x0 #save return value in s2
			add a0, s1, x0 #a0 = a[i]
			lw a2, 20(sp) #load column
			add a1, a2, x0 # a1 = column
			jal ra, difference
			
			# if s2 == a0 return 0, else return 1
			beq s2, a0, is_valid_false
				
		#continue loop
		addi s0, s0, 0x1 #i++
		beq x0, x0, is_valid_lp #loopstart

is_valid_false:
	add a0, x0, x0
	beq x0, x0, is_valid_return

is_valid_exit:
	addi a0, x0, 1 #return 1

is_valid_return: 
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw ra, 28(sp)
	lw s2, 8(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

process_solution:
	#stack frame
	addi sp, sp, -64
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw s0, 8(sp)
	sw s1, 12(sp)
	sw s2, 16(sp)
	sw s3, 20(sp)
	sw ra, 24(sp)
	addi s0, sp, 28 #start of 9 word array 'line[]', ends at offset 64
	
	add s1, x0, x0 #i = 0
Lps1:
	beq s1, s11, Lp2 # i == boardsize, skip
		slli s2, s1, 0x2 #multiply i by word size
		add s3, s0, s2 #add offset
		sw s10, 0(s3) # store '-' at line[i]
		addi s1, s1, 0x1 #i++
		beq x0, x0, Lps1 #loopstart

	sw x0, 32(s0) #line[8] = 0
Lp2:
	add s1, x0, x0 #i = 0
Lps2:
	beq s1, s11, Lp3 # i == boardsize, skip
	
		lw t0, 0(sp) #t0 = og a0
		slli t1, s1, 2 #multiply by word size
		add t0, t0, t1 #add offset
		lw t0, 0(t0)

		slli t1, t0, 2 #multiply by word size
		add t1, s0, t1 #add offset
		sw s9, 0(t1) #store '*' in t1
		add s3, t0, x0 #save t0	
		add a0, s0, x0 #pass &line
		jal ra, my_puts

		add t0, s3, x0 #restore t0
		slli t1, t0, 2 #multiply by word size
		add t1, s0, t1 #add offset
		sw s10, 0(t1) #store '-' in line[a[i]]
	
		addi s1, s1, 1 #i++
		beq, x0, x0, Lps2
Lp3:
	add s1, x0, x0 # i = 0
Lps3:
	beq s1, s11, Lps_exit # i == boardsize, skip
		lw t0, 0(sp) #og a
		slli t1, s1, 2 #multiply by word size
		add t0, t0, t1 #add offset
		lw t0, 0(t0) #a[i]

		addi t0, t0, 0x30 # letter 0 + a[i]
		
		slli t1, s1, 2 #multiply by word size
		add t1, s0, t1 #add offset
		sw t0, 0(t1) #line[i] = '0' + a[i]
		
		addi s1, s1, 1 #i++
		beq x0, x0, Lps3

Lps_exit:
	add a0, s0, x0
	jal ra, my_puts #print
	#pop frame
	lw s0, 8(sp)
	lw s1, 12(sp)
	lw s2, 16(sp)
	lw s3, 20(sp)
	lw ra, 24(sp)
	addi sp, sp, 64	
	#no return value
	jalr x0, ra, 0
	
solve_8queens:
	#make stack frame
	addi sp, sp, -32
	#reg dump
	sw s0, 0(sp)
	sw s1, 4(sp)#don't edit s1
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)

	sw ra, 20(sp)
	sw a0, 24(sp)
	sw a1, 28(sp)#k

	#     s1 = location of queen in row, s11 = boardsize
	#pass a and 1 (&a[] := a0 and k := a1) on first iteration
	add s0, x0, x0 #counter
	beq a1, s11, solve_8queens_base #if k == boardsize skip
		#a already in a0
		#k already in a1
	
	# try row k rows 0 .. (k-1) already have a queen
	#j for columns
	add s2, x0, x0 #j = 0
L1s:
	beq s2, s11, solve_8queens_exit #j == boardsize skip to exit
		lw a0, 24(sp) #get og a
		lw a1, 28(sp) #get og k
		add a2, x0, s2 #pass j in a2
		jal ra, is_valid

		addi t0, x0, 0x1 #1
		bne a0, t0, L2 #isvalid != 1
			lw a1, 28(sp) #get og k
			lw a0, 24(sp) #get og a

			slli t1, a1, 0x2 #multiply index by word size
			add t1, a0, t1 #store index + offset
			sw s2, 0(t1) #j = a[k]

			addi a1, a1, 0x1 #k += 1
			jal ra, solve_8queens

			add s0, s0, a0 #add return from recursive call to counter
			bne s0, x0, solve_8queens_exit #if solution found exit 
L2:
	addi s2, s2, 0x1 #j++
	beq x0, x0, L1s #back to loopstart
solve_8queens_base:
	lw a0, 24(sp) #og a
	lw a1, 28(sp) #og k
	jal ra, process_solution

	addi s0, s0, 1 #counter ++
	beq x0, x0, solve_8queens_exit

solve_8queens_exit:
	#return value
	add a0, s0, x0 #counter in return
	
	#pop stack frame
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw ra, 20(sp)
	addi sp, sp, 32
	addi a1, x0, -1 #put all ones in a1 for debugging
	jalr x0, ra, 0

### End of your code
#######################

exit:   





        # no need to do anything here
