.data

msg_sum: .string "Sum: "
msg_min: .string "Minimum: "
msg_max: .string "Maximum: "
msg_neg: .string "Negative Count: "
array: .word 2 5 -3 10 15 -6 30 -12 9 13 23 -5


.text 

main:

    # ---------------- Sum ----------------
    la a0, array
    addi a1, x0, 12
    call sum_array
    mv s0, a0

    li a0, 4
    la a1, msg_sum
    ecall

    li a0, 1
    mv a1, s0
    ecall

    # Print newline
    li a0, 11
    li a1, 10
    ecall


    # ---------------- Minimum ----------------
    la a0, array
    addi a1, x0, 12
    call find_min
    mv s0, a0

    li a0, 4
    la a1, msg_min
    ecall

    li a0, 1
    mv a1, s0
    ecall

    li a0, 11
    li a1, 10
    ecall


    # ---------------- Maximum ----------------
    la a0, array
    addi a1, x0, 12
    call find_max
    mv s0, a0

    li a0, 4
    la a1, msg_max
    ecall

    li a0, 1
    mv a1, s0
    ecall

    li a0, 11
    li a1, 10
    ecall


    # ---------------- Negative Count ----------------
    la a0, array
    addi a1, x0, 12
    call count_negative
    mv s0, a0

    li a0, 4
    la a1, msg_neg
    ecall

    li a0, 1
    mv a1, s0
    ecall

    li a0, 11
    li a1, 10
    ecall


    # Exit
    li a0, 10
    ecall





sum_array:

addi t0, x0, 0 # int i = 0

addi t1, x0, 0 # int sum = 0


sum_loop:
bge t0, a1, end
add t2, t0, x0
slli t2, t2, 2
add t2, t2, a0

lw t3, 0(t2)

add t1, t1, t3

addi t0, t0, 1

j sum_loop



find_min:

addi t0, x0, 0          # int i = 0

lw t1, 0(a0)            # int min = array[0]

min_loop:
bge t0, a1, end

add t2, t0, x0
slli t2, t2, 2
add t2, t2, a0

lw t3, 0(t2)

bge t3, t1, min_skip
add t1, x0, t3

min_skip:
addi t0, t0, 1



j min_loop


find_max:

addi t0, x0, 0          # int i = 0

lw t1, 0(a0)            # int max = array[0]

max_loop:
bge t0, a1, end

add t2, t0, x0
slli t2, t2, 2
add t2, t2, a0

lw t3, 0(t2)

ble t3, t1, max_skip
add t1, x0, t3

max_skip:
addi t0, t0, 1

j max_loop


count_negative:

addi t0, x0, 0          # int i = 0

addi t1, x0, 0          # int count = 0

count_neg_loop:
bge t0, a1, end

add t2, t0, x0
slli t2, t2, 2
add t2, t2, a0

lw t3, 0(t2)

bge t3, x0, count_neg_skip
addi t1, t1, 1

count_neg_skip:
addi t0, t0, 1


j count_neg_loop



end:

add a0, x0, t1
ret



