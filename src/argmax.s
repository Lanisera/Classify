.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1, 
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi t1, x0, 1
    bge a1, t1, judge
    addi a1, x0, 77
    jal exit2
judge:
    addi t0, x0, 1
    lw t1, 0(a0)
    add t3, x0, x0
    addi a0, a0, 4

loop_start: 
    beq a1, t0, loop_end
    lw t2, 0(a0)
    bge t1, t2, loop_continue
    add t1, x0, t2
    add t3, x0, t0
loop_continue:
    addi t0, t0, 1
    addi a0, a0, 4
    jal x0, loop_start
loop_end:
    
    add a0, x0, t3
    # Epilogue


    ret
