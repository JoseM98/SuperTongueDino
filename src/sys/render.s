;;
;; SQUARE RENDER SYSTEM
;;
.include "cmp/entity.h.s"
.include "man/entity.h.s"
.include "cpctelera.h.s"
.include "cpct_functions.h.s"




.module sys_entity_render

.globl _hero_pal

;; //////////////////
;; Square Render System Constants
screen_start = 0xC000




;; //////////////////
;; Sys Render Init
;; Input: -
;; Destroy: AF, BC, DE, HL
sys_eren_init::
	ld	c, #0
	call cpct_setVideoMode_asm
	ld	hl, #_hero_pal
	ld	de, #16
	call cpct_setPalette_asm
	cpctm_setBorder_asm HW_WHITE
	ret



sys_eren_update::
	call sys_eren_render_entities

	ret



;; //////////////////
;; Sys Render Update
;; Input: IX -> Puntero al array de entidades,   A -> numero de elementos en el array
;; Destroy: AF, BC, DE, HL, IX
;; Stack Use: 2 bytes
sys_eren_render_entities::
	ld	(_ent_counter), a

_update_loop:
	;; Erase Previous Instance

	cpctm_setBorder_asm HW_RED


	ld 	e, e_lastVP_l(ix)
	ld	d, e_lastVP_h(ix)
	xor 	a
	ld	c, e_w(ix)
	ld 	b, e_h(ix)
	push	bc
	call	cpct_drawSolidBox_asm

	;; Calcular puntero a memoria de video
	ld	de, #screen_start
	ld	c, e_x(ix)
	ld	b, e_y(ix)
	call	cpct_getScreenPtr_asm

	;; Almacena el puntero de memoria de video al final
	ld	e_lastVP_l(ix), l
	ld	e_lastVP_h(ix), h

	;; Drae Entity Sprite
	ex	de, hl
	ld	l, e_pspr_l(ix)
	ld	h, e_pspr_h(ix)
	pop	bc
	call cpct_drawSprite_asm

	cpctm_setBorder_asm HW_WHITE

	_ent_counter = . + 1
		ld	a, #0
		dec	a
		ret 	z

		ld	(_ent_counter), a
		ld	bc, #sizeof_e
		add	ix, bc
		jr	_update_loop






sys_eren_update_obstacle::
	call sys_eren_render_obstacles

	ret

;; //////////////////
;; Sys Render Update Obstacles
;; Input: IY -> Puntero al array de entidades,   A -> numero de elementos en el array
;; Destroy: AF, BC, DE, HL, IY
;; Stack Use: 2 bytes
sys_eren_render_obstacles::
	ld	(_obs_counter), a

_update_loop_obstacles:
	;; Calcular puntero a memoria de video
	ld	de, #screen_start
	ld	c, obs_x(iy)
	ld	b, obs_y(iy)
	call	cpct_getScreenPtr_asm

	;; Almacena el puntero de memoria de video al final
	ld	obs_lastVP_l(iy), l
	ld	obs_lastVP_h(iy), h

	;; Drae Entity Sprite
	ex	de, hl
	ld	a, obs_color(iy)
	ld	c, obs_w(iy)
	ld 	b, obs_h(iy)
	call cpct_drawSolidBox_asm

	_obs_counter = . + 1
		ld	a, #0
		dec	a
		ret 	z

		ld	(_obs_counter), a
		ld	bc, #sizeof_obs
		add	iy, bc
		jr	_update_loop_obstacles




; -----------------------------------------------------
; ENEMIGOS
; -----------------------------------------------------
sys_eren_update_enemigo::
	call sys_eren_render_enemigos

	ret
;; //////////////////
;; Sys Render Update
;; Input: IX -> Puntero al array de entidades,   A -> numero de elementos en el array
;; Destroy: AF, BC, DE, HL, IX
;; Stack Use: 2 bytes
sys_eren_render_enemigos::
	ld	(_enemigo_counter), a

_update_loop_enemigo:
	;; Erase Previous Instance

	cpctm_setBorder_asm HW_RED


	ld 	e, enemigo_lastVP_l(ix)
	ld	d, enemigo_lastVP_h(ix)
	xor 	a
	ld	c, enemigo_w(ix)
	ld 	b, enemigo_h(ix)
	push	bc
	call	cpct_drawSolidBox_asm

	;; Calcular puntero a memoria de video
	ld	de, #screen_start
	ld	c, enemigo_x(ix)
	ld	b, enemigo_y(ix)
	call	cpct_getScreenPtr_asm

	;; Almacena el puntero de memoria de video al final
	ld	enemigo_lastVP_l(ix), l
	ld	enemigo_lastVP_h(ix), h

	;; Drae Entity Sprite
	ex	de, hl
	ld	l, enemigo_pspr_l(ix)
	ld	h, enemigo_pspr_h(ix)
	pop	bc
	call cpct_drawSprite_asm

	cpctm_setBorder_asm HW_WHITE

	_enemigo_counter = . + 1
		ld	a, #0
		dec	a
		ret 	z

		ld	(_enemigo_counter), a
		ld	bc, #sizeof_enemigo
		add	ix, bc
		jr	_update_loop_enemigo












sys_eren_clearScreen::
	ld   a, #0xC0
	ld   h, a
	ld de, #0
	ld   l, e
	ld  bc, #0x4000  
	jp cpct_memset_f64_asm