# Problema 4: Desvendando a Calculadora (Serie de Taylor)
# Autor: Mateus Gomes Costa
.data
	title:	.asciiz	"===== Testes =====\n\n"
	msg1:	.asciiz "atan: "
	msg2:	.asciiz "asen: "
	msg3:	.asciiz "acos: "
	msg4:	.asciiz	"x: "
	msg5:	.asciiz "erro absoluto: "
	breakline:	.asciiz	"\n"
	const_um:	.float	1.0
	const_dois:	.float	2.0
	k_max:	.word	50
	criterio_erro:	.float	1.0e-7
	xs:	.float	0.0, 0.1, 0.5, 0.9, 1.1, -1.1
	esperadosAtan:	.float	0.0, 0.0996687, 0.4636476, 0.7328151, 0.8329813, -0.8329813
	esperadosAsen:	.float	0.0, 0.1001674, 0.5235988, 1.1197695, 0.0, 0.0
	esperadosAcos:	.float	1.5707963, 1.4706289, 1.0471976, 0.4510268, 0.0, 0.0
	size:	.word	6
	pi:	.float	3.1415927

.text
.globl main
main:
	la $a0, title
	li $v0, 4
	syscall
	
	la $t4, xs # $t4 = inicio do array de xs
	la $t7, esperadosAtan # $t7 = inicio do array de esperados da atan
	la $t8, esperadosAsen # $t8 = inicio do array de esperados da asen
	la $t9, esperadosAcos # $t9 = inicio do array de esperados da acos
	xor $t5, $t5, $t5 # $t5 = contador dos arrays = 0
	lw $t6, size # $t6 = 5
loopMain:
	la $a0, msg4
	li $v0, 4
	syscall # Imprime a msg4
	
	l.s $f12, ($t4)
	li $v0, 2
	syscall # Imprime x que sera aplicado
	
	la $a0, breakline
	li $v0, 4
	syscall # Quebra a linha

	la $a0, msg1
	li $v0, 4
	syscall # Imprime a msg1

	jal atan
	
	mov.s $f12, $f0
	li $v0, 2
	syscall # Imprime atan(x)
	
	la $a0, breakline
	li $v0, 4
	syscall # Quebra a linha
	
	la $a0, msg5
	li $v0, 4
	syscall # Imprime msg5
	
	# Calculo do erro para atan
	l.s $f1, ($t7)
	sub.s $f1, $f1, $f0
	abs.s $f1, $f1
	mov.s $f12, $f1
	li $v0, 2
	syscall 
	
	la $a0, breakline
	li $v0, 4
	syscall # Quebra a linha
	
	la $a0, msg2
	syscall # Imprime msg2
	
	l.s $f12, ($t4)
	jal asen
	
	mov.s $f12, $f0
	li $v0, 2
	syscall # Imprime asen(x)
	
	la $a0, breakline
	li $v0, 4
	syscall # Quebra a linha
	
	la $a0, msg5
	li $v0, 4
	syscall # Imprime msg5
	
	# Calculo do erro para asen
	l.s $f1, ($t8)
	sub.s $f1, $f1, $f0
	abs.s $f1, $f1
	mov.s $f12, $f1
	li $v0, 2
	syscall 
	
	la $a0, breakline
	li $v0, 4
	syscall # Quebra a linha
	
	la $a0, msg3
	syscall # Imprime a msg3
	
	l.s $f12, ($t4)
	jal acos
	
	mov.s $f12, $f0
	li $v0, 2
	syscall # Imprime acos(x)
	
	la $a0, breakline
	li $v0, 4
	syscall # Quebra a linha
	
	la $a0, msg5
	li $v0, 4
	syscall # Imprime msg5
	
	# Calculo do erro para acos
	l.s $f1, ($t9)
	sub.s $f1, $f1, $f0
	abs.s $f1, $f1
	mov.s $f12, $f1
	li $v0, 2
	syscall 
	
	la $a0, breakline
	li $v0, 4
	syscall # Quebra a linha
	
	la $a0, breakline
	li $v0, 4
	syscall # Quebra a linha
	
	addiu $t4, $t4, 4 # Incrementa no endereco do array de xs
	addiu $t7, $t7, 4 # Incrementa no endereco do array de esperados da atan
	addiu $t8, $t8, 4 # Incrementa no endereco do array de esperados da asen
	addiu $t9, $t9, 4 # Incrementa no endereco do arrau de esperados da acos
	addiu $t5, $t5, 1 # Incrementa no contador dos arrays
	blt $t5, $t6, loopMain
	
	j fim

# Recebe $f12 = x e retorna $f0 = atan(x)
atan:
	# Zerando os registradores
	mtc1 $0, $f0
	mtc1 $0, $f1
	abs.s $f13, $f12
	l.s $f8, const_um # $f8 = 1.0
	c.lt.s $f8, $f13 # Verifica se modulo de x e maior que 1
	bc1t atanMaiores
	add.s $f0, $f0, $f12 # $f0 = soma = x
	add.s $f1, $f1, $f12 # $f1 = numerador = x
	l.s $f2, const_um # $f2 = denominador = 1.0
	mul.s $f3, $f12, $f12
	neg.s $f3, $f3 # $f3 = -x^2
	l.s $f4, const_dois # $f4 = 2.0
	l.s $f5, criterio_erro # $f5 = 1.0e-7
	la $t0, k_max
	lw $t0, ($t0) # $t0 = 50
	xor $t1, $t1, $t1 # $t0 = k = 0
loopAtan:
	mul.s $f1, $f1, $f3 # Somando as potencias no numerador
	add.s $f2, $f2, $f4 # denominador += 2
	div.s $f6, $f1, $f2 # $f6 = novo termo = numerador / denominador
	abs.s $f7, $f6
	c.lt.s $f7, $f5 # Verifica se novo termo atingiu criterio de aproximacao
	bc1t fimFunction
	beq $t0, $t1, fimFunction # Verifica se k chegou no limite
	add.s $f0, $f0, $f6 # soma += novo termo
	addi $t1, $t1, 1 # k++
	j loopAtan
atanMaiores:
	# Inversão de x
	div.s $f12, $f8, $f12 # $f12 = 1 / x
	add.s $f0, $f0, $f12 # $f0 = soma = 1 / x
	add.s $f1, $f1, $f12 # $f1 = numerador = 1 / x
	l.s $f2, const_um # $f2 = denominador = 1.0
	mul.s $f3, $f12, $f12
	neg.s $f3, $f3 # $f3 = -(1/x)^2
	l.s $f4, const_dois # $f4 = 2.0
	l.s $f8, const_um # $f8 = 1.0
	l.s $f5, criterio_erro # $f5 = 1.0e-7
	la $t0, k_max
	lw $t0, ($t0) # $t0 = 50
	xor $t1, $t1, $t1 # $t0 = k = 0
loopAtanMaiores:
	mul.s $f1, $f1, $f3 # Somando as potencias no numerador
	add.s $f2, $f2, $f4 # denominador += 2
	div.s $f6, $f1, $f2 # $f6 = novo termo = numerador / denominador
	abs.s $f7, $f6
	c.lt.s $f7, $f5 # Verifica se novo termo atingiu criterio de aproximacao
	bc1t atanMaioresFinal
	beq $t0, $t1, atanMaioresFinal # Verifica se k chegou no limite
	add.s $f0, $f0, $f6 # soma += novo termo
	addi $t1, $t1, 1 # k++
	j loopAtanMaiores
atanMaioresFinal:
	l.s $f9, pi # $f9 = pi
	div.s $f9, $f9, $f4 # $f9 = pi / 2
	mtc1 $zero, $f10 # $f10 = 0
	c.lt.s 1, $f12, $f10 # Verifica se (1/x) e menor que 0, pois o sinal na inversao se mantem
	bc1t 1, atanMaioresNegativoFinal
	sub.s $f0, $f9, $f0 # $f0 = (pi / 2) - atan(1 / x)
	j fimFunction
atanMaioresNegativoFinal:
	neg.s $f9, $f9 # $f9 = - (pi / 2)
	sub.s $f0, $f9, $f0 # $f0 = -(pi / 2) - atan(1 / x)
	j fimFunction

# Recebe $f12 = x e retorna $f0 = asen(x)
asen:
	# Zerando os registradores
	mtc1 $0, $f0
	mtc1 $0, $f1
	# Verificacao de dominio
	l.s $f5, const_um # $f5 = 1.0
	abs.s $f13, $f12
	c.le.s $f12, $f5
	bc1f fimFunction
	neg.s $f18, $f5
	c.le.s $f18, $f12
	bc1f fimFunction
	add.s $f0, $f0, $f12 # $f0 = soma = x
	add.s $f1, $f1, $f12 # $f1 = potencia de x = x
	l.s $f2, const_um # $f2 = coeficiente = 1.0
	l.s $f3, const_um # $f3 = contador de impar = 1.0
	mul.s $f4, $f12, $f12 # $f4 = x^2
	l.s $f6, const_dois # $f6 = 2.0
	l.s $f17, criterio_erro # $f17 = 1.0e-7
	la $t0, k_max
	lw $t0, ($t0) # $t0 = 50
	xor $t1, $t1, $t1 # $t1 = contador do k = 0
loopAsen:
	add.s $f7, $f3, $f5 # denominador do coeficiente
	div.s $f8, $f3, $f7 # contador de impar / denominador do coefiente
	mul.s $f2, $f2, $f8 # coeficiente *= novo fator do coeficiente calculado
	mul.s $f1, $f1, $f4 # Aumentando a potencia do numerador x
	add.s $f9, $f3, $f6 # contador de impar += 2
	div.s $f10, $f1, $f9 # Divisão da direita do termo
	mul.s $f11, $f2, $f10 # Novo termo calculado
	abs.s $f16, $f11
	c.lt.s $f16, $f17 # Verifica se o novo termo atingiu o critério de aproximacao
	bc1t fimFunction
	beq $t0, $t1, fimFunction # Verifica se chegou ao k maximo
	add.s $f0, $f0, $f11 # Soma final
	add.s $f3, $f3, $f6 # n += 2
	j loopAsen

# Recebe $f12 = x e retorna $f0 = acos(x)
acos:
	# Manipulando a Stack Frame
	addiu $sp, $sp, -4
	sw $ra, 0($sp) # Guardando o endereco de retorno anterior por ela chamar outra funcao
	jal asen
	# Liberando stack frame
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	l.s $f19, pi # $f19 = pi
	l.s $f6, const_dois # $f16 = 2.0
	div.s $f19, $f19, $f6 # $f19 = pi / 2
	# Verificacao de dominio
	l.s $f5, const_um # $f5 = 1.0
	c.le.s $f12, $f5
	bc1f fimFunction
	neg.s $f6, $f5
	c.le.s $f6, $f12
	bc1f fimFunction
	sub.s $f0, $f19, $f0 # $f0 = pi / 2 - asen(x)
	j fimFunction

fimFunction:
	jr $ra

fim:
	li $v0, 10
	syscall
	
