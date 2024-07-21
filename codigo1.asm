.data

.include "mapa.data"
.include "bloco.data"
playerPos: .word 16, 16

.text

##################
# a0 -> o endereço de memória do primeiro pixel do 
# mapa a ser renderizado
##################

mapRender:
mv s6, ra
li s0, 76800 #numero de pixeis
li s1, 0xff000000 #endereço da tela
li t1, 0
LP1:
bge t1, s0, LE1
#---------------
add
#---------------
addi t1, t1, 1
jal LP1 
LE1:

