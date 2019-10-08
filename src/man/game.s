;;
;;  GAME MANAGER
;;

.include "cpctelera.h.s"
.include "sys/render.h.s"
.include "cmp/entity.h.s"
.include "sys/physics.h.s"
.include "sys/render.h.s"
.include "sys/input.h.s"
.include "man/entity.h.s"
.include "sys/ai_control.h.s"
.include "sys/menuIngame.h.s"
;.include "sys/colisions.h.s"


.module game_manager

bool_mostrar_menu: .db #0


.globl _hero_sp_1
.globl _hero_sp_0

;; Manager Variables
ent1: DefineCmp_Entity 50,    40,    0,    0, 4,  8, _hero_sp_1, e_ai_st_noAI
ent2: DefineCmp_Entity 70,  0, 0xFF, 0xFE, 4,  8, _hero_sp_0, e_ai_st_stand_by
;ent3: DefineCmp_Entity 40, 120,    2, 0xFC, 4,  8, _hero_sp_0, e_ai_st_stand_by
;ent4: DefineCmp_Entity 50,  20,    2, 0xFC, 4,  8, _hero_sp_0, e_ai_st_stand_by

obst1: DefineCmp_Obstacle  0, 121,    12, 8, 0x0F
obst2: DefineCmp_Obstacle 40, 70,    4, 80, 0x0F
obst3: DefineCmp_Obstacle 60, 101,    20, 8, 0x0F
obst4: DefineCmp_Obstacle  0, 150,   40, 8, 0x0F
obst5: DefineCmp_Obstacle  40, 150,   40, 8, 0x0F
obst6: DefineCmp_Obstacle  0, 40,    24, 8, 0x0F


enemigo1: DefineCmp_Enemigo 70,  20, 0, 0, 4,  8, _hero_sp_0, enemigo_ia_noIA

;; //////////////////
;; Manager Game Init
;; Input: -
;; Destroy: AF, BC, DE, HL, IX
man_game_init::
	;; Obstacle manager
	call man_obstacle_init

	ld hl, #obst1
	call man_obstacle_create
	ld hl, #obst2
	call man_obstacle_create
	ld hl, #obst3
	call man_obstacle_create
	ld hl, #obst4
	call man_obstacle_create
	ld hl, #obst5
	call man_obstacle_create
	ld hl, #obst6
	call man_obstacle_create
 
 	;; nos da el puntero al array de obstaculos
	call man_obstacle_getArray
	;; TEMPORANEO!!! Para comprobar coliones, despues no se renderizara
	call sys_eren_update_obstacle


;======================================================0


	;; Entity manager
	call man_entity_init

	
	;; Init Systems
	call man_entity_getArray
	call sys_ai_control_init
	call sys_eren_init
	call sys_physics_init
	call sys_input_init

	;; Init 3 entities
	ld hl, #ent1
	call man_entity_create
	ld hl, #ent2
	call man_entity_create
	;ld hl, #ent3
	;call man_entity_create
	;ld hl, #ent4
	;call man_entity_create

	call man_enemigo_init

	ld hl, #enemigo1
	call man_enemigo_create


	ret



;; //////////////////
;; Manager Game Update
;; Input: -
;; Destroy: -
man_game_update::				;; MEJORAR!!! esto ya que estoy pasando IX al update y se puede pasar en el Init

	;ld	a, e_x(ix)
	;add	e_vx(ix)
	;ld	c, a
	;ld	a, e_vx(ix)
	;sub	c
	;jr	z, continuar
	;jr	c, sprite_1
	;	ld	hl, #_hero_sp_1
	;	ld	e_pspr_l(ix), l
	;	ld	e_pspr_h(ix), h
	;	jr continuar
;sprite_1:
;	ld	hl, #_hero_sp_0
;	ld	e_pspr_l(ix), l
;	ld	e_pspr_h(ix), h
;continuar:

	ld a, (#bool_mostrar_menu) ;; comprobacion menu ingame abierto
	dec a
	jr z, #update_menuIngame


	call man_entity_getArray
	call sys_input_update


	call man_entity_getArray
	call sys_ai_control_update


	call man_entity_getArray
	call sys_physics_update

	ret

update_menuIngame:
	call menuIngame_update
	call menuIngame_input
	ret



;; //////////////////
;; Manager Game Render
;; Input: -
;; Destroy: -
man_game_render::
	ld a, (#bool_mostrar_menu) ;; comprobacion menu ingame abierto
	dec a
	jr z, #render_menuIngame

	cpctm_setBorder_asm HW_RED
	call man_entity_getArray
	call sys_eren_update
	call man_enemigo_getArray
	call sys_eren_update_enemigo
	cpctm_setBorder_asm HW_WHITE

	ret
render_menuIngame:
	call menuIngame_render
	ret




; ===============
; Elimina: A
abrir_cerrar_menuIngame::
	ld a, (#bool_mostrar_menu) ;; comprobacion menu ingame abierto
	dec a
	jr z, #cerrar_menuIngame
	abrir_menuIngame:
	ld a, #1
	ld (#bool_mostrar_menu), a
	call menuIngame_init
	ret
	
	cerrar_menuIngame:
	ld a, #0
	ld (#bool_mostrar_menu), a
	call sys_eren_clearScreen

	;; nos da el puntero al array de obstaculos
	call man_obstacle_getArray
	;; TEMPORANEO!!! Para comprobar coliones, despues no se renderizara
	call sys_eren_update_obstacle

	ret