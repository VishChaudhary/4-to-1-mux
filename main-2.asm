;
; mux_4to1.asm
;
; Created: 9/22/2021 3:41:00 PM
; Author : vish75000
; Target: AVR128DB48


; Replace with your application code
start:
    ; Configure I/O ports
    ldi r16, 0xFF        ;load r16 with all 1s
    out VPORTD_DIR, r16    ;VPORTD - all pins configured
    out VPORTD_OUT, r16    ;VPORTD - all outputs 1s
    ldi r16, 0x00        ;load r16 with all 0s
    out VPORTC_DIR, r16    ;VPORTC- all pins configured as inputs

    ; Continually input switch values and output to LEDs
again:
    in r17, VPORTD_OUT    ;get current output value
    andi r17, 0x7F        ;mask msb bit
    in r16, VPORTC_IN    ;read switch values
    mov r19, r16        ;save copy of inputs
    andi r16, 0x80        ;mask all but /G
    brne inv_y            ;device is not enabled, Y =L

mux_enabled:
c0:
    mov r16, r19        ;get copy of input
    ldi r18, 0xE0        ;complement /G, B, A
    eor r16, r18
    andi r16, 0xE0        ;clear ls 5 bits *
    cpi r16, 0xE0        ;check for a result of 0xE0
    brne c1                ;if not equal, branch
    mov r16, r19        ;if equal, get data inputs again *
    lsl r16                ;positions C0 to bit 7 position, Y = C0
    lsl r16
    lsl r16
    andi r16, 0x80        ;clear all bits except bit 7, C0
    or r17, r16            ;OR new bit 7 with bits 6 - 0 previously output
    rjmp inv_y

c1:
    mov r16, r19		;get copy of input
    ldi r18, 0xE0		;complement /G, B, A
    eor r16, r18
    andi r16, 0xE0		;clear ls 5 bits *
    cpi r16, 0xC0		;check for a result of 0xC0
    brne c2				;if not equal, branch
    mov r16, r19		;if equal, get data inputs again *
    lsl r16				;positions C1 to bit 7 position, Y = C1
    lsl r16
    lsl r16
    lsl r16
    andi r16, 0x80		;clear all bits except bit 7, C1
    or r17, r16			;OR new bit 7 with bits 6 - 0 previously output
    rjmp inv_y
c2:
    mov r16, r19		;get copy of input
    ldi r18, 0xE0		;complement /G, B, A
    eor r16, r18
    andi r16, 0xE0		;clear ls 5 bits *
    cpi r16, 0xA0		;check for a result of 0xA0
    brne c3				;if not equal, branch
    mov r16, r19		;if equal, get data inputs again *
    lsl r16				;positions C2 to bit 7 position, Y = C2
    lsl r16
    lsl r16
    lsl r16
    lsl r16
    andi r16, 0x80		;clear all bits except bit 7, C2
    or r17, r16			;OR new bit 7 with bits 6 - 0 previously output
    rjmp inv_y
c3:
    mov r16, r19		;get copy of input
    ldi r18, 0xE0		;complement /G, B, A
    eor r16, r18
    andi r16, 0xE0		;clear ls 5 bits *
    cpi r16, 0x80		;check for a result of 0x80
    brne inv_y			;if not equal, branch
    mov r16, r19		;if equal, get data inputs again *
    lsl r16				;positions C3 to bit 7 position, Y = C3
    lsl r16
    lsl r16
    lsl r16
    lsl r16
    lsl r16
    andi r16, 0x80		;clear all bits except bit 7, C3
    or r17, r16			;OR new bit 7 with bits 6 - 0 previously output
    rjmp inv_y

inv_y:
    ldi r18, 0x80        ;mask to toggle msb, Y
    eor r17, r18
    out VPORTD_OUT, r17    ;output to LEDs complement input from switches
    rjmp again 

