# Addition of decimal strings

# strings are stored in global data section 
        .data   
dst:    .space  128
str1:   .space  128
str2:   .space  128

# instructions are in text section
        .text
main: 
        # load adresses of strings into s1, s2, and s3
        # s3 is dst, where we store the result 

        lui     s3, 0x10010 
        addi    s1, s3, 128
        addi    s2, s1, 128

        # read the first number as a string
        addi    a0, s1, 0
        addi    a1, x0, 100
        addi    a7, x0, 8
        ecall

        # read the second number as a string
        addi    a0, s2, 0
        addi    a1, x0, 100
        addi    a7, x0, 8
        ecall

        #TODO
        # write a loop to find out the number of decimal digits in str1
        # the loop searches for the first character that is less than '0' 
	addi t0, s1, 0 #start of str1
	addi t1, x0, 48 # ascii 0
	addi t3, x0, 0 #i = 0

f_len:
	lbu t2, 0(t0) #load byte
	blt t2, t1, cont1 #skip
	addi t0, t0, 1 #next byte in memory
	addi t3, t3, 1 #i++
	beq x0, x0, f_len 

cont1:
	addi t0, t3, -1 #starting index in t0
	add t1, x0, x0 # carry bit = 0
	addi t6, x0, 10 #carry for 10

	add t2, s3, t3 #destination address
	sb x0, 0(t2) #store null terminator

addl:
	blt t0, x0, exit

	#get str1 digit
	add t2, s1, t0
	lbu t2, 0(t2)
	addi t2, t2, -48 #char to number :3
	
	#get str2 digit
	add t4, s2, t0
	lbu t4, 0(t4)
	addi t4, t4, -48

	#sum
	add t5, t2, t4
	add t5, t5, t1
	
	blt t5, t6, no_carry
	addi t5, t5, -10 #digit = sum - 10
	addi t1, x0, 1 #assign carry
	beq x0, x0, write_digit

no_carry:
	addi t1, x0, 0
write_digit:
	addi t5, t5, 48 #now it's ascii again
	add t2, s3, t0 #dst address
	sb t5, 0(t2) #store byte

	addi t0, t0, -1 #move to next digit
	beq x0, x0, addl

exit:
	addi a0, s3, 0
	addi a7, x0, 4
	ecall

        # Note that we assume str1, str2, and dst have the same number of 
        # decimal digits. 

        # We then write a loop to add str1 and str2, and save the result in 
        # dst. 
        # Remember that dst should have a terminating NULL.

        # find the length
        # do addition
        # print the result

        # exit
        addi    a7, x0, 10
        ecall

