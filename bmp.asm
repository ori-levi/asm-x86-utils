include 'files.asm'

DATASEG
	Header			db	54 		dup(0)
	Palette			db	256 * 4	dup(0)
	ScreenLine		db	320		dup(0)
	ErrorMessage	db	'Error', 13, 10, '$'
CODESEG

proc ReadHeader
	push ax bx cx dx

	mov ah, 3fh
	mov bx, [FileHandle]
	mov cx, 54
	mov dx, offset Header
	int 21h

	pop dx cx bx ax
	ret
endp ReadHeader

proc ReadPalette
	push ax cx bx

	mov ah, 3fh
	mov cx, 400h
	mov dx, offset Palette
	int 21h

	pop bx cx ax
	ret
endp ReadPalette

proc CopyPalette
	push ax cx dx si

	mov si, offset Palette
	mov cx, 256
	mov dx, 3c8h
	xor al, al
	out dx, al
	inc dx

PaletteLoop:
	mov al, [si + 2]
	shr al, 2
	out dx, al
	mov al, [si + 1]
	shr al, 2
	out dx, al
	mov al, [si]
	shr al, 2
	out dx, al
	add si, 4
	loop PaletteLoop

	pop si dx cx ax
	ret
endp CopyPalette

proc CopyBitmap
	push ax cx di si es	

	mov ax, 0a000h
	mov es, ax
	mov cx, 200

PrintBmpLoop:
	push cx
	mov di, cx
	shl cx, 6
	shl di, 8
	add di, cx

	mov ah, 3fh
	mov dx, offset ScreenLine
	int 21h

	cld
	mov cx, 320
	mov si, offset ScreenLine
	rep movsb

	pop cx
	loop PrintBmpLoop

	pop es si di cx ax
	ret
endp CopyBitmap