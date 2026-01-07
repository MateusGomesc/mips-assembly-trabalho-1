.data
   vet:    .word 1,2,3,4,5,6,7,8,9,10
   par:    .space 400
   impar:  .space 400
   size:   .word 10
   
   msgVet:   .asciiz "\nVetor original:\n"
   msgPar:   .asciiz "\nVetor par:\n"
   msgImpar: .asciiz "\nVetor impar:\n"
   espaco:   .asciiz " "
  
   
.text
.globl main

 main:
  #carregamento do size
  lw $t0, size
  
  #inicilização dos contadores
  li $t1, 0
  li $t2, 0
  li $t3, 0
  
  #carregamento dos ponteiros 
  la $s0, vet     #ponteiro para o incio de vet
  la $s1, par     #ponteiro para o inicio do vetor par
  la $s2, impar   #ponteiro para o inicio do vetor impar 
  
 loop:
  #condição de parada
   beq $t1, $t0, fim  
   
  #carregar o vet[i]
  lw $t4, 0($s0) 
  addi $s0, $s0, 4 
  
  #testar se é par
  li $t5, 2                  #divisor = 2
  div $t4,$t5                #divisão do valor atual por 2
  mfhi $t6                   #resto da divisão
  beq $t6, $zero, eh_par     #se o resto der zero, o elem é par 
  j eh_impar
   
 eh_par:
  sw $t4, 0($s1)           #salva no vetor par
  addi $s1, $s1, 4         #avança o ponteiro par 
  addi $t2, $t2, 1         #incrementa o contador de par 
  addi $t1, $t1, 1         #incrementa no indice geral 
  j loop
   
 eh_impar:
  sw $t4, 0($s2)          #salva no vetor impar 
  addi $s2, $s2, 4        #avança o ponteiro impar 
  addi $t3, $t3, 1        #incrementa o contador impar
  addi $t1, $t1, 1        #incrementa na indice geral 
  j loop
  
fim:
# ----------- IMPRIME ORIGINAL -----------
    li $v0,4
    la $a0,msgVet
    syscall

    la $s0, vet
    li $t7,0

print_vet:
    beq $t7, $t0, depois_original

    lw $t4, 0($s0)

    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 4
    la $a0, espaco
    syscall

    addi $s0, $s0, 4
    addi $t7, $t7, 1
    j print_vet

depois_original:


# ----------- IMPRIME PAR -----------
    li $v0,4
    la $a0,msgPar
    syscall

    la $s1, par
    li $t7,0

print_par:
    beq $t7, $t2, depois_par

    lw $t4, 0($s1)

    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 4
    la $a0, espaco
    syscall

    addi $s1, $s1, 4
    addi $t7, $t7, 1
    j print_par

depois_par:


# ----------- IMPRIME IMPAR -----------
    li $v0,4
    la $a0,msgImpar
    syscall

    la $s2, impar
    li $t7,0

print_impar:
    beq $t7, $t3, depois_impar

    lw $t4, 0($s2)

    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 4
    la $a0, espaco
    syscall

    addi $s2, $s2, 4
    addi $t7, $t7, 1
    j print_impar

depois_impar:

    li $v0, 10
    syscall      
