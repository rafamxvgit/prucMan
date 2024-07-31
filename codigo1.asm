.data
enemy1Pos: .word 32, 16
enemy1Intention: .byte 0
enemy1Move: .byte 0
playerIntention: .byte 0
playerMove: .byte 0
playerPos: .word 16, 16
counterNaoMexe: .byte 0
lastPlayerPos: .word 16, 16
lastEnemy1Pos: .word 32, 16
enemy2Pos: .word 64, 16
lastEnemy2Pos: .word 64, 16
enemy2Intention: .byte 0
enemy2Move: .byte 0

.include "mapa2.data"
.include "bloco.data"
.include "colisao.data"
.include "gato1.data"

.text

la a0, mapa2
addi a0, a0, 8
jal, mapRender

start:

#checa certos casos especiais
la a0, playerPos
jal checkLeftEnd
jal checkRightEnd


la t0, counterNaoMexe
lb t0, 0(t0)
bne t0, zero, EP26
 
	# lê a intenção do player
	jal readKeyboard

	
	#define a movimentação do player
	jal playerMovement


	#define a movimentação do inimigo
	la a0, enemy1Intention
	la a1, enemy1Move
	la a2, enemy1Pos
	jal enemyMovement

EP26:

#movimenta o inimigo
la t0, enemy1Move
la t1, enemy1Pos
jal changeEnemyPos

#movimenta o player
jal changePlayerPos

# desrenderiza o inimigo
la t1, lastEnemy1Pos
lw a0, 0(t1)
lw a1, 4(t1)
la a2, mapa2
addi a2, a2, 8
jal tileUnrender

# desrenderiza o player
la t1, lastPlayerPos
lw a0, 0(t1)
lw a1, 4(t1)
la a2, mapa2
addi a2, a2, 8
jal tileUnrender

# renderiza o inimigo
la t0, enemy1Pos
lw a0, 0(t0)
lw a1, 4(t0)
la a2, gato1
addi a2, a2, 8
jal tileRender

# renderiza o player
la t0, playerPos
lw a0, 0(t0)
lw a1, 4(t0)
la a2, bloco
addi a2, a2, 8
jal tileRender

# espera um tempinho
li a7, 32
li a0, 20
ecall

#decrementa o counterNaoMexe
la t0, counterNaoMexe
lb t1, 0(t0)
bge zero, t1, EP27
	addi t1, t1, -1
	sb t1, 0(t0)
EP27:

jal start
end:

#definição de funções:

##################
# a0 -> o endereço de memória do primeiro pixel do 
# mapa a ser renderizado
##################

mapRender:
mv s6, ra
li s0, 76800 #1.
li s1, 0xff000000 #2.
li t1, 0
LP1:
bge t1, s0, LE1
#---------------
add t0, a0, t1
lb t3, 0(t0)
add t0, s1, t1
sb t3, 0(t0)
#---------------
addi t1, t1, 1
jal LP1 
LE1:
mv ra, s6
ret

#1. numero de pixeis
#2. #endereço da tela



###########################################
# a0 -> posição x do tile
# a1 -> posição y do tile
# a2 -> endereço do primeiro pixel do tile
###########################################

tileRender:
mv s6, ra
li s0, 16
li s1, 320
li s3, 0xff000000
mul s2, a1, s1
add s2, s2, a0 # 1.
add s2, s2, s3

li t1, 0
	LP2:
	bge t1, s0, LE2
	#--------------
	li t2, 0
		LP3:
		bge t2, s0, LE3
		#--------------
		slli t0, t1, 4
		add t0, t0, t2
		add t0, t0, a2 # 2.
		lb t3, 0(t0)

		mul t0, t1, s1
		add t0, t0, t2
		add t0, t0, s2 # 3.
		sb t3, 0(t0)
		#--------------
		addi t2, t2, 1
		jal LP3
	LE3:
	#--------------
	addi t1, t1, 1
	jal LP2
LE2:
mv ra, s6
ret

#1. s2 <- endereço do primeiro pixel no qual o tile deve ser renderizado
#2. t0 <- endereço do pixel no tile
#3. t0 <- endereço do pixel no qual o tile deve ser renderizado


