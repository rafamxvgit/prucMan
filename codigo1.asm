.data

playerSprite: .word 0
playerIntention: .byte 0
playerMove: .byte 0

playerPos: .word 16, 16
playerLastPos: .word 16, 16


contadorPontos: .byte 0

pontos1:
.word 5,
2,16,80, 
3,48,80, 
4,80,80,
5,112,80,
6,144,80

supPoints:
.word 1,
7, 96, 80

supPointMode: .word 0

enm1Move: .byte 0
enm1Intention: .byte 0
enm1Pos: .word 48, 16
enm1LastPos: .word 32, 16
enm1State: .byte 1

counterNaoMexe: .byte 0

fnMem1: .word 0,0,0,0,0,0,0,0
fnMem2: .word 0,0,0,0,0,0,0,0

numAddresses: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 

.include "normalPoint.data"
.include "mapa2.data"
.include "bloco.data"
.include "pruc.data"
.include "pruc1.data"
.include "colisao.data"
.include "gato1.data"
.include "ptMax.data"

.include "n0.data"
.include "n1.data"
.include "n2.data"
.include "n3.data"
.include "n4.data"
.include "n5.data"
.include "n6.data"
.include "n7.data"
.include "n8.data"
.include "n9.data"

.text

#salva os endereços dos números nos seus respectivos lugares

la t0, numAddresses

la t1, n0
addi t1, t1, 8
sw t1, 0(t0)

la t1, n1
addi t1, t1, 8
sw t1, 4(t0)

la t1, n2
addi t1, t1, 8
sw t1, 8(t0)

la t1, n3
addi t1, t1, 8
sw t1, 12(t0)

la t1, n4
addi t1, t1, 8
sw t1, 16(t0)

la t1, n5
addi t1, t1, 8
sw t1, 20(t0)

la t1, n6
addi t1, t1, 8
sw t1, 24(t0)

la t1, n7
addi t1, t1, 8
sw t1, 28(t0)

la t1, n8
addi t1, t1, 8
sw t1, 32(t0)

la t1, n9
addi t1, t1, 8
sw t1, 36(t0)

#renderiza o mapa
la a0, mapa2
addi a0, a0, 8
jal mapRender

#renderiza a colisão inicial do inimigo 1
la a0, colisao
addi a0, a0, 8
la a1, enm1Pos
lw a2, 4(a1)
lw a1, 0(a1)
li a3, 123
jal solidColorTileRender

#início do game loop
start:

#checa certos casos especiais
la a0, playerPos
jal checkLeftEnd
la a0, playerPos
jal checkRightEnd

la t0, counterNaoMexe
lb t0, 0(t0)
bne t0, zero, EP26
 
	# lê a intenção do player
	jal readKeyboard

	
	#define a movimentação do player
	la a0, playerIntention
	la a1, playerMove
	la a2, playerPos
	la a3, colisao
	addi a3, a3, 8
	jal entityMove

EP26:

#define a movimentação do inimigo
la a0, enm1Intention
la a1, enm1Move
la a2, enm1Pos
la a3, colisao
addi a3, a3, 8
jal entityMove

#altera a posição do player
la a0, playerPos
la a1, playerLastPos
la a2, playerMove
jal changeEntityPos

#altera a posição do inimigo
la a0, enm1Pos
la a1, enm1LastPos
la a2, enm1Move
jal changeEntityPos

#renderiza a colisão dos pontos
la a0, colisao
addi a0, a0, 8
la a1, pontos1
jal renderPointsCollision

#renderiza a colisão dos superPontos
la a0, colisao
addi a0, a0, 8
la a1, supPoints
jal renderPointsCollision

la t0, enm1State
lb t0, 0(t0)
beq t0, zero, EP41
	#renderiza a colisão do inimigo 1
	la a0, colisao
	addi a0, a0, 8 
	la a1, enm1Pos
	lw a2, 4(a1)
	lw a1, 0(a1)
	la a3, enm1Move
	lb a3, 0(a3)
	li a4, 123
	jal moveEntityCollision
