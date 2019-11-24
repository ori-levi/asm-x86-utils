DATASEG
	FileHandle			dw	?
	OpenErrorMessage	db	'Failed to open the file.', 13, 10, '$'

	FILENAME_OFFSET	equ	[bp + 4]
CODESEG

proc OpenFile
	push bp
	mov bp, sp

	push ax dx

	mov ah, 3dh
	xor al, al
	mov dx, FILENAME_OFFSET
	int 21h

	jc @@Error
	mov [FileHandle], ax
	jmp @@return
	mov dx, offset OpenErrorMessage
	mov ah, 9h
	int 21h

@@return:
	pop dx ax bp
	ret 2
endp OpenFile

proc CloseFile
	push ax bx

	mov ah, 3eh
	mov bx, [FileHandle]
	int 21h

	pop bx ax
	ret
endp CloseFile