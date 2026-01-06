#################################################################################
# Autor: 	Leonardo Pereira da Silva
# Data: 	28/12/2025
# Descrição: 	Implementa o cálculo da cinemática inversa de um robô 2D (θ1, θ2)
#		a partir das entradas Px, Py, L1 e L2
#		 - Px e Py: coordenadas X e Y desejadas do end-effector
#		 - L1 e L2: comprimentos do segmento do braço do robô
#################################################################################

.data
msg0: .asciiz "############################################\n#   - Controlador de Braço Robótico 2D -   #\n############################################\n"
msg1: .asciiz "Entre com o valor de Px: "
msg2: .asciiz "Entre com o valor de Py: "
msg3: .asciiz "Entre com o valor de L1: "
msg4: .asciiz "Entre com o valor de L2: "
msg5: .asciiz "\nValor calculado de D: "
msg6: .asciiz "\nPonto Inalcaçável - Muito longe.\n - Tente Novamenrte - \n"
msg7: .asciiz "\nPonto Inalcaçável - Muito perto.\n - Tente Novamenrte - \n"
msg8: .asciiz "\nValor calculado de Cos(Teta2): "
msg9: .asciiz "\nValor calculado de Cos(Phi): "
msg10: .asciiz "\nValor calculado de Beta/2: "

L1:   .float 10
L2:   .float 8
Px:   .float
py:   .float
D:    .float

zero: .float 0.0
um:   .float 1.0
dois: .float 2.0

.text
main:
   # Register Mapping:	L1: $f20,	L2: $f21,   	Px: $f22,   	Py: $f23,  
   #			D: $f24,	Cos(θ2): $f25, 	Cos(ϕ): $f26	Tan(β)/2: $f27
   
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
   s.s $f0, D

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
   
   l.s $f9, dois
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
   
   l.s $f9, dois
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
   
   l.s $f4, zero
   c.lt.s $f12, $f4		# if x < 0
   bc1t verificaY		# verifica y
   j numeradorY			# else, use a expressao com Y no numerador
   
   verificaY:
   c.eq.s $f13, $f4		# if y ≠ 0
   bc1f denominadorY		# use a expressao com Y no denominador
   
   numeradorY:
   add.s $f8, $f7, $f12		# $f8: sqrt(x^2 + y^2) + x 
   div.s $f0, $f13, $f8		# $f0: Beta/2 = (y / (sqrt(x^2 + y^2) + x)) ==> Retorno
   jr $ra

   denominadorY:
   sub.s $f8, $f7, $f12		# $f8: sqrt(x^2 + y^2) - x 
   div.s $f0, $f8, $f13		# $f0: Beta/2 = ((sqrt(x^2 + y^2) - x) / y) ==> Retorno
   jr $ra
   