###########################################
# a0 -> posição x do tile
# a1 -> posição y do tile
# a2 -> endereço do primeiro pixel do mapa
###########################################


tileUnrender:
mv s6, ra
li s0, 16
li s1, 320
li s3, 0xff000000 #1.
mul s2, a1, s1
add s2, s2, a0 #2.

li t1, 0
	LP4:
	bge t1, s0, LE4
	#--------------
	li, t2, 0
		LP5:
		bge t2, s0, LE5
		#--------------
		mul t0, t1, s1
		add t0, t0, t2
		add t0, t0, s2

		add t3, t0, a2
		lb t4, 0(t3)
		add t3, t0, s3
		sb t4, 0(t3)

		#--------------
		addi t2, t2, 1
		jal LP5
	LE5:
	#--------------
	addi t1, t1, 1
	jal LP4
LE4:
mv ra, s6
ret

#1. endereço da tela
#2. posição do primeiro pixel em relativo ao mapa ou à tela

readKeyboard:
mv s6, ra
li s0, 0xff200000
lw s1, 0(s0)
andi s1, s1, 1 #bit de controle
lw s2, 4(s0) #tecla pressionada
la s5, playerIntention
beq s1, zero, EP1
	#caso alguma coisa tenha sido teclada execute isso aqui
	li t0, 119
	bne s2, t0, EP2
		li s3, 1
		sb s3, 0(s5)
	EP2:
	
	li t0, 97
	bne s2, t0, EP3
		li s3, 2
		sb s3, 0(s5)
	EP3:
	
	li t0, 115
	bne s2, t0, EP4
		li s3, 3
		sb s3, 0(s5)
	EP4:
	
	li t0, 100
	bne s2, t0, EP5
		sb zero, 0(s5)
	EP5:
EP1:
mv ra, s6
ret


playerMovement:
mv s7, ra
la s0, playerIntention
lb s0, 0(s0)
mv a0, s0
jal CheckMapCollision
beq a0, zero, EP14
	la s1, playerMove
	la s0, playerIntention
	lb s0, 0(s0)
	sb s0, 0(s1)
	mv ra, s7
	ret
EP14:

la a0, playerMove
lb a0, 0(a0)
jal CheckMapCollision
beq a0, zero, EP15
	mv ra, s7
	ret
EP15:
la a0, playerMove
lb a0, 0(a0)
jal rotateClock
jal CheckMapCollision
beq a0, zero, EP18
	la s1, playerMove
	lb a0, 0(s1)
	jal rotateClock
	sb a0, 0(s1)
	la s1, playerIntention
	sb a0, 0(s1)
	mv ra, s7
	ret
EP18:


la a0, playerMove
lb a0, 0(a0)
jal rotateCounter
jal CheckMapCollision
beq a0, zero, EP19
	la s1, playerMove
	lb a0, 0(s1)
	jal rotateCounter
	sb a0, 0(s1)
	la s1, playerIntention
	sb a0, 0(s1)
	mv ra, s7
	ret
EP19:

la a0, playerMove
lb a0, 0(a0)
jal rotateClock
jal rotateClock
mv s10, a0
jal CheckMapCollision
beq a0, zero, EP24
	la s1, playerMove
	sb s10, 0(s1)
	la s1, playerIntention
	sb s10, 0(s1)
	mv ra, s7
	ret
EP24:

mv ra, s7
ret

###############################################
# a0 <- recebe a direção de checagem da colisão
###############################################
# retorna 1 no a 0 caso o caminho não esteja obstruido

CheckMapCollision: #TODO: comentar essa porra dessa função
mv s6, ra
la s0, playerPos
lw s1, 0(s0) # posição x do player
lw s2, 4(s0) # posição y do player
la s0, colisao
addi s0, s0, 8

li s4, 255 

li t0, 320
mul s3, s2, t0
add s3, s3, s1
add s3, s3, s0 # esse é o endereço do player no mapa de colisão


