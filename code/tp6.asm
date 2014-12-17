.global Decode
.global EmuPush
.global EmuWrite
.global EmuPop
.global EmuRead
.global EmuAdd
.global EmuSub
.global EmuMul
.global EmuDiv
.global EmuBz
.global EmuBn
.global EmuJmp

.section ".text"

Decode:
	save	%sp,-96,%sp

	ld		[%i1], %l1				! Obtention du compteur ordinal
	ld		[%i1+12], %l0		  ! Obtention du pointeur sur la memoire de la machine virtuelle
	ldub	[%l0+%l1], %l7		! Lecture du premier octet de l instruction courante

	/* DEBUG */
	set		debug, %o0
	mov		%l0, %o1
	call	printf
	nop

	/* Type instruction */
	srl		%l7, 6, %l1			  ! On va aller chercher le type de l instruction
	and		%l1, 3, %l1

	/* Detection erreur */
	cmp		%l1, 3					  ! Si on ne connait pas le type de l instruction, erreur
	bg		DecodeError
	nop

	/* Ajouter le type d'instruction à l'instruction */
	st		%l1, [%i0]

	/* Switch-case */
	set		DecodeSwitch, %l2
	umul	%l1, 4, %l3
	jmp		%l2+%l3							! Jump a la fonction pour decoder le type d instruction
	nop

DecodeError:
	mov	1, %i0								! code d erreur 1: instruction illegale.
	ret
	restore


DecodeSwitch:
	ba,a	Decode00
	ba,a	Decode01
	ba,a	Decode10
	ba,a	Decode11


Decode00:
	/* Type d'operation */
	srl		%l0, 0, %l2
	and		%l2, 7, %l2		  	! On conserve juste les 3 derniers bits
	st		%l2, [%i0+4]			! On enregistre le type d operation

	/* Bit CC */
	mov		0, %l2
	st		%l2, [%i0+12]

	/* Bit Fl */
	mov		0, %l2
	st		%l2, [%i0+16]

	/* Size */
	mov		1, %l3
	st		%l3, [%i0+20]

	/* Retour */
	ba		DecodeFin
	nop


Decode01:
	/* Type d'operation */
	srl		%l7, 2, %l2
	and		%l2, 0xF, %l2			! On conserve juste les 4 derniers bits
	st		%l2, [%i0+4]			! On enregistre le type d operation

	set		debug3, %o0
	mov		%l0, %o1
	call	printf
	nop

	/* Bit CC */
	srl		%l0, 1, %l2				! On regarde l avant dernier bit de octet
	and		%l2, 1, %l2
	st		%l2, [%i0+12]

	/* Bit Fl */
	and		%l0, 1, %l2				! On garde juste le dernier bit de octet
	st		%l2, [%i0+16]

	/* Size */
	mov		3, %l3						! Taille de base = 3, max = 4
	add		%l3, %l2, %l3			! Si Float, alors 3+1=4, sinon 3+0=3
	st		%l3, [%i0+20]

	/* Operand */
	tst		%l2
	bne		Decode01_float
	nop

Decode01_int:
	inc		1, %l1
	ldub	[%l0+%l1], %l2
	inc		1, %l1
	ldub	[%l0+%l1], %l3
	sll		%l2, 8, %l2

	clr		%l6									! On prepare la creation de operande
	add		%l6, %l2, %l6
	add		%l6, %l3, %l6

	ba		Decode01Fin
	nop

Decode01_float:
	inc		1, %l1
	ldub	[%l0+%l1], %l2
	sll		%l2, 24, %l2
	inc		1, %l1
	ldub	[%l0+%l1], %l3
	sll		%l3, 16, %l3
	inc		1, %l1
	ldub	[%l0+%l1], %l4
	sll		%l4, 8, %l4
	inc		1, %l1
	ldub	[%l0+%l1], %l5

	clr		%l6									! On prepare la creation de operande
	add		%l6, %l2, %l6
	add		%l6, %l3, %l6
	add		%l6, %l4, %l6
	add		%l6, %l5, %l6

Decode01Fin:
	st		%l6, [%i0+8]				! On sauvegarde operande

	set		debug2, %o0
	mov		%l6, %o1
	call	printf
	nop

	ba		DecodeFin
	nop

Decode10:

	/* Retour */
	ba		DecodeFin
	nop

Decode11:

	/* Retour - A RETIRER */
	ba		DecodeFin
	nop

DecodeFin:
	mov	0 ,%i0								! code d erreur 0: decodage reussi
	ret
	restore


EmuPush:
	save	%sp,-96,%sp

	ld		[%i0+8], %l0			! Aller chercher l operand
	ld		[%i1+8], %l1			! Aller chercher PS
	ld		[%i1+12], %l2			! Pointeur vers memoire

	! Push
	umul	%l1, 4, %l3
	add		%l2, %l3, %l3			! Memory add + PS * 4
	st		%l0, [%l3]

	! Increment PS
	inc		2, %l1
	st		%l1, [%i1+8]			! Incrementer PS dans l etat de la machine

	mov	0, %i0
	ret
	restore

EmuWrite:
	save	%sp,-96,%sp


	mov	1,%i0
	ret
	restore

EmuPop:
	save	%sp,-96,%sp


	mov	1,%i0
	ret
	restore

EmuRead:
	save	%sp,-96,%sp


	mov	1,%i0
	ret
	restore



EmuAdd:
	save	%sp,-96,%sp


	mov	1,%i0
	ret
	restore

EmuSub:
	save	%sp,-96,%sp


	mov	1,%i0
	ret
	restore

EmuMul:
	save	%sp,-96,%sp


	mov	1,%i0
	ret
	restore

EmuDiv:
	save	%sp,-96,%sp


	mov	1,%i0
	ret
	restore


EmuBz:
	save	%sp,-96,%sp


	mov	1,%i0
	ret
	restore

EmuBn:
	save	%sp,-96,%sp


	mov	1,%i0
	ret
	restore

EmuJmp:
	save	%sp,-96,%sp


	mov	1,%i0
	ret
	restore


.section ".rodata"
	.align 4
debug:    .asciz "l0 = %x\n"
debug2:   .asciz "l6 = %x\n"
debug3:   .asciz "l2 = %x\n"
