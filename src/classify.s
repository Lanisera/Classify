.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)   # store the row and col of m0 
    sw s4, 20(sp)   # store the m0 matrix           
    sw s5, 24(sp)   # store the row and col of m1
    sw s6, 28(sp)   # store the m1 matrix           
    sw s7, 32(sp)   # store the row and col of input
    sw s8, 36(sp)   # store input matrix
    sw s9, 40(sp)   # the new_0 matrix  row: 0(s3) ,col: 4(s7)
    sw s10, 44(sp)  # the new_1 matrix  row: 0(s5) ,col: 4(s7)
    
    add s0, x0, a0
    add s1, x0, a1
    add s2, x0, a2
    
    # check error 89
    addi t0, x0, 5
    bne t0, s0, exit_command



	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    addi a0, x0, 8
    jal malloc
    beq a0, x0, exit_malloc
    add s3, x0, a0
    lw a0, 4(s1)
    add a1, x0, s3
    add a2, x0, s3
    addi a2, a2, 4
    jal read_matrix
    add s4, x0, a0

    # Load pretrained m1
    addi a0, x0, 8
    jal malloc
    beq a0, x0, exit_malloc
    add s5, x0, a0
    lw a0, 8(s1)
    add a1, x0, s5
    add a2, x0, s5
    addi a2, a2, 4
    jal read_matrix
    add s6, x0, a0

    # Load input matrix
    addi a0, x0, 8
    jal malloc
    beq a0, x0, exit_malloc
    add s7, x0, a0
    lw a0, 12(s1)
    add a1, x0, s7
    add a2, x0, s7
    addi a2, a2, 4
    jal read_matrix
    add s8, x0, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # m0 * input = new_0
    # malloc for new_0
    lw t0, 0(s3)
    lw t1, 4(s7)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exit_malloc
    add s9, x0, a0
    # matmul
    add a0, x0, s4
    lw a1, 0(s3)
    lw a2, 4(s3)
    add a3, x0, s8
    lw a4, 0(s7)
    lw a5, 4(s7)
    add a6, x0, s9
    jal matmul
    
    # ReLU(new_0)
    add a0, x0, s9
    lw t0, 0(s3)
    lw t1, 4(s7)
    mul a1, t0, t1
    jal relu
    
    # m1 * new_0 = new_1
    # malloc for new_1 
    lw t0, 0(s5)
    lw t1, 4(s7)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exit_malloc
    add s10, x0, a0
    # matmul
    add a0, x0, s6
    lw a1, 0(s5)
    lw a2, 4(s5)
    add a3, x0, s9
    lw a4, 0(s3)
    lw a5, 4(s7)
    add a6, x0, s10
    jal matmul
    
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    add a1, x0, s10
    lw a2, 0(s5)
    lw a3, 4(s7)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    add a0, x0, s10    
    lw t0, 0(s5)
    lw t1, 4(s7)
    mul a1, t0, t1
    jal argmax
    add s0, a0, x0
    # Print classification
    bne s2, x0, print_answer
    add a1, x0, s0
    jal print_int


    # Print newline afterwards for clarity
    addi a1, x0, '\n'
    jal print_char
    
print_answer:
    #free all the malloc
    add a0, x0, s3
    jal free
    add a0, x0, s4
    jal free
    add a0, x0, s5
    jal free
    add a0, x0, s6
    jal free
    add a0, x0, s7
    jal free
    add a0, x0, s8
    jal free
    add a0, x0, s9
    jal free
    add a0, x0, s10
    jal free
    
    # save the answer
    add a0, x0, s0
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48
    
    ret
exit_command:
    addi a1, x0, 89
    j exit2
exit_malloc:
    addi a1, x0, 88
    j exit2
