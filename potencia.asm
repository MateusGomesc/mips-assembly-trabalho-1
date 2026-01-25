#######################################################
# Autor: Carlos Eduardo Rabelo Rodrigues Pelet
# Data: 19/01/25
# Descrição: 
# 	Fragmentos 1 e 2 relativos à primeira
# 	questão do trabalho. Análise de desempenho do 
# 	algoritmo dado um inteiro grande.
#######################################################

.data 
	
	# dados referentes ao primeiro fragmento do programa
	introLin:.asciiz "O primeiro fragmento será executado.\n"
	baseLin:.asciiz "Digite a base (inteiro maior ou igual à zero): "
	expLin:.asciiz "Digite o expoente (inteiro maior ou igual à zero): "
	resLin:.asciiz "O resultado da operação é: "
	fimLin:.asciiz "O primeiro fragmento foi executado com sucesso."
	
	# dados referentes ao segundo fragmento
	introQuad:.asciiz "\nO segundo fragmento será executado.\n"
	baseQuad:.asciiz "Digite a base (inteiro maior ou igual à zero): "
	expQuad:.asciiz "Digite o expoente (inteiro maior ou igual à zero): "
	resQuad:.asciiz "O resultado é: "
	fimQuad:.asciiz "O segundo fragmento foi executado com sucesso. Fim do programa."
	
	# Padrão a ser seguido no código:
	# $t0 -> result [inicialmente será igual à 1]
	# $t1 -> base
	# $t2 -> expoente

.text 
	
	# $t0 recebe result
	lw $t0, 1
	
	# imprime intro1
	li $v0, 4
	la $a0, introLin
	syscall
	
	# imprime base1
	li $v0, 4	
	la $a0, baseLin	
	syscall		
	
	# recebe o valor do usuário e guarda em $t1
	li $v0, 5	
	syscall		
	move $t1, $v0	
	
	# imprime exp1
	li $v0, 4	
	la $a0, expLin
	syscall		
	
	# recebe o valor e guarda em $t2
	li $v0, 5	
	syscall
	move $t2, $v0
	
	whileLin:

		ble $t2, $zero, returnLin # quando o expoente for igual a zero -> return
		mul $t0, $t0, $t1 # result = result * base 
		subi $t2, $t2, 1  # decrementa o expoente
		j whileLin
		
	returnLin:

		li $v0, 4
		la $a0, resLin
		syscall
		
		# resultado
		li $v0, 1
		move $a0, $t0
		syscall

