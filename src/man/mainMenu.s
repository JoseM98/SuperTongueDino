;;
;; MENU PRINCIPAL
;;
.include "cpctelera.h.s"
.include "cpct_functions.h.s"
.include "sys/render.h.s"
.include "man/state.h.s"

.globl _hero_pal
string_menuIngame_info: .asciz "Menu Principal"
string_menuIngame_jugar: .asciz "Enter to play"


;//////////// INTI
; Elimina: HL, DE, BC, IY
man_mainMenu_init::
	ld	c, #0
	call cpct_setVideoMode_asm
	ld	hl, #_hero_pal
	ld	de, #16
	call cpct_setPalette_asm
	cpctm_setBorder_asm HW_WHITE
	;call sys_eren_init	;; va a dibujar el mapa, CORREGIR!!!

	call sys_eren_clearScreen

	;; Set up draw char colours before calling draw string ;; Pone colores de fondo y letra
	ld    l, #3         ;; D = Background PEN (0)
	ld    h, #0         ;; E = Foreground PEN (3)
	call cpct_setDrawCharM0_asm   ;; Set draw char colours

	;///////// Texto 1
	;; Calculate a video-memory location for printing a string
	ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
	ld    b, #24                  ;; B = y coordinate (24 = 0x18)
	ld    c, #2                  ;; C = x coordinate (16 = 0x10)
	call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

	;; Print the string in video memory
	;; HL already points to video memory, as it is the return
	;; value from cpct_getScreenPtr_asm
	ld   IY, #string_menuIngame_info   ;; IY = Pointer to the string 
	call cpct_drawStringM0_asm  ;; Draw the string


	;///////// Texto 2
	;; Calculate a video-memory location for printing a string
	ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
	ld    b, #48                ;; B = y coordinate (24 = 0x18)
	ld    c, #2                  ;; C = x coordinate (16 = 0x10)
	call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

	;; Print the string in video memory
	;; HL already points to video memory, as it is the return
	;; value from cpct_getScreenPtr_asm
	ld   IY, #string_menuIngame_jugar    ;; IY = Pointer to the string 
	call cpct_drawStringM0_asm  ;; Draw the string

	ret



man_mainMenu_update::
	call mainMenu_input
	ret



man_mainMenu_render::
	ret



; Elimina: HL, A
mainMenu_input:
	call cpct_scanKeyboard_f_asm

	ld	hl, #Key_Return
	call cpct_isKeyPressed_asm
	jr	z, Return_NotPressed_mainMenu
Return_Pressed_mainMenu:
	ld	a, #1
	call man_state_setEstado  ;; cambia el estado

Return_NotPressed_mainMenu:
	ret