.data

.include "mapa.data"
.include "bloco.data"
playerPos: .word 16, 16
playerMove: .byte 1, 0

.text

la a0, mapa
addi a0, a0, 8
jal, mapRender

start:

jal readKeyboard

la t0, playerMove
la t1, playerPos

lw s10, 0(t1)
lw s11, 4(t1)
lb s0, 0(t0)
lb s1, 1(t0)

# muda a posição do player
add s10, s10, s0
add s11, s11, s1

sw s10, 0(t1)
sw s11, 4(t1)

# renderiza o player
mv a0, s10
mv a1, s11
la a2, bloco
addi a2, a2, 8
jal tileRender

# espera um tempinho
li a7, 32
li a0, 20
ecall

# desrenderiza o player
la t1, playerPos
lw a0, 0(t1)
lw a1, 4(t1)
la a2, mapa
addi a2, a2, 8
jal tileUnrender

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
la s5, playerMove
li s3, 1 # <- o número 1 :)
li s4, -1 # <- o número -1 :)
beq s1, zero, EP1
	#caso alguma coisa tenha sido teclada execute isso aqui
	li t0, 119
	bne s2, t0, EP2
		sb zero, 0(s5)
		sb s4, 1(s5)
	EP2:
	
	li t0, 97
	bne s2, t0, EP3
		sb s4, 0(s5)
		sb zero, 1(s5)
	EP3:
	
	li t0, 115
	bne s2, t0, EP4
		sb zero, 0(s5)
		sb s3, 1(s5)
	EP4:
	
	li t0, 100
	bne s2, t0, EP5
		sb s3, 0(s5)
		sb zero, 1(s5)
	EP5:
EP1:
mv ra, s6
ret

