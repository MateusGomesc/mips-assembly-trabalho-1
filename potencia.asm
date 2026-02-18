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
	intro:.asciiz "Os fragmentos serão executados.\n"
	base:.asciiz "Digite a base (inteiro maior ou igual à zero): "
	expoente:.asciiz "Digite o expoente (inteiro maior ou igual à zero): "
	resLin:.asciiz "\nO resultado da exp. LINEAR é: "
	resQuad:.asciiz "\nO resultado da exp. QUADRÁTICA é: "
	
	# Padrão do código:
	# $t0 -> result [inicialmente será igual à 1]
	# $t1 -> base
	# $t2 -> expoente

.text 
	
	li $v0, 4
	la $a0, intro
	syscall
	
	li $v0, 4	
	la $a0, base
	syscall		
	
	# recebe a base do usuário e guarda em $t1
	li $v0, 5	
	syscall		
	move $t1, $v0	
	
	li $v0, 4	
	la $a0, expoente
	syscall		
	
	# recebe o expoente e guarda em $t2
	li $v0, 5	
	syscall
	move $t2, $v0
	
	# guarda os valores de base e expoente para que possam ser utilizados nas duas funções sem risco de alteração
	move $s1, $t1
	move $s2, $t2
	
	jal exponenciacaoLinear
	
	move $t1, $s1
	move $t2, $s2
	
	jal exponenciacaoQuadratica
	
	# encerra o programa
	li $v0, 10
	syscall
	
	
	# FUNÇÕES:
	
	exponenciacaoLinear:
		
		# $t0 recebe o valor inicial de result
		li $t0, 1
		
		whileLin:

			ble $t2, $zero, returnLin # quando o expoente for igual a zero -> return
			mul $t0, $t0, $t1 # result = result * base 
			subi $t2, $t2, 1  
			j whileLin
		
		returnLin:

			li $v0, 4
			la $a0, resLin
			syscall
		
			# resultado
			li $v0, 1
			move $a0, $t0
			syscall
			jr $ra
	
	exponenciacaoQuadratica:
		
		# nessa função, especificamente:
		# $t3 guarda a const. 2
		# $t4 guarda o resto exigido pelo if
		# $t5 guarda a const. 1
		
		# retorna result ao seu valor inicial
		li $t0, 1
		
		# divisor utilizado para o if.
		li $t3, 2
		
		# const. 1 
		li $t5, 1
		
		whileQuad:
			
			beqz $t2, returnQuad          # se n = 0 -> resultado
			
			div $t2, $t3	              # divide n por 2
			mfhi $t4   		      # resto = n % 2
			mflo $t2                      # n = n / 2
			
			bne $t4, $t5, pulaMultIf      # se resto = 1 -> result * base
			mul $t0, $t0, $t1             
		
		pulaMultIf:
			mul $t1, $t1, $t1             # base = base^2
			j whileQuad
			
		returnQuad:
			li $v0, 4
			la $a0, resQuad
			syscall
			 
 			li $v0, 1
			move $a0, $t0
			syscall
			jr $ra
			