EP41:

#verifica se o player pegou o ponto
la a0, colisao
addi a0, a0, 8
la a1, playerPos
lw a2, 4(a1)
lw a1, 0(a1)
la a3, pontos1
jal checkPointsColl

#verifica se o player pegou o superPonto
la a0, colisao
addi a0, a0, 8
la a1, playerPos
lw a2, 4(a1)
lw a1, 0(a1)
la a3, supPoints
jal checkPointsColl

#muda o modo de comportamento dos inimigos
beq a0, zero, EP37 
	la t0, supPointMode
	li t1, 640
	sw t1, 0(t0)
EP37:

#verifica se o player deve ir de base
la t0, supPointMode
lw t0, 0(t0)
bne t0, zero, EP38
	#---------------------------------
	#caso de colisão com o inimigo 1
	la a0, colisao
	addi a0, a0, 8
	la a2, playerPos
	lw a1, 0(a2)
	lw a2, 4(a2)
	li a3, 123
	jal isEntityTouching
	beq a0, zero, EP33
		li a7, 10
		ecall
	EP33:  
	#---------------------------------

	jal EP40

EP38:
	#---------------------------------
	#verifica se o inimigo deve ir de base

	#caso de colisão com o inimigo 1
	la a0, colisao
	addi a0, a0, 8
	la a2, playerPos
	lw a1, 0(a2)
	lw a2, 4(a2)
	li a3, 123
	jal isEntityTouching
	beq a0, zero, EP39
		la t0, enm1State
		sb zero, 0(t0)
		
		la t1, enm1LastPos
		lw a0, 0(t1)
		lw a1, 4(t1)
		la a2, mapa2
		addi a2, a2, 8
		jal tileUnrender
	EP39:
	#---------------------------------

EP40:

#renderiza os pontos
li a0, 0xff000000
la a1, pontos1
la a2, normalPoint
addi a2, a2, 8
jal renderPoints

#renderiza os superPontos
li a0, 0xff000000
la a1, supPoints
la a2, ptMax
addi a2, a2, 8
jal renderPoints

# desrenderiza o player
la t1, playerLastPos
lw a0, 0(t1)
lw a1, 4(t1)
la a2, mapa2
addi a2, a2, 8
jal tileUnrender


la t0, enm1State
lb t0, 0(t0)
beq t0, zero, EP43
	#desrenderiza o inimigo
	la t1, enm1LastPos
	lw a0, 0(t1)
	lw a1, 4(t1)
	la a2, mapa2
	addi a2, a2, 8
	jal tileUnrender
EP43:

#escolhe a imagem do player a se renderizar

jal playerSpritePicker

# renderiza o player
la t0, playerPos
lw a0, 0(t0)
lw a1, 4(t0)
la a2, playerSprite
lw a2, 0(a2)
addi a2, a2, 8
jal tileRender

la t0, enm1State
lb t0, 0(t0)
beq t0, zero, EP42
	#renderiza o inimigo
	la t0, enm1Pos
	lw a0, 0(t0)
	lw a1, 4(t0)
	la a2, gato1
	addi a2, a2, 8
	jal tileRender
EP42:

#renderiza o contador de pontos
la a0, contadorPontos
lb a0, 0(a0)
li a1, 0
li a2, 0
jal numRepresentation

#renderiza o timer do super
la a0, supPointMode
lw a0, 0(a0)
li a1, 96
li a2, 0
jal numRepresentation

# espera um tempinho
li a7, 32
li a0, 15
ecall

#-----------------------
#-----------------------

#decrementa o counterNaoMexe
la t0, counterNaoMexe
lb t1, 0(t0)
bge zero, t1, EP27
	addi t1, t1, -1
	sb t1, 0(t0)
EP27:

#decrementa o supPointMode
la t0, supPointMode
lw t1, 0(t0)
bge zero, t1, EP44
	addi t1, t1, -1
	sw t1, 0(t0)
EP44:

jal start
end:

##################################################
# a0 -> o endereço de memória do primeiro pixel do 
# mapa a ser renderizado
##################################################

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

################################################################################
#lê a tecla pressionada pelo jogador e define a "playerIntention" a partir disso
################################################################################

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

##########################################################
#a0 <- recebe o endereço da posição da entidade a se checar
##########################################################

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

##########################################################
#a0 <- recebe o endereço da posição da entidade a se checar
##########################################################

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

####################################################
#a0 <- endereço da intenção da entidade
#a1 <- endereço da movimentação da entidade
#a2 <- endereço da posição da entidade
#a3 <- endereço do primeiro pixel do mapa de colisão
####################################################

entityMove:
la s11, fnMem1 #endereço da memória da função
sw ra, 0(s11)
sw a0, 4(s11) #endereço intenção
sw a1, 8(s11) #endereço movimento
sw a2, 12(s11) #endereço posição
sw a3, 16(s11) #endereço do mapa colisão

lb a1, 0(a0)
mv a0, a2
mv a2, a3
jal checkMapCollision
beq a0, zero, EP14
	lw s1, 8(s11)
	lw s2, 4(s11)
	lb s2, 0(s2)
	sb s2, 0(s1)
	lw ra, 0(s11)
	ret
EP14:

lw a0, 12(s11)
lw a1, 8(s11)
lb a1, 0(a1)
lw a2, 16(s11)
jal checkMapCollision
beq a0, zero, EP15
	lw ra, 0(s11)
	ret
EP15:

lw a0, 8(s11)
lb a0, 0(a0)
jal rotateClock
mv a1, a0
sb a1, 20(s11)
lw a0, 12(s11)
lw a2, 16(s11)
jal checkMapCollision
beq a0, zero, EP16
	lb t0, 20(s11)
	lw t1, 8(s11)
	lw t2, 4(s11)
	sb t0, 0(t1)
	sb t0, 0(t2)
	lw ra, 0(s11)
	ret
EP16:

lw a0, 8(s11)
lb a0, 0(a0)
jal rotateCounter
mv a1, a0
sb a1, 20(s11)
lw a0, 12(s11)
lw a2, 16(s11)
jal checkMapCollision
beq a0, zero, EP17
	lb t0, 20(s11)
	lw t1, 8(s11)
	lw t2, 4(s11)
	sb t0, 0(t1)
	sb t0, 0(t2)
	lw ra, 0(s11)
	ret
EP17:

lb a0, 20(s11)
jal rotateCounter
lw t1, 8(s11)
lw t2, 4(s11)
sb a0, 0(t1)
sb a0, 0(t2)
lw ra, 0(s11)
ret

#####################################################
#a0 <- recebe o endereço da posição da entidade
#a1 <- recebe a direção da checagem
#a2 <- endereço do primeiro pixel do mapa de colisão
#####################################################

checkMapCollision:
mv s6, ra
lw s1, 0(a0) #posição x da entidade
lw s2, 4(a0) #posição y da entidade

li t0, 320
mul s3, s2, t0
add s3, s3, s1
add s3, s3, a2 # endereço da entidade no mapa de colisão


li t4, -1

bne a1, zero, EP6
	addi t1, s3, 16
	lb t2, 0(t1)
	beq t2, t4, EP10
		li t3, 4816
		add t1, s3, t3
		lb t2, 0(t1)
		beq t2, t4, EP10
			li a0, 1
			mv ra, s6
			ret
	EP10:
	mv a0, zero
	mv ra, s6
	ret
EP6:

li t0, 1
bne a1, t0, EP7
	addi t1, s3, -320
	lb t2, 0(t1)
	beq t2, t4, EP11
		li t3, -305
		add t1, s3, t3
		lb t2, 0(t1)
		beq t2, t4, EP11
			li a0, 1
			mv ra, s6
			ret
	EP11:
	mv a0, zero
	mv ra, s6
	ret
EP7:

li t0, 2
bne a1, t0, EP8
	addi t1, s3, -1
	lb t2, 0(t1)
	beq t2, t4, EP12
		li t3, 4799
		add t1, s3, t3
		lb t2, 0(t1)
		beq t2, t4, EP12
			li a0, 1
			mv ra, s6
			ret
	EP12:
	mv a0, zero
	mv ra, s6
	ret
EP8:

li t0, 3
bne a1, t0, EP9
	li t3, 5120
	add t1, s3, t3
	lb t2, 0(t1)
	beq t2, t4, EP13
		li t3, 5135
		add t1, s3, t3
		lb t2, 0(t1)
		beq t2, t4, EP13
			li a0, 1
			mv ra, s6
			ret
	EP13:
	mv a0, zero
	mv ra, s6
	ret
EP9:
mv ra, s6
ret

######################################################
#a0 <- recebe endereço da posição da entidade
#a1 <- recebe o endereço da ÚLTIMA posição da entidade
#a2 <- recebe o endereço da movimentação da entidade
######################################################

changeEntityPos:
mv s6, ra
lw t0, 0(a0)
lw t1, 4(a0)
sw t0, 0(a1)
sw t1, 4(a1)
lb t2, 0(a2)
bne t2, zero, EP20
	addi t0, t0, 1
	sw t0, 0(a0)
EP20:

li t3, 1
bne t2, t3, EP21
	addi t1, t1, -1
	sw t1, 4(a0)
EP21:

li t3, 2
bne t2, t3, EP22
	addi t0, t0, -1
	sw t0, 0(a0)
EP22:

li t3, 3
bne t2, t3, EP23
	addi t1, t1, 1
	sw t1, 4(a0)
EP23:
mv ra, s6
ret

############################################################
#a0 <- endereço do primeiro pixel da tela/seção-de-memória
#a1 <- posição x na tela
#a2 <- posição y na tela
#a3 <- cor a se renderizar
############################################################

solidColorTileRender:
mv s6, ra
li t3, 320
li t4, 16
mul s0, a2, t3
add s0, s0, a1
add s0, s0, a0 #endereço do primeiro pixel na tela

li t1, 0
LP6:
	bge t1, t4, LE6
	#---------------
	li t2, 0
	LP7:
		bge t2, t4, LE7
		#---------------
		mul t5, t1, t3
		add t5, t5, t2
		add t5, t5, s0
		sb a3, 0(t5)
		#---------------
		addi t2, t2, 1
		jal LP7
	LE7:
	#---------------
	addi t1, t1, 1
	jal LP6
LE6:

mv ra, s6
ret

###########################################################
#a0 <- endereço do primeiro pixel ta tela/região de memória
#a1 <- posição x atual da entidade
#a2 <- posição y atual da entidade
#a3 <- última movimentação da entidade
#a4 <- cor a se renderizar
###########################################################

moveEntityCollision:
mv s6, ra
li t3, 320
li t4, 16
mul s0, a2, t3
add s0, s0, a1
add s0, s0, a0 #endereço da entidade na tela

bne a3, zero, EP31
	addi s1, s0, 15 #primeiro pixel de escrita
	addi s2, s0, -1 #primeiro pixel de apagamento
	li t1, 0
	LP8:
		bge t1, t4, LE8
		#--------------
		mul t5, t1, t3 #contador*320
		add t5, t5, s1 #(contador*320)+(enderço do primeiro pixel de escrita)
		mul t6, t1, t3 #contador*320
		add t6, t6, s2 #(contador*320)+(endereço do primeiro pixel de apagamento)
		sb zero, 0(t6)
		sb a4, 0(t5)
		#--------------
		addi t1, t1, 1
		jal LP8
	LE8:
EP31:

li t0, 1
bne a3, t0, EP24
	li s2, 5120
	add s2, s2, s0 #endereço do primeiro pixel de apagamento
	mv s1, s0 #endereço do primeiro pixel de escrita
	li t1, 0
	LP9:
		bge t1, t4, LE9
		#--------------
		add t5, s1, t1
		add t6, s2, t1
		sb zero, 0(t6)
		sb a4, 0(t5)
		#--------------
		addi t1, t1, 1
		jal LP9
	LE9:
	
EP24:

li t0, 2
bne a3, t0, EP29
	mv s1, s0
	addi s2, s0, 16
	li t1, 0
	LP10:
		bge t1, t4, LE10
		#---------------
		mul t5, t1, t3
		add t5, t5, s1
		mul t6, t1, t3
		add t6, t6, s2
		sb zero, 0(t6)
		sb a4, 0(t5)
		#---------------
		addi t1, t1, 1
		jal LP10
	LE10:
EP29:

li t0, 3
bne a3, t0, EP30
	addi s2, s0, -320 # endereço do primeiro pixel de apagamento
	li s1, 4800
	add s1, s1, s0 # endereço do primeiro pixel de escrita
	li t1, 0
	LP15:
		bge t1, t4, LE15
		#---------------
		add t5, s1, t1
		add t6, s2, t1
		sb zero, 0(t6)
		sb a4, 0(t5)
		#---------------
		addi t1, t1, 1
		jal LP15
	LE15:
		
EP30:
mv ra, s6
ret

############################################################
#a0 <- endereço do primeiro pixel do mapa de colisão
#a1 <- endereço x da entidade
#a2 <- endereço y da entidade
#a3 <- valor de contato
############################################################

#DESCRIÇÃO:
#essa função checa se a entidade está em contato com
#com um certo elemento definido por a3  

isEntityTouching:
mv s6, ra
li t0, 320
mul s0, a2, t0
add s0, s0, a1
add s0, s0, a0 #endereço da entidade no mapa de colisão

addi s1, s0, 16
addi s2, s0, -1
addi s3, s0, -320
addi s4, s0, -305
li t0, 4799
add s5, s0, t0
li t0, 4816
add s7, s0, t0
li t0, 5120
add s8, s0, t0
li t0, 5135
add s9, s0, t0

jal EP32
P1:
li a0, 1
mv ra, s6
ret
EP32:

lb t0, 0(s1)
beq t0, a3, P1
lb t0, 0(s2)
beq t0, a3, P1
lb t0, 0(s3)
beq t0, a3, P1
lb t0, 0(s4)
beq t0, a3, P1
lb t0, 0(s5)
beq t0, a3, P1
lb t0, 0(s7)
beq t0, a3, P1
lb t0, 0(s8)
beq t0, a3, P1
lb t0, 0(s9)
beq t0, a3, P1

li a0, 0
mv ra, s6
ret

#####################################################################
#a0 <- endereço do primeiro pixel do lugar no qual se deve renderizar
#a1 <- endereço da lista de pontos a se renderizar
#####################################################################

renderPointsCollision:
mv s6, ra
lw t0, 0(a1)
addi a1, a1, 4
li t1, 0
LP11:
	bge t1, t0, LE11
	#---------------
	li t3, 12
	mul t2, t1, t3
	add t2, t2, a1 #endereço dos valores do ponto
	
	lw s0, 4(t2) # x do ponto
	lw s1, 8(t2) # y do ponto
	lw s3, 0(t2) # se deve renderizar o ponto ou não

	beq s3, zero, EP34
		li t3, 320
		mul s4, s1, t3
		add s4, s4, s0
		add s4, s4, a0 #endereço do primeiro pixel a se renderizar

		sb s3, 0(s4)
		addi s5, s4, 15
		sb s3, 0(s5)
		li t3, 4800
		add s5, s4, t3
		sb s3, 0(s5)
		li t3, 4815
		add s5, s4, t3
		sb s3, 0(s5)
	EP34:
	
	#---------------
	addi t1, t1, 1
	jal LP11
