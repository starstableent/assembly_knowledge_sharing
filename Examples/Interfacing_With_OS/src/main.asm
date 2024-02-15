.data

HEAP_GENERATE_EXCEPTIONS equ 004h
HEAP_NO_SERIALIZE equ 001h
HEAP_ZERO_MEMORY equ 008h

.code

; Win32 functions
extern ExitProcess : proc
extern GetProcessHeap : proc
extern HeapAlloc : proc
extern HeapFree : proc
extern HeapDestroy : proc
extern MessageBoxA : proc

main proc
    ; Setup stack
    mov r12, rsp                    ; Cache stack ptr
    and rsp, 0fffffff0h             ; 16-bit align stack pointer. Some functions (MessageBoxA) seem to require it
    sub rsp, 32                     ; Allocate shadow space for all the following function calls since none of them need to push arguments to the stack

    call GetProcessHeap             ; Returns ptr to heap handle in rax
    mov r13, rax                    ; Cache heap handle for later

    ; Allocate 6 bytes for string
    mov r8, 6                       ; SIZE_T dwBytes
    mov rdx, HEAP_ZERO_MEMORY       ; DWORD  dwFlags
    mov rcx, rax                    ; HANDLE hHeap                        

    call HeapAlloc                  ; Returns ptr to allocated in rax
    mov r14, rax                    ; Cache memory ptr for later

    ; Set string characters
    mov byte ptr [rax], "H"
    mov byte ptr [rax + 1], "e"
    mov byte ptr [rax + 2], "l"
    mov byte ptr [rax + 3], "l"
    mov byte ptr [rax + 4], "o"
    mov byte ptr [rax + 5], 0 
    
    ; Create message box that displayes allocated string
    mov r9d, 0                      ; uType (style of message box)
    mov r8d, 0                      ; lpCaption (pointer to title of message box)
    mov rdx, rax                    ; lpText (pointer to text in message box)
    mov rcx, 0                      ; hWnd (handle to owner window)

    call MessageBoxA

    ; Deallocate heap memory for string
    mov r8, r14     ; _Frees_ptr_opt_ LPVOID lpMem
    mov rdx, 0      ; DWORD dwFlags
    mov rcx, r13    ; HANDLE hHeap

    call HeapFree

    ; Destroy heap
    mov rcx, r13 ; HANDLE hHeap

    call HeapDestroy

    mov rsp, r12 ; Restore stack
    
    ret 
main endp    

end