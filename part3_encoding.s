.data
instructions:
    .word 0x007302B3
    .word 0x00A30293
    .word 0x00742423
    .word 0x00208863
    .word 0x123452B7
    .word 0x020000EF

msg1: .string "Opcode: "
msg2: .string " RD: "
msg3: .string " RS1: "
msg4: .string " Funct3: "
nl:   .string "\n"

.text
.globl main

main:
    la t0, instructions
    li t1, 6              # Number of instructions

loop:
    beqz t1, exit

    lw t2, 0(t0)           # Current instruction

    # Opcode = bits [6:0]
    andi t3, t2, 0x7F

    # RD = bits [11:7]
    srli t4, t2, 7
    andi t4, t4, 0x1F

    # Funct3 = bits [14:12]
    srli t5, t2, 12
    andi t5, t5, 0x07

    # RS1 = bits [19:15]
    srli t6, t2, 15
    andi t6, t6, 0x1F

    # Print Opcode
    li a0, 4
    la a1, msg1
    ecall

    li a0, 1
    mv a1, t3
    ecall

    # Print RD
    li a0, 4
    la a1, msg2
    ecall

    li a0, 1
    mv a1, t4
    ecall

    # Print RS1
    li a0, 4
    la a1, msg3
    ecall

    li a0, 1
    mv a1, t6
    ecall

    # Print Funct3
    li a0, 4
    la a1, msg4
    ecall

    li a0, 1
    mv a1, t5
    ecall

    # Newline
    li a0, 4
    la a1, nl
    ecall

    addi t0, t0, 4
    addi t1, t1, -1
    j loop

exit:
    li a0, 10
    ecall