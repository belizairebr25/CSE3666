#       Merge Sort

        .data                   #data segment
        .align 2
#buffer: .space 1024             #allocate space for 256 words
buffer: .words 	
        234,  39, 432, 797, 374, 595, 879, 987, 863, 661,
        679, 933, 359, 443, 849, 778, 345, 782,  75,  42,
        714, 941, 502, 506,  80, 152, 814, 437, 938, 365,
        313,  21, 488, 998, 402, 841, 495, 955, 526, 783,
        964, 534, 695, 883, 559, 754, 133, 519, 895, 754,
         63, 698,  11, 159, 691, 421, 343,  65, 161, 628,
        353, 725, 113, 862, 786, 571, 197, 306, 588, 161,
        160,  18,  71, 934, 685, 816,  92, 130,   8,  33,
        706, 150, 670, 352, 136, 712, 911,  78, 366, 530,
        170, 321, 438, 806, 393, 864, 946, 326, 449, 459,
        632,   3, 290,  15, 757, 606, 131, 916, 821,  76,
         23, 381, 583, 120, 140, 445, 523, 208, 373, 445,
        179, 773, 485, 169, 798, 500, 619, 154, 884, 404,
        111, 440, 606, 888, 564, 794, 736, 950, 734, 352,
        562, 107, 861, 929, 819,  93,  12, 618,  28, 863,
        608,  78, 455, 108, 401, 424,  73, 288, 500, 999,
        714,  69, 784, 315, 581, 136,  38, 763, 120, 975,
        300, 491, 214, 884, 367, 538, 533, 775, 614,  97,
         74,  58, 871,  37, 418, 680, 492, 966, 837, 566,
        202, 743, 540, 658, 267, 974, 669, 451, 986, 760,
        757,  11, 382, 730, 769, 270, 368, 610,  73, 315,
        120, 831, 778, 991, 253, 843, 944,  71, 543, 503,
        474, 339, 600, 884, 469, 715, 429, 193, 252, 996,
        809, 414, 495, 753, 944, 724, 217, 156,  54, 937,
        666, 364, 996, 573, 243, 394,  99, 473, 708, 865,
        931, 218, 108, 640,  74, 629

        .text                   # Code segment
main: 
        # la      s1, buffer    # address of the buffer
        lui     s1, 0x10010     # hard code the address of buffer
        addi    s2, x0, 200     # number of elements, must be 256 or less

        # call init_array() to initialize the array with random values
        # it is not being called
        # uncomment the jal below to actually call the function
        addi    a0, s1, 0
        addi    a1, s2, 0
        # jal     ra, init_array 

        # call merge_sort function with proper arguments
        # we must assume a0 and a1 are changed after calling init_array
        addi    a0, s1, 0
        addi    a1, s2, 0
        jal     ra, merge_sort

        # set a breakpoint here and examine the memory
Exit:   
        addi    a7, x0, 10 
        ecall 

# void init_array(int p[], int n) 
# use pseudorandom numbers to fill out the array
init_array:
        # we use pointers in this function
        # t0 is the starting address and 
        # t1 is the word address right after the array 
        addi    t0, a0, 0
        slli    t1, a1, 2       
        add     t1, t1, t0      # &p[n]

        # set the seed
        addi    a0, x0, 1010
        lui     a1, 0x3666
        addi    a7, x0, 40 
        ecall

        # syscall for rand()
        # 41 on random integer
        # 42 for bounded values. upper bound is in a1. a0 selects the generator
        # a1 and a7 are not changed in the loop
        #lui     a1, 0x100
        addi	a1, x0, 1000
        addi     a7, x0, 42

ia_loop:
        addi    a0, x0, 0
        ecall                  # a1 and a7 are set before the loop
        sw      a0, 0(t0)      # save the random value
        addi    t0, t0, 4      # move to the next word
ia_test:
        bltu    t0, t1, ia_loop 

        jalr    x0, ra, 0
#### End of init_array

####START_OF_MERGE_SORT and helper functions

# array_copy(int dst[], int src[], int n)
array_copy :
	addi	t4, x0, 0       # i = 0