bne a0, zero, EP6
	addi t3, s3, 16
	lb t4, 0(t3)
	bne t4, zero, EP10
		li t6, 4816
		add t3, s3, t6
		lb t4, 0(t3)
		bne t4, zero, EP10
			li a0, 1
			mv ra, s6
			ret
	EP10:
	mv a0, zero
	mv ra, s6
	ret
EP6:


li t0, 1
bne a0, t0, EP7
	addi t3, s3, -320
	lb t4, 0(t3)
	bne t4, zero, EP11
		addi t3, s3, -305
		lb t4, 0(t3)
		bne t4, zero, EP11
			li a0, 1
			mv ra, s6
			ret
		
	EP11:
	mv a0, zero
	mv ra, s6
	ret
EP7:


li t0, 2
bne a0, t0, EP8
	addi t3, s3, -1
	lb t4, 0(t3)
	bne t4, zero, EP12
		li t6, 4799
		add t3, s3, t6
		lb t4, 0(t3)
		bne t4, zero, EP12
			li a0, 1
			mv ra, s6
			ret
	EP12: 
	mv a0, zero
	mv ra, s6
	ret
EP8:


li, t0, 3
bne a0, t0, EP9
	li t6, 5120
	add t3, s3, t6
	lb t4, 0(t3)
	bne t4, zero, EP13
		li t6, 5135
		add t3, s3, t6
		lb t4, 0(t3)
		bne t4, zero, EP13
			li a0, 1
			mv ra, s6
			ret
	EP13:
	mv a0, zero
	mv ra, s6
	ret
EP9:

# você coloca um número (n) a0 e a função retorna (n+1) se (n < 3) e (0) se (n == 3)
rotateClock:
mv s6, ra
li t0, 3
bne t0, a0, EP16
	mv a0, zero
	mv ra, s6
	ret
EP16:
addi a0, a0, 1
mv ra, s6
ret

# você coloca um número (n) a0 e a função retorna (n-1) se (n > 0) e (3) se (n == 0)
rotateCounter:
mv s6, ra
li t0, 3
bne zero, a0, EP17
	mv a0, t0
	mv ra, s6
	ret
EP17:
addi a0, a0, -1
mv ra, s6
ret

changePlayerPos:
mv s6, ra
la s10, lastPlayerPos
la s0, playerPos
la s3, playerMove
lb s3, 0(s3)
lw s1, 0(s0)
lw s2, 4(s0)
sw s1, 0(s10)
sw s2, 4(s10)
li t0, 0
bne s3, t0, EP20
	addi s1, s1, 1
	sw s1, 0(s0)
EP20:

li t0, 1
bne s3, t0, EP21
	addi s2, s2, -1
	sw s2, 4(s0)
EP21:

li t0, 2
bne s3, t0, EP22
	addi s1, s1, -1
	sw s1, 0(s0)
EP22:

li t0, 3
bne s3, t0 EP23
	addi s2, s2, 1
	sw s2, 4(s0)
EP23:
mv ra, s6
ret

#a0 <- passa o endereço posição da entidade a se checar

checkLeftEnd:
mv s7, ra
la t1, mapa2
addi t1, t1, 8
lw s1, 0(a0)
lw s2, 4(a0)
la s3, playerMove
lb s3, 0(s3)
li t3, 2
bne s3, t3, EP25
bne s1, zero, EP25
	la t0, counterNaoMexe
	li t2, 16
	sb t2, 0(t0)
	li t4, 320
	add s4, s1, t4
	sw s4, 0(a0)
	mv a0, s1
	mv a1, s2
	mv a2, t1
	jal tileUnrender
EP25:

mv ra, s7
ret


#a0 <- passa o endereço posição da entidade a se checar

checkRightEnd:
mv s7, ra
la t1, mapa2
addi t1, t1, 8
lw s1, 0(a0)
lw s2, 4(a0)
la s3, playerMove
lb s3, 0(s3)
li t0, 304
bne s3, zero, EP28
bne s1, t0, EP28
	la, t0, counterNaoMexe
	li t2, 16
	sb t2, 0(t0)
	li t4, -320
	add s4, s1, t4
	sw s4, 0(a0) 
	mv a0, s1
	mv a1, s2
	mv a2, t1
	jal tileUnrender
