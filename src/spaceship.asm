.include "constants.inc"
.include "header.inc"

.segment "CODE"
.proc irq_handler
  RTI
.endproc


.import read_right
.import read_left
.import read_down
.import read_ax
.import read_by
.import read_up
.import read_start
.import background_tiles
.import ship_enemies
.import move_enemies
.import move_enemies_right
.import move_enemies_left
.import background_scroll


.proc nmi_handler

  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
	LDA #$00
	STA $2005
	STA $2005

  JSR background_scroll
  JSR move_enemies_right
  JSR move_enemies_left
  JSR move_enemies
  
LatchController:
	LDA #$01
	STA $4016
	LDA #$00
	STA $4016 ;tell both the controllers to latch buttons



ReadAandX: 
  LDA $4016 ;player 1 - A
  AND #%00000001 
  BEQ ReadAandXDone
  LDX #$00
  JMP read_ax
 ReadAandXDone:

ReadBandY: 
	LDA $4016    ;player 1 - A
	AND #%00000001  
	BEQ ReadBandYDone
	JMP read_by

ReadBandYDone:
	
ReadBack: 
  LDA $4016       ; player 1 - A
  AND #%00000001 
  BEQ ReadStart 
  JMP reset_handler


ReadStart: 
  LDA $4016       ; player 1 - A
  AND #%00000001 
  BEQ ReadStartDone 
  JMP read_start

ReadStartDone:

ReadUp: 
  LDA $4016       ; player 1 - A
  AND #%00000001
  BEQ ReadUpDone  
  JMP read_up

ReadUpDone:

ReadDown: 
  LDA $4016       ; player 1 - A
  AND #%00000001
  BEQ ReadDownDone
  JMP read_down

ReadDownDone:

 
ReadLeft: 
  LDA $4016       ; player 1 - A
  AND #%00000001
  BEQ ReadLeftDone 
  JMP read_left
	
ReadLeftDone:
	

ReadRight: 
  LDA $4016       ; player 1 - A
  AND #%00000001
  BEQ ReadRigthDone 
  JMP read_right
 
ReadRigthDone:

	RTI  


.endproc

.import reset_handler

.export main
.proc main
  ; write a palette
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR

  LDA #240 ;scroll size
  STA $0300 ;end scroll size

  LDA #$4  ;size enemie ship (eg. each 4 number decimal is a ship)
  STA $0303 ;end size enemie ship
  
  LDA #$01 ;counter ship (eg. this always need to be the number of the enemie / 4)
  STA $0304 ;end counter

  LDA #$01
  STA $0307

  ;TMPPP
  LDA #$10
  STA $0308

  LDA #$1f ;control the levels
  STA $0306 ;end control

  LDA #$04 ;max lifes
  STA $0302 ;end max lifes


load_palettes:
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$20
  BNE load_palettes
  LDX #$00

 
load_ship: ;start draw ship
	LDA sprites_ship,X
	STA $0200,X
  INX
	CPX #$10
	BNE load_ship ;end draw ship

	JSR background_tiles

vblankwait:       ; wait for another vblank before continuing
	BIT PPUSTATUS
	BPL vblankwait

	LDA #%10010000  ; turn on NMIs, sprites use first pattern table
	STA PPUCTRL
	LDA #%00011110  ; turn on screen
	STA PPUMASK

forever:
  JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"

palettes:
  .byte $0f, $12, $23, $27
  .byte $0f, $2b, $3c, $39
  .byte $0f, $0c, $07, $13
  .byte $0f, $19, $09, $29

  .byte $0f, $2d, $10, $05
  .byte $0f, $19, $09, $29
  .byte $0f, $19, $09, $29
  .byte $0f, $19, $09, $29


sprites_ship:
  .byte $BE, $05, $00, $10
  .byte $BE, $06, $00, $18	
  .byte $C6, $07, $00, $10
  .byte $C6, $08, $00, $18

.segment "CHR"
.incbin "graphics.chr"
