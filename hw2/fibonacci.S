## fibonacci.S

    .text                          # code section 
    .global fibonacci_asm          # declar the sum_asm function as a  global function
    .type fibonacci_asm, @function # define sum_asm as a function 
fibonacci_asm:

    # Write your assembly code funtion here.
    # Please notice the rules of calling convention.
    
    addi   sp, sp, -8         # move stack pointer
    sw     ra, 0(sp)          # store return address

    beq    a0, x0, ret_zero   # when n = 0, go to ret_zero

    addi   t0, x0, 1          # store 1 in t0 for compare
    beq    a0, t0, ret_one    # when n = 1, go to ret_one

    addi   a0, a0, -1         # otherwise, n > 1, n = n - 1
    sw     a0, 4(sp)          # store a0
    jal    fibonacci_asm

    add    t0, a0, x0         # store return value in t0
	lw     a0, 4(sp)          # load a0 back
    sw     t0, 4(sp)          # store return value

    addi   a0, a0, -1         # n = n - 2
    jal    fibonacci_asm
    lw     t0, 4(sp)          # read stored return value to t0
    add    a0, t0, a0         # add 2 return values and store in a0
    j      done

ret_one:
    addi   a0, x0, 1          # return 1 in a0
    j done

ret_zero:
	addi   a0, x0, 0          # return 0 in a0

done:
    lw     ra, 0(sp)          # load return address
    addi   sp, sp, 8          # move stack pointer back
    jr     ra

    .size fibonacci_asm, .-fibonacci_asm