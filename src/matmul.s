.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    ble a1, zero, exit_72
    ble a2, zero, exit_72
    ble a4, zero, exit_73
    ble a5, zero, exit_73
	bne a2, a4, exit_74
    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)
    add s0, x0, a0
    add s1, x0, a1
    add s2, x0, a2
    add s3, x0, a3
    add s4, x0, a4
    add s5, x0, a5
    add s6, x0, a6
    
    add t0, x0, x0

outer_loop_start:
    beq t0, s1, outer_loop_end
    add t1, x0, x0

inner_loop_start:
    beq t1, s5, inner_loop_end
    
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    
    add a0, x0, s0
    add a1, x0, s3
    add a2, x0, s2
    addi a3, x0, 1
    add a4, x0, s5 
    jal dot
    sw a0, 0(s6)
    addi s6, s6, 4
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8
    
    addi s3, s3, 4
    
    addi t1, t1, 1
    j inner_loop_start

inner_loop_end:
    addi t2, x0 ,4
    mul t2, t2, s2
    add s0, s0, t2
    
    addi t2, x0, 4
    mul t2, t2, s5
    sub s3, s3, t2
    
    addi t0, t0, 1
    j outer_loop_start



outer_loop_end:


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    
    ret    
exit_72:
    li a1, 72
    j exit2
exit_73:
	li a1, 73
    j exit2
exit_74:
	li a1, 74
    j exit2
