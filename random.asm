DATASEG
	RND_Seed	DW	?
	RND_CLOCK 	equ	es:6Ch

CODESEG

proc InitRandom
	; --------------------------
	; InitRandom Proc
	; Initialize the random seed with the clock.
	;
	; Return:
	;	None
	; --------------------------
	push ax es

	mov ax, 40h
    	mov es, ax
    	mov ax, [RND_CLOCK]
	mov [RND_Seed], ax

	pop es ax
	ret
endp InitRandom

proc GenerateRandNum
	; --------------------------
	; GenerateRandNum Proc
	; Generates a pseudo-random 15-bit number.
	;
	; NOTE:
	;   the algorithm describe http://stackoverflow.com/a/43978947/5380472
	;
	; Return Value -> AX:
	;   AX contains the random number.
	; --------------------------
	push bx cx si di

	; 32-bit multiplication in 16-bit mode (DX:AX * CX:BX == SI:DI)
	mov  ax, [RND_Seed]
	xor  dx, dx
	mov  cx, 041C6h
	mov  bx, 04E6Dh
	xor  di, di
	push ax
	mul  bx
	mov  si, dx
	xchg di, ax
	mul  bx
	add  si, ax
	pop  ax
	mul  cx
	add  si, ax

	; Do addition
	add  di, 3039h
	adc  si, 0

	; Save seed
	mov  [RND_Seed], di

	; Get result and mask bits
	mov  ax, si
	and  ah, 07Fh

	pop  di si cx bx
	ret
endp GenerateRandNum
