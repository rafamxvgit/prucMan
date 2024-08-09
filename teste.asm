.data
lastNoteStart: .word 0
currentNote: .word 0

notas: .word 5
65, 1000, 0, 127
66, 1000, 0, 127
67, 1000, 0, 127
68, 1000, 0, 127


.text

#-------------------------
la t0, lastNoteStart

li a7, 30
ecall

sw a0, 0(t0)

start:

#descobre o numero da nota atual
la t0, currentNote
lw t0, 0(t0)

#pega o endereço da primeia nota
la t1, notas
addi t1, t1, 4

#endereço da nota atual
slli t2, t0, 4
add t2, t2, t1

#descobre a duração da nota atual
lw s4, 0(t2)
lw s3, 4(t2)

#pega quando foi que a ultima nota começõu
la s0, lastNoteStart
lw s0, 0(s0)

#pega o tempo atual e coloca em s1
li a7, 30
ecall
mv s1, a0

#descobre o tempo decorrido desde quando a última nota foi tocada
#coloca o valor em s2
sub s2, s1, s0

bgt s3, s2, EP0
        mv a0, s4
        mv a1, s3
        li a3, 125
        li a7, 31

        ecall
        la t0, lastNoteStart

        li a7, 30
        ecall

        sw a0, 0(t0)

        la t0, currentNote
        lw t1, 0(t0)
        la t2, notas
        lw t2, 0(t2)
        bne t1, t2, EP1
                la t2, currentNote
                sw zero, 0(t2)
                mv t1, zero
        EP1: 
        addi t1, t1, 1
        sw t1, 0(t0)
EP0:



# espera um tempinho
li a7, 32
li a0, 15
ecall

jal start
#-------------------------
