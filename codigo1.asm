.data

.eqv tela 0xff000000
.eqv mmio 0xff200000

playerMove: .byte 0
playerIntention: .byte 0
playerPos: .word 16, 16, 16, 16
playerSpriteAdd: .word 0

anims0: .word 0, 
0, 0, 0, 0

anims2: .word 0,
0, 0, 0, 0

enm1Pos: .word 288, 16, 288, 16
enm1Move: .byte 3
enm1Col: .byte 100
enm1State: .byte 1

enm2Pos: .word 48, 16, 48, 16
enm2Move: .byte 0
enm2Col: .byte 101
enm2State: .byte 1

enm3Pos: .word 48, 208, 48, 208
enm3Move: .byte 0
enm3Col: .byte 102
enm3State: .byte 1
enm3TpTimer: .word 500, 80
enm3TpAddress: .word 16, 16

enm4Pos: .word 128, 16, 128, 16
enm4Move: .byte 0
enm4Col: .byte 103
enm4State: .byte 1

counterPts: .byte 0
counterNaoMexe: .byte 0
supPtMode: .word 0

pts:
.word 22,
2, 16, 80, 
3, 80, 80,
4, 80, 16,
5, 112, 16,
6, 128, 80,
7, 176, 80,
8, 192, 16,
9, 224, 16,
10, 288, 16,
11, 304, 80,

12,16,208, 
13,48,144,
14,80,208,
15,112,144,
16, 112, 208,
17, 192, 208,
18, 208, 144,
19, 224, 208,
20, 304, 144,

21, 32, 112,
22, 96, 112,
23, 208, 112,
24, 272, 112

ptsMap2:
.word 18,
2, 96, 16,
3, 48, 48,
4, 48, 96,
5, 96, 80,
6, 128, 16,
7, 208, 16,
8, 240, 208,
9, 256, 144,
10, 96, 176,
11, 16, 208,
12, 256, 112,
13, 240, 48,
14, 208, 176,
15, 208, 80,
16, 144, 176,
17, 288, 112,
18, 288, 48,
19, 176, 64,
20, 176, 16


supPts:
.word 2,
25, 288, 208,
26, 288, 48

supPtsMap2: 
.word 2,
25, 288, 208,
26, 288, 48

notas: .word 9, 0, 0,
67, 1000, 0,
74, 1000, 0,
70, 1500, 0,
69, 500, 0,
67, 500, 0,
70, 500, 0,
69, 500, 0,
67, 500, 0,
66, 500, 0

level: .word 0

enm1Sprites: .word 0, 0, 0, 0
enm2Sprites: .word 0, 0, 0, 0
enm3Sprites: .word 0, 0, 0, 0
enm4Sprites: .word 0, 0, 0, 0

.include "nums.data"
.include "normalPoint.data"
.include "ptMax.data"
.include "mapa.data"
.include "mp2rev.data"
.include "col.data"
.include "col2.data"
.include "gato1.data"
.include "gatoEsquerda.data"
.include "gatoDireita.data"
.include "gato1costas.data"
.include "gato1frente.data"
.include "gEsquerda2.data"
.include "gDireita2.data"
.include "gFrente2.data"
.include "gCostas2.data"
.include "gEsquerda3.data"
.include "gDireita3.data"
.include "gFrente3.data"
.include "gCostas3.data"
.include "gEsquerda4.data"
.include "gDireita4.data"
.include "gFrente4.data"
.include "gCostas4.data"

.include "p00.data"
.include "p01.data"
.include "p02.data"
.include "p03.data"

.include "p20.data"
.include "p21.data"
.include "p22.data"
.include "p23.data"

.text

#---------------------
la t0, enm1Sprites
la t1, gatoDireita
sw t1, 0(t0)
#---------------------
la t1, gatoEsquerda
sw t1, 8(t0)
#---------------------
la t1, gato1frente
sw t1, 12(t0)
#---------------------
la t1, gato1costas
sw t1, 4(t0)
#---------------------
la t0, enm2Sprites
la t1, gDireita2
sw t1, 0(t0)
la t1, gCostas2
sw t1, 4(t0)
la t1, gEsquerda2
sw t1, 8(t0)
la t1, gFrente2
sw t1, 12(t0)
#----------------------
la t0, enm3Sprites
la t1, gDireita3
sw t1, 0(t0)
la t1, gCostas3
sw t1, 4(t0)
la t1, gEsquerda3
sw t1, 8(t0)
la t1, gFrente3
sw t1, 12(t0)
#----------------------
la t0, enm4Sprites
la t1, gDireita4
sw t1, 0(t0)
la t1, gCostas4
sw t1, 4(t0)
la t1, gEsquerda4
sw t1, 8(t0)
la t1, gFrente4
sw t1, 12(t0)

la t0, anims0

la t1, p00
sw t1, 4(t0)

la t1, p01
sw t1, 8(t0)

la t1, p02
sw t1, 12(t0)

la t1, p03
sw t1, 16(t0)
#---------------------
la t0, anims2

la t1, p20
sw t1, 4(t0)

la t1, p21
sw t1, 8(t0)

la t1, p22
sw t1, 12(t0)

la t1, p23
sw t1, 16(t0)
#---------------------

ST:

la a0, mapa
jal mapRender


#início do game loop
start:
#-------------------

la t0, level
lw t0, 0(t0)
beq t0, zero, CTN
	la t0, counterPts
	lb t0, 0(t0)
	li t1, 18
	bne t0, t1, CTN
		li a7, 10
		ecall
CTN:

la t0, counterPts
lb t0, 0(t0)
li t1, 22 
bne t0, t1 SAMELEVEL
	jal levelTransition	
SAMELEVEL:

#checagem das bordas
jal checkEnds

#renderiza o contador de pontos
la a0, counterPts
lb a0, 0(a0)
li a1, 2
li a3, 0
li a4, 0
jal renderNum

#renderiza o contador de super
la a0, supPtMode
lw a0, 0(a0)
li a1, 3
li a3, 64
li a4, 0
jal renderNum

#------------------------------------------------------------
#lê a intenção do player
jal readKeyboard

#checa se o player deve ou não poder mudar de direção
la t0, counterNaoMexe
lb t0, 0(t0)
bne t0, zero, EP26

	#define a movimentação do player.
	jal movePlayer

EP26:

#move o player.
la a0, playerPos
la a1, playerMove
jal changeEntityPos

#move os inimgos
la t0, enm1State
lb t0, 0(t0)
beq t0, zero, EP51
	jal normalMoveEnm1
EP51:

la t0, enm2State
lb t0, 0(t0)
beq t0, zero, EP54
	jal normalMoveEnm2
