
;CodeVisionAVR C Compiler V3.52 
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x37
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _id=R4
	.DEF _id_msb=R5
	.DEF _x=R6
	.DEF _x_msb=R7
	.DEF _c=R8
	.DEF _c_msb=R9
	.DEF _i=R10
	.DEF _i_msb=R11
	.DEF _pass=R12
	.DEF _pass_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _EXT__INT1
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x6F,0x0,0xCB,0x0,0x7E,0x0,0x81,0x0
	.DB  0x80,0x0,0x45,0x1,0x82,0x0,0xAA,0x1
	.DB  0x84,0x0,0xB3,0x0,0x86,0x0,0x86
_0x5:
	.DB  LOW(_0x4),HIGH(_0x4),LOW(_0x4+5),HIGH(_0x4+5),LOW(_0x4+11),HIGH(_0x4+11),LOW(_0x4+15),HIGH(_0x4+15)
	.DB  LOW(_0x4+20),HIGH(_0x4+20),LOW(_0x4+25),HIGH(_0x4+25)
_0x0:
	.DB  0x50,0x72,0x6F,0x66,0x0,0x41,0x68,0x6D
	.DB  0x65,0x64,0x0,0x41,0x6D,0x72,0x0,0x41
	.DB  0x64,0x65,0x6C,0x0,0x4F,0x6D,0x65,0x72
	.DB  0x0,0x41,0x64,0x6D,0x69,0x6E,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x79,0x6F,0x75
	.DB  0x72,0x20,0x49,0x44,0x20,0x20,0x20,0x0
	.DB  0x59,0x6F,0x75,0x20,0x43,0x61,0x6E,0x27
	.DB  0x74,0x20,0x45,0x6E,0x74,0x65,0x72,0x0
	.DB  0x2A,0x20,0x43,0x6C,0x6F,0x73,0x65,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x23,0x43,0x68,0x61,0x6E,0x67,0x65,0x20
	.DB  0x50,0x61,0x73,0x73,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x4E,0x65,0x77,0x20,0x70
	.DB  0x61,0x73,0x73,0x20,0x20,0x0,0x57,0x65
	.DB  0x6C,0x63,0x6F,0x6D,0x20,0x25,0x73,0x0
	.DB  0x43,0x6F,0x6E,0x66,0x69,0x72,0x6D,0x20
	.DB  0x6E,0x65,0x77,0x20,0x70,0x61,0x73,0x73
	.DB  0x20,0x20,0x0,0x50,0x61,0x73,0x73,0x20
	.DB  0x6E,0x6F,0x74,0x20,0x4D,0x61,0x74,0x63
	.DB  0x68,0x20,0x20,0x0,0x50,0x61,0x73,0x73
	.DB  0x20,0x43,0x61,0x6E,0x27,0x74,0x20,0x63
	.DB  0x68,0x61,0x6E,0x67,0x65,0x0,0x50,0x61
	.DB  0x73,0x73,0x20,0x43,0x68,0x61,0x6E,0x67
	.DB  0x65,0x64,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x59,0x6F,0x75,0x72,0x20,0x50,0x61
	.DB  0x73,0x73,0x20,0x0,0x57,0x72,0x6F,0x6E
	.DB  0x67,0x20,0x50,0x61,0x73,0x73,0x21,0x21
	.DB  0x0,0x2A,0x0,0x43,0x6F,0x6E,0x66,0x69
	.DB  0x72,0x6D,0x20,0x6E,0x65,0x77,0x20,0x49
	.DB  0x64,0x20,0x20,0x20,0x0,0x49,0x64,0x20
	.DB  0x6E,0x6F,0x74,0x20,0x4D,0x61,0x74,0x63
	.DB  0x68,0x20,0x20,0x0,0x49,0x64,0x20,0x43
	.DB  0x61,0x6E,0x27,0x74,0x20,0x63,0x68,0x61
	.DB  0x6E,0x67,0x65,0x0,0x49,0x64,0x20,0x43
	.DB  0x68,0x61,0x6E,0x67,0x65,0x64,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x59,0x6F,0x75
	.DB  0x72,0x20,0x49,0x44,0x20,0x20,0x20,0x0
	.DB  0x2A,0x20,0x43,0x6C,0x6F,0x73,0x65,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x23,0x20,0x45,0x64,0x69,0x74,0x0,0x2A
	.DB  0x20,0x45,0x64,0x69,0x74,0x20,0x69,0x64
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x23
	.DB  0x20,0x45,0x64,0x69,0x74,0x20,0x50,0x61
	.DB  0x73,0x73,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x49,0x44,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x45,0x6E,0x74,0x65
	.DB  0x72,0x20,0x6E,0x65,0x77,0x20,0x49,0x64
	.DB  0x20,0x20,0x20,0x20,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x6E,0x65,0x77,0x20,0x50
	.DB  0x61,0x73,0x73,0x20,0x20,0x20,0x0,0x59
	.DB  0x6F,0x75,0x20,0x61,0x72,0x65,0x20,0x6E
	.DB  0x6F,0x74,0x20,0x41,0x64,0x6D,0x69,0x6E
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x17
	.DW  _Data
	.DW  _0x3*2

	.DW  0x05
	.DW  _0x4
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x4+5
	.DW  _0x0*2+5

	.DW  0x04
	.DW  _0x4+11
	.DW  _0x0*2+11

	.DW  0x05
	.DW  _0x4+15
	.DW  _0x0*2+15

	.DW  0x05
	.DW  _0x4+20
	.DW  _0x0*2+20

	.DW  0x06
	.DW  _0x4+25
	.DW  _0x0*2+25

	.DW  0x0C
	.DW  _names
	.DW  _0x5*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG
_0x4:
	.BYTE 0x1F
;char keypad();
;void Insert_data() ;
;unsigned char EE_Read(unsigned int address);
;void EE_Write(unsigned int add, unsigned char data);
;void MyCode();
;void alarm();
;void readid();
;void readpass();
;void checkPass();
;void confirmPass();
;void confirmId();
;void ChangeId();
;void ChangePass();
;void Admin();
;void main(void)
; 0000 0029 {

	.CSEG
_main:
; .FSTART _main
; 0000 002A 
; 0000 002B DDRC = 0b00000111;  //port c.0,1,2 as  output port c.3,4,5,6,7 as  input
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 002C 
; 0000 002D PORTC = 0b11111000; //active pull up at port c.3,4,5,6,7
	LDI  R30,LOW(248)
	OUT  0x15,R30
; 0000 002E 
; 0000 002F DDRD.4=1;           //port D.4 as output
	SBI  0x11,4
; 0000 0030 
; 0000 0031 PORTD.3=1;
	SBI  0x12,3
; 0000 0032 
; 0000 0033 DDRB=0b00001111;    //port B.0,1,2,3 as output
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0034 
; 0000 0035 
; 0000 0036 SREG.7 = 1;
	BSET 7
; 0000 0037 
; 0000 0038 GICR |= 0b10000000;     //active Intrrupt 1
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 0039 
; 0000 003A MCUCR  |= 0b00001100;  // Rising Edge
	IN   R30,0x35
	ORI  R30,LOW(0xC)
	OUT  0x35,R30
; 0000 003B 
; 0000 003C lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 003D 
; 0000 003E Insert_data();         //insert  data to EEPROM
	RCALL _Insert_data
; 0000 003F 
; 0000 0040 while (1)
_0xA:
; 0000 0041 {
; 0000 0042 
; 0000 0043 MyCode();
	RCALL _MyCode
; 0000 0044 
; 0000 0045 }
	RJMP _0xA
; 0000 0046 }
_0xD:
	RJMP _0xD
