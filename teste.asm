.data
.include "mapa2.data"




.text

la a0, mapa2
addi a0, a0, 8
jal, mapRender


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


