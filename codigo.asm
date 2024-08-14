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


counterPts: .byte 0
counterNaoMexe: .byte 0
supPtMode: .word 0

pts1:
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

#define a movimentação do player
jal playerMove

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

readKeyboard:
li s0, mmio
lb s1, 0(s0)
andi s1, s1, 1 #bit de controle
lw s2, 4(s0) #tecla pressionada
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

playerMove:

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

EP6:
