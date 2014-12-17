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

	ld		[%i1],%l1				! Obtention du compteur ordinal
	ld		[%i1+12],%l0		! Obtention du pointeur sur la memoire de la machine virtuelle
	ldub	[%l0+%l1],%l0		! Lecture du premier octet de linstruction courante
	cmp		%l0,0						! Est-ce linstruction HALT? (0x00)
	bnz 	decodeError			! sinon, le reste nest pas encore supporte: Erreur.
	nop										! ...

	st	%g0,[%i0]					! type dinstruction: systeme (0)
	st	%g0,[%i0+4]				! no doperation: 0 (HALT)

	mov	0,%i0							! code derreur 0: decodage reussi
	ret
	restore


decodeError:
	mov	1,%i0							! code derreur 1: instruction illegale.
	ret
	restore





EmuPush:
	save	%sp,-96,%sp


	mov	1,%i0
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
