;;
;; Entity COMPONENT
;;
;;

max_entities == 4

;; Defines a new entity component
.macro DefineCmp_Entity _x, _y, _vx, _vy, _w, _h, _pspr, _aist
	.db 	_x, _y	
	.db	_vx, _vy
	.db	_w, _h
	.dw	_pspr		;; puntero del sprite
	.db	0x00, 0x00	;; pos X e Y del objetivo
	.db	_aist		;; estatus del tipo de IA
	.dw	0xCCCC	;; Last video memory pointer value
.endm

e_x		= 0
e_y		= 1
e_vx		= 2
e_vy		= 3
e_w		= 4
e_h		= 5
e_pspr_l	= 6
e_pspr_h	= 7
e_ai_aim_x	= 8
e_ai_aim_y  = 9
e_ai_st	= 10
e_lastVP_l	= 11
e_lastVP_h	= 12
sizeof_e	= 13


;; Enumeracion de tipos de IA
e_ai_st_noAI	= 0
e_ai_st_stand_by	= 1
e_ai_st_move_to	= 2


;; Default constructor for entity components
.macro DefineCmp_Entity_default
	DefineCmp_Entity 0, 0, 0, 0, 1, 1, 0x0000, e_ai_st_noAI  ;; reserva el espacio de una entidad, NO!! crea una entidad
.endm

;; Defines entity array for components
;.macro DefineCmpArray_Entity _N
;	.rept _N
;		DefineCmp_Entity_default
;	.endm
;.endm



;;
;; Entity COMPONENT
;;
;;

max_obstacles == 6

;; Defines a new entity component
.macro DefineCmp_Obstacle _x, _y, _w, _h, _color
	.db 	_x, _y	
	.db	_w, _h
	.db	_color
	.dw	0xCCCC	;; Last video memory pointer value
.endm

obs_x		 = 0
obs_y		 = 1
obs_w		 = 2
obs_h		 = 3
obs_color	 = 4
obs_lastVP_l = 5
obs_lastVP_h = 6
sizeof_obs	 = 7

;; Default constructor for entity components
.macro DefineCmp_Obstacle_default
	DefineCmp_Obstacle 0, 0, 0, 0, 0xFF
.endm

;; Defines entity array for components
;.macro DefineCmpArray_Obstacle _N
;	.rept _N
;		DefineCmp_Obstacle_default
;	.endm
;.endm






; ///////////////////////////////////////
;	ENEMIGOS
; //////////////////////////////////////
max_enemigos == 6

;; Definir un nuevo enemigo
.macro DefineCmp_Enemigo _x, _y, _vx, _vy, _w, _h, _pSprite, _tipoIA
	.db 	_x, _y	
	.db	_vx, _vy
	.db	_w, _h
	.dw	_pSprite		;; puntero del sprite
	.db	0x00, 0x00	;; pos X e Y del objetivo
	.db	_tipoIA		;; estatus del tipo de IA
	.dw	0xCCCC	;; Last video memory pointer value
.endm

enemigo_x		= 0
enemigo_y		= 1
enemigo_vx		= 2
enemigo_vy		= 3
enemigo_w		= 4
enemigo_h		= 5
enemigo_pspr_l	= 6
enemigo_pspr_h	= 7
enemigo_ai_aim_x	= 8
enemigo_ai_aim_y  = 9
enemigo_ai_st	= 10
enemigo_lastVP_l	= 11
enemigo_lastVP_h	= 12
sizeof_enemigo	= 13


;; Enumeracion de tipos de IA para el enemigo
enemigo_ia_noIA		= 0
enemigo_ia_stand_by	= 1
enemigo_ia_move_to	= 2


;; Default constructor for entity components
.macro DefineCmp_Enemigo_default
	DefineCmp_Enemigo 0, 0, 0, 0, 1, 1, 0x0000, enemigo_ia_noIA  ;; reserva el espacio de una entidad, NO!! crea una entidad
.endm






; ///////////////////////////////////////
;	BALAS
; //////////////////////////////////////
max_balas == 10

;; Defines a new entity component
.macro DefineCmp_Bala _x, _y, _w, _h, _color
	.db 	_x, _y	
	.db	_w, _h
	.db	_color
	.dw	0xCCCC	;; Last video memory pointer value
.endm

bala_x		 = 0
bala_y		 = 1
bala_w		 = 2
bala_h		 = 3
bala_color	 	 = 4
bala_lastVP_l 	 = 5
bala_lastVP_h	 = 6
sizeof_bala		 = 7

;; Default constructor for entity components
.macro DefineCmp_Bala_default
	DefineCmp_Bala 0, 0, 0, 0, 0xFF
.endm