section	.text

    global _start

_start:	                
    mov eax, 4
    mov ebx, 1
    mov ecx, setcolor
    mov edx, setcolor.len
    int 80h

    mov rax, mem
    call _print
    call _delay

    mov rax, cpu_fan
    call _print
    call _delay

    mov rax, post
    call _print
    call _delay

    mov rax, boot
    call _print
    call _delay

back_cls:

    call _delay
    ;call _cls

    mov rax, welcome5
    call _print

back:
  
    call _color   
 
    mov rax, bash
    call _print

    call _defaultcolor

;read input
;   mov eax, 3
;   mov ebx, 2
;   mov rcx, num  
;   mov edx, 5         
;   int 80h

compare:
;read input
    xor rax, rax
    mov rdi, rax
    mov rsi, userpass
    mov rdx, rax
    add rdx, 0x64 ; 100 
    syscall
;shutdown
    lea rdi, [shutdownf]
    lea rsi, [userpass]
    mov rcx, shutlen
    repe cmpsb 
    je _exit
;print name
    lea rdi, [names]
    lea rsi, [userpass]
    mov rcx, nameslen
    repe cmpsb 
    je _pname
;print pi
    lea rdi, [pif]
    lea rsi, [userpass]
    mov rcx, pilen
    repe cmpsb 
    je _printpi
;clear screen
    lea rdi, [clsf]
    lea rsi, [userpass]
    mov rcx, clslen
    repe cmpsb 
    je _cls 
;help
    lea rdi, [helpf]
    lea rsi, [userpass]
    mov rcx, helplen
    repe cmpsb 
    je _help 
;in case of error 
    mov rax, error
      call _print

jmp back

_exit:

   mov rax, shut
   call _print
   mov dword [tv_sec], 2 
   mov dword [tv_usec], 0
   mov eax, 162
   mov ebx, timeval
   mov ecx, 0
   int 0x80
   mov	rax, 1
   xor	rbx, rbx
   int	80h

_print:

    push rax
    mov rbx, 0

_printLoop:

    inc rax
    inc rbx
    mov cl, [rax]
    cmp cl, 0
    jne _printLoop
    mov rax, 1
    mov rdi, 1
    pop rsi
    mov rdx, rbx
    syscall
    ret

_pname:

    mov rax,name
    call _print
    jmp back

_cls:

    mov eax, 4                         
    mov ebx, 1                          
    mov ecx, ClearTerm                  
    mov edx, CLEARLEN                  
    int 80h
    jmp back

_delay:

    mov dword [tv_sec], 0
    mov dword [tv_usec], 0
    mov eax, 162
    mov ebx, timeval
    mov ecx, 0
    int 0x80
    ret

_printpi:

   mov rax, pi
   call _print
   jmp back   

_help:

   mov rax, helplist
   call _print
   jmp back

_color:

   mov eax, 4
   mov ebx, 1
   mov ecx, setcolor
   mov edx, setcolor.len
   int 80h
   ret

_defaultcolor:

    mov eax, 4
    mov ebx, 1
    mov ecx, defaultcolor
    mov edx, defaultcolor.len
    int 80h
    ret

section .bss     
      
   num resb 64
	
section	.data
   mem    	db	"Checking memory",0xa,0
   cpu_fan db "Checking CPU fan", 0xa,0
   post db "POST completed succesfully. Looking for boot signatures...",0xa,0
   boot db "Booting OS",0xa,0
   welcome1 db "......................",0xa,0 
   welcome2 db ".Welcome To My catOS.",0xa,0
   welcome3 db "......................",0xa,0
   welcome4 db "" , 0xa,0
   name db "Catalin",0xa,0
   shut db "Shutting down...",0xa,0
   ClearTerm: db   27,"[H",27,"[2J"    ; <ESC> [H <ESC> [2J
   CLEARLEN   equ  $-ClearTerm         ; Length of term clear string
   bash db "catOS#: ",0
   error db "command not found, try again" , 0xa,0
   welcome5 db "Please remember only 32-bit commands are accepted." ,0xa,0
   pi db "3.14", 0xa,0	
   helplist db "The following commands are present:" , 0xa , "cls", 0xa , "help", 0xa , "pi", 0xa , "shutdown", 0xa , "name" , 0xa , 0
   timeval:
    tv_sec  dd 0
    tv_usec dd 0
   time:   dq      0
   shutdownf db 'shutdown', 0xa  
   shutlen equ $ - shutdownf
   names db 'name', 0xa  
   nameslen equ $ - names 
   pif db 'pi', 0xa  
   pilen equ $ - pif
   clsf db 'cls', 0xa  
   clslen equ $ - clsf
   helpf db 'help', 0xa  
   helplen equ $ - helpf
   userpass times 100 db 0
   uplen equ $ - userpass
   setcolor db 1Bh, '[32;40m', 0  ; cyan on black
   .len equ $ - setcolor
   defaultcolor db 1Bh, '[37;40m', 0  ; white on black
   .len equ $ - defaultcolor

