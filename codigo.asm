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

enm1Pos: .word 48, 16, 48, 16
enm1Move: .byte 0
enm1Vals: .byte 100, 1, 1 #corDeColisão #estadoAtual #estadoAnterior

enm2Pos: .word 48, 16, 48, 16
enm2Move: .byte 0
enm2Vals: .byte 100, 1, 1 #corDeColisão #estadoAtual #estadoAnterior

enm3Pos: .word 48, 16, 48, 16
enm3Move: .byte 0
enm3Vals: .byte 100, 1, 1 #corDeColisão #estadoAtual #estadoAnterior

enm4Pos: .word 48, 16, 48, 16
enm4Move: .byte 0
enm4Vals: .byte 100, 1, 1 #corDeColisão #estadoAtual #estadoAnterior

counterPts: .byte 0
counterNaoMexe: .byte 0
supPtMode: .word 0

pts:
.word 5,
2,16,80, 
3,48,80, 
4,80,80,
5,112,80,
6,144,80

supPts:
.word 1,
7, 96, 80

fnMem1: .word 0,0,0,0,0,0,0,0
fnMem2: .word 0,0,0,0,0,0,0,0

.include "nums.data"
.include "normalPoint.data"
.include "ptMax.data"
.include "mapa.data"
.include "col.data"
.include "gato1.data"

.include "p00.data"
.include "p01.data"
.include "p02.data"
.include "p03.data"

.include "p20.data"
.include "p21.data"
.include "p22.data"
.include "p23.data"

.text

#renderiza o mapa
la a0, mapa
jal mapRender

#renderiza a colisao inicial do inimigo 1
la a0, col
la a1, enm1Pos
lw a2, 4(a1)
lw a1, 0(a1)
la a3, enm1Vals
lb a3, 0(a3)
jal collTileRender

#início do game loop
start:
#-------------------

#lê a intenção do player
jal readKeyboard

#define a movimentação do player.
jal movePlayer

#move o player.
la a0, playerPos
la a1, playerMove
jal changeEntityPos

la a0, playerPos
lw a1, 4(a0)
lw a0, 0(a0)
jal returnCol

#checa os casos de colisão
jal collisionCases

#renderiza a colisão dos pontos. do
jal rendPtsColl

#desrenderiza o player. do
la a0, playerPos
lw a1, 12(a0)
lw a0, 8(a0)
la a2, mapa
jal unrenderTile

#renderiza os pontos
jal renderPoints

#renderiza o player. do
la a0, playerPos
lw a1, 4(a0)
lw a0, 0(a0)
la a2, p03
addi a2, a2, 8
jal tileRender

# espera um tempinho. do
li a7, 32
li a0, 15
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

################################
# renderiza a colisão dos pontos
################################

rendPtsColl:
la s0, pts
la s4, col
lw t0, 0(s0) #n pts
addi s0, s0, 4
li t1, 12
mul t0, t0, t1
add t0, t0, s0

LP8:
	bge s0, t0, LE8
	#--------------
	lw s1, 0(s0) # cor
	lw s2, 4(s0) # x
	lw s3, 8(s0) # y

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
	addi s0, s0, 12
	jal zero, LP8
LE8:

ret

####################
#Renderiza os pontos
####################

renderPoints:
la s0, pts
li s1, tela
li s5, 320
la s7, normalPoint
addi s7, s7, 8
lw s2, 0(s0) #n pts
addi s0, s0, 4
li t0, 12
mul s2, s2, t0
add s2, s2, s0

LP9:
	bge s0, s2, LE9
	#--------------
	lw t0, 0(s0) # cor do ponto
	beq t0, zero, EP21
		lw s3, 4(s0) # x
		addi s3, s3, 4
		lw s4, 8(s0) # y
		addi s4, s4, 4
		mv s8, s7 #imagem
		
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
	addi s0, s0, 12
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

#checa a colisão com os inimigos

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
