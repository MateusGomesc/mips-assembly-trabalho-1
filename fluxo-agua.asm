#########################################################################################
# Autor: 	Davi Gonçalves Cabeceira
# Data: 	08/01/2026
# Descrição: 	Implementa a matriz e o vetor dado pelo problema , realiza a multiplicação
                matricial e faz o pós processamento.
#########################################################################################




.data


.align 2
B:
    .word -1,-1,0,0,0,0,0
    .word  1,0,-1,-1,0,0,0
    .word  0,1,1,0,-1,-1,0
    .word  0,0,0,1,1,0,-1
    .word  0,0,0,0,0,1,1

.align 2
F:
    .float 100.0, 50.0, 80.0, 80.0, 30.0, 20.0, 10.0



fonte:       .asciiz "Fonte"
sumidouro:   .asciiz "Sumidouro/Acumulador"
equilibrio:  .asciiz "Passagem/Equilibrio"
quebra:      .asciiz "\n"

.text
.globl main

main:
    li $s1, 0          # i
    li $t7, 5          # linhas
    li $t2, 7          # colunas

    la $s2, B
    la $s3, F

loop_externo:   #anda com as linhas
    bge $s1, $t7, fim

    mtc1 $zero, $f4
    li $t0, 0

loop_interno:
    bge $t0, $t2, fim_linha

    # endereço B[i][j]
    mul $t1, $s1, $t2
    add $t1, $t1, $t0
    sll $t1, $t1, 2
    add $t1, $s2, $t1
    lw  $t3, 0($t1)

    # endereço F[j]
    sll $t4, $t0, 2
    add $t4, $s3, $t4
    l.s $f2, 0($t4)

    # Bij * Fj
    mtc1 $t3, $f6
    cvt.s.w $f6, $f6
    mul.s $f6, $f6, $f2
    add.s $f4, $f4, $f6

    addi $t0, $t0, 1
    j loop_interno

fim_linha:
    # imprime valor
    mov.s $f12, $f4
    li $v0, 2
    syscall

    li $v0, 4
    la $a0, quebra
    syscall

    # compara com 0.0
    mtc1 $zero, $f8
    cvt.s.w $f8, $f8

    c.lt.s $f8, $f4
    bc1t eh_sumidouro

    c.lt.s $f4, $f8
    bc1t eh_fonte

    j eh_equilibrio

eh_sumidouro:
    li $v0, 4
    la $a0, sumidouro
    syscall
    j continua

eh_fonte:
    li $v0, 4
    la $a0, fonte
    syscall
    j continua

eh_equilibrio:
    li $v0, 4
    la $a0, equilibrio
    syscall

continua:
    li $v0, 4
    la $a0, quebra
    syscall

    addi $s1, $s1, 1
    j loop_externo

fim:
    li $v0, 10
    syscall


