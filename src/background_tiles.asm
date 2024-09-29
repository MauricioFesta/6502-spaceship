.include "constants.inc"
.segment "CODE"
.import main
.export background_tiles
.export background_scroll

.proc background_tiles
	
	LDA #$20 ;big stars first
	STA PPUADDR
	LDA #$4b
	STA PPUADDR
	LDX #$2f
	STX PPUDATA

	LDA #$21
	STA PPUADDR
	LDA #$59
	STA PPUADDR
	STX PPUDATA

	LDA #$22
	STA PPUADDR
	LDA #$23
	STA PPUADDR
	STX PPUDATA

	LDA #$23
	STA PPUADDR
	LDA #$52
	STA PPUADDR
	STX PPUDATA ;end big star

	
	LDA #$20  ;start small star 1
	STA PPUADDR
	LDA #$74
	STA PPUADDR
	LDX #$2d
	STX PPUDATA

	LDA #$21
	STA PPUADDR
	LDA #$43
	STA PPUADDR
	STX PPUDATA

	LDA #$21
	STA PPUADDR
	LDA #$5d
	STA PPUADDR
	STX PPUDATA

	LDA #$21
	STA PPUADDR
	LDA #$73
	STA PPUADDR
	STX PPUDATA

	LDA #$22
	STA PPUADDR
	LDA #$2f
	STA PPUADDR
	STX PPUDATA

	LDA #$22
	STA PPUADDR
	LDA #$f7
	STA PPUADDR
	STX PPUDATA ;end small star 1

	
	LDA #$20 ;start small star 2
	STA PPUADDR
	LDA #$f1
	STA PPUADDR
	LDX #$2e
	STX PPUDATA

	LDA #$21
	STA PPUADDR
	LDA #$a8
	STA PPUADDR
	STX PPUDATA

	LDA #$22
	STA PPUADDR
	LDA #$7a
	STA PPUADDR
	STX PPUDATA

	LDA #$23
	STA PPUADDR
	LDA #$44
	STA PPUADDR
	STX PPUDATA

	LDA #$23
	STA PPUADDR
	LDA #$7c
	STA PPUADDR
	STX PPUDATA ;end small star 2
	
	; finally, attribute table
	LDA #$23
	STA PPUADDR
	LDA #$c2
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA

	LDA #$23
	STA PPUADDR
	LDA #$e0
	STA PPUADDR
	LDA #%00001100
	STA PPUDATA

	RTS


.endproc


.proc background_scroll

  LDA $0304 ;if win don't do nothing
  TAX
  CPX #$00
  BEQ nothing ;end if win

	LDA #$00 ;start scroll
	STA PPUSCROLL 
	CLD
	DEC $0300
	LDA $0300
	CMP #$00
	BEQ reset_scroll
	STA PPUSCROLL ;end scroll
	STA $0300

	RTS


reset_scroll:

  LDA #239
  STA PPUSCROLL
  STA $0300
  RTS


nothing:

  LDA $0305 ;validate if already hited all enemieship
  TAX
  CPX #$01
  BNE draw_level ;end validate
  RTS

draw_level:
	LDA #$01
	STA $0305

	LDA #$20
	STA PPUADDR
	LDA #$cd
	STA PPUADDR
  LDX #$0f
	STX PPUDATA

	LDA #$20
	STA PPUADDR
	LDA #$ce
	STA PPUADDR
	LDX #$08
	STX PPUDATA

	LDA #$20
	STA PPUADDR
	LDA #$cf
	STA PPUADDR
	LDX #$19
	STX PPUDATA 

	LDA #$20
	STA PPUADDR
	LDA #$d0
	STA PPUADDR
	LDX #$08
	STX PPUDATA

	LDA #$20
	STA PPUADDR
	LDA #$d1
	STA PPUADDR
	LDX #$0f
	STX PPUDATA

	LDA #$20
	STA PPUADDR
	LDA #$d2
	STA PPUADDR
	LDA $0306
	TAX
	;LDX #$1f
	STX PPUDATA

	; finally, attribute table
	LDA #$23
	STA PPUADDR
	LDA #$c2
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA

	LDA #$23
	STA PPUADDR
	LDA #$e0
	STA PPUADDR
	LDA #%00001100
	STA PPUDATA
	

vblankwait:       ; wait for another vblank before continuing
	BIT PPUSTATUS
	BPL vblankwait

	LDA #%10010000  ; turn on NMIs, sprites use first pattern table
	STA PPUCTRL
	LDA #%00011110  ; turn on screen
	STA PPUMASK

	JMP nothing


.endproc