EP28:
mv ra, s7
ret


#a1 <- posiçãoInimigo

CheckEnemyMapCollision: #TODO: comentar essa porra dessa função
mv s6, ra
mv s0, a1
lw s1, 0(s0) # posição x do inimigo
lw s2, 4(s0) # posição y do inimigo
la s0, colisao
addi s0, s0, 8

li s4, 255 

li t0, 320
mul s3, s2, t0
add s3, s3, s1
add s3, s3, s0 # esse é o endereço do player no mapa de colisão

bne a0, zero, EP33
	addi t3, s3, 16
	lb t4, 0(t3)
	bne t4, zero, EP34
		li t6, 4816
		add t3, s3, t6
		lb t4, 0(t3)
		bne t4, zero, EP34
			li a0, 1
			mv ra, s6
			ret
	EP34:
	mv a0, zero
	mv ra, s6
	ret
EP33:


li t0, 1
bne a0, t0, EP35
	addi t3, s3, -320
	lb t4, 0(t3)
	bne t4, zero, EP36
		addi t3, s3, -305
		lb t4, 0(t3)
		bne t4, zero, EP36
			li a0, 1
			mv ra, s6
			ret
		
	EP36:
	mv a0, zero
	mv ra, s6
	ret
EP35:


li t0, 2
bne a0, t0, EP37
	addi t3, s3, -1
	lb t4, 0(t3)
	bne t4, zero, EP38
		li t6, 4799
		add t3, s3, t6
		lb t4, 0(t3)
		bne t4, zero, EP38
			li a0, 1
			mv ra, s6
			ret
	EP38: 
	mv a0, zero
	mv ra, s6
	ret
EP37:


li, t0, 3
bne a0, t0, EP39
	li t6, 5120
	add t3, s3, t6
	lb t4, 0(t3)
	bne t4, zero, EP40
		li t6, 5135
		add t3, s3, t6
		lb t4, 0(t3)
		bne t4, zero, EP40
			li a0, 1
			mv ra, s6
			ret
	EP40:
	mv a0, zero
	mv ra, s6
	ret
EP39:


#########################################
#a0 <- endereço da intenção do player
#a1 <- endereço da movimentação do player
#a2 <- endereço da posição do player
#########################################

enemyMovement:
mv s7, ra
mv s9, a0
mv s10, a1
mv s11, a2

lb a0, 0(s9)
mv a1, s11
jal CheckEnemyMapCollision
beq a0, zero, EP29
	lb t0, 0(s9)
	sb t0, 0(s10)
	mv ra, s7
	ret
EP29:

lb a0, 0(s10)
mv a1, s11
jal CheckEnemyMapCollision
beq a0, zero, EP30
	mv ra, s7
	ret
EP30:

mv a1, s11
lb a0, 0(s10)
jal rotateClock
beq a0, zero, EP31
	lb a0, 0(s10)
	jal rotateClock
	sb a0, 0(s10)
	mv ra, s7
	ret
EP31:

mv a1, s11
lb a0, 0(s10)
jal rotateCounter
beq a0, zero, EP32
	lb a0, 0(s10)
	jal rotateCounter
	sb a0, 0(s10)
	mv ra, s7
	ret
EP32:

mv ra, s7
ret

##############################
#a0 <- endereço enemyMove
#a1 <- endereço enemyPosition

##############################

changeEnemyPos:
mv s6, ra
mv s9, a0
mv s10, a1
lb t0, 0(s9)
lw t1, 0(s10)
lw t2, 4(s10)

bne t0, zero, EP41
	addi t1, t1, 1
	sw t1, 0(s10)
	mv ra, s6
	ret
EP41: 

li t3, 1
bne t0, t3, EP42
	addi t2, t2, -1
	sw t2, 4(s10)
	mv ra, s6
	ret
EP42:

li t3, 2
bne t0, t3, EP43
	addi t1, t1, -1
	sw t1, 0(s10)
	mv ra, s6
	ret
EP43:

li t3, 3
bne t0, t3, EP44
	addi t2, t2, 1
	sw t2, 4(s10)
	mv ra, s6
	ret
EP44:

mv ra, s6
ret
