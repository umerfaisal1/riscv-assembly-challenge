.data
array:      .word 12, -5, 7, 0, 23, -9, 15, 4, 8, -1
size:       .word 10
temp:       .space 40
msg_orig:   .asciiz "Original Array:\n"
msg_sorted: .asciiz "Sorted Array:\n"
space:      .asciiz " "
newline:    .asciiz "\n"

.text
main:
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 4
    la a1, msg_orig
    ecall

    la a0, array
    lw a1, size
    jal print_array

    la a0, array
    li a1, 0
    lw t0, size
    addi a2, t0, -1
    jal merge_sort

    li a0, 4
    la a1, msg_sorted
    ecall

    la a0, array
    lw a1, size
    jal print_array

    lw ra, 0(sp)
    addi sp, sp, 4

    li a0, 10
    ecall

# ---------------------------------------------------------
# print_array(a0 = base address, a1 = count)
# ---------------------------------------------------------
print_array:
    addi sp, sp, -20
    sw ra, 16(sp)
    sw s0, 12(sp)
    sw s1, 8(sp)
    sw s2, 4(sp)
    sw s3, 0(sp)

    mv s0, a0
    mv s1, a1
    li  s2, 0

print_array_loop:
    bge s2, s1, print_array_done

    slli t0, s2, 2
    add  t0, s0, t0
    lw   a1, 0(t0)
    li   a0, 1
    ecall

    li a0, 4
    la a1, space
    ecall

    addi s2, s2, 1
    j print_array_loop

print_array_done:
    li a0, 4
    la a1, newline
    ecall

    lw ra, 16(sp)
    lw s0, 12(sp)
    lw s1, 8(sp)
    lw s2, 4(sp)
    lw s3, 0(sp)
    addi sp, sp, 20
    ret

# ---------------------------------------------------------
# merge_sort(a0 = base, a1 = left, a2 = right)
# ---------------------------------------------------------
merge_sort:
    bge a1, a2, ms_done

    addi sp, sp, -20
    sw ra, 16(sp)
    sw s0, 12(sp)
    sw s1, 8(sp)
    sw s2, 4(sp)
    sw s3, 0(sp)

    mv s0, a0        # base
    mv s1, a1        # left
    mv s2, a2        # right

    add  t0, s1, s2
    srai s3, t0, 1   # mid = (left + right) / 2

    mv a0, s0
    mv a1, s1
    mv a2, s3
    jal merge_sort

    mv a0, s0
    addi a1, s3, 1
    mv a2, s2
    jal merge_sort

    mv a0, s0
    mv a1, s1
    mv a2, s3
    mv a3, s2
    jal merge

    lw ra, 16(sp)
    lw s0, 12(sp)
    lw s1, 8(sp)
    lw s2, 4(sp)
    lw s3, 0(sp)
    addi sp, sp, 20

ms_done:
    ret

# ---------------------------------------------------------
# merge(a0 = base, a1 = left, a2 = mid, a3 = right)
# ---------------------------------------------------------
merge:
    addi sp, sp, -28
    sw ra, 24(sp)
    sw s0, 20(sp)
    sw s1, 16(sp)
    sw s2, 12(sp)
    sw s3, 8(sp)
    sw s4, 4(sp)
    sw s5, 0(sp)

    mv s0, a0        # base
    mv s1, a1        # left
    mv s2, a2        # mid
    mv s3, a3        # right

    mv   s4, s1       # i = left
    addi s5, s2, 1    # j = mid + 1

    la t3, temp       # t3 = temp base (constant scratch, no calls in this function)
    mv t4, s1         # k = left

merge_loop:
    bgt s4, s2, merge_copy_right
    bgt s5, s3, merge_copy_left

    slli t0, s4, 2
    add  t0, s0, t0
    lw   t1, 0(t0)      # array[i]

    slli t2, s5, 2
    add  t2, s0, t2
    lw   t5, 0(t2)      # array[j]

    ble t1, t5, merge_take_left
    j merge_take_right

merge_take_left:
    slli t6, t4, 2
    add  t6, t3, t6
    sw   t1, 0(t6)
    addi s4, s4, 1
    addi t4, t4, 1
    j merge_loop

merge_take_right:
    slli t6, t4, 2
    add  t6, t3, t6
    sw   t5, 0(t6)
    addi s5, s5, 1
    addi t4, t4, 1
    j merge_loop

merge_copy_right:
    bgt s5, s3, merge_combine
    slli t2, s5, 2
    add  t2, s0, t2
    lw   t5, 0(t2)
    slli t6, t4, 2
    add  t6, t3, t6
    sw   t5, 0(t6)
    addi s5, s5, 1
    addi t4, t4, 1
    j merge_copy_right

merge_copy_left:
    bgt s4, s2, merge_combine
    slli t0, s4, 2
    add  t0, s0, t0
    lw   t1, 0(t0)
    slli t6, t4, 2
    add  t6, t3, t6
    sw   t1, 0(t6)
    addi s4, s4, 1
    addi t4, t4, 1
    j merge_copy_left

merge_combine:
    mv t4, s1        # k = left, for copy-back pass

merge_copy_back:
    bgt t4, s3, merge_done
    slli t6, t4, 2
    add  t6, t3, t6
    lw   t1, 0(t6)      # temp[k]
    slli t0, t4, 2
    add  t0, s0, t0
    sw   t1, 0(t0)      # array[k] = temp[k]
    addi t4, t4, 1
    j merge_copy_back

merge_done:
    lw ra, 24(sp)
    lw s0, 20(sp)
    lw s1, 16(sp)
    lw s2, 12(sp)
    lw s3, 8(sp)
    lw s4, 4(sp)
    lw s5, 0(sp)
    addi sp, sp, 28
    ret