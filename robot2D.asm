#################################################################################
# Autor: 	Leonardo Pereira da Silva
# Data: 	15/01/2026
# Descrição: 	Implementa o cálculo da cinemática inversa de um robô 2D (θ1, θ2)
#		a partir das entradas Px, Py, L1 e L2
#		 - Px e Py: coordenadas X e Y desejadas do end-effector
#		 - L1 e L2: comprimentos do segmento do braço do robô
#################################################################################

.data
msg0:   .asciiz "############################################\n#   - Controlador de Braço Robótico 2D -   #\n############################################\n"
msg1:   .asciiz "Entre com o valor de Px: "
msg2:   .asciiz "Entre com o valor de Py: "
msg3:   .asciiz "Entre com o valor de L1: "
msg4:   .asciiz "Entre com o valor de L2: "
msg5:   .asciiz "\nValores calculados:\n D: "
msg6:   .asciiz "\nPonto Inalcaçável - Muito longe.\n - Tente Novamenrte - \n"
msg7:   .asciiz "\nPonto Inalcaçável - Muito perto.\n - Tente Novamenrte - \n"
msg8:   .asciiz "\n Cos(Teta2): "
msg9:   .asciiz "\n Cos(Phi): "
msg10:  .asciiz "\n Tan(Beta)/2: "
msg12:  .asciiz "\n Phi [rad]: "
msg13:  .asciiz "\n Beta [rad]: "
msg14:  .asciiz "\n Teta1 [deg]: "
msg15:  .asciiz "\n Teta2 [deg]: "

fUm:    .float 1.0
fZero:  .float 0.0
fDois:  .float 2.0
fPIDeg: .float 180.0
pi:	.float	3.1415927

const_um:	.float	1.0
const_dois:	.float	2.0
k_max:		.word	50
criterio_erro:	.float	1.0e-7

