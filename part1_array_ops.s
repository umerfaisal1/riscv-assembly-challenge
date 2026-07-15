.data

msg: .string "Sum: "
array: .word 2 5 -3 10 15 -6 30 -12 9 13 23 -5


.text 

main:

la a0, array

addi, a1, x0, 12

call sum_array

mv s0, a0

# Print "Sum: "
    li a0, 4
    la a1, msg
    ecall

    # Print the sum in a0
    li a0, 1
    mv a1, s0
    ecall

    # Exit
    li a0, 10
    ecall






sum_array:

addi t0, x0, 0 # int i = 0

addi t1, x0, 0 # int sum = 0


loop:
bge t0, a1, end
add t2, t0, x0
slli t2, t2, 2
add t2, t2, a0

lw t3, 0(t2)

add t1, t1, t3

addi t0, t0, 1

j loop

end:

add a0, x0, t1
ret





