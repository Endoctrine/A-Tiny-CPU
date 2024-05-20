# A Tiny CPU

本项目为一使用 Verilog HDL 实现的 32 位五级流水线 CPU ，支持的指令有：

```
nop, add, sub, and, or, slt, sltu, lui
addi, andi, ori
lb, lh, lw, sb, sh, sw
mult, multu, div, divu, mfhi, mflo, mthi, mtlo
beq, bne, jal, jr,
mfc0, mtc0, eret, syscall
```
