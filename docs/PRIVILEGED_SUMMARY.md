# RISC-V Privileged Architecture Summary

The RISC-V privileged architecture explains how the processor gives different
permissions to different software. This is done using privilege levels so that
not every program can directly access the hardware.

## Privilege Levels

There are three main privilege levels in RISC-V.

Machine Mode (M-mode) is the highest privilege level. It is always present in
every RISC-V processor. The firmware or bootloader usually runs in this mode
because it has full access to the hardware. It can also control interrupts and
exceptions.

Supervisor Mode (S-mode) is mainly used by the operating system kernel. It is
responsible for things like virtual memory and managing system resources. This
mode is optional, so not every RISC-V processor has it.

User Mode (U-mode) is where normal applications run. It has the least
permissions and cannot directly access hardware. This helps improve security
because user programs cannot just change everything in the system.

A simple RISC-V processor, like the one we designed in Module 5, may only
support Machine Mode. A full Linux system normally needs M-mode, S-mode and
U-mode.

## Important CSRs

CSR stands for Control and Status Register. These registers store important
information used by the processor.

- mstatus stores information like the current privilege mode and whether
  interrupts are enabled or disabled.
- mtvec stores the address of the trap handler. Whenever a trap happens, the
  processor jumps to this address.
- mepc stores the address of the instruction that caused the trap so the
  processor knows where to continue later.
- mcause stores the reason why the trap happened. For example, it could be an
  illegal instruction, an ecall or a timer interrupt.
- mtval stores extra information about the trap, such as the address that caused
  a fault. I think it is mainly used when more details about the error are
  needed.

## Trap Handling Flow

The trap handling process is quite simple.

1. The processor detects an exception or interrupt.
2. The hardware automatically saves the current instruction address in mepc and
   the reason for the trap in mcause.
3. The processor jumps to the address stored in mtvec.
4. The trap handler checks mcause and decides what should be done.
5. After finishing, the handler executes the MRET instruction.
6. MRET loads the PC from mepc and the program continues from where it stopped
   before the trap.

Overall, the privileged architecture helps keep the system organized by
separating software into different privilege levels and using CSRs to handle
traps correctly. It also makes the processor more secure because user programs
cannot access everything directly.
