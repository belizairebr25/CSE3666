        # code
        .text
main:   

        # allocate space for array a from the stack
        # the numbers in the array are the location of the queen in each row
        # we can place the queen in row 0 in a different column
        # by changing the immediate in the first instruction below

        addi    s1, x0, 0           # location of the queen in row 0

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
solve_8queens: 


### End of your code
#######################

exit:   
        # no need to do anything here
