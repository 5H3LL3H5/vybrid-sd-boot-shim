/*
 * Colibri VFxx SD boot shim - Redirects Vybrids boot flow to SD card
 *
 * Copyright (c) 2014 Stefan Agner <stefan.agner@toradex.com>
 *
 */

main:
	ldr	r0, GPR9	@ boot device
	ldr	r1, GPR9_VAL
	str	r1, [r0, #0]
	ldr	r1, GPR10_VAL	@ overwrite boot flow
	str	r1, [r0, #4]
	ldr	r0, WDOG_WCR	@ start watchdog (SW_RST doesn't work)
	ldrh	r1, RESET
	strh	r1, [r0, #0]
empty:
	nop
	b	empty

.globl GPR9
GPR9:
	.word	0x4006e040

.globl GPR9_VAL
GPR9_VAL:
	.word	0x00002860

.globl GPR10_VAL
GPR10_VAL:
	.word	0x10000000

.global WDOG_WCR
WDOG_WCR:
	.word	0x4003E000

.global RESET
RESET:
	.hword	0x0004