.text
main:
   # Register Mapping:	L1: $f20,	L2: $f21,   	Px: $f22,   	Py: $f23,  
   #			D: $f24,	Cos(θ2): $f25, 	Cos(ϕ): $f26	Tan(β)/2: $f27
   #					θ2: $f28	ϕ: $f29		β: $f30		θ1: $f31
   
   # Imprime cabeçalho
   li $v0, 4
   la $a0, msg0
   syscall
   
   #####################################################
   # Leitura das entradas (L1 e L2)
   # Imprime string (solicita L1)
   li $v0, 4
   la $a0, msg3
   syscall
   
   # Lê float (L1 em $f20)
   li $v0, 6
   syscall
   mov.s $f20, $f0
   
   # print string (solicita L2)
   li $v0, 4
   la $a0, msg4
   syscall
 
   # read float (L2 em $f21)
   li $v0, 6
   syscall
   mov.s $f21, $f0
   
   inicio:
   # Leitura das entradas (Px e Py)
   # Imprime string (solicita Px)
   li $v0, 4
   la $a0, msg1
   syscall
   
   # Lê float (Px em $f22)
   li $v0, 6
   syscall
   mov.s $f22, $f0
   
   # print string (solicita Py)
   li $v0, 4
   la $a0, msg2
   syscall
 
   # read float (Py em $f23)
   li $v0, 6
   syscall
   mov.s $f23, $f0

   ##################################################
   # Calcula e Verifica D
   
   # Calcula D
   # Define Argumentos para chamar a funcao calcula D
   mov.s $f12, $f22		# Px em $f12
   mov.s $f13, $f23		# Py em $f13
   jal calculaD
   mov.s $f24, $f0		# Preserva resultado (D) em $f24

   # print float (valor de D)
   li $v0, 4
   la $a0, msg5
   syscall
   mov.s $f12, $f24
   li $v0, 2
   syscall
   
   # Verifica D
   # Define Argumentos para chamar a funcao verifica D
   mov.s $f12, $f20		# L1 em $f12
   mov.s $f13, $f21		# L2 em $f13
   mov.s $f14, $f24		# D em $f14
   jal verificaD

   ##################################################
   # Calcula Cos(Teta2)
   # Argumentos para chamar a funcao calcCosTeta2
   mov.s $f12, $f20		# L1 em $f12
   mov.s $f13, $f21		# L2 em $f13
   mov.s $f14, $f24		# D em $f14
   
   jal calcCosTeta2
   mov.s $f25, $f0		# Preserva resultado em $f25
   
   # print msg8 (valor de Cos(Teta2))
   li $v0, 4
   la $a0, msg8
   syscall
   
   # print Cos(Teta2)
   mov.s $f12, $f0
   li $v0, 2
   syscall
   
   ##################################################
   # Calcula Cos(Phi)
   # Argumentos para chamar a funcao calcCosPhi
   mov.s $f12, $f20		# L1 em $f12
   mov.s $f13, $f21		# L2 em $f13
   mov.s $f14, $f24		# D em $f14
   
   jal calcCosPhi
   mov.s $f26, $f0		# Preserva resultado em $f26
   
   # print msg9 (valor de Cos(Phi))
   li $v0, 4
   la $a0, msg9
   syscall
   
   # print Cos(Phi)
   mov.s $f12, $f0
   li $v0, 2
   syscall   
   
   ##################################################
   # Calcula Phi
   # Argumentos para chamar a funcao acos(x)
   mov.s $f12, $f26		# Cos(Phi) em $f12
   
   jal acos
   mov.s $f29, $f0		# Preserva resultado em $f29
   
   # print msg12 (valor de Phi)
   li $v0, 4
   la $a0, msg12
   syscall
   
   # print Phi
   mov.s $f12, $f29
   li $v0, 2
   syscall  
   
   ##################################################
   # Calcula tan (Beta)/2
   # Argumentos para chamar a funcao CalcTanBeta2
   mov.s $f12, $f22		# Px em $f12
   mov.s $f13, $f23		# Py em $f13
   
   jal calcTanBeta2
   mov.s $f27, $f0		# Preserva resultado em $f27
   
   # print msg10 (valor de Beta/2)
   li $v0, 4
   la $a0, msg10
   syscall
   
   # print Beta/2
   mov.s $f12, $f0
   li $v0, 2
   syscall   
   
   ##################################################
   # Calcula Beta
   # Argumentos para chamar a funcao atan(x)
   mov.s $f12, $f27		# Tan(Beta)/2 em $f12
   
   jal atan
   l.s $f4, fDois
   mul.s $f30, $f0, $f4		# Beta/2 * 2; Preserva resultado em $f30
   
   # print msg11 (valor de Beta)
   li $v0, 4
   la $a0, msg13
   syscall
   
   # print Beta
   mov.s $f12, $f30
   li $v0, 2
   syscall  
   
   ##################################################
   # Calcula Teta1
   add.s $f0, $f29, $f30	# Teta1 = Phi + Beta; Preserva resultado em $f31
   
   # Converte resultado de Rad para Deg
   l.s $f4, pi			# PI em $f4
   l.s $f5, fPIDeg		# 180 em $f5
   div.s $f0, $f0, $f4		# div resultado por PI
   mul.s $f0, $f0, $f5		# mult resultado por 180
   mov.s $f31, $f0		# Preserva resultado em $f31
   
   # print msg14 (valor de Teta1)
   li $v0, 4
   la $a0, msg14
   syscall
   
   # print Teta1
   mov.s $f12, $f31
   li $v0, 2
   syscall  
   
   ##################################################
   # Calcula Teta2
   # Argumentos para chamar a funcao acos(x)
   mov.s $f12, $f25		# Cos(Teta2) em $f12
   
   jal acos
   # Converte resultado de Rad para Deg
   l.s $f4, pi			# PI em $f4
   l.s $f5, fPIDeg		# 180 em $f5
   div.s $f0, $f0, $f4		# div resultado por PI
   mul.s $f0, $f0, $f5		# mult resultado por 180
   mov.s $f28, $f0		# Preserva resultado em $f28
   
   # print msg12 (valor de Teta2)
   li $v0, 4
   la $a0, msg15
   syscall
   
   # print Teta2
   mov.s $f12, $f28
   li $v0, 2
   syscall  
   
Fim:
   li $v0, 10
   syscall

#############################################
# Função: 	calculaD
# Entradas: 	$f12: Px   $f13: Py
# Saída:   	$f0: D = sqrt(Px^2 + Py^2)
# Reg. Temp.:	$f4, $f5 e $f6
# Preserva: 
#############################################
calculaD:
   mul.s $f4, $f12, $f12	# f4: Px^2
   mul.s $f5, $f13, $f13	# f5: Py^2
   add.s $f6, $f4, $f5		# f6: (Px^2 + Py^2)
   sqrt.s $f0, $f6		# f0 <-- sqrt(Px^2 + Py^2)
   jr $ra
   
#############################################
# Função: 	verificaD
# Descrição:	Verifica se D > L1+L2 ou D < L1-L2
#		Imprime msg, tooClose ou tooFar caso seja
# Entradas: 	$f12: L1   $f13: L2   $f14: D
# Saída:   	N/A
# Reg. Temp.:	$f4, $f5
# Preserva: 
#############################################
verificaD:
   add.s $f4, $f12, $f13
   c.le.s $f14, $f4		# if D > L1+L2  [ D <= (L1+L2) --> False ]
   bc1f TargetTooFar

   sub.s $f5, $f12, $f13
   abs.s $f5, $f5
   c.lt.s  $f14, $f5		# if D < L1+L2
   
   #mov.s $f12, $f5
   #li $v0, 2
   #syscall
   
   bc1t TargetTooClose
  
   jr $ra

   TargetTooFar:
   # print string
   li $v0, 4
   la $a0, msg6
   syscall
   j inicio

   TargetTooClose:
   # print string
   li $v0, 4
   la $a0, msg7
   syscall
   j inicio

