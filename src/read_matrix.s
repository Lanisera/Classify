.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
	sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)   
    sw s4, 16(sp)   
    sw ra, 20(sp)
    sw s5, 24(sp)
    
    add s0, x0, a0
    add s1, x0, a1
    add s2, x0, a2

    # fopen
    add a1, x0, s0
    add a2, x0, x0
    jal fopen
    addi t0, x0, -1
    beq a0, t0, exit_90
    add s3, x0, a0
    
    # get row and col
    # row
    add a1, x0, s3
    add a2, x0, s1
    addi a3, x0, 4
    jal fread
    addi t0, x0, 4
    bne a0, t0, exit_91
    #col
    add a1, x0, s3
    add a2, x0, s2
    addi a3, x0, 4
    jal fread
    addi t0, x0, 4
    bne a0, t0, exit_91
    
    lw s1, 0(s1)    # get num of row
    lw s2, 0(s2)    # get num of col

    # malloc the matrix
    # malloc
    mul s5, s1, s2
    addi t0, x0, 4
    mul s5, s5, t0
    add a0, x0, s5
    jal malloc
    beq a0, x0, exit_88
    add s4, x0, a0
    # get the value 
    add a1, x0, s3
    add a2, x0, s4
    add a3, x0, s5
    ebreak
    jal fread
    bne a0, s5, exit_91
    
    # fclose
    add a1, x0, s3
    jal fclose
    bne a0, x0, exit_92
    
    add a0, x0, s4
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    
    ret
exit_88:
    addi a1, x0, 88
    j exit2
exit_90:
    addi a1, x0, 90
    j exit2
exit_91:
    addi a1, x0, 91
    j exit2
exit_92:
    addi a1, x0, 92
    j exit2
