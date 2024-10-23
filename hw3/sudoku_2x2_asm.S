# sudoku_2x2_asm.S

    .text                           # code section
    .global sudoku_2x2_asm          # declare the asm function as a global function
    .type sudoku_2x2_asm, @function # define sum_asm as a function
sudoku_2x2_asm:

    ## add your assembly code here

    addi   sp, sp, -4               # move stack pointer
    sw     ra, 0(sp)                # store return address

    add    a1, a0, x0               # set a1 to a0 (*test_c_data)
    addi   a0, x0, 0                # set a0 to 0
    jal    solve

    lw     ra, 0(sp)                # load return address
    addi   sp, sp, 4                # move stack pointer back
    jr     ra

solve:
    addi   sp, sp, -16              # move stack pointer
    sw     ra, 0(sp)                # store return address

    addi   t0, x0, 16               # store 16 in t0 for compare
    bge    a0, t0, solve_ret_one    # return 1 if index >= 16

    add    t0, a0, a1
    lb     t0, 0(t0)                # get test_c_data[index] in t0
    blt    x0, t0, solve_ret_solve  # recursive call if test_c_data[index] > 0

    addi   t0, x0, 1                # init t0 (i) to 1
    addi   t1, x0, 4                # init t1 to 4 for compare
solve_loop:
    add    t2, a0, a1
    sb     t0, 0(t2)                # test_c_data[index] = i
    sw     a0, 4(sp)                # store a0
    sw     t0, 8(sp)                # store t0
    sw     t1, 12(sp)               # store t1
    jal    check
    beq    a0, x0, solve_check_fail # check return false
    lw     a0, 4(sp)                # load a0
    addi   a0, a0, 1                # increase index
    jal    solve
    bne    a0, x0, solve_ret_one    # return 1 if both are true
solve_check_fail:
    lw     a0, 4(sp)                # load a0
    lw     t0, 8(sp)                # load t0
    lw     t1, 12(sp)               # load t1
    addi   t0, t0, 1                # increase i
    bge    t1, t0, solve_loop       # back to loop if i <= 4

    add    t0, a0, a1
    sb     x0, 0(t0)                # set test_c_data[index] to 0
    j      solve_ret_zero

solve_ret_solve:
    addi   a0, a0, 1                # add index by 1
    jal    solve                    # call solve
    j      solve_done

solve_ret_one:
    addi   a0, x0, 1                # return 1 in a0
    j      solve_done

solve_ret_zero:
	addi   a0, x0, 0                # return 0 in a0

solve_done:
    lw     ra, 0(sp)                # load return address
    addi   sp, sp, 16               # move stack pointer back
    jr     ra

check:
    addi   sp, sp, -4               # move stack pointer
    sw     ra, 0(sp)                # store return address

    srl    t0, a0, 2                # row = index / 4
    andi   t1, a0, 3                # column = index % 4
    add    t2, a0, a1
    lb     t2, 0(t2)                # test_c_data[index]

    addi   t3, x0, 1                # init t3(i) to 1
    addi   t4, x0, 4                # init t4 to 4 for compare
check_loop_1:
    sll    t5, t3, 2                # 4 * i
    add    t5, t5, a0               # index + 4 * i
    andi   t5, t5, 15               # (index + 4 * i) % 16
    add    t5, t5, a1
    lb     t5, 0(t5)                # test_c_data[(index + 4 * i) % 16]
    beq    t5, t2, check_ret_zero
    add    t5, a0, t3               # index + i
    andi   t5, t5, 3                # (index + i) % 4
    sll    t6, t0, 2                # 4 * row
    add    t5, t5, t6               # (index + i) % 4 + 4 * row
    add    t5, t5, a1
    lb     t5, 0(t5)                # test_c_data[(index + i) % 4 + 4 * row]
    beq    t5, t2, check_ret_zero
    addi   t3, t3, 1                # increase i
    blt    t3, t4, check_loop_1     # back to loop if i < 4

    andi   t3, t0, 1                # row % 2
    sub    t0, t0, t3               # start_row = row - row % 2
    andi   t3, t1, 1                # column % 2
    sub    t1, t1, t3               # start_column = column - column % 2

    addi   t3, x0, 0                # init t3(i) to 0
    addi   t5, x0, 2                # init t5 to 2 for compare
check_loop_out:
    addi   t4, x0, 0                # init t4(j) to 0
check_loop_in:
    add    t6, t0, t3               # start_row + i
    sll    t6, t6, 2                # (start_row + i) * 4
    add    t6, t6, t1               # (start_row + i) * 4 + start_column
    add    t6, t6, t4               # (start_row + i) * 4 + start_column + j
    beq    a0, t6, check_fail       # index == id
    add    t6, t6, a1
    lb     t6, 0(t6)                # test_c_data[id]
    beq    t6, t2, check_ret_zero
check_fail:
    addi   t4, t4, 1                # increase j
    blt    t4, t5, check_loop_in    # back to loop if j < 2
    addi   t3, t3, 1                # increase i
    blt    t3, t5, check_loop_out   # back to loop if i < 2

    addi   a0, x0, 1                # return 1 in a0
    j      check_done

check_ret_zero:
	addi   a0, x0, 0                # return 0 in a0

check_done:
    lw     ra, 0(sp)                # load return address
    addi   sp, sp, 4                # move stack pointer back
    jr     ra

    .size sudoku_2x2_asm, .-sudoku_2x2_asm