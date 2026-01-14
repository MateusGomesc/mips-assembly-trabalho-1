# Problema 4: Desvendando a Calculadora (Serie de Taylor)
# Autor: Mateus Gomes Costa
.data
	msg1:	.asciiz "atan: "
	msg2:	.asciiz "asen: "
	msg3:	.asciiz "acos: "
	breakline:	.asciiz	"\n"
	const_um:	.float	1.0
	const_dois:	.float	2.0
	k_max:	.word	50
	criterio_erro:	.float	1.0e-7
	x:	.float	0.1
	pi:	.float	3.1415927

.text
.globl main
main:
	la $a0, msg1
	li $v0, 4
	syscall # Imprime a msg1

	l.s $f12, x
	jal atan
	
	mov.s $f12, $f0
	li $v0, 2
	syscall # Imprime atan(x)
	
	la $a0, breakline
	li $v0, 4
	syscall # Quebra a linha
	
	la $a0, msg2
	syscall # Imprime msg2
	
	l.s $f12, x
	jal asen
	
	mov.s $f12, $f0
	li $v0, 2
	syscall # Imprime asen(x)
	
	la $a0, breakline
	li $v0, 4
	syscall # Quebra a linha
	
	la $a0, msg3
	syscall # Imprime a msg3
	
	l.s $f12, x
	jal acos
	
	mov.s $f12, $f0
	li $v0, 2
	syscall # Imprime acos(x)
	
	li $v0, 10
	syscall

# Recebe $f12 = x e retorna $f0 = atan(x)
atan:
	# Zerando os registradores
	mtc1 $0, $f0
	mtc1 $0, $f1
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

# Recebe $f12 = x e retorna $f0 = asen(x)
asen:
	# Zerando os registradores
	mtc1 $0, $f0
	mtc1 $0, $f1
	add.s $f0, $f0, $f12 # $f0 = soma = x
	add.s $f1, $f1, $f12 # $f1 = potencia de x = x
	l.s $f2, const_um # $f2 = coeficiente = 1.0
	l.s $f3, const_um # $f3 = contador de impar = 1.0
	mul.s $f4, $f12, $f12 # $f4 = x^2
	l.s $f5, const_um # $f5 = 1.0
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
	l.s $f18, pi # $f18 = pi
	l.s $f19, const_dois # $f19 = 2.0
	div.s $f18, $f18, $f19 # $f18 = pi / 2
	jal asen
	sub.s $f0, $f18, $f0 # $f0 = pi / 2 - asen(x)
	# Liberando stack frame
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	j fimFunction

fimFunction:
	jr $ra
	
