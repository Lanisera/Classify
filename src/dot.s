.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    addi t1, x0, 1
    bge a2, t1, state1
    addi a1, x0, 75
    jal exit2
state1:
    bge a3, t1, state2
    addi a1, x0, 76
    jal exit2
state2:
    bge a4, t1, state3
    addi a1, x0, 76
    jal exit2
state3:
    add t0, x0, x0
    add t1, x0, x0
    addi t2, x0, 4
    mul a3, a3, t2
    mul a4, a4, t2
loop_start:
    beq t0, a2, loop_end
    lw t2, 0(a0)
    lw t3, 0(a1)
    mul t4, t2, t3
    add t1, t1, t4
    add a0, a0, a3
    add a1, a1, a4
    addi t0, t0, 1
    jal x0, loop_start



loop_end:

    add a0, x0 ,t1
    # Epilogue

    
    ret
