.data
.include "mapa.data"
.include "bloco.data"
playerPos: .word 16, 16

.text
#beq, zero, zero, playerRender
mapRender:
li 	t1, 0
li 	t2, 76800
li	t0, 0xff000000
la 	s0, mapa
addi 	s0, s0, 8

	LOOP: #esse loop coloca todos os valores na tela
	bge 	t1, t2, LE
	#-------------------
	add 	t3, s0, t1
	lb 	t4, 0(t3)
	add 	t5, t0, t1
	sb 	t4, 0(t5)
	#-------------------
	addi 	t1, t1, 1
	jal 	zero, LOOP
LE:

inicio:
la t1, playerPos
lw t2, 0(t1)
addi t2, t2, 1
sb t2, 0(t1)

playerRender:
la 	s0, playerPos
lw 	t0, 0(s0) #posicao x
lw 	t3, 4(s0) #posicao y
li 	t4, 320
mul 	s0, t3, t4
add 	s0, s0, t0
li 	t4, 0xff000000

add 	s0, s0, t4 #posicao do player em espaço de memória
la	s6, bloco
addi	s6, s6, 8 #endereço da imagem do player
li 	t1, 0 #contador do loop
li	t3, 16 #ponto de parada
	LOOPY:
	bge 	t1, t3, LOOPYEND
	#--------------
	li 	t2, 0
		LOOPX:
		bge 	t2, t3, LOOPXEND
		#---------------------
		mul 	t0, t3, t1
		add 	t0, t0, t2 #pixel a ser mostrado
		add 	t0, t0, s6
		lb 	t0, 0(t0)
		
		li 	t5, 320
		mul 	t4, t1, t5
		add 	t4, t4, t2
		add 	t4, t4, s0
		
		sb 	t0, 0(t4)
		
		
		#---------------------
		addi 	t2, t2, 1
		jal 	zero, LOOPX
	LOOPXEND:
	#--------------
	addi 	t1, t1, 1
	jal 	zero, LOOPY
LOOPYEND:

la t0, playerPos
lb a0, 0(t0)
lb a1, 4(t0)

li a7, 32
li a0, 20
ecall

unrenderTile: #remove o tile da posição definida por a0, a1
li 	s0, 320
li 	s1, 0xff000000
la s2, mapa
addi s2, s2, 8

li 	t1, 0 #contador do loop
li 	t3, 16 #ponto de parada
	LOOPUNY:
	bge 	t1, t3, LOOPUNYEND
	#----------------------
	li 	t2, 0
		LOOPUNX:
		bge 	t2, t3, LOOPUNXEND
		#----------------------
		add t0, t1, a1 
		mul t0, t0, s0
		add t0, t0, a0
		add t0, t0, t2

		add t4, t0, s2
		lb t5, 0(t4)

		add t4, t0, s1
		sb t5, 0(t4)
			
		#----------------------
		addi 	t2, t2, 1
		jal 	zero, LOOPUNX
	LOOPUNXEND:
	#----------------------
	addi 	t1, t1, 1
	jal 	zero, LOOPUNY
LOOPUNYEND:

jal 	zero, inicio