EP54:

la t0, enm3State
lb t0, 0(t0)
beq t0, zero, EP64
	jal normalMoveEnm3
EP64:

la t0, enm4State
lb t0, 0(t0)
beq t0, zero, EP68
	jal normalMoveEnm4
EP68:


#vê se o player está colidindo com alguma coisa
la a0, playerPos
lw a1, 4(a0)
lw a0, 0(a0)
jal returnCol


li t0, -1
beq a0, t0, EP30
	#checa os casos de colisão
	jal collisionCases
EP30:

#renderiza a colisão dos pontos. do
la a0, pts
jal rendPtsColl

la a0, supPts
jal rendPtsColl

#renderiza os pontos
la a0, pts
la a1, normalPoint
jal renderPoints

la a0, supPts
la a1, ptMax
jal renderPoints

la, t0, enm1State
lb t0, 0(t0)
beq t0, zero, EP52

	#desrenderiza o inimigo 1. do
	la a0, enm1Pos
	lw a1, 12(a0)
	lw a0, 8(a0)
	la a2, mapa
	jal unrenderTile
	
	jal selectSpriteEnm1
	
	#renderiza o inimigo 1. do
	la a0, enm1Pos
	lw a1, 4(a0)
	lw a0, 0(a0)
	addi a2, a2, 8
	jal tileRender

EP52:

la, t0, enm2State
lb t0, 0(t0)
beq t0, zero, EP53

	#desrenderiza o inimigo 2.
	la a0, enm2Pos
	lw a1, 12(a0)
	lw a0, 8(a0)
	la a2, mapa
	jal unrenderTile

	jal selectSpriteEnm2

	#renderiza o inimigo 2.
	la a0, enm2Pos
	lw a1, 4(a0)
	lw a0, 0(a0)
	addi a2, a2, 8
	jal tileRender
	EP53:

la, t0, enm3State
lb t0, 0(t0)
beq t0, zero, EP63

	#desrenderiza o inimigo 3.
	la a0, enm3Pos
	lw a1, 12(a0)
	lw a0, 8(a0)
	la a2, mapa
	jal unrenderTile

	jal selectSpriteEnm3

	#renderiza o inimigo 3.
	la a0, enm3Pos
	lw a1, 4(a0)
	lw a0, 0(a0)
	addi a2, a2, 8
	jal tileRender
	EP63:

la, t0, enm4State
lb t0, 0(t0)
beq t0, zero, EP635

	#desrenderiza o inimigo 3.
	la a0, enm4Pos
	lw a1, 12(a0)
	lw a0, 8(a0)
	la a2, mapa
	jal unrenderTile

	jal selectSpriteEnm4

	#renderiza o inimigo 3.
	la a0, enm4Pos
	lw a1, 4(a0)
	lw a0, 0(a0)
	addi a2, a2, 8
	jal tileRender
	EP635:

#desrenderiza o player. do
la a0, playerPos
lw a1, 12(a0)
lw a0, 8(a0)
la a2, mapa
jal unrenderTile

jal playerSpritePicker

#renderiza o player. do
la a0, playerPos
lw a1, 4(a0)
lw a0, 0(a0)
la a2, playerSpriteAdd
lw a2, 0(a2)
addi a2, a2, 8
jal tileRender

#decrementa os counters
la t0, counterNaoMexe
lb t1, 0(t0)
beq t1, zero, EP27
	addi t1, t1, -1
	sb t1, 0(t0)
EP27:

la t0, supPtMode
lw t1, 0(t0)
beq t1, zero, EP31
	addi t1, t1, -1
	sw t1, 0(t0)
EP31:

jal musica

# espera um tempinho. do
li a7, 32
li a0, 16
ecall
#-------------------
jal zero, start
end:


#######################
#a0 -> endereço do mapa
####################### do

mapRender:
li s0, 76800
li t1, tela
add s0, s0, t1
LP1:
	bge t1, s0, LE1
	#--------------
	lb t2, 0(a0)
	sb t2, 0(t1)
	#--------------
	addi a0, a0, 1
	addi t1, t1, 1
	jal zero, LP1
LE1:
ret

#############################################
#a0 <- endereço tela/colisão/seção-de-memória
#a1 <- x pos
#a2 <- y pos
#a3 <- cor
############################################# do

collTileRender:
li s0, 320
li s1, 16
li s2, 5120
mul s3, s0, a2
add s3, s3, a1
add s3, s3, a0
mv t1, s3
add s3, s3, s2

LP2:
	bge t1, s3, LE2
	#----------------
	li t2, 0
	LP3:
		bge t2, s1, LE3
		#--------------
		add t3, t1, t2
		sb a3, 0(t3)
		#--------------
		addi t2, t2, 1
		jal zero, LP3
	LE3:
	#----------------
	addi t1, t1, 320
	jal zero, LP2
LE2:
ret

#########################################
#lê a a entrada de teclado
#########################################  do

readKeyboard:
li s0, mmio
lb s1, 0(s0)
andi s1, s1, 1
lw s2, 4(s0) 
la s3, playerIntention

beq s1, zero, EP1
	li t0, 119
	bne s2, t0, EP2
		li t1, 1
		sb t1, 0(s3)
		ret
	EP2:
	li t0, 97
	bne s2, t0, EP3
		li t1, 2
		sb t1, 0(s3)
		ret
	EP3:
	li t0, 115
	bne s2, t0, EP4
		li t1, 3
		sb t1, 0(s3)
		ret
	EP4:
	li t0, 100
	bne s2, t0, EP5
		sb zero, 0(s3)
		ret
	EP5:
	li t0, 32
	bne s2, t0, EP67
		jal levelTransition
	EP67:
EP1:
ret

#########################################
# define a movimentação do player
######################################### do

movePlayer:
la s7, playerIntention
la s8, playerMove
la s9, playerPos
la s10, col
mv s11, ra

lw a0, 0(s9)
lw a1, 4(s9)
lb a2, 0(s7)
la a3, col
jal checkMapCollision
beq a0, zero, EP14
	lb s7, 0(s7)
	sb s7, 0(s8)
	mv ra, s11
	ret
EP14:

lw a0, 0(s9)
lb a2, 0(s8)
jal checkMapCollision
beq a0, zero, EP15
	mv ra, s11
	ret
EP15:

li s7, -1
sb s7, 0(s8)
mv ra, s11
ret



###########################
#a0 <- x da entidade
#a1 <- y da entidade
#a2 <- direção de checagem
#a3 <- mapa de colisão
########################### do

checkMapCollision:
li t0, 320
mul s0, a1, t0
add s0, s0, a0
add s0, s0, a3

