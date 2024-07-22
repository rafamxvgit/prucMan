.data

.include "mapa.data"
.include "bloco.data"
playerPos: .word 16, 16

.text

li s11, 0

la a0, mapa
addi a0, a0, 8
jal, mapRender

start:
addi s11, s11, 1

mv a0, s11
li a1, 16
la a2, bloco
addi a2, a2, 8
jal tileRender


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