; .FEND
;void MyCode(){
; 0000 004A void MyCode(){
_MyCode:
; .FSTART _MyCode
; 0000 004B 
; 0000 004C lcd_clear();  //make lcd empty
	RCALL _lcd_clear
; 0000 004D 
; 0000 004E x= keypad();
	RCALL SUBOPT_0x0
; 0000 004F 
; 0000 0050 if(x==10){
	BREQ PC+2
	RJMP _0xE
; 0000 0051 
; 0000 0052 lcd_clear();
	RCALL _lcd_clear
; 0000 0053 
; 0000 0054 lcd_printf("Enter your ID   ");
	__POINTW1FN _0x0,31
	RCALL SUBOPT_0x1
; 0000 0055 
; 0000 0056 readid();   // Enter 3digits Id
	RCALL _readid
; 0000 0057 
; 0000 0058 lcd_clear();
	RCALL _lcd_clear
; 0000 0059 
; 0000 005A checkPass();  // Enter 3digits pass
	RCALL _checkPass
; 0000 005B 
; 0000 005C lcd_clear();
	RCALL SUBOPT_0x2
; 0000 005D 
; 0000 005E if(counter>=3){    // user enter wrong pass 3 times
	BRLT _0xF
; 0000 005F 
; 0000 0060 lcd_printf("You Can't Enter");
	__POINTW1FN _0x0,48
	RCALL SUBOPT_0x1
; 0000 0061 
; 0000 0062 delay_ms(1500);    //wait 1500 ms
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	RCALL _delay_ms
; 0000 0063 
; 0000 0064 MyCode(); // start from begin and enter new id
	RCALL _MyCode
; 0000 0065 }
; 0000 0066 
; 0000 0067 lcd_printf("* Close         #Change Pass");   //if user want change his pass or just open the door
_0xF:
	__POINTW1FN _0x0,64
	RCALL SUBOPT_0x1
; 0000 0068 
; 0000 0069 x = keypad();      //enter * or #
	RCALL _keypad
	MOV  R6,R30
	CLR  R7
; 0000 006A 
; 0000 006B lcd_clear();
	RCALL _lcd_clear
; 0000 006C 
; 0000 006D if(x==11){    //user want change his pass
	RCALL SUBOPT_0x3
	BRNE _0x10
; 0000 006E 
; 0000 006F lcd_clear();
	RCALL _lcd_clear
; 0000 0070 
; 0000 0071 lcd_printf("Enter New pass  ");
	__POINTW1FN _0x0,93
	RCALL SUBOPT_0x1
; 0000 0072 
; 0000 0073 readpass();       //user enter his new pass
	RCALL _readpass
; 0000 0074 
; 0000 0075 confirmPass();    //user confirm his new pass
	RCALL _confirmPass
; 0000 0076 
; 0000 0077 }
; 0000 0078 lcd_clear();
_0x10:
	RCALL _lcd_clear
; 0000 0079 
; 0000 007A for(i=0;i<12;i+=2) //search for name
	CLR  R10
	CLR  R11
_0x12:
	RCALL SUBOPT_0x4
	BRGE _0x13
; 0000 007B 
; 0000 007C if( id == Data[i] ) {
	RCALL SUBOPT_0x5
	BRNE _0x14
; 0000 007D lcd_printf("Welcom %s",names[i/2]);
	__POINTW1FN _0x0,110
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R10
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __DIVW21
	LDI  R26,LOW(_names)
	LDI  R27,HIGH(_names)
	RCALL SUBOPT_0x6
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printf
	ADIW R28,6
; 0000 007E 
; 0000 007F PORTB.1=1;     // open door
	SBI  0x18,1
; 0000 0080 
; 0000 0081 PORTB.2 = 1;   // turn on led
	SBI  0x18,2
; 0000 0082 
; 0000 0083 PORTB.3=1;     // turn on peep alarm
	SBI  0x18,3
; 0000 0084 
; 0000 0085 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 0086 
; 0000 0087 PORTB.1=0;
	CBI  0x18,1
; 0000 0088 
; 0000 0089 PORTB.0=1;   //close door
	SBI  0x18,0
; 0000 008A 
; 0000 008B delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 008C 
; 0000 008D PORTB.2 = 0;    //turn off led
	CBI  0x18,2
; 0000 008E 
; 0000 008F PORTB.3=0;     // turn off peep alarm
	CBI  0x18,3
; 0000 0090 
; 0000 0091 PORTB.0=0;
	CBI  0x18,0
; 0000 0092 }
; 0000 0093 }
_0x14:
	MOVW R30,R10
	ADIW R30,2
	MOVW R10,R30
	RJMP _0x12
_0x13:
; 0000 0094 
; 0000 0095 
; 0000 0096 
; 0000 0097 }
_0xE:
	RET
; .FEND
;void alarm() {
; 0000 009A void alarm() {
_alarm:
; .FSTART _alarm
; 0000 009B 
; 0000 009C PORTB.2 = 1;   // turn on led
	SBI  0x18,2
; 0000 009D 
; 0000 009E PORTB.3=1;     // turn on peep alarm
	SBI  0x18,3
; 0000 009F 
; 0000 00A0 delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	RCALL _delay_ms
; 0000 00A1 
; 0000 00A2 PORTB.2 = 0;    //turn off led
	CBI  0x18,2
; 0000 00A3 
; 0000 00A4 PORTB.3=0;     // turn off peep alarm
	CBI  0x18,3
; 0000 00A5 }
	RET
; .FEND
;void ChangePass(){
; 0000 00A9 void ChangePass(){
_ChangePass:
; .FSTART _ChangePass
; 0000 00AA 
; 0000 00AB char m=oldPass;  //pass
; 0000 00AC 
; 0000 00AD for(i=0;i<12;i+=2)if(id==Data[i]){Data[i+1]=oldPass;break;} //change old pass to new one in Data array
	ST   -Y,R17
;	m -> R17
	LDS  R17,_oldPass
	CLR  R10
	CLR  R11
_0x2E:
	RCALL SUBOPT_0x4
	BRGE _0x2F
	RCALL SUBOPT_0x5
	BRNE _0x30
	MOVW R30,R10
	ADIW R30,1
	RCALL SUBOPT_0x7
	LDS  R26,_oldPass
	LDS  R27,_oldPass+1
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP _0x2F
; 0000 00AE 
; 0000 00AF //change old pass to new one in EEPROM
; 0000 00B0 
; 0000 00B1 EE_Write(id,m);
_0x30:
	MOVW R30,R10
	ADIW R30,2
	MOVW R10,R30
	RJMP _0x2E
_0x2F:
	ST   -Y,R5
	ST   -Y,R4
	MOV  R26,R17
	RCALL _EE_Write
; 0000 00B2 
; 0000 00B3 m=oldPass>>8;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	MOV  R17,R30
; 0000 00B4 
; 0000 00B5 EE_Write(id+1,m );
	RCALL SUBOPT_0xA
	MOV  R26,R17
	RCALL _EE_Write
; 0000 00B6 }
	JMP  _0x2080001
; .FEND
;void confirmPass(){
; 0000 00BA void confirmPass(){
_confirmPass:
; .FSTART _confirmPass
; 0000 00BB 
; 0000 00BC oldPass=pass;
	__PUTWMRN _oldPass,0,12,13
; 0000 00BD 
; 0000 00BE for(counter=0;counter<3;counter++){
	RCALL SUBOPT_0xB
_0x32:
	RCALL SUBOPT_0xC
	BRGE _0x33
; 0000 00BF 
; 0000 00C0 lcd_clear();
	RCALL _lcd_clear
; 0000 00C1 
; 0000 00C2 lcd_printf("Confirm new pass  ");
	__POINTW1FN _0x0,120
	RCALL SUBOPT_0x1
; 0000 00C3 
; 0000 00C4 readpass();              //enter new pass again
	RCALL _readpass
; 0000 00C5 
; 0000 00C6 if(pass==oldPass) break;  //new pass is confirmed  loop will stop
	RCALL SUBOPT_0x8
	CP   R30,R12
	CPC  R31,R13
	BREQ _0x33
; 0000 00C7 
; 0000 00C8 lcd_clear();
	RCALL _lcd_clear
; 0000 00C9 
; 0000 00CA lcd_printf("Pass not Match  "); //new pass is not confirmed
	__POINTW1FN _0x0,139
	RCALL SUBOPT_0x1
; 0000 00CB 
; 0000 00CC alarm();
	RCALL _alarm
; 0000 00CD 
; 0000 00CE }
	RCALL SUBOPT_0xD
	RJMP _0x32
_0x33:
; 0000 00CF lcd_clear();
	RCALL SUBOPT_0x2
; 0000 00D0 
; 0000 00D1 
; 0000 00D2 if(counter>=3){ //user can't confirm his new pass 3 times so pass did't change
	BRLT _0x35
; 0000 00D3 
; 0000 00D4 lcd_printf("Pass Can't change");
	__POINTW1FN _0x0,156
	RCALL SUBOPT_0x1
; 0000 00D5 
; 0000 00D6 alarm();
	RCALL _alarm
; 0000 00D7 }
; 0000 00D8 
; 0000 00D9 else {
	RJMP _0x36
_0x35:
; 0000 00DA 
; 0000 00DB ChangePass();   //change old pass to new one
	RCALL _ChangePass
; 0000 00DC 
; 0000 00DD lcd_printf("Pass Changed");    //print at lcd that pass changed
	__POINTW1FN _0x0,174
	RCALL SUBOPT_0x1
; 0000 00DE 
; 0000 00DF delay_ms(1500);    //wait 1500 ms
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	RCALL _delay_ms
; 0000 00E0 }
_0x36:
; 0000 00E1 
; 0000 00E2 }
	RET
; .FEND
;void checkPass(){
; 0000 00E6 void checkPass(){
_checkPass:
; .FSTART _checkPass
; 0000 00E7 
; 0000 00E8 counter=0;
	RCALL SUBOPT_0xB
; 0000 00E9 
; 0000 00EA while( counter < 3 ){
_0x37:
	RCALL SUBOPT_0xC
	BRGE _0x39
; 0000 00EB 
; 0000 00EC lcd_clear();
	RCALL _lcd_clear
; 0000 00ED 
; 0000 00EE lcd_printf("Enter Your Pass ");
	__POINTW1FN _0x0,187
	RCALL SUBOPT_0x1
; 0000 00EF 
; 0000 00F0 readpass();    //reed 3 digits pass
	RCALL _readpass
; 0000 00F1 
; 0000 00F2 x=EE_Read(id);   //reed stored pass in EEPROM
	MOVW R26,R4
	RCALL _EE_Read
	MOV  R6,R30
	CLR  R7
; 0000 00F3 
; 0000 00F4 y=EE_Read(id+1)<<8;   //reed stored pass in EEPROM
	MOVW R26,R4
	ADIW R26,1
	RCALL _EE_Read
	MOV  R31,R30
	LDI  R30,0
	STS  _y,R30
	STS  _y+1,R31
; 0000 00F5 
; 0000 00F6 lcd_clear();
	RCALL _lcd_clear
; 0000 00F7 
; 0000 00F8 if(x+y==pass) {     //Enterd pass match pass that stored in EEPROM
	LDS  R26,_y
	LDS  R27,_y+1
	ADD  R26,R6
	ADC  R27,R7
	CP   R12,R26
	CPC  R13,R27
	BREQ _0x39
; 0000 00F9 
; 0000 00FA break;
; 0000 00FB }
; 0000 00FC 
; 0000 00FD else {             //Enterd pass dosen't match pass that stored in EEPROM
; 0000 00FE 
; 0000 00FF lcd_printf("Wrong Pass!!");
	__POINTW1FN _0x0,204
	RCALL SUBOPT_0x1
; 0000 0100 
; 0000 0101 alarm();
	RCALL _alarm
; 0000 0102 }
; 0000 0103 
; 0000 0104 counter++;
	RCALL SUBOPT_0xD
; 0000 0105 }
	RJMP _0x37
_0x39:
; 0000 0106 }
	RET
; .FEND
;void readpass(){
; 0000 010A void readpass(){
_readpass:
; .FSTART _readpass
; 0000 010B 
; 0000 010C pass=0,c=0;
	CLR  R12
	CLR  R13
	CLR  R8
	CLR  R9
; 0000 010D 
; 0000 010E while(c<3){
_0x3C:
	RCALL SUBOPT_0xE
	BRGE _0x3E
; 0000 010F 
; 0000 0110 x = keypad();         //read one digit from keypad
	RCALL _keypad
	MOV  R6,R30
	CLR  R7
; 0000 0111 
; 0000 0112 pass = pass * 10 + x ; //store 3digits as one int number pass
	MOVW R30,R12
	RCALL SUBOPT_0xF
	MOVW R12,R30
; 0000 0113 
; 0000 0114 lcd_printf("*");
	__POINTW1FN _0x0,217
	RCALL SUBOPT_0x1
; 0000 0115 
; 0000 0116 c++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0117 
; 0000 0118 }
	RJMP _0x3C
_0x3E:
; 0000 0119 x = keypad();       //read one digit from keypad
	RJMP _0x2080002
; 0000 011A }
; .FEND
;void readid(){
; 0000 011E void readid(){
_readid:
; .FSTART _readid
; 0000 011F 
; 0000 0120 id=0,c=0;
	CLR  R4
	CLR  R5
	CLR  R8
	CLR  R9
; 0000 0121 
; 0000 0122 while( c < 3 ){
_0x3F:
	RCALL SUBOPT_0xE
	BRGE _0x41
; 0000 0123 
; 0000 0124 x = keypad();     //read one digit from keypad
	RCALL _keypad
	MOV  R6,R30
	CLR  R7
; 0000 0125 
; 0000 0126 id = id * 10 + x ;    //store 3digits as one int number id
	MOVW R30,R4
	RCALL SUBOPT_0xF
	MOVW R4,R30
; 0000 0127 
; 0000 0128 lcd_printf("*");
	__POINTW1FN _0x0,217
	RCALL SUBOPT_0x1
; 0000 0129 
; 0000 012A c++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 012B }
	RJMP _0x3F
_0x41:
; 0000 012C 
; 0000 012D x = keypad();       //read one digit from keypad
_0x2080002:
	RCALL _keypad
	MOV  R6,R30
	CLR  R7
; 0000 012E 
; 0000 012F }
	RET
; .FEND
;char keypad()
; 0000 0134 {
_keypad:
; .FSTART _keypad
; 0000 0135 while(1)
_0x42:
; 0000 0136 {
; 0000 0137 PORTC.0 = 0; PORTC.1 = 1; PORTC.2 = 1;
	CBI  0x15,0
	SBI  0x15,1
	SBI  0x15,2
; 0000 0138 
; 0000 0139 //Only C1 is activated
; 0000 013A 
; 0000 013B switch(PINC)
	IN   R30,0x13
; 0000 013C {
; 0000 013D case 0b11110110:   //user press 1
	CPI  R30,LOW(0xF6)
	BRNE _0x4E
; 0000 013E 
; 0000 013F while (PINC.3 == 0);
_0x4F:
	SBIS 0x13,3
	RJMP _0x4F
; 0000 0140 
; 0000 0141 return 1;
	LDI  R30,LOW(1)
	RET
; 0000 0142 
; 0000 0143 break;
	RJMP _0x4D
; 0000 0144 
; 0000 0145 case 0b11101110:   //user press 4
_0x4E:
	CPI  R30,LOW(0xEE)
	BRNE _0x52
; 0000 0146 
; 0000 0147 while (PINC.4 == 0);
_0x53:
	SBIS 0x13,4
	RJMP _0x53
; 0000 0148 
; 0000 0149 return 4;
	LDI  R30,LOW(4)
	RET
; 0000 014A 
; 0000 014B break;
	RJMP _0x4D
; 0000 014C 
; 0000 014D case 0b11011110:     //user press 7
_0x52:
	CPI  R30,LOW(0xDE)
	BRNE _0x56
; 0000 014E while (PINC.5 == 0);
_0x57:
	SBIS 0x13,5
	RJMP _0x57
; 0000 014F return 7;
	LDI  R30,LOW(7)
	RET
; 0000 0150 break;
	RJMP _0x4D
; 0000 0151 
; 0000 0152 case 0b10111110:    //user press *
_0x56:
	CPI  R30,LOW(0xBE)
	BRNE _0x4D
; 0000 0153 while (PINC.6 == 0);
_0x5B:
	SBIS 0x13,6
	RJMP _0x5B
; 0000 0154 return 10;
	LDI  R30,LOW(10)
	RET
; 0000 0155 break;
; 0000 0156 
; 0000 0157 }
_0x4D:
; 0000 0158 PORTC.0 = 1; PORTC.1 = 0; PORTC.2 = 1;
	SBI  0x15,0
	CBI  0x15,1
	SBI  0x15,2
; 0000 0159 
; 0000 015A //Only C2 is activated
; 0000 015B switch(PINC)
	IN   R30,0x13
; 0000 015C {
; 0000 015D case 0b11110101:   //user press 2
	CPI  R30,LOW(0xF5)
	BRNE _0x67
; 0000 015E while (PINC.3 == 0);
_0x68:
	SBIS 0x13,3
	RJMP _0x68
; 0000 015F return 2;
	LDI  R30,LOW(2)
	RET
; 0000 0160 break;
	RJMP _0x66
; 0000 0161 
; 0000 0162 case 0b11101101:    //user press 5
_0x67:
	CPI  R30,LOW(0xED)
	BRNE _0x6B
; 0000 0163 while (PINC.4 == 0);
_0x6C:
	SBIS 0x13,4
	RJMP _0x6C
; 0000 0164 return 5;
	LDI  R30,LOW(5)
	RET
; 0000 0165 break;
	RJMP _0x66
; 0000 0166 
; 0000 0167 case 0b11011101:    //user press 8
_0x6B:
	CPI  R30,LOW(0xDD)
	BRNE _0x6F
; 0000 0168 while (PINC.5 == 0);
_0x70:
	SBIS 0x13,5
	RJMP _0x70
; 0000 0169 return 8;
	LDI  R30,LOW(8)
	RET
; 0000 016A break;
	RJMP _0x66
; 0000 016B 
; 0000 016C case 0b10111101:    //user press 0
_0x6F:
	CPI  R30,LOW(0xBD)
	BRNE _0x66
; 0000 016D while (PINC.6 == 0);
_0x74:
	SBIS 0x13,6
	RJMP _0x74
; 0000 016E return 0;
	LDI  R30,LOW(0)
	RET
; 0000 016F break;
; 0000 0170 
; 0000 0171 }
_0x66:
; 0000 0172 
; 0000 0173 PORTC.0 = 1; PORTC.1 = 1; PORTC.2 = 0;
	SBI  0x15,0
	SBI  0x15,1
	CBI  0x15,2
; 0000 0174 //Only C3 is activated
; 0000 0175 switch(PINC)
	IN   R30,0x13
; 0000 0176 {
; 0000 0177 case 0b11110011:   //user press 3
	CPI  R30,LOW(0xF3)
	BRNE _0x80
; 0000 0178 while (PINC.3 == 0);
_0x81:
	SBIS 0x13,3
	RJMP _0x81
; 0000 0179 return 3;
	LDI  R30,LOW(3)
	RET
; 0000 017A break;
	RJMP _0x7F
; 0000 017B 
; 0000 017C case 0b11101011:    //user press 6
_0x80:
	CPI  R30,LOW(0xEB)
	BRNE _0x84
; 0000 017D while (PINC.4 == 0);
_0x85:
	SBIS 0x13,4
	RJMP _0x85
; 0000 017E return 6;
	LDI  R30,LOW(6)
	RET
; 0000 017F break;
	RJMP _0x7F
; 0000 0180 
; 0000 0181 case 0b11011011:     //user press 9
_0x84:
	CPI  R30,LOW(0xDB)
	BRNE _0x88
; 0000 0182 while (PINC.5 == 0);
_0x89:
	SBIS 0x13,5
	RJMP _0x89
; 0000 0183 return 9;
	LDI  R30,LOW(9)
	RET
; 0000 0184 break;
	RJMP _0x7F
; 0000 0185 
; 0000 0186 case 0b10111011:    //user press #
_0x88:
	CPI  R30,LOW(0xBB)
	BRNE _0x7F
; 0000 0187 while (PINC.6 == 0);
_0x8D:
	SBIS 0x13,6
	RJMP _0x8D
; 0000 0188 return 11;
	LDI  R30,LOW(11)
	RET
; 0000 0189 break;
; 0000 018A 
; 0000 018B }
_0x7F:
; 0000 018C 
; 0000 018D }
	RJMP _0x42
; 0000 018E }
; .FEND
;void Insert_data() {
; 0000 0192 void Insert_data() {
_Insert_data:
; .FSTART _Insert_data
; 0000 0193 
; 0000 0194 for (i=0; i < 12; i+=2) {
	CLR  R10
	CLR  R11
_0x91:
	RCALL SUBOPT_0x4
	BRGE _0x92
; 0000 0195 
; 0000 0196 char c=Data[i+1];  //pass
; 0000 0197 
; 0000 0198 //store pass in 2byte in EEPROM
; 0000 0199 
; 0000 019A EE_Write(Data[i],c );
	SBIW R28,1
;	c -> Y+0
	RCALL SUBOPT_0x10
	LD   R30,X
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
; 0000 019B 
; 0000 019C c=Data[i+1]>>8;
	RCALL SUBOPT_0x10
	LD   R30,X+
	LD   R31,X+
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x11
; 0000 019D 
; 0000 019E EE_Write(Data[i]+1,c );
	ADIW R30,1
	RCALL SUBOPT_0x12
; 0000 019F 
; 0000 01A0 }
	ADIW R28,1
	MOVW R30,R10
	ADIW R30,2
	MOVW R10,R30
	RJMP _0x91
_0x92:
; 0000 01A1 }
	RET
; .FEND
;unsigned char EE_Read(unsigned int address)
; 0000 01A6 {
_EE_Read:
; .FSTART _EE_Read
; 0000 01A7 
; 0000 01A8 while(EECR.1 == 1);    //Wait till EEPROM is ready  (eeprom not busy)
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	address -> R16,R17
_0x93:
	SBIC 0x1C,1
	RJMP _0x93
; 0000 01A9 EEAR = address;        //Prepare the address you want to read from
	__OUTWR 16,17,30
; 0000 01AA 
; 0000 01AB EECR.0 = 1;            //Execute read
	SBI  0x1C,0
; 0000 01AC 
; 0000 01AD return EEDR;
	IN   R30,0x1D
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 01AE 
; 0000 01AF }
; .FEND
;void EE_Write(unsigned int add, unsigned char data)
; 0000 01B3 {
_EE_Write:
; .FSTART _EE_Write
; 0000 01B4 
; 0000 01B5 while(EECR & 0x2 );    //Wait till EEPROM is ready  (eeprom not busy)
	RCALL __SAVELOCR4
	MOV  R17,R26
	__GETWRS 18,19,4
;	add -> R18,R19
;	data -> R17
_0x98:
	SBIC 0x1C,1
	RJMP _0x98
; 0000 01B6 EEAR = add;        //Prepare the address you want to read from
	__OUTWR 18,19,30
; 0000 01B7 EEDR = data;           //Prepare the data you want to write in the address above
	OUT  0x1D,R17
; 0000 01B8 EECR.2 = 1;            //Master write enable
	SBI  0x1C,2
; 0000 01B9 EECR.1 = 1;            //Write Enable
	SBI  0x1C,1
; 0000 01BA 
; 0000 01BB }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;void ChangeId(){
; 0000 01BF void ChangeId(){
_ChangeId:
; .FSTART _ChangeId
; 0000 01C0 
; 0000 01C1 for(i=0;i<12;i+=2)if(saveId==Data[i]){Data[i]=id;break;}//change id in Data array
	CLR  R10
	CLR  R11
_0xA0:
	RCALL SUBOPT_0x4
	BRGE _0xA1
	MOVW R30,R10
	LDI  R26,LOW(_Data)
	LDI  R27,HIGH(_Data)
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x13
	CP   R30,R26
	CPC  R31,R27
	BRNE _0xA2
	MOVW R30,R10
	RCALL SUBOPT_0x7
	ST   Z,R4
	STD  Z+1,R5
	RJMP _0xA1
; 0000 01C2 
; 0000 01C3 //restore pass in old id address to new id address
; 0000 01C4 
; 0000 01C5 EE_Write(id,EE_Read(saveId) );
_0xA2:
	MOVW R30,R10
	ADIW R30,2
	MOVW R10,R30
	RJMP _0xA0
_0xA1:
	ST   -Y,R5
	ST   -Y,R4
	RCALL SUBOPT_0x13
	RCALL _EE_Read
	MOV  R26,R30
	RCALL _EE_Write
; 0000 01C6 
; 0000 01C7 EE_Write(id+1,EE_Read(saveId+1) );
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x13
	ADIW R26,1
	RCALL _EE_Read
	MOV  R26,R30
	RCALL SUBOPT_0x14
; 0000 01C8 
; 0000 01C9 //make old id address value to 0
; 0000 01CA 
; 0000 01CB EE_Write(saveId,0);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x14
; 0000 01CC 
; 0000 01CD EE_Write(saveId+1,0);
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _EE_Write
; 0000 01CE 
; 0000 01CF 
; 0000 01D0 }
	RET
; .FEND
;void confirmId(){
; 0000 01D4 void confirmId(){
_confirmId:
; .FSTART _confirmId
; 0000 01D5 
; 0000 01D6 oldId=id;
	__PUTWMRN _oldId,0,4,5
; 0000 01D7 
; 0000 01D8 for(counter=0;counter<3;counter++){
	RCALL SUBOPT_0xB
_0xA4:
	RCALL SUBOPT_0xC
	BRGE _0xA5
; 0000 01D9 
; 0000 01DA lcd_clear();
	RCALL _lcd_clear
; 0000 01DB 
; 0000 01DC lcd_printf("Confirm new Id   ");
	__POINTW1FN _0x0,219
	RCALL SUBOPT_0x1
; 0000 01DD 
; 0000 01DE readid();          //enter new id again
	RCALL _readid
; 0000 01DF 
; 0000 01E0 if(id==oldId) break;  //new id is confirmed  loop will stop
	LDS  R30,_oldId
	LDS  R31,_oldId+1
	CP   R30,R4
	CPC  R31,R5
	BREQ _0xA5
; 0000 01E1 
; 0000 01E2 lcd_clear();
	RCALL _lcd_clear
; 0000 01E3 
; 0000 01E4 lcd_printf("Id not Match  ");  //new id is not confirmed
	__POINTW1FN _0x0,237
	RCALL SUBOPT_0x1
; 0000 01E5 
; 0000 01E6 alarm();
	RCALL _alarm
; 0000 01E7 
; 0000 01E8 }
	RCALL SUBOPT_0xD
	RJMP _0xA4
_0xA5:
; 0000 01E9 lcd_clear();
	RCALL SUBOPT_0x2
; 0000 01EA 
; 0000 01EB 
; 0000 01EC if(counter>=3){   //Admin can't confirm new id 3 times so pass did't change
	BRLT _0xA7
; 0000 01ED 
; 0000 01EE lcd_printf("Id Can't change");
	__POINTW1FN _0x0,252
	RCALL SUBOPT_0x1
; 0000 01EF 
; 0000 01F0 alarm();
	RCALL _alarm
; 0000 01F1 }
; 0000 01F2 else {
	RJMP _0xA8
_0xA7:
; 0000 01F3 
; 0000 01F4 ChangeId();      //change old id to new one
	RCALL _ChangeId
; 0000 01F5 
; 0000 01F6 lcd_printf("Id Changed");
	__POINTW1FN _0x0,268
	RCALL SUBOPT_0x1
; 0000 01F7 
; 0000 01F8 delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	RCALL _delay_ms
; 0000 01F9 }
_0xA8:
; 0000 01FA 
; 0000 01FB }
	RET
; .FEND
;void Admin(){
; 0000 01FF void Admin(){
_Admin:
; .FSTART _Admin
; 0000 0200 
; 0000 0201 lcd_clear();
	RCALL _lcd_clear
; 0000 0202 
; 0000 0203 lcd_printf("Enter Your ID   ");
	__POINTW1FN _0x0,279
	RCALL SUBOPT_0x1
; 0000 0204 
; 0000 0205 readid();                        //enter admin id
	RCALL _readid
; 0000 0206 
; 0000 0207 lcd_clear();
	RCALL _lcd_clear
; 0000 0208 
; 0000 0209 checkPass();                //enter admin pass
	RCALL _checkPass
; 0000 020A 
; 0000 020B if(id==Data[10]&&pass==Data[11]){       //enterd id and pass is id,pass of admin
	__GETW1MN _Data,20
	CP   R30,R4
	CPC  R31,R5
	BRNE _0xAA
	__GETW1MN _Data,22
	CP   R30,R12
	CPC  R31,R13
	BREQ _0xAB
_0xAA:
	RJMP _0xA9
_0xAB:
; 0000 020C 
; 0000 020D while(1){
_0xAC:
; 0000 020E 
; 0000 020F lcd_clear();
	RCALL _lcd_clear
; 0000 0210 
; 0000 0211 lcd_printf("* Close         # Edit");
	__POINTW1FN _0x0,296
	RCALL SUBOPT_0x1
; 0000 0212 
; 0000 0213 x=keypad();
	RCALL _keypad
	MOV  R6,R30
	CLR  R7
; 0000 0214 
; 0000 0215 if(x==11){  // admin want Edit info   he presed #
	RCALL SUBOPT_0x3
	BRNE _0xAF
; 0000 0216 
; 0000 0217 lcd_clear();
	RCALL _lcd_clear
; 0000 0218 
; 0000 0219 lcd_printf("* Edit id       # Edit Pass"); //press * for edit id press # for edit pass
	__POINTW1FN _0x0,319
	RCALL SUBOPT_0x1
; 0000 021A 
; 0000 021B x=keypad();
	RCALL SUBOPT_0x0
; 0000 021C 
; 0000 021D if(x==10){   //admin press *
	BRNE _0xB0
; 0000 021E 
; 0000 021F lcd_clear();
	RCALL SUBOPT_0x15
; 0000 0220 
; 0000 0221 lcd_printf("Enter ID        ");
; 0000 0222 
; 0000 0223 readid();         //read id of person want to be changed
	RCALL _readid
; 0000 0224 
; 0000 0225 lcd_clear();
	RCALL _lcd_clear
; 0000 0226 
; 0000 0227 saveId=id;        //saveId is id wanted to be changed
	__PUTWMRN _saveId,0,4,5
; 0000 0228 
; 0000 0229 lcd_printf("Enter new Id    ");
	__POINTW1FN _0x0,364
	RCALL SUBOPT_0x1
; 0000 022A 
; 0000 022B readid();        //enter new id
	RCALL _readid
; 0000 022C 
; 0000 022D confirmId();     //confirm new id
	RCALL _confirmId
; 0000 022E 
; 0000 022F }
; 0000 0230 else { //press # want change pass
	RJMP _0xB1
_0xB0:
; 0000 0231 
; 0000 0232 lcd_clear();
	RCALL SUBOPT_0x15
; 0000 0233 
; 0000 0234 lcd_printf("Enter ID        ");
; 0000 0235 
; 0000 0236 readid();      //read id of person want to be changed
	RCALL _readid
; 0000 0237 
; 0000 0238 lcd_clear();
	RCALL _lcd_clear
; 0000 0239 
; 0000 023A lcd_printf("Enter new Pass   ");
	__POINTW1FN _0x0,381
	RCALL SUBOPT_0x1
; 0000 023B 
; 0000 023C readpass();    //read new pass
	RCALL _readpass
; 0000 023D 
; 0000 023E lcd_clear();
	RCALL _lcd_clear
; 0000 023F 
; 0000 0240 confirmPass();  //confirm new pass
	RCALL _confirmPass
; 0000 0241 
; 0000 0242 lcd_clear();
	RCALL _lcd_clear
; 0000 0243 }
_0xB1:
; 0000 0244 
; 0000 0245 }
; 0000 0246 else break;    //press * to close admin mood
	RJMP _0xB2
_0xAF:
	RJMP _0xAE
; 0000 0247 }
_0xB2:
	RJMP _0xAC
_0xAE:
; 0000 0248 
; 0000 0249 }
; 0000 024A else { //enterd id and pass is not id,pass of admin
	RJMP _0xB3
_0xA9:
; 0000 024B lcd_clear();
	RCALL _lcd_clear
; 0000 024C 
; 0000 024D lcd_printf("You are not Admin");
	__POINTW1FN _0x0,399
	RCALL SUBOPT_0x1
; 0000 024E 
; 0000 024F }
_0xB3:
; 0000 0250 
; 0000 0251 }
	RET
; .FEND
;interrupt [3] void EXT__INT1(void)
; 0000 0256 {
_EXT__INT1:
; .FSTART _EXT__INT1
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0257 SREG.7 = 1; //enable global intrupt
	BSET 7
; 0000 0258 
; 0000 0259 PORTD.4= 1;  //turn on red led
	SBI  0x12,4
; 0000 025A 
; 0000 025B Admin();//admin mood
	RCALL _Admin
; 0000 025C 
; 0000 025D PORTD.4= 0;   //turn off red led
	CBI  0x12,4
; 0000 025E 
; 0000 025F delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0260 
; 0000 0261 lcd_clear();
	RCALL _lcd_clear
; 0000 0262 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	STS  __lcd_x,R16
	STS  __lcd_y,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x16
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x16
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	CPI  R17,10
	BREQ _0x2080001
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	STS  __lcd_maxx,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x17
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	LD   R17,Y+
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	RCALL SUBOPT_0x18
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	RCALL SUBOPT_0x18
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	RCALL SUBOPT_0x19
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x1A
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1B
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1B
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	RCALL SUBOPT_0x19
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	RCALL SUBOPT_0x19
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	__GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	RCALL SUBOPT_0x18
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	RCALL SUBOPT_0x18
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	RCALL SUBOPT_0x18
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x1A
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_put_lcd_G102:
; .FSTART _put_lcd_G102
	RCALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
	MOV  R26,R19
	RCALL _lcd_putchar
	MOVW R26,R16
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
_lcd_printf:
; .FSTART _lcd_printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	__ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	__ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_lcd_G102)
	LDI  R31,HIGH(_put_lcd_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G102
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG
_Data:
	.BYTE 0x18
_names:
	.BYTE 0xC
_y:
	.BYTE 0x2
_counter:
	.BYTE 0x2
_oldPass:
	.BYTE 0x2
_oldId:
	.BYTE 0x2
_saveId:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	RCALL _keypad
	MOV  R6,R30
	CLR  R7
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:90 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
	RCALL _lcd_clear
	LDS  R26,_counter
	LDS  R27,_counter+1
	SBIW R26,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R10,R30
	CPC  R11,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	MOVW R30,R10
	LDI  R26,LOW(_Data)
	LDI  R27,HIGH(_Data)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	__GETW1P
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_Data)
	LDI  R27,HIGH(_Data)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDS  R30,_oldPass
	LDS  R31,_oldPass+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__ASRW8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	MOVW R30,R4
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	STS  _counter,R30
	STS  _counter+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	LDS  R26,_counter
	LDS  R27,_counter+1
	SBIW R26,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_counter)
	LDI  R27,HIGH(_counter)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12
	ADD  R30,R6
	ADC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	MOVW R26,R10
	LSL  R26
	ROL  R27
	__ADDW2MN _Data,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	ST   Y,R30
	MOVW R30,R10
	LDI  R26,LOW(_Data)
	LDI  R27,HIGH(_Data)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	RJMP _EE_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDS  R26,_saveId
	LDS  R27,_saveId+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	RCALL _EE_Write
	LDS  R30,_saveId
	LDS  R31,_saveId+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	RCALL _lcd_clear
	__POINTW1FN _0x0,347
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x18:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x19:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