ac_loop:
	bge t4, a2, ac_done
	slli	t0, t4, 2	# t0 = i * 4
	add	t2, t0, a1 	# compute addr of src[i]
	lw	t1, 0(t2)	
	add	t3, t0, a0	# compute addr of dst[i]
	sw	t1, 0(t3)
	addi	t4, t4, 1
	beq x0, x0, ac_loop
ac_done:
	jalr x0, ra, 0
# TODO
# copy array_merge code from lab
# implement msort function 

# array_merge
# merge two sorted arrays
array_merge:

        # initialize 3 indexes
        addi    a5, x0, 0  	# idst
        addi    a6, x0, 0  	# i1
        addi    a7, x0, 0  	# i2
        
        # your code can only change registers a5, a6, a7, and t0 - t6
loop1: 
        # Short-circuit evaluation
        # if i1 >= n1, go to end_loop1
        # if i2 >= n2, go to end_loop2
	bge a6, a2, loop2
	bge a7, a4, loop3
		slli t0, a6, 2 #multiply i1 by 4 for word
		slli t1, a7, 2 #same thing
		add t3, a1, t0 #add index 1 to starting address and store in t0 (w1)
		add t4, a3, t1 #add index 2 to starting address and store in t1 (w2)
		#load values
		lw t5, 0(t3) 
		lw t6, 0(t4)
		bge t5, t6, skip1
			add t2, t5, x0 #wd = w1
			addi a6, a6, 0x1 #i++ 
			beq x0, x0, endl1 #skip to restart loop
skip1:
			add t2, t6, x0 #wd = w2
			addi a7, a7, 0x1 #i++
endl1:
		slli t3, a5, 0x2
		add t3, a0, t3
		sw t2, 0(t3) #store wd in array using index as offset
		addi a5, a5, 0x1 #i++
		beq x0, x0, loop1 #jump to loopstart

loop2:
	#WRITE LOOP 2 and 3
	bge a7, a4, f_exit
	slli t0, a7, 2 #calculate offset
	add t3, a3, t0 #add offset
	lw t5, 0(t3) #load word

	slli t0, a5, 0x2 #destination offset
	add t4, a0, t0 #add offset
	sw t5, 0(t4) #put it away

	addi a7, a7, 1 #i++
	addi a5, a5, 1 #destination ++
	beq x0, x0, loop2
		
loop3:
	bge a6, a2, f_exit
	slli t0, a6, 2 #calculate offset
	add t3, a1, t0 #add offset
	lw t5, 0(t3) #load word
	
	slli t0, a5, 0x2 #dst offset
	add t4, a0, t0 #add offset
	sw t5, 0(t4)

	addi a6, a6, 0x1 #i++
	addi a5, a5, 0x1 #dist++
	beq x0, x0, loop3
        # Do not change the lines below 
f_exit:
        jalr    x0, ra, 0


# void msort(int p[], int n)
merge_sort:
	#check base case
	addi t0, x0, 0x1 #t0 = 1
	bge t0, a1, L1 

	#Stack Frame
	addi sp, sp, -1056 #1024 bytes for array, 32 bytes for reg dump
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw a0, 16(sp)#original p base 
	sw a1, 20(sp)#original n


	#make 1024 byte array 
	addi s0, sp, 32  #store start of array in stack at offset 32
	add s2, a0, x0 #store p in s2
	srli s1, a1, 0x1 #s1 = n//2

	#function calls
	#msort	
	add a0, s2, x0 #pass p
	add a1, s1, x0 #pass n//2
	jal ra, merge_sort

	#msort
	lw t0, 16(sp) #p in t0
	slli t1, s1,0x2 #offset
	add a0, t0, t1 #address of p[n1]
	lw t2, 20(sp) #original n
	sub a1, t2, s1 #n-n1
	jal ra, merge_sort

	#array_merge
	add a0, s0, x0 #start of array
	lw a1, 16(sp) #p
	add a2, s1, x0 #n1
	slli t1, s1, 0x2 #offset
	add a3, a1, t1 #&p[n1]
	lw t2, 20(sp) #og n
	sub a4, t2, s1 #n-n1
	jal ra, array_merge

	lw a0, 16(sp) #p
	add a1, s0, x0 # start of array
	lw a2, 20(sp) #n
	jal ra, array_copy 	
	
	#end	
	#put registers back from stack
	lw ra 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp, 1056 #reset sp

L1:
	jalr x0, ra, 0