######################################################################
# Função: 	calcCosTeta2
# Descrição:	Calcula Cos(Teta2)
# Entradas: 	$f12: L1   $f13: L2   $f14: D
# Saída:   	$f0: Cos (Teta2) = ((D^2 - L1^2 - L2^2)/(2 * L1 * L2))
# Reg. Temp.:	$f4, $f5, $f6, $f7, $f8, $f9
# Preserva: 
######################################################################
calcCosTeta2:
   mul.s $f4, $f12, $f12	# $f4: L1^2
   mul.s $f5, $f13, $f13	# $f5: L2^2
   mul.s $f6, $f14, $f14	# $f6: D^2
   
   sub.s $f7, $f6, $f4		# $f7: D^2 - L1^2
   sub.s $f7, $f7, $f5		# $f7: (D^2 - L1^2 - L2^2)
   
   l.s $f9, fDois
   mul.s $f8, $f9, $f12 	# $f8: 2 * L1
   mul.s $f8, $f8, $f13		# $f8: 2 * L1 * L2
   
   div.s $f0, $f7, $f8		# $f0: Cos (Teta2) = ((D^2 - L1^2 - L2^2)/(2 * L1 * L2))
   
   jr $ra

######################################################################
# Função: 	calcCosPhi
# Descrição:	Calcula Cos(Phi)
# Entradas: 	$f12: L1   $f13: L2   $f14: D
# Saída:   	$f0: Cos (Phi) = ((D^2 + L1^2 - L2^2) / (2 * D * L1))
# Reg. Temp.:	$f4, $f5, $f6, $f7, $f8, $f9
# Preserva: 
######################################################################
calcCosPhi:
   mul.s $f4, $f12, $f12	# $f4: L1^2
   mul.s $f5, $f13, $f13	# $f5: L2^2
   mul.s $f6, $f14, $f14	# $f6: D^2
   
   add.s $f7, $f6, $f4		# $f7: D^2 + L1^2
   sub.s $f7, $f7, $f5		# $f7: D^2 + L1^2 - L2^2
   
   l.s $f9, fDois
   mul.s $f8, $f9, $f14		# $f8: 2 * D
   mul.s $f8, $f8, $f12		# $f8: 2 * D * L1
   
   div.s $f0, $f7, $f8		# $f0: Cos (Phi) ==> Retorno
   
   jr $ra

######################################################################
# Função: 	calcTanBeta2
# Descrição:	Calcula Tan(Beta) / 2
# Entradas: 	$f12: Px   $f13: Py
# Saída:   	$f0: Tan(Beta)/2 = ((sqrt(x^2 + y^2) - x) / y)		se x < 0 e y ≠ 0
#				 = (y / (sqrt(x^2 + y^2) + x))		caso contrário
# Reg. Temp.:	$f4, $f5, $f6, $f7, $f8
# Preserva: 
######################################################################
calcTanBeta2:
   mul.s $f5, $f12, $f12	# $f5: x^2
   mul.s $f6, $f13, $f13	# $f6: y^2
   add.s $f7, $f5, $f6		# $f7: x^2 + y^2
   sqrt.s $f7, $f7		# $f7: sqrt(x^2 + y^2)
   
   l.s $f4, fZero
   c.lt.s $f12, $f4		# if x < 0
   bc1t verificaY		# verifica y
   j numeradorY			# else, use a expressao com Y no numerador
   
   verificaY:
   c.eq.s $f13, $f4		# if y ≠ 0
   bc1f denominadorY		# use a expressao com Y no denominador
   l.s $f0, fZero
   jr $ra
   
   numeradorY:
   add.s $f8, $f7, $f12		# $f8: sqrt(x^2 + y^2) + x 
   div.s $f0, $f13, $f8		# $f0: Beta/2 = (y / (sqrt(x^2 + y^2) + x)) ==> Retorno
   jr $ra

   denominadorY:
   sub.s $f8, $f7, $f12		# $f8: sqrt(x^2 + y^2) - x 
   div.s $f0, $f8, $f13		# $f0: Beta/2 = ((sqrt(x^2 + y^2) - x) / y) ==> Retorno
   jr $ra
   
######################################################################
################ FUNÇÕES REAPROVEITADAS DO PROBLEMA 4 ################

######################################################################
# Função: 	atan
# Descrição:	Calcula Arco Tangente (x)
# Entradas: 	$f12: x
# Saída:   	$f0: atan(x)
######################################################################
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

######################################################################
# Função: 	asen
# Descrição:	Calcula Arco Seno (x)
# Entradas: 	$f12: x
# Saída:   	$f0: asen(x)
######################################################################
asen:
	# Zerando os registradores
	mtc1 $0, $f0
	mtc1 $0, $f1
	# Verificacao de dominio
	l.s $f5, const_um # $f5 = 1.0
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

######################################################################
# Função: 	acos
# Descrição:	Calcula Arco Coseno (x)
# Entradas: 	$f12: x
# Saída:   	$f0: acos(x)
######################################################################
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
