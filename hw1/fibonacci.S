## fibonacci.S
## put input n in register x10 (a0)
## put output fibonacci(n) in register x11 (a1)
## use Venus to test correctness

.text
main:
    ## write assembly code here.
    ## call fibonacci function and get return value.
    addi   a0, x0, 16         # set a0 to 16
    jal    fibonacci          # fibonacci
    j      exit

fibonacci:
    ## fibonacci function
    addi   sp, sp, -8         # move stack pointer
    sw     ra, 0(sp)          # store return address

    beq    a0, x0, ret_zero   # when n = 0, go to ret_zero

    addi   t0, x0, 1          # store 1 in t0 for compare
    beq    a0, t0, ret_one    # when n = 1, go to ret_one

    addi   a0, a0, -1         # otherwise, n > 1, n = n - 1
    sw     a0, 4(sp)          # store a0
    jal    fibonacci

	lw     a0, 4(sp)          # load a0
    sw     a1, 4(sp)          # store return value
    addi   a0, a0, -1         # n = n - 2
    jal    fibonacci
    lw     t0, 4(sp)          # read stored return value to t0
    add    a1, t0, a1         # add 2 return values and store in a1
    j      done

ret_one:
    addi   a1, x0, 1          # return 1 in a1
    j done

ret_zero:
	addi   a1, x0, 0          # return 0 in a1

done:
    lw     ra, 0(sp)          # load return address
    addi   sp, sp, 8          # move stack pointer back
    jr     ra

exit:
	addi   a0, x0, 1
    ecall                     # Terminate