li s1, -1

bne a2, zero, EP6
	lb t1, 16(s0)
	beq t1, s1, EP7
		li t1, 4816
		add t1, t1, s0
		lb t1, 0(t1)
		beq t1, s1, EP7
			li a0, 1
			ret
	EP7:
	li a0, 0
	ret	
EP6:

li t1, 1
bne a2, t1, EP8
	lb t1, -320(s0)
	beq t1, s1, EP9
		lb t1, -305(s0)
		beq t1, s1, EP9
			li a0, 1
			ret
	EP9:
	li a0, 0
	ret	
EP8:

li t1, 2
bne a2, t1, EP10
	lb t1, -1(s0)
	beq t1, s1, EP11
		li t1, 4799
		add t1, t1, s0
		lb t1, 0(t1)
		beq t1, s1, EP11
			li a0, 1
			ret
	EP11:
	li a0, 0
	ret
EP10:

li t1, 3
bne a2, t1, EP12
	li t1, 5120
	add t1, t1, s0
	lb t1, 0(t1)
	beq t1, s1, EP13
		li t1, 5135
		add t1, t1, s0
		lb t1, 0(t1)
		beq t1, s1, EP13
			li a0, 1
			ret
	EP13:
	li a0, 0
	ret
EP12:

li a0, 1
ret

##########################################
#a0 -> posição x do tile
#a1 -> posição y do tile
#a2 -> endereço do primeiro pixel do tile
######################################### do

tileRender:
li s0, 320
li s1, 16
li s2, tela
mul t1, a1, s0
add t1, t1, a0
add t1, t1, s2

li t0, 5120
add s4, t1, t0

LP4:
	bge t1, s4, LE4
	#----------------
	add t2, t1, s1
	LP5:
		bge t1, t2, LE5
		#--------------
		lb t3, 0(a2)
		sb t3, 0(t1)
		addi a2, a2, 1
		#--------------
		addi t1, t1, 1
		jal zero, LP5
	LE5:
	#----------------
	addi t1, t1, 304
	jal zero, LP4
LE4:
ret

###########################################
# a0 -> posição x do tile
# a1 -> posição y do tile
# a2 -> imagem de background
########################################### do

unrenderTile:
li s0, 16
li s1, 320
li s2, tela

mul s3, s1, a1
add s3, s3, a0

add s4, s3, s2 #tela
add s3, s3, a2 #imagem

li t0, 5120
add s2, s4, t0

LP6:
	bge s4, s2, LE6
	#---------------
	add t1, s4, s0 
	LP7:
		bge s4, t1, LE7
		#--------------
		lb t2, 0(s3)
		sb t2, 0(s4)
		addi s3, s3, 1
		#--------------
		addi s4, s4, 1
		jal zero, LP7
	
	LE7:
	addi s4, s4, 304
	#---------------
	addi s3, s3, 304
	jal zero, LP6
LE6:
ret


####################################################
#a0 <- recebe o endereço da posição da entidade
#a1 <- recebe o endereço da movimentação da entidade
#################################################### do

changeEntityPos:

lw s0, 0(a0)
lw s1, 4(a0)
sw s0, 8(a0)
sw s1, 12(a0)
lb s2, 0(a1)

bne s2, zero, EP16
	addi s0, s0, 1
	sw s0, 0(a0)
	ret
EP16:

li t1, 1
bne s2, t1, EP17
	addi s1, s1, -1
	sw s1, 4(a0)
	ret
EP17:

li t1, 2
bne s2, t1, EP18
	addi s0, s0, -1
	sw s0, 0(a0)
	ret
EP18:

li t1, 3
bne, s2, t1, EP19
	addi s1, s1, 1
	sw s1, 4(a0)
	ret
EP19:
ret

#################################
# a0 <- quais conjuntos de pontos
#################################

rendPtsColl:
la s4, col
lw t0, 0(a0) #n pts
addi a0, a0, 4
li t1, 12
mul t0, t0, t1
add t0, t0, a0

LP8:
	bge a0, t0, LE8
	#--------------
	lw s1, 0(a0) # cor
	lw s2, 4(a0) # x
	lw s3, 8(a0) # y

	beq s1, zero, EP20
		li t1, 320
		mul t1, t1, s3
		add t1, t1, s2
		add t1, t1, s4
		
		sb s1, 0(t1)
		sb s1, 15(t1)
		li t2, 4800
		add t2, t2, t1
		sb s1, 0(t2)
	EP20:
	#--------------
	addi a0, a0, 12
	jal zero, LP8
LE8:

ret

#########################
#a0 <- conjunto de pontos
#a1 <- a imagem do ponto
#########################

renderPoints:
li s1, tela
li s5, 320
addi a1, a1, 8
lw s2, 0(a0) #n pts
addi a0, a0, 4
li t0, 12
mul s2, s2, t0
add s2, s2, a0

LP9:
	bge a0, s2, LE9
	#--------------
	lw t0, 0(a0) # cor do ponto
	beq t0, zero, EP21
		lw s3, 4(a0) # x
		addi s3, s3, 4
		lw s4, 8(a0) # y
		addi s4, s4, 4
		mv s8, a1 #imagem
		
		mul t1, s4, s5
		add t1, t1, s3
		add t1, t1, s1

		li t0, 2560
		add t0, t1, t0
		LP10:
			bge t1, t0, LE10
			#---------------
			addi t2, t1, 8
			LP11:
				bge t1, t2, LE11
				#---------------
				lb t3, 0(s8)
				addi s8, s8, 1
				sb t3, 0(t1)
				#---------------
				addi t1, t1, 1
				jal zero, LP11
			LE11:
			#---------------
			addi t1, t1, 312
			jal zero, LP10
		LE10:
		
	EP21:
	#--------------
	addi a0, a0, 12
	jal zero, LP9
LE9:
ret

###################
#a0 <- x
#a1 <- y
##################

returnCol:
la s0, col
li s3, -1

li t0, 320
mul s1, a1, t0
add s1, s1, a0
add s1, s1, s0

jal zero, EP22
	P1:
	mv a0, s2
	ret
EP22:

lb s2, 16(s1)
beq s2, zero, OUT1
beq s2, s3, OUT1
	jal zero, P1
OUT1:

lb s2, -1(s1)
beq s2, zero, OUT2
beq s2, s3, OUT2
	jal zero, P1
OUT2:

lb s2, -320(s1)
beq s2, zero, OUT3
beq s2, s3, OUT3
	jal zero, P1
OUT3:

lb s2, -305(s1)
beq s2, zero, OUT4
beq s2, s3, OUT4
	jal zero, P1
OUT4:

li t1, 4799
add t1, t1, s1
lb s2, 0(t1)
beq s2, zero, OUT5
beq s2, s3, OUT5
	jal zero, P1
OUT5:

li t1, 4816
add t1, t1, s1
lb s2, 0(t1)
beq s2, zero, OUT6
beq s2, s3, OUT6
	jal zero, P1
OUT6:

li t1, 5120
add t1, t1, s1
lb s2, 0(t1)
beq s2, zero, OUT7
beq s2, s3, OUT7
	jal zero, P1
OUT7:

li t1, 5135
add t1, t1, s1
lb s2, 0(t1)
beq s2, zero, OUT8
beq s2, s3, OUT8
	jal zero, P1
OUT8:

li a0, -1
ret

#####################
#a0 <- colisionCollor
#####################

collisionCases:

#checa a colisão com os pontos
la s0, pts
lw t0, 0(s0)
li t1, 12
mul t0, t0, t1
addi s0, s0, 4
add s1, s0, t0
LP12:
	bge s0, s1, LE12
	#---------------
	lw t0, 0(s0)
	bne t0, a0, EP23
		#---------------

		#adiciona o ponto no contador
		sw zero, 0(s0)

		la t1, counterPts
		lb t2, 0(t1)
		addi t2, t2, 1
		sb t2, 0(t1)

		#apaga o ponto
		mv s6, ra
		lw s10, 4(s0)
		lw s11, 8(s0)
		mv a0, s10
		mv a1, s11
		la a2, mapa
		jal unrenderTile

		#apaga a colisão do ponto
		la a0, col
		mv a1, s10
		mv a2, s11
		li a3, 0
		jal singlePtRender

		mv ra, s6
		ret
		
		#---------------
	EP23:
	#---------------
	addi s0, s0, 12
	jal zero, LP12

LE12: 

la s0, supPts
lw t0, 0(s0)
li t1, 12
mul t0, t0, t1
addi s0, s0, 4
add s1, s0, t0
LP33:
	bge s0, s1, LE33
	#---------------
	lw t0, 0(s0)
	bne t0, a0, EP29
		#---------------

		#adiciona o ponto no contador
		sw zero, 0(s0)

		#seta o modo super
		li t2, 600
		la t1, supPtMode
		sw t2, 0(t1)

		#apaga o ponto
		mv s6, ra
		lw s10, 4(s0)
		lw s11, 8(s0)
		mv a0, s10
		mv a1, s11
		la a2, mapa
		jal unrenderTile

		#apaga a colisão do ponto
		la a0, col
		mv a1, s10
		mv a2, s11
		li a3, 0
		jal singlePtRender

		jal changeDir

		mv ra, s6
		ret
		
		#---------------
	EP29:
	#---------------
	addi s0, s0, 12
	jal zero, LP33

LE33: 

#checa a colisão com os inimigos no modo normal

la s0, supPtMode
lw s0, 0(s0)
bne s0, zero, EP36 
	
	#se eu não estiver no modo super 
	la s0, enm1Col
	lb s0, 0(s0)
	bne s0, a0, EP37
		li a7, 10
		ecall
		ret
	EP37:

	la s0, enm2Col
	lb s0, 0(s0)
	bne s0, a0, EP38
		li a7, 10
		ecall
		ret
	EP38:

	la s0, enm3Col
	lb s0, 0(s0)
	bne s0, a0, EP39
		li a7, 10
		ecall
		ret
	EP39:

	la s0, enm4Col
	lb s0, 0(s0)
	bne s0, a0, EP40
		li a7, 10
		ecall
		ret
	EP40:

EP36:
#checa a colisão com os inimigos no modo super

la s0, enm1Col
lb s0, 0(s0)
bne s0, a0, EP41
	mv s6, ra

	la t0, enm1State
	sb zero, 0(t0)
	
	la t0, enm1Pos
	la a0, col
	lw a1, 0(t0)
	lw a2, 4(t0)
	li a3, 0
	jal collTileRender

	la a0, enm1Pos
	lw a1, 12(a0)
	lw a0, 8(a0)
	la a2, mapa
	jal unrenderTile

	mv ra, s6
	ret
EP41:

la s0, enm2Col
lb s0, 0(s0)
bne s0, a0, EP42
	mv s6, ra

	la t0, enm2State
	sb zero, 0(t0)

	la t0, enm2Pos
	la a0, col
	lw a1, 0(t0)
	lw a2, 4(t0)
	li a3, 0
	jal collTileRender

	la a0, enm2Pos
	lw a1, 12(a0)
	lw a0, 8(a0)
	la a2, mapa
	jal unrenderTile

	mv ra, s6
	ret

EP42:

la s0, enm3Col
lb s0, 0(s0)
bne s0, a0, EP43
	mv s6, ra

	la t0, enm3State
	sb zero, 0(t0)

	la t0, enm3Pos
	la a0, col
	lw a1, 0(t0)
	lw a2, 4(t0)
	li a3, 0
	jal collTileRender

	la a0, enm3Pos
	lw a1, 12(a0)
	lw a0, 8(a0)
	la a2, mapa
	jal unrenderTile

	mv ra, s6
	ret
EP43:

la s0, enm4Col
lb s0, 0(s0)
bne s0, a0, EP44
	mv s6, ra

	la t0, enm4State
	sb zero, 0(t0)

	la t0, enm4Pos
	la a0, col
	lw a1, 0(t0)
	lw a2, 4(t0)
	li a3, 0
	jal collTileRender

	la a0, enm3Pos
	lw a1, 12(t0)
	lw a0, 8(t0)
	la a2, mapa
	jal unrenderTile


	mv ra, s6
	ret
EP44:

#-------------------------------
ret

#######################
#a0 <- mapa de colisão
#a1 <- x
#a2 <- y
#a3 <- cor
#######################

singlePtRender:
li t0, 320
mul t0, a2, t0
add t0, t0, a1
add t0, t0, a0

sb a3, 0(t0)
sb a3, 15(t0)
li t1, 4800
add t1, t1, t0
sb a3, 0(t1)

ret

##########################################################################
#Descrição: verifica se o player chegou em alguma das extremidades da tela
##########################################################################

checkEnds:
la t0, counterNaoMexe
lb t1, 0(t0)
bne t1, zero, EP25 
	la s0, playerPos
	lw s1, 0(s0)

	bne s1, zero, EP24 #se chegar na esquerda

		li t1, 18
		sb t1, 0(t0)

		mv s6, ra
		mv a0, s1
		lw a1, 4(s0)
		la a2, mapa
		addi s1, s1, 320
		sw s1, 0(s0)
		jal unrenderTile
		mv ra, s6
		ret
	EP24:

	li t2, 304
	bne s1, t2, EP28 #se chegar na esquerda

		li t1, 18
		sb t1, 0(t0)

		mv s6, ra
		mv a0, s1
		lw a1, 4(s0)
		la a2, mapa
		addi s1, s1, -320
		sw s1, 0(s0)
		jal unrenderTile
		mv ra, s6
		ret
	EP28:

	
