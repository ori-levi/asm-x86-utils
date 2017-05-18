proc GenerateRandNum
    ; --------------------------
    ; GenerateRandNum Proc
    ; Generates a pseudo-random 15-bit number.
    ;
    ; NOTE:
    ;   your code MUST contains a variable with the name RNG_Seed with initial seed to the random algorithem.
    ;   the algorithm describe http://stackoverflow.com/a/43978947/5380472
    ;
    ; Return Value -> AX:
    ;   AX contains the random number.
    ; --------------------------
   push bx cx si di

   ; 32-bit multiplication in 16-bit mode (DX:AX * CX:BX == SI:DI)
   mov  ax, [RNG_Seed]
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
   mov  [RNG_Seed], di

   ; Get result and mask bits
   mov  ax, si
   and  ah, 07Fh

   pop  di si cx bx
   ret
endp GenerateRandNum