LE11:

mv ra, s6
ret


#####################################################################
#a0 <- endereço do primeiro pixel do lugar no qual se deve renderizar
#a1 <- endereço da lista de pontos a se renderizar
#a2 <- prmeiro pixel da imagem
#####################################################################

renderPoints:
mv s6, ra
li s4, 8
li s5, 320
lw t0, 0(a1)
addi a1, a1, 4
li t1, 0
LP12:
	bge t1, t0, LE12
	#---------------
	li t3, 12
	mul t2, t1, t3
	add t2, t2, a1 #endereço dos valores do ponto
	
	lw s0, 4(t2) # x do ponto
	addi s0, s0, 4
	lw s1, 8(t2) # y do ponto
	addi s1, s1, 4
	mul s1, s5, s1
	add s1, s1, s0
	add s1, s1, a0 #endereço do primeiro pixel na tela a se renderizar

	lw s3, 0(t2) # se deve renderizar o ponto ou não

	beq s3, zero, EP35
		li t2, 0
		LP13:
			bge t2, s4, LE13
			#---------------
			li t3, 0
			LP14:
				bge t3, s4, LE14
				#----------------
				mul s8, t2, s4
				add s8, s8, t3
				add s8, s8, a2
				lb s8, 0(s8)
				mul s7, t2, s5
				add s7, s7, t3  
				add s7, s7, s1
				sb s8, 0(s7)
				
				#----------------
				addi t3, t3, 1
				jal LP14
			LE14:
			#---------------
			addi t2, t2, 1
			jal LP13
		LE13:
	EP35:
	#---------------
	addi t1, t1, 1
	jal LP12
LE12:

mv ra, s6
ret

############################################################
#a0 <- endereço do primeiro pixel do mapa de colisão
#a1 <- endereço x da entidade
#a2 <- endereço y da entidade
#a3 <- enderço dos pontos
############################################################

#DESCRIÇÃO:
#essa função checa se a entidade está em contato com
#um ponto  

checkPointsColl:
mv s6, ra
li t0, 320
mul s0, a2, t0
add s0, s0, a1
add s0, s0, a0 #endereço da entidade no mapa de colisão

addi s1, s0, 16
lb s1, 0(s1)

addi s2, s0, -1
lb s2, 0(s2)

addi s3, s0, -320
lb s3, 0(s3)

addi s4, s0, -305
lb s4, 0(s4)

li t0, 4799
add s5, s0, t0
lb s5, 0(s5)

li t0, 4816
add s7, s0, t0
lb s7, 0(s7)

li t0, 5120
add s8, s0, t0
lb s8, 0(s8)

li t0, 5135
add s9, s0, t0
lb s9, 0(s9)

lb t2, 0(a3) #numero de pontos
li t1, 0
LP16:
	bge t1, t2, LE16
	#---------------
	li t0, 12
	mul t3, t1, t0
	addi t3, t3, 4 
	add t3, t3, a3 # endereço da cor de colisão do ponto 
	lw t0, 0(t3) # cor de colisão do ponto
	beq t0, zero, EP36 
	
	beq s1, t0, P2
	beq s2, t0, P2
	beq s3, t0, P2
	beq s4, t0, P2
	beq s5, t0, P2
	beq s7, t0, P2
	beq s8, t0, P2
	beq s9, t0, P2

	
	jal EP36
		P2:
		
		li t0, 12
		mul t3, t1, t0
		add t3, t3, a3
		addi t3, t3, 4
		sw zero, 0(t3) # desativa o ponto
		la t3, contadorPontos
		lb t0, 0(t3)
		addi t0, t0, 1
		sb t0, 0(t3)
		li a0, 1
		mv ra, s6
		ret
	EP36:


	
	#--------------
	addi t1, t1, 1
	jal LP16
LE16:

li a0, 0
mv ra, s6
ret

####################################
#a0 <- numero a ser representado
#a1 <- x da posição de representação
#a2 <- y da posição de representação
####################################

numRepresentation:
mv s7, ra

la s2, numAddresses
la s10, fnMem2

sw a1, 12(s10)
sw a2, 16(s10)

li s0, 100
li s1, 10

div t0, a0, s0 # centenas
rem a0, a0, s0

div t1, a0, s1 # dezenas
rem t2, a0, s1 # unidades


slli t0, t0, 2 
slli t1, t1, 2
slli t2, t2, 2

add t0, t0, s2
add t1, t1, s2
add t2, t2, s2

lw t0, 0(t0) # endereço do primeiro digito
lw t1, 0(t1) # endereço do segundo digito
lw t2, 0(t2) # endereço do terceiro digito

sw t0, 0(s10)
sw t1, 4(s10)
sw t2, 8(s10)

mv a0, t0
mv a3, a2
mv a2, a1
li a1, 0xff000000
jal renderDigit


lw a0, 4(s10)
lw a2, 12(s10)
addi a2, a2, 8
lw a3, 16(s10)
li a1, 0xff000000
jal renderDigit


lw a0, 8(s10)
lw a2, 12(s10)
addi a2, a2, 16
lw a3, 16(s10)
li a1, 0xff000000
jal renderDigit

mv ra, s7
ret

#######################
#a0 endereço da imagem
#a1 endereço do lugar
#a2 x da imagem
#a3 y da imagem
#######################

renderDigit:
mv s6, ra
li s0, 8
li s1, 16
li s2, 320

mul s3, s2, a3
add s3, s3, a2
add s3, s3, a1 # endereço inicial na tela

li t1, 0
LP17:
	bge t1, s1, LE17
	#---------------
	li t2, 0
	LP18:
		bge t2, s0, LE18
		#---------------
		mul t0, t1, s2
		add t0, t0, t2
		add t0, t0, s3 # endereço no qual se deve escrever

		mul t3, t1, s0
		add t3, t3, t2
		add t3, t3, a0 # endereço do qual se deve ler

		lb s4, 0(t3)
		sb s4, 0(t0)
		
		#---------------
		addi t2, t2, 1
		jal LP18
	LE18:
	#---------------
	addi t1, t1, 1
	jal LP17
LE17:

mv ra, s6
ret

playerSpritePicker:
mv s6, ra
la s0, playerSprite
la s1, playerMove
lb s1, 0(s1)

li t0, 0
bne s1, t0, EP45
	la t0, pruc1
	sw t0, 0(s0)
	jal EP48
EP45:

li t0, 1
bne s1, t0, EP46
	jal EP48
EP46:

li t0, 2
bne s1, t0, EP47
	la t0, pruc
	sw t0, 0(s0)
	jal EP48
EP47:

li t0, 3
bne s1, t0, EP48
	#tá vazio por enquanto
EP48:

mv ra, s6
ret

####################################################################################
# você coloca um número (n) a0 e a função retorna (n-1) se (n > 3) e (3) se (n == 0)
####################################################################################

rotateClock:
mv s6, ra
bne a0, zero, EP18
	li a0, 3
	mv ra, s6
	ret
EP18:
addi a0, a0, -1
mv ra, s6
ret


####################################################################################
# você coloca um número (n) a0 e a função retorna (n+1) se (n < 3) e (0) se (n == 3)
####################################################################################

rotateCounter:
mv s6, ra
li t0, 3
bne t0, a0, EP19
	mv a0, zero
	mv ra, s6
	ret
EP19:
addi a0, a0, 1
mv ra, s6
ret