EP25:
ret

#########################
# a0 <- numero
# a1 <- numero de digitos
# a3 <- x
# a4 <- y
#########################

renderNum:
mv s6, ra	
addi a1, a1, -1
jal pow

mv a5, a4 #y
mv a4, a3 #x
mv a3, a0 #numero
mv s10, a2 #potencia

li s4, 10
li t0, 1

LP32:
	beq s10, t0, LE32
	#---------------
	div t5, a3, s10
	rem a3, a3, s10

	mv a0, t5
	mv a1, a4
	mv a2, a5
	jal renderDigit

	addi a4, a4, 8
	#---------------
	div s10, s10, s4
	jal zero, LP32
LE32:

mv a0, a3
mv a1, a4
mv a2, a5
jal renderDigit

mv ra, s6
ret

#############
#a0 <- digito
#a1 <- x
#a2 <- y
#############

renderDigit:
la s0, nums
li s1, 128
mul s1, s1, a0
add s1, s1, s0
li s2, tela
li s3, 320

mul t1, s3, a2
add t1, t1, a1
add t1, t1, s2
li t2, 5120
add t2, t2, t1

LP29:
	bge t1, t2, LE29
	#---------------
	addi t3, t1, 8
	LP30:
		bge t1, t3, LE30
		#---------------
		lb t4, 0(s1)
		sb t4, 0(t1)
		addi s1, s1, 1
		#---------------
		addi t1, t1, 1
		jal zero, LP30 
	LE30: 
	#---------------
	addi t1, t1, 312
	jal zero, LP29
LE29:
ret

###############
#a1 <- expoente
###############

pow:
li t0, 0
li t1, 1
li t2, 10
LP31:
	bge t0, a1, LE31
	#---------------
	mul t1, t1, t2
	#---------------
	addi t0, t0, 1
	jal zero, LP31
LE31:
mv a2, t1
ret


playerSpritePicker:
la s0, playerSpriteAdd
la s1, playerMove
lb s1, 0(s1)

li t0, 0
bne s1, t0, EP45
	la t0, anims0
	lw t1, 0(t0)
	li t2, 15
	bne t1, t2, EP50
		li t1, -1
	EP50:
	addi t1, t1, 1
	sw t1, 0(t0)
	srli t1, t1, 2
	slli t1, t1, 2
	addi t1, t1, 4
	add t1, t1, t0 #endereço da imagem
	lw t1, 0(t1)
	sw t1, 0(s0)
	jal zero, EP48
EP45:

li t0, 1
bne s1, t0, EP46
	ret
EP46:

li t0, 2
bne s1, t0, EP47
	la t0, anims2
	lw t1, 0(t0)
	li t2, 15
	bne t1, t2, EP49
		li t1, -1
	EP49:
	addi t1, t1, 1
	sw t1, 0(t0)
	srli t1, t1, 2
	slli t1, t1, 2
	addi t1, t1, 4
	add t1, t1, t0 #endereço da imagem
	lw t1, 0(t1)
	sw t1, 0(s0)
	jal zero, EP48
EP47:

li t0, 3
bne s1, t0, EP48
	ret
EP48:

ret

normalMoveEnm1:
mv s6, ra
la s10, enm1Pos
la s11, enm1Move
la s9, playerPos

lw t0, 0(s10) #meu x
lw t1, 0(s9) #pl x
lw t2, 4(s10) #meu y
lw t3, 4(s9) #pl y
lb t4, 0(s11)

andi t4, t4, 1
beq t0, t1, EQX
beq t2, t3, EQY
beq t4, zero, HOR

VER:

        blt t0, t1, DIR
                li s8, 2
                jal zero, ND0
        DIR:
                li s8, 0
        ND0:

        #vê se dá pra ir pra onde eu quero. do
        lw a0, 0(s10)
        lw a1, 4(s10)
        mv a2, s8
        la a3, col
        jal checkMapCollision

        beq a0, zero, FAIL0
                sb s8, 0(s11)
                jal zero, LOCOM
        FAIL0:

        #vê se dá pra ir pra onde eu já tô indo
        lw a0, 0(s10)
        lb a2, 0(s11)
        jal checkMapCollision

        beq a0, zero, FAIL2
                jal zero, LOCOM
        FAIL2:

        #vê se dá pra ir pra o lado contrário de onde eu quero ir
        addi a2, s8, 2
        li t0, 4
        blt a2, t0, ND3 
                addi a2, a2, -4
        ND3:

        lw a0, 0(s10)
        lw a1, 4(s10)
        jal checkMapCollision

        beq a0, zero, FAIL4
                sb a2, 0(s11)
                jal zero, LOCOM
        FAIL4:

        #vê se dá pra ir pra o lado contrário de onde eu estou indo
        lb a2, 0(s11)
        addi a2, a2, 2
        li t0, 4
        blt a2, t0, ND5 
                addi a2, a2, -4
        ND5:

        lw a0, 0(s10)
        lw a1, 4(s10)
        la a3, col
        jal checkMapCollision

        beq a0, zero, FAIL7
                sb a2, 0(s11)
                jal zero, LOCOM
        FAIL7:
HOR:

        blt t2, t3, BAIXO
                li s8, 1
                jal zero, ND1 
        BAIXO:
                li s8, 3
        ND1:
        
        #vê se dá pra ir pra onde eu quero. do
        lw a0, 0(s10)
        lw a1, 4(s10)
        mv a2, s8
        la a3, col
        jal checkMapCollision 

        beq a0, zero, FAIL1
                sb s8, 0(s11)
                jal zero, LOCOM
        FAIL1:

        #vê se dá pra ir pra onde eu já tô indo
        lw a0, 0(s10)
        lb a2, 0(s11)
        jal checkMapCollision 

        beq a0, zero, FAIL3
                jal zero, LOCOM
        FAIL3:

        #vê se dá pra ir pra o lado contrário de onde eu quero ir
        addi a2, s8, 2
        li t0, 4
        blt a2, t0, ND2 
                addi a2, a2, -4
        ND2:

        lw a0, 0(s10)
        jal checkMapCollision

        beq a0, zero, FAIL5
                sb a2, 0(s11)
                jal zero, LOCOM
        FAIL5:

        #vê se dá pra ir pra o lado contrário de onde eu estou indo
        lb a2, 0(s11)
        addi a2, a2, 2
        li t0, 4
        blt a2, t0, ND4 
                addi a2, a2, -4
        ND4:

        lw a0, 0(s10)
        jal checkMapCollision

        beq a0, zero, FAIL6
                sb a2, 0(s11)
                jal zero, LOCOM
        FAIL6:
EQX:

        blt t2, t3, BAIXO1
                li s8, 1
                jal zero, ND7 
        BAIXO1:
                li s8, 3
        ND7:

        #vê se dá pra ir pra onde eu quero. do
        lw a0, 0(s10)
        lw a1, 4(s10)
        mv a2, s8
        la a3, col
        jal checkMapCollision 

        beq a0, zero, FAIL12
                sb s8, 0(s11)
                jal zero, LOCOM
        FAIL12:

        #vê se dá pra ir pra onde eu já to indo do
        lw a0, 0(s10)
        lb a2, 0(s11)
        jal checkMapCollision

        beq a0, zero, FAIL13
                jal zero, LOCOM
        FAIL13:

        #vê se dá pra ir pra esquerda. do
        lw a0, 0(s10)
        li a2, 2
        jal checkMapCollision

        beq a0, zero, FAIL14
                sb a2, 0(s11)
                jal zero, LOCOM
        FAIL14:

        #vê se dá pra ir pra direita. do
        lw a0, 0(s10)
        li a2, 0
        la a3, col

        beq a0, zero, FAIL15
                sb a2, 0(s11)
                jal zero, LOCOM
        FAIL15:

        
        

EQY:
        blt t0, t1, DIR1
                li s8, 2
                jal zero, ND6
        DIR1:
                li s8, 0
        ND6:

        #vê se dá pra ir pra onde eu quero. do
        lw a0, 0(s10)
        lw a1, 4(s10)
        mv a2, s8
        la a3, col
        jal checkMapCollision 

        beq a0, zero, FAIL8
                sb s8, 0(s11)
                jal zero, LOCOM
        FAIL8:

        #vê se dá pra ir pra onde eu já to indo do
        lw a0, 0(s10)
        lb a2, 0(s11)
        jal checkMapCollision

        beq a0, zero, FAIL9
                jal zero, LOCOM
        FAIL9:

        #vê se dá pra ir pra cima. do
        lw a0, 0(s10)
        li a2, 1
        jal checkMapCollision

        beq a0, zero, FAIL10
                sb a2, 0(s11)
                jal zero, LOCOM
        FAIL10:

        #vê se dá pra ir pra baixo. do
        lw a0, 0(s10)
        li a2, 3
        jal checkMapCollision

        beq a0, zero, FAIL11
                sb a2, 0(s11)
                jal zero, LOCOM
        FAIL11:
        

LOCOM:

mv a0, s10
mv a1, s11
jal changeEntityPos

la a0, col
la a1, enm1Pos
lw a2, 12(a1)
lw a1, 8(a1)
la a3, enm1Move
lb a3, 0(a3)
la a4, enm1Col
lb a4, 0(a4)
jal moveEntityCollision

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
li s0, 320
mul s1, a2, s0
add s1, s1, a1
add s1, s1, a0

bne a3, zero, EP32
	addi t1, s1, 16
	mv t2, s1
	li t4, 5120
	add t3, t1, t4
	LP34:
		bge t1, t3, LE34
		#---------------
		sb zero, 0(t2)
		sb a4, 0(t1)
		addi t2, t2, 320
		#---------------
		addi t1, t1, 320
		jal zero, LP34
	LE34:
	ret
EP32:

li t0, 1
bne a3, t0, EP33
	addi t1, s1, -320
	li t3, 4800
	add t2, s1, t3
	addi t3, t1, 16
	LP35:
		bge t1, t3, LE35
		#---------------
		sb zero, 0(t2)
		sb a4, 0(t1)
		addi t2, t2, 1
		#---------------
		addi t1, t1, 1
		jal zero, LP35
	LE35:
	ret
EP33:

li t0, 2
bne a3, t0, EP34
	addi t1, s1, -1
	addi t2, s1, 15
	li t4, 5120
	add t3, t4, t1
	LP36:
		bge t1, t3, LE36
		#---------------
		sb zero, 0(t2)
		sb a4, 0(t1)
		addi t2, t2, 320
		#---------------
		addi t1, t1, 320
		jal zero, LP36
	LE36:
	ret
EP34:

li t0, 3
bne a3, t0, EP35
	li t4, 5120
	add t1, s1, t4
	mv t2, s1
	addi t3, t1, 16
	LP37:
		bge t1, t3, LE37
		#---------------
		sb zero, 0(t2)
		sb a4, 0(t1)
		addi t2, t2, 1
		#---------------
		addi t1, t1, 1
		jal zero, LP37
	LE37:
	ret
EP35:
ret
	
	
normalMoveEnm2:
mv s6, ra
la s11, enm2Pos
la s10, enm2Move

TER4:
li s8, 0
#tenta se mover pra a esquerda ou pra direita
li a7, 41
ecall
andi t0, a0, 3

lb a2, 0(s10)

bne t0, zero, BBC
	addi a2, a2, 1
	li t0, 4
	bne a2, t0, EP56
		addi a2, a2, -4
	EP56:
	jal zero, FDS
BBC:
li t1, 1
bne t0, t1, BTT
	addi a2, a2, -1
	li t0, -1
	bne a2, t0, EP57
		addi a2, a2, 4
	EP57:
	jal zero, FDS
BTT:
li t1, 2
bne t0, t1, KSS
	li s8, 1
	jal zero, TER1
KSS:
	jal TER4
FDS:

lw a0, 0(s11)
lw a1, 4(s11)
la a3, col
jal checkMapCollision

beq a0, zero, EP58
	sb a2, 0(s10)
	jal zero, LOCOM2
EP58:

addi a2, a2, -2
bge a2, zero, EP59
	addi a2, a2, 4
EP59:

lw a0, 0(s11)
lw a1, 4(s11)
la a3, col
jal checkMapCollision

beq a0, zero, EP60
	sb a2, 0(s10)
	jal zero, LOCOM2
EP60:

TER1:
#tenta se mover para onde eu já estava indo

lw a0, 0(s11)
lw a1, 4(s11)
lb a2, 0(s10)
la a3, col
jal checkMapCollision

beq a0, zero, EP55
	jal LOCOM2
EP55:

beq s8, zero, TER2
	li s8, 0
	addi a2, a2, 1
	li t2, 4
	bne a2, t2, TER3
		li a2, 0
	TER3:
	jal zero, FDS
TER2:

#tenta se mover para o oposto de onde eu estava indo

lw a2, 0(s10)
addi a2, a2, -2
bge a2, zero, EP61
	addi a2, a2, 4
EP61:

lw a0, 0(s11)
lw a1, 4(s11)
la a3, col
jal checkMapCollision

beq a0, zero, EP62
	sb a2, 0(s10)
EP62:

LOCOM2:

mv a0, s11
mv a1, s10
jal changeEntityPos

la a0, col
lw a1, 8(s11)
lw a2, 12(s11)
lb a3, 0(s10)
la a4, enm2Col
lb a4, 0(a4)
jal moveEntityCollision


mv ra, s6
ret



normalMoveEnm3:
mv s6, ra
la s11, enm3Pos
la s10, enm3Move
la s9, enm3TpTimer

lw t0, 0(s9)
bne t0, zero, EP65
	jal TPTIME
EP65:
#----------------------------------------

addi t0, t0, -1
sw t0, 0(s9)
#tenta se mover pra a esquerda ou pra direita
li a7, 41
ecall
andi t0, a0, 1

lb a2, 0(s10)

beq t0, zero, BBC2
	addi a2, a2, 1
	li t0, 4
	bne a2, t0, EP562
		addi a2, a2, -4
	EP562:
	jal zero, BTT2
BBC2:
	addi a2, a2, -1
	li t0, -1
	bne a2, t0, EP572
		addi a2, a2, 4
	EP572:
BTT2:

lw a0, 0(s11)
lw a1, 4(s11)
la a3, col
jal checkMapCollision

beq a0, zero, EP582
	sb a2, 0(s10)
	jal zero, LOCOM22
EP582:

addi a2, a2, -2
bge a2, zero, EP592
	addi a2, a2, 4
EP592:

lw a0, 0(s11)
lw a1, 4(s11)
la a3, col
jal checkMapCollision

beq a0, zero, EP602
	sb a2, 0(s10)
	jal zero, LOCOM22
EP602:

#tenta se mover para onde eu já estava indo

lw a0, 0(s11)
lw a1, 4(s11)
lb a2, 0(s10)
la a3, col
jal checkMapCollision

beq a0, zero, EP552
	jal LOCOM22
EP552:

#tenta se mover para o oposto de onde eu estava indo

lw a2, 0(s10)
addi a2, a2, -2
bge a2, zero, EP612
	addi a2, a2, 4
EP612:

lw a0, 0(s11)
lw a1, 4(s11)
la a3, col
jal checkMapCollision

beq a0, zero, EP622
	sb a2, 0(s10)
EP622:

LOCOM22:

mv a0, s11
mv a1, s10
jal changeEntityPos

la a0, col
la a1, enm3Pos
lw a2, 12(a1)
lw a1, 8(a1)
la a3, enm3Move
lb a3, 0(a3)
la a4, enm3Col
lb a4, 0(a4)
jal moveEntityCollision

#la a0, col
#lw a1, 8(s11)
#lw a2, 12(s11)
#lb a3, 0(s10)
#la a4, enm3Col
#lb a4, 0(a4)
#jal moveEntityCollision

mv ra, s6
ret
#----------------------------------------

TPTIME:

lw t0, 4(s9)
bne t0, zero, EP66

	
	la a0, enm3Pos
	lw a1, 4(a0)
	lw a0, 0(a0)
	la a2, mapa
	jal unrenderTile
	
	la t0, enm3Pos
	la a0, col
	lw a1, 0(t0)
	lw a2, 4(t0)
	li a3, 0
	jal collTileRender


	la t1, enm3TpAddress	

	lw t0, 0(t1)
	sw t0, 0(s11)
	lw t0, 4(t1)
	sw t0, 4(s11)
	lw t0, 0(t1)
	sw t0, 8(s11)
	lw t0, 4(t1)
	sw t0, 12(s11)

	la t2, playerPos
	lw t3, 4(t2)
	lw t2, 0(t2)
	
	sw t2, 0(t1)
	sw t3, 4(t1)
	
	li t0, 500
	sw t0, 0(s9)
	li t0, 80
	sw t0, 4(s9)
	mv ra, s6
	ret
EP66:

addi t0, t0, -1
sw t0, 4(s9)


mv ra, s6
ret

levelTransition:

la t0, level
lw t1, 0(t0)
addi t1, t1, 1
sw t1, 0(t0)

la t0, mapa
la t1, mp2rev

li t2, 76800
add t2, t2, t0
LP38:
	bge t0, t2, LE38
	#----------------
	lb t3, 0(t1)
	sb t3, 0(t0)
	#----------------
	addi t1, t1, 1
	addi t0, t0, 1
	jal LP38
LE38:

la t0, col
la t1, col2
li t2, 76800
add t2, t2, t0
LP39:
	bge t0, t2, LE39
	#---------------
	lb t3, 0(t1)
	sb t3, 0(t0)
	#---------------
	addi t1, t1, 1
	addi t0, t0, 1
	jal LP39
LE39:

la t0, playerPos
li t1, 16
sw t1, 0(t0)
sw t1, 4(t0)
sw t1, 8(t0)
sw t1, 12(t0)

la t0, enm1Pos
li t1, 288
li t2, 16
sw t1, 0(t0)
sw t1, 8(t0)
sw t2, 4(t0)
sw t2, 12(t0)

la t0, enm1State
li t1, 1
sb t1, 0(t0)

la t0, enm2Pos
li t1, 208
sw t1, 4(t0)
sw t1, 12(t0)
sw t2, 0(t0)
sw t2, 8(t0)

la t0, enm2State
li t1, 1
sb t1, 0(t0)

la t0, enm3Pos
li t2, 288
li t1, 208
sw t1, 4(t0)
sw t1, 12(t0)
sw t2, 0(t0)
sw t2, 8(t0)

la t0, enm3TpAddress
li t1, 16
sw t1, 0(t0)
sw t1, 4(t0)

la t0, enm3State
li t1, 1
sb t1, 0(t0)

la t0, enm4Pos
li t1, 128
li t2, 16
sw t1 0(t0)
sw t1, 8(t0)
sw t2, 4(t0)
sw t2, 12(s0)

la t0, enm4State
li t1, 1
sb t1, 0(t0)

la t0, counterPts
sb zero, 0(t0)

la t0, pts
la t1, ptsMap2

addi t2, t1, 232

LP40:
	bge t1, t2, LE40
	#---------------
	lw t3, 0(t1)
	sw t3, 0(t0)
	#---------------
	addi t1, t1, 4
	addi t0, t0, 4
	jal LP40
LE40:

la t0, supPts
la t1, supPtsMap2
addi t2, t1, 28

LP41:
	bge t1, t2, LE41
	#---------------
	lw t3, 0(t1)
	sw t3, 0(t0)
	#--------------
	addi t1, t1, 4
	addi t0, t0, 4
	jal LP41
LE41:

jal ST



musica:
la s0, notas
lw s1, 0(s0) #quantas notas existem
lw s2, 4(s0) #em que nota eu estou
lw s3, 8(s0) #quand a ultima nota foi tocada do 6

li t0, 12
mul s4, t0, s2
add s4, s4, s0  #endereço da nota atual do 6

li a7, 30
ecall

sub s5, a0, s3 # quanto tempo já se passou desde que a última nota foi tocada

lw t1, 4(s4)
bgtu t1, s5, MF0 
        #se já for pra tocar a próxima nota do, 6
	
	bne s2, s1, MF1
		li s2, 0
		mv s4, s0
	MF1:
        addi s4, s4, 12

        li a7, 31
        lw a0, 0(s4)
        lw a1, 4(s4)
        li a2, 0
        li a3, 60
        ecall

        li a7, 30
        ecall

        sw a0, 8(s0)

        addi s2, s2, 1
        sw s2, 4(s0)
        
MF0:
ret

normalMoveEnm4:
mv s6, ra
la s11, enm4Pos
la s10, enm4Move

TER410:
li s8, 0
#tenta se mover pra a esquerda ou pra direita
li a7, 41
ecall
andi t0, a0, 3

lb a2, 0(s10)

bne t0, zero, BBC10
	addi a2, a2, 1
	li t0, 4
	bne a2, t0, EP5610
		addi a2, a2, -4
	EP5610:
	jal zero, FDS10
BBC10:
li t1, 1
bne t0, t1, BTT10
	addi a2, a2, -1
	li t0, -1
	bne a2, t0, EP5710
		addi a2, a2, 4
	EP5710:
	jal zero, FDS10
BTT10:
li t1, 2
bne t0, t1, KSS10
	li s8, 1
	jal zero, TER110
KSS10:
	jal TER410
FDS10:

lw a0, 0(s11)
lw a1, 4(s11)
la a3, col
jal checkMapCollision

beq a0, zero, EP5810
	sb a2, 0(s10)
	jal zero, LOCOM210
EP5810:

addi a2, a2, -2
bge a2, zero, EP5910
	addi a2, a2, 4
EP5910:

lw a0, 0(s11)
lw a1, 4(s11)
la a3, col
jal checkMapCollision

beq a0, zero, EP6010
	sb a2, 0(s10)
	jal zero, LOCOM210
EP6010:

TER110:
#tenta se mover para onde eu já estava indo

lw a0, 0(s11)
lw a1, 4(s11)
lb a2, 0(s10)
la a3, col
jal checkMapCollision

beq a0, zero, EP5510
	jal LOCOM210
EP5510:

beq s8, zero, TER210
	li s8, 0
	addi a2, a2, 1
	li t2, 4
	bne a2, t2, TER310
		li a2, 0
	TER310:
	jal zero, FDS10
TER210:

#tenta se mover para o oposto de onde eu estava indo

lw a2, 0(s10)
addi a2, a2, -2
bge a2, zero, EP6110
	addi a2, a2, 4
EP6110:

lw a0, 0(s11)
lw a1, 4(s11)
la a3, col
jal checkMapCollision

beq a0, zero, EP6210
	sb a2, 0(s10)
EP6210:

LOCOM210:

mv a0, s11
mv a1, s10
jal changeEntityPos

la a0, col
lw a1, 8(s11)
lw a2, 12(s11)
lb a3, 0(s10)
la a4, enm4Col
lb a4, 0(a4)
jal moveEntityCollision


mv ra, s6
ret


changeDir:
la s0, enm1Move
la s1, enm2Move
la s2, enm3Move
la s3, enm4Move

lb t0, 0(s0)
addi t0, t0, 2
andi t0, t0, 3
sb t0, 0(s0)

lb t0, 0(s1)
addi t0, t0, 2
andi t0, t0, 3
sb t0, 0(s1)

lb t0, 0(s1)
addi t0, t0, 2
andi t0, t0, 3
sb t0, 0(s1)

lb t0, 0(s1)
addi t0, t0, 2
andi t0, t0, 3
sb t0, 0(s1)

ret



selectSpriteEnm1:

la s0, enm1Sprites
la s1, enm1Move

lb s1, 0(s1)

bne s1, zero, SPF1
	lw a2, 0(s0)
	ret
SPF1:

li t1, 1
bne s1, t1, SPF3
	lw a2, 4(s0)
	ret
SPF3:

li t1, 2
bne s1, t1, SPF2
	lw a2, 8(s0)
	ret
SPF2:

li t1, 3
bne s1, t1, SPF4
	lw a2, 12(s0)
	ret
SPF4:
lw a2, 12(s0)
ret
ret

selectSpriteEnm2:
la s0, enm2Sprites
la s1, enm2Move
lb s1, 0(s1)

bne s1, zero, SPF5
	lw a2, 0(s0)
	ret
SPF5:

li t1, 1
bne s1, t1, SPF6
	lw a2, 4(s0)
	ret
SPF6:

li t1, 2
bne s1, t1, SPF7
	lw a2, 8(s0)
	ret
SPF7:

li t1, 3
bne s1, t1, SPF8
	lw a2, 12(s0)
	ret
SPF8:
lw a2, 12(s0)
ret
ret

selectSpriteEnm3:
la s0, enm3Sprites
la s1, enm3Move
lb s1, 0(s1)

bne s1, zero, SPF9
	lw a2, 0(s0)
	ret
SPF9:

li t1, 1
bne s1, t1, SPF10
	lw a2, 4(s0)
	ret
SPF10:

li t1, 2
bne s1, t1, SPF11
	lw a2, 8(s0)
	ret
SPF11:

li t1, 3
bne s1, t1, SPN12
	lw a2, 12(s0)
	ret
SPN12:
lw a2, 12(s0)
ret
ret

selectSpriteEnm4:
la s0, enm4Sprites
la s1, enm4Move
lb s1, 0(s1)

bne s1, zero, SPF13
	lw a2, 0(s0)
	ret
SPF13:

li t1, 1
bne s1, t1, SPF14
	lw a2, 4(s0)
	ret
SPF14:

li t1, 2
bne s1, t1, SPF15
	lw a2, 8(s0)
	ret
SPF15:

li t1, 3
bne s1, t1, SPN16
	lw a2, 12(s0)
	ret
SPN16:
lw a2, 12(s0)
ret
ret
