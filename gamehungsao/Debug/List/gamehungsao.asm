
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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
	.DEF _basket_x=R5
	.DEF _star_x=R4
	.DEF _star_y=R7
	.DEF _old_basket_x=R6
	.DEF _old_star_x=R9
	.DEF _old_star_y=R8
	.DEF _miss_count=R11
	.DEF _game_over=R10
	.DEF _old_score=R12
	.DEF _old_score_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
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

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF

_0x0:
	.DB  0x44,0x69,0x65,0x6D,0x3A,0x0,0x4C,0x3A
	.DB  0x0,0x48,0x55,0x4E,0x47,0x20,0x53,0x41
	.DB  0x4F,0x0,0x42,0x54,0x31,0x3A,0x20,0x54
	.DB  0x72,0x61,0x69,0x0,0x42,0x54,0x32,0x3A
	.DB  0x20,0x50,0x68,0x61,0x69,0x0,0x42,0x54
	.DB  0x33,0x3A,0x20,0x53,0x74,0x61,0x72,0x74
	.DB  0x0,0x54,0x48,0x55,0x41,0x20,0x43,0x55
	.DB  0x4F,0x43,0x0,0x42,0x54,0x33,0x3A,0x20
	.DB  0x43,0x68,0x6F,0x69,0x20,0x6C,0x61,0x69
	.DB  0x0
_0x20C0060:
	.DB  0x1
_0x20C0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  _0x16
	.DW  _0x0*2

	.DW  0x03
	.DW  _0x16+6
	.DW  _0x0*2+6

	.DW  0x09
	.DW  _0x37
	.DW  _0x0*2+9

	.DW  0x0A
	.DW  _0x37+9
	.DW  _0x0*2+18

	.DW  0x0A
	.DW  _0x37+19
	.DW  _0x0*2+28

	.DW  0x0B
	.DW  _0x37+29
	.DW  _0x0*2+38

	.DW  0x0A
	.DW  _0x38
	.DW  _0x0*2+49

	.DW  0x06
	.DW  _0x38+10
	.DW  _0x0*2

	.DW  0x0E
	.DW  _0x38+16
	.DW  _0x0*2+59

	.DW  0x01
	.DW  __seed_G106
	.DW  _0x20C0060*2

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
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

	OUT  RAMPZ,R24

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
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <glcd.h>
;#include <font5x7.h>
;#include <delay.h>
;
;#define BTN_START  PINB.0
;#define BTN_LEFT   PINB.2
;#define BTN_RIGHT  PINB.3
;
;#define LCD_W      84
;#define LCD_H      48
;#define HUD_H      9
;#define BASKET_W   18
;#define BASKET_H   5
;#define STAR_SIZE  5
;#define STEP_X     3
;#define MAX_MISS   3
;#define SPEED_START_MS 90
;#define SPEED_MIN_MS   30
;
;unsigned char basket_x;
;unsigned char star_x;
;unsigned char star_y;
;unsigned char old_basket_x;
;unsigned char old_star_x;
;unsigned char old_star_y;
;unsigned char miss_count;
;unsigned char game_over;
;unsigned int old_score;
;unsigned char old_miss_count;
;unsigned int score;
;unsigned int tick_seed;
;unsigned char game_delay_ms;
;
;void uint_to_str(unsigned int value, char *s)
; 0000 0024 {

	.CSEG
_uint_to_str:
; .FSTART _uint_to_str
; 0000 0025     char temp[6];
; 0000 0026     unsigned char i = 0;
; 0000 0027     unsigned char j = 0;
; 0000 0028 
; 0000 0029     if (value == 0) {
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
;	value -> Y+10
;	*s -> Y+8
;	temp -> Y+2
;	i -> R17
;	j -> R16
	LDI  R17,0
	LDI  R16,0
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,0
	BRNE _0x3
; 0000 002A         s[0] = '0';
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(48)
	ST   X,R30
; 0000 002B         s[1] = 0;
	ADIW R26,1
	LDI  R30,LOW(0)
	RJMP _0x210000D
; 0000 002C         return;
; 0000 002D     }
; 0000 002E 
; 0000 002F     while (value > 0) {
_0x3:
_0x4:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL __CPW02
	BRSH _0x6
; 0000 0030         temp[i++] = (value % 10) + '0';
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
; 0000 0031         value /= 10;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0032     }
	RJMP _0x4
_0x6:
; 0000 0033 
; 0000 0034     while (i > 0) {
_0x7:
	CPI  R17,1
	BRLO _0x9
; 0000 0035         s[j++] = temp[--i];
	MOV  R30,R16
	SUBI R16,-1
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	SUBI R17,LOW(1)
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0036     }
	RJMP _0x7
_0x9:
; 0000 0037     s[j] = 0;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
_0x210000D:
	ST   X,R30
; 0000 0038 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,12
	RET
; .FEND
;
;unsigned char rand_x(void)
; 0000 003B {
_rand_x:
; .FSTART _rand_x
; 0000 003C     tick_seed = tick_seed * 109u + 89u;
	LDS  R26,_tick_seed
	LDS  R27,_tick_seed+1
	LDI  R30,LOW(109)
	CALL __MULB1W2U
	SUBI R30,LOW(-89)
	SBCI R31,HIGH(-89)
	CALL SUBOPT_0x0
; 0000 003D     return (unsigned char)(tick_seed % (LCD_W - STAR_SIZE - 2)) + 1;
	LDS  R26,_tick_seed
	LDS  R27,_tick_seed+1
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	CALL __MODW21U
	SUBI R30,-LOW(1)
	RET
; 0000 003E }
; .FEND
;
;void new_star(void)
; 0000 0041 {
_new_star:
; .FSTART _new_star
; 0000 0042     star_x = rand_x();
	RCALL _rand_x
	MOV  R4,R30
; 0000 0043     star_y = HUD_H + 1;
	LDI  R30,LOW(10)
	MOV  R7,R30
; 0000 0044 }
	RET
; .FEND
;
;void draw_star(unsigned char x, unsigned char y)
; 0000 0047 {
_draw_star:
; .FSTART _draw_star
; 0000 0048     glcd_putpixel(x + 2, y, 1);
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
; 0000 0049     glcd_putpixel(x + 1, y + 1, 1);
	CALL SUBOPT_0x3
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x2
; 0000 004A     glcd_putpixel(x + 2, y + 1, 1);
	CALL SUBOPT_0x1
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x2
; 0000 004B     glcd_putpixel(x + 3, y + 1, 1);
	CALL SUBOPT_0x4
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x2
; 0000 004C     glcd_putpixel(x,     y + 2, 1);
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x2
; 0000 004D     glcd_putpixel(x + 1, y + 2, 1);
	CALL SUBOPT_0x3
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x2
; 0000 004E     glcd_putpixel(x + 2, y + 2, 1);
	CALL SUBOPT_0x1
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x2
; 0000 004F     glcd_putpixel(x + 3, y + 2, 1);
	CALL SUBOPT_0x4
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x2
; 0000 0050     glcd_putpixel(x + 4, y + 2, 1);
	LDD  R30,Y+1
	SUBI R30,-LOW(4)
	ST   -Y,R30
	LDD  R30,Y+1
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x2
; 0000 0051     glcd_putpixel(x + 1, y + 3, 1);
	CALL SUBOPT_0x3
	SUBI R30,-LOW(3)
	CALL SUBOPT_0x2
; 0000 0052     glcd_putpixel(x + 3, y + 3, 1);
	CALL SUBOPT_0x4
	SUBI R30,-LOW(3)
	CALL SUBOPT_0x2
; 0000 0053     glcd_putpixel(x,     y + 4, 1);
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	SUBI R30,-LOW(4)
	CALL SUBOPT_0x2
; 0000 0054     glcd_putpixel(x + 4, y + 4, 1);
	LDD  R30,Y+1
	SUBI R30,-LOW(4)
	ST   -Y,R30
	LDD  R30,Y+1
	SUBI R30,-LOW(4)
	CALL SUBOPT_0x2
; 0000 0055 }
	RJMP _0x210000C
; .FEND
;
;void clear_star(unsigned char x, unsigned char y)
; 0000 0058 {
_clear_star:
; .FSTART _clear_star
; 0000 0059     unsigned char i;
; 0000 005A     unsigned char j;
; 0000 005B 
; 0000 005C     for (i = 0; i < STAR_SIZE; i++) {
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	x -> Y+3
;	y -> Y+2
;	i -> R17
;	j -> R16
	LDI  R17,LOW(0)
_0xB:
	CPI  R17,5
	BRSH _0xC
; 0000 005D         for (j = 0; j < STAR_SIZE; j++) {
	LDI  R16,LOW(0)
_0xE:
	CPI  R16,5
	BRSH _0xF
; 0000 005E             glcd_putpixel(x + i, y + j, 0);
	MOV  R30,R17
	LDD  R26,Y+3
	ADD  R30,R26
	ST   -Y,R30
	MOV  R30,R16
	LDD  R26,Y+3
	ADD  R30,R26
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_putpixel
; 0000 005F         }
	SUBI R16,-1
	RJMP _0xE
_0xF:
; 0000 0060     }
	SUBI R17,-1
	RJMP _0xB
_0xC:
; 0000 0061 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void clear_rect(unsigned char left, unsigned char top, unsigned char right, unsigned char bottom)
; 0000 0064 {
_clear_rect:
; .FSTART _clear_rect
; 0000 0065     unsigned char x;
; 0000 0066     unsigned char y;
; 0000 0067 
; 0000 0068     for (x = left; x <= right; x++) {
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	left -> Y+5
;	top -> Y+4
;	right -> Y+3
;	bottom -> Y+2
;	x -> R17
;	y -> R16
	LDD  R17,Y+5
_0x11:
	LDD  R30,Y+3
	CP   R30,R17
	BRLO _0x12
; 0000 0069         for (y = top; y <= bottom; y++) {
	LDD  R16,Y+4
_0x14:
	LDD  R30,Y+2
	CP   R30,R16
	BRLO _0x15
; 0000 006A             glcd_putpixel(x, y, 0);
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(0)
	RCALL _glcd_putpixel
; 0000 006B         }
	SUBI R16,-1
	RJMP _0x14
_0x15:
; 0000 006C     }
	SUBI R17,-1
	RJMP _0x11
_0x12:
; 0000 006D }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2100009
; .FEND
;
;void draw_basket(unsigned char x)
; 0000 0070 {
_draw_basket:
; .FSTART _draw_basket
; 0000 0071     unsigned char y = LCD_H - BASKET_H;
; 0000 0072 
; 0000 0073     glcd_setcolor(1);
	ST   -Y,R26
	ST   -Y,R17
;	x -> Y+1
;	y -> R17
	LDI  R17,43
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
; 0000 0074     glcd_line(x, y, x + 3, LCD_H - 1);
; 0000 0075     glcd_line(x + BASKET_W, y, x + BASKET_W - 3, LCD_H - 1);
; 0000 0076     glcd_line(x + 3, LCD_H - 1, x + BASKET_W - 3, LCD_H - 1);
; 0000 0077     glcd_line(x + 2, y + 2, x + BASKET_W - 2, y + 2);
; 0000 0078 }
	RJMP _0x210000B
; .FEND
;
;void clear_basket(unsigned char x)
; 0000 007B {
_clear_basket:
; .FSTART _clear_basket
; 0000 007C     unsigned char y = LCD_H - BASKET_H;
; 0000 007D 
; 0000 007E     glcd_setcolor(0);
	ST   -Y,R26
	ST   -Y,R17
;	x -> Y+1
;	y -> R17
	LDI  R17,43
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 007F     glcd_line(x, y, x + 3, LCD_H - 1);
; 0000 0080     glcd_line(x + BASKET_W, y, x + BASKET_W - 3, LCD_H - 1);
; 0000 0081     glcd_line(x + 3, LCD_H - 1, x + BASKET_W - 3, LCD_H - 1);
; 0000 0082     glcd_line(x + 2, y + 2, x + BASKET_W - 2, y + 2);
; 0000 0083     glcd_setcolor(1);
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
; 0000 0084 }
_0x210000B:
	LDD  R17,Y+0
_0x210000C:
	ADIW R28,2
	RET
; .FEND
;
;void draw_hud(void)
; 0000 0087 {
_draw_hud:
; .FSTART _draw_hud
; 0000 0088     char buf[6];
; 0000 0089 
; 0000 008A     clear_rect(0, 0, LCD_W - 1, HUD_H);
	SBIW R28,6
;	buf -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(83)
	ST   -Y,R30
	LDI  R26,LOW(9)
	RCALL _clear_rect
; 0000 008B     glcd_setcolor(1);
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
; 0000 008C     glcd_outtextxy(0, 0, "Diem:");
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	__POINTW2MN _0x16,0
	CALL SUBOPT_0x6
; 0000 008D     uint_to_str(score, buf);
; 0000 008E     glcd_outtextxy(34, 0, buf);
	LDI  R30,LOW(34)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL _glcd_outtextxy
; 0000 008F     glcd_outtextxy(58, 0, "L:");
	LDI  R30,LOW(58)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW2MN _0x16,6
	CALL _glcd_outtextxy
; 0000 0090     glcd_putchar((MAX_MISS - miss_count) + '0');
	LDI  R30,LOW(3)
	SUB  R30,R11
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _glcd_putchar
; 0000 0091     glcd_line(0, HUD_H, LCD_W - 1, HUD_H);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(83)
	ST   -Y,R30
	LDI  R26,LOW(9)
	CALL _glcd_line
; 0000 0092 }
	JMP  _0x2100009
; .FEND

	.DSEG
_0x16:
	.BYTE 0x9
;
;void draw_screen(void)
; 0000 0095 {

	.CSEG
_draw_screen:
; .FSTART _draw_screen
; 0000 0096     if ((old_score != score) || (old_miss_count != miss_count)) {
	LDS  R30,_score
	LDS  R31,_score+1
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x18
	LDS  R26,_old_miss_count
	CP   R11,R26
	BREQ _0x17
_0x18:
; 0000 0097         draw_hud();
	RCALL _draw_hud
; 0000 0098         old_score = score;
	__GETWRMN 12,13,0,_score
; 0000 0099         old_miss_count = miss_count;
	STS  _old_miss_count,R11
; 0000 009A     }
; 0000 009B 
; 0000 009C     clear_star(old_star_x, old_star_y);
_0x17:
	ST   -Y,R9
	MOV  R26,R8
	RCALL _clear_star
; 0000 009D     clear_basket(old_basket_x);
	MOV  R26,R6
	RCALL _clear_basket
; 0000 009E     draw_star(star_x, star_y);
	CALL SUBOPT_0x7
; 0000 009F     draw_basket(basket_x);
; 0000 00A0 
; 0000 00A1     old_star_x = star_x;
	MOV  R9,R4
; 0000 00A2     old_star_y = star_y;
	MOV  R8,R7
; 0000 00A3     old_basket_x = basket_x;
	MOV  R6,R5
; 0000 00A4 }
	RET
; .FEND
;
;void read_buttons(void)
; 0000 00A7 {
_read_buttons:
; .FSTART _read_buttons
; 0000 00A8     if (BTN_LEFT == 0) {
	SBIC 0x16,2
	RJMP _0x1A
; 0000 00A9         delay_ms(12);
	LDI  R26,LOW(12)
	LDI  R27,0
	CALL _delay_ms
; 0000 00AA         if (BTN_LEFT == 0) {
	SBIC 0x16,2
	RJMP _0x1B
; 0000 00AB             if (basket_x > STEP_X) {
	LDI  R30,LOW(3)
	CP   R30,R5
	BRSH _0x1C
; 0000 00AC                 basket_x -= STEP_X;
	SUB  R5,R30
; 0000 00AD             } else {
	RJMP _0x1D
_0x1C:
; 0000 00AE                 basket_x = 0;
	CLR  R5
; 0000 00AF             }
_0x1D:
; 0000 00B0             tick_seed += 17;
	LDS  R30,_tick_seed
	LDS  R31,_tick_seed+1
	ADIW R30,17
	CALL SUBOPT_0x0
; 0000 00B1         }
; 0000 00B2     }
_0x1B:
; 0000 00B3 
; 0000 00B4     if (BTN_RIGHT == 0) {
_0x1A:
	SBIC 0x16,3
	RJMP _0x1E
; 0000 00B5         delay_ms(12);
	LDI  R26,LOW(12)
	LDI  R27,0
	CALL _delay_ms
; 0000 00B6         if (BTN_RIGHT == 0) {
	SBIC 0x16,3
	RJMP _0x1F
; 0000 00B7             if (basket_x < LCD_W - BASKET_W - STEP_X - 1) {
	LDI  R30,LOW(62)
	CP   R5,R30
	BRSH _0x20
; 0000 00B8                 basket_x += STEP_X;
	LDI  R30,LOW(3)
	ADD  R5,R30
; 0000 00B9             } else {
	RJMP _0x21
_0x20:
; 0000 00BA                 basket_x = LCD_W - BASKET_W - 1;
	LDI  R30,LOW(65)
	MOV  R5,R30
; 0000 00BB             }
_0x21:
; 0000 00BC             tick_seed += 31;
	LDS  R30,_tick_seed
	LDS  R31,_tick_seed+1
	ADIW R30,31
	CALL SUBOPT_0x0
; 0000 00BD         }
; 0000 00BE     }
_0x1F:
; 0000 00BF }
_0x1E:
	RET
; .FEND
;
;void update_star(void)
; 0000 00C2 {
_update_star:
; .FSTART _update_star
; 0000 00C3     if (star_y < LCD_H - STAR_SIZE - 1) {
	LDI  R30,LOW(42)
	CP   R7,R30
	BRSH _0x22
; 0000 00C4         star_y++;
	INC  R7
; 0000 00C5         return;
	RET
; 0000 00C6     }
; 0000 00C7 
; 0000 00C8     if ((star_x + STAR_SIZE >= basket_x) && (star_x <= basket_x + BASKET_W)) {
_0x22:
	MOV  R30,R4
	LDI  R31,0
	ADIW R30,5
	MOVW R26,R30
	MOV  R30,R5
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x24
	MOV  R30,R5
	LDI  R31,0
	ADIW R30,18
	MOV  R26,R4
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x25
_0x24:
	RJMP _0x23
_0x25:
; 0000 00C9         score++;
	LDI  R26,LOW(_score)
	LDI  R27,HIGH(_score)
	CALL SUBOPT_0x8
; 0000 00CA         new_star();
	RCALL _new_star
; 0000 00CB         return;
	RET
; 0000 00CC     }
; 0000 00CD 
; 0000 00CE     if (miss_count < MAX_MISS) {
_0x23:
	LDI  R30,LOW(3)
	CP   R11,R30
	BRSH _0x26
; 0000 00CF         miss_count++;
	INC  R11
; 0000 00D0     }
; 0000 00D1 
; 0000 00D2     if (miss_count >= MAX_MISS) {
_0x26:
	LDI  R30,LOW(3)
	CP   R11,R30
	BRLO _0x27
; 0000 00D3         game_over = 1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 00D4     } else {
	RJMP _0x28
_0x27:
; 0000 00D5         new_star();
	RCALL _new_star
; 0000 00D6     }
_0x28:
; 0000 00D7 }
	RET
; .FEND
;
;void update_speed(void)
; 0000 00DA {
_update_speed:
; .FSTART _update_speed
; 0000 00DB     if (score < 5) {
	CALL SUBOPT_0x9
	SBIW R26,5
	BRSH _0x29
; 0000 00DC         game_delay_ms = 90;
	LDI  R30,LOW(90)
	RJMP _0x40
; 0000 00DD     } else if (score < 10) {
_0x29:
	CALL SUBOPT_0x9
	SBIW R26,10
	BRSH _0x2B
; 0000 00DE         game_delay_ms = 75;
	LDI  R30,LOW(75)
	RJMP _0x40
; 0000 00DF     } else if (score < 15) {
_0x2B:
	CALL SUBOPT_0x9
	SBIW R26,15
	BRSH _0x2D
; 0000 00E0         game_delay_ms = 60;
	LDI  R30,LOW(60)
	RJMP _0x40
; 0000 00E1     } else if (score < 25) {
_0x2D:
	CALL SUBOPT_0x9
	SBIW R26,25
	BRSH _0x2F
; 0000 00E2         game_delay_ms = 45;
	LDI  R30,LOW(45)
	RJMP _0x40
; 0000 00E3     } else {
_0x2F:
; 0000 00E4         game_delay_ms = SPEED_MIN_MS;
	LDI  R30,LOW(30)
_0x40:
	STS  _game_delay_ms,R30
; 0000 00E5     }
; 0000 00E6 }
	RET
; .FEND
;
;void reset_game(void)
; 0000 00E9 {
_reset_game:
; .FSTART _reset_game
; 0000 00EA     basket_x = (LCD_W - BASKET_W) / 2;
	LDI  R30,LOW(33)
	MOV  R5,R30
; 0000 00EB     old_basket_x = basket_x;
	MOV  R6,R5
; 0000 00EC     score = 0;
	LDI  R30,LOW(0)
	STS  _score,R30
	STS  _score+1,R30
; 0000 00ED     miss_count = 0;
	CLR  R11
; 0000 00EE     game_over = 0;
	CLR  R10
; 0000 00EF     game_delay_ms = SPEED_START_MS;
	LDI  R30,LOW(90)
	STS  _game_delay_ms,R30
; 0000 00F0     new_star();
	RCALL _new_star
; 0000 00F1     old_star_x = star_x;
	MOV  R9,R4
; 0000 00F2     old_star_y = star_y;
	MOV  R8,R7
; 0000 00F3     old_score = 65535u;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R12,R30
; 0000 00F4     old_miss_count = 255;
	STS  _old_miss_count,R30
; 0000 00F5     glcd_clear();
	RCALL _glcd_clear
; 0000 00F6     draw_hud();
	RCALL _draw_hud
; 0000 00F7     draw_star(star_x, star_y);
	CALL SUBOPT_0x7
; 0000 00F8     draw_basket(basket_x);
; 0000 00F9 }
	RET
; .FEND
;
;void wait_bt3_press(void)
; 0000 00FC {
_wait_bt3_press:
; .FSTART _wait_bt3_press
; 0000 00FD     while (BTN_START != 0) {
_0x31:
	SBIS 0x16,0
	RJMP _0x33
; 0000 00FE         tick_seed++;
	LDI  R26,LOW(_tick_seed)
	LDI  R27,HIGH(_tick_seed)
	CALL SUBOPT_0x8
; 0000 00FF         delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 0100     }
	RJMP _0x31
_0x33:
; 0000 0101     delay_ms(150);
	LDI  R26,LOW(150)
	LDI  R27,0
	CALL _delay_ms
; 0000 0102     while (BTN_START == 0);
_0x34:
	SBIS 0x16,0
	RJMP _0x34
; 0000 0103     delay_ms(80);
	LDI  R26,LOW(80)
	LDI  R27,0
	CALL _delay_ms
; 0000 0104 }
	RET
; .FEND
;
;void show_start(void)
; 0000 0107 {
_show_start:
; .FSTART _show_start
; 0000 0108     glcd_clear();
	RCALL _glcd_clear
; 0000 0109     glcd_outtextxy(9, 4, "HUNG SAO");
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	__POINTW2MN _0x37,0
	CALL SUBOPT_0xA
; 0000 010A     glcd_outtextxy(0, 18, "BT1: Trai");
	LDI  R30,LOW(18)
	ST   -Y,R30
	__POINTW2MN _0x37,9
	CALL SUBOPT_0xA
; 0000 010B     glcd_outtextxy(0, 28, "BT2: Phai");
	LDI  R30,LOW(28)
	ST   -Y,R30
	__POINTW2MN _0x37,19
	CALL SUBOPT_0xA
; 0000 010C     glcd_outtextxy(0, 40, "BT3: Start");
	LDI  R30,LOW(40)
	ST   -Y,R30
	__POINTW2MN _0x37,29
	CALL _glcd_outtextxy
; 0000 010D 
; 0000 010E     wait_bt3_press();
	RCALL _wait_bt3_press
; 0000 010F }
	RET
; .FEND

	.DSEG
_0x37:
	.BYTE 0x28
;
;void show_game_over(void)
; 0000 0112 {

	.CSEG
_show_game_over:
; .FSTART _show_game_over
; 0000 0113     char buf[6];
; 0000 0114 
; 0000 0115     glcd_clear();
	SBIW R28,6
;	buf -> Y+0
	RCALL _glcd_clear
; 0000 0116     glcd_outtextxy(15, 5, "THUA CUOC");
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	__POINTW2MN _0x38,0
	CALL _glcd_outtextxy
; 0000 0117     glcd_outtextxy(8, 18, "Diem:");
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(18)
	ST   -Y,R30
	__POINTW2MN _0x38,10
	CALL SUBOPT_0x6
; 0000 0118     uint_to_str(score, buf);
; 0000 0119     glcd_outtextxy(44, 18, buf);
	LDI  R30,LOW(44)
	ST   -Y,R30
	LDI  R30,LOW(18)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL SUBOPT_0xA
; 0000 011A     glcd_outtextxy(0, 36, "BT3: Choi lai");
	LDI  R30,LOW(36)
	ST   -Y,R30
	__POINTW2MN _0x38,16
	CALL _glcd_outtextxy
; 0000 011B 
; 0000 011C     wait_bt3_press();
	RCALL _wait_bt3_press
; 0000 011D }
	RJMP _0x2100009
; .FEND

	.DSEG
_0x38:
	.BYTE 0x1E
;
;void main(void)
; 0000 0120 {

	.CSEG
_main:
; .FSTART _main
; 0000 0121     GLCDINIT_t glcd_init_data;
; 0000 0122 
; 0000 0123     DDRD = 0x80;
	SBIW R28,8
;	glcd_init_data -> Y+0
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 0124     PORTD = 0x80;
	OUT  0x12,R30
; 0000 0125 
; 0000 0126     DDRB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 0127     PORTB = 0x0D;
	LDI  R30,LOW(13)
	OUT  0x18,R30
; 0000 0128 
; 0000 0129     glcd_init_data.font = font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 012A     glcd_init_data.temp_coef = 80;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0000 012B     glcd_init_data.bias = 3;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	STD  Y+6,R30
; 0000 012C     glcd_init_data.vlcd = 55;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x37)
	STD  Y+7,R30
; 0000 012D     glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 012E 
; 0000 012F     tick_seed = 1234;
	LDI  R30,LOW(1234)
	LDI  R31,HIGH(1234)
	CALL SUBOPT_0x0
; 0000 0130     show_start();
	RCALL _show_start
; 0000 0131 
; 0000 0132     while (1) {
_0x39:
; 0000 0133         reset_game();
	RCALL _reset_game
; 0000 0134 
; 0000 0135         while (game_over == 0) {
_0x3C:
	TST  R10
	BRNE _0x3E
; 0000 0136             tick_seed++;
	LDI  R26,LOW(_tick_seed)
	LDI  R27,HIGH(_tick_seed)
	CALL SUBOPT_0x8
; 0000 0137             read_buttons();
	RCALL _read_buttons
; 0000 0138             update_star();
	RCALL _update_star
; 0000 0139             update_speed();
	RCALL _update_speed
; 0000 013A             draw_screen();
	RCALL _draw_screen
; 0000 013B             delay_ms(game_delay_ms);
	LDS  R26,_game_delay_ms
	CLR  R27
	CALL _delay_ms
; 0000 013C         }
	RJMP _0x3C
_0x3E:
; 0000 013D 
; 0000 013E         show_game_over();
	RCALL _show_game_over
; 0000 013F     }
	RJMP _0x39
; 0000 0140 }
_0x3F:
	RJMP _0x3F
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_pcd8544_delay_G100:
; .FSTART _pcd8544_delay_G100
	RET
; .FEND
_pcd8544_wrbus_G100:
; .FSTART _pcd8544_wrbus_G100
	ST   -Y,R26
	ST   -Y,R17
	LDS  R30,101
	ANDI R30,0xEF
	STS  101,R30
	LDI  R17,LOW(8)
_0x2000004:
	RCALL _pcd8544_delay_G100
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2000006
	LDS  R30,101
	ORI  R30,2
	RJMP _0x20000A0
_0x2000006:
	LDS  R30,101
	ANDI R30,0xFD
_0x20000A0:
	STS  101,R30
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G100
	LDS  R30,101
	ORI  R30,4
	STS  101,R30
	RCALL _pcd8544_delay_G100
	LDS  R30,101
	ANDI R30,0xFB
	STS  101,R30
	SUBI R17,LOW(1)
	BRNE _0x2000004
	LDS  R30,101
	ORI  R30,0x10
	STS  101,R30
	LDD  R17,Y+0
	JMP  _0x2100003
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	LDS  R30,101
	ANDI R30,0xFE
	STS  101,R30
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x210000A
; .FEND
_pcd8544_wrdata_G100:
; .FSTART _pcd8544_wrdata_G100
	ST   -Y,R26
	LDS  R30,101
	ORI  R30,1
	STS  101,R30
	LD   R26,Y
	RCALL _pcd8544_wrbus_G100
	RJMP _0x210000A
; .FEND
_pcd8544_setaddr_G100:
; .FSTART _pcd8544_setaddr_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R17,R30
	LDI  R30,LOW(84)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _gfx_addr_G100,R30
	STS  _gfx_addr_G100+1,R31
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2100002
; .FEND
_pcd8544_gotoxy:
; .FSTART _pcd8544_gotoxy
	ST   -Y,R26
	LDD  R30,Y+1
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_setaddr_G100
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	JMP  _0x2100003
; .FEND
_pcd8544_rdbyte:
; .FSTART _pcd8544_rdbyte
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_gotoxy
	LDS  R30,_gfx_addr_G100
	LDS  R31,_gfx_addr_G100+1
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	LD   R30,Z
	JMP  _0x2100003
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	CALL SUBOPT_0xB
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G100
	RJMP _0x210000A
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	LDS  R30,100
	ORI  R30,0x10
	CALL SUBOPT_0xC
	ORI  R30,0x10
	STS  101,R30
	LDS  R30,100
	ORI  R30,4
	CALL SUBOPT_0xC
	ANDI R30,0xFB
	STS  101,R30
	LDS  R30,100
	ORI  R30,2
	STS  100,R30
	LDS  R30,100
	ORI  R30,1
	STS  100,R30
	LDS  R30,100
	ORI  R30,8
	CALL SUBOPT_0xC
	ANDI R30,0XF7
	STS  101,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	LDS  R30,101
	ORI  R30,8
	STS  101,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ _0x2000008
	LDD  R30,Z+6
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+6
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+7
	ANDI R30,0x7F
	MOV  R19,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20000A1
_0x2000008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(50)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20000A1:
	__PUTW1MN _glcd_state,27
	LDI  R26,LOW(33)
	RCALL _pcd8544_wrcmd
	MOV  R30,R17
	ORI  R30,4
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R16
	ORI  R30,0x10
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R19
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(32)
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	RJMP _0x2100009
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x200000A
	LDI  R30,LOW(12)
	RJMP _0x200000B
_0x200000A:
	LDI  R30,LOW(8)
_0x200000B:
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
_0x210000A:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x200000D
	LDI  R19,LOW(255)
_0x200000D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _pcd8544_gotoxy
	__GETWRN 16,17,504
_0x200000E:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2000010
	MOV  R26,R19
	RCALL _pcd8544_wrbyte
	RJMP _0x200000E
_0x2000010:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	JMP  _0x2100001
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x54)
	BRSH _0x2000012
	LDD  R26,Y+3
	CPI  R26,LOW(0x30)
	BRLO _0x2000011
_0x2000012:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2100004
_0x2000011:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x2000014
	OR   R17,R16
	RJMP _0x2000015
_0x2000014:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2000015:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2100004
; .FEND
_pcd8544_wrmasked_G100:
; .FSTART _pcd8544_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2000020
	CPI  R30,LOW(0x8)
	BRNE _0x2000021
_0x2000020:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x2000022
_0x2000021:
	CPI  R30,LOW(0x3)
	BRNE _0x2000024
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000025
_0x2000024:
	CPI  R30,0
	BRNE _0x2000026
_0x2000025:
_0x2000022:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000027
_0x2000026:
	CPI  R30,LOW(0x2)
	BRNE _0x2000028
_0x2000027:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x200001E
_0x2000028:
	CPI  R30,LOW(0x1)
	BRNE _0x2000029
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x200001E
_0x2000029:
	CPI  R30,LOW(0x4)
	BRNE _0x200001E
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x200001E:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+0
_0x2100009:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x54)
	BRSH _0x200002C
	LDD  R26,Y+15
	CPI  R26,LOW(0x30)
	BRSH _0x200002C
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x200002C
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x200002B
_0x200002C:
	RJMP _0x2100008
_0x200002B:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRLO _0x200002E
	LDD  R26,Y+16
	LDI  R30,LOW(84)
	SUB  R30,R26
	STD  Y+14,R30
_0x200002E:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,49
	BRLO _0x200002F
	LDD  R26,Y+15
	LDI  R30,LOW(48)
	SUB  R30,R26
	STD  Y+13,R30
_0x200002F:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2000030
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	RJMP _0x2100008
_0x2000034:
	CPI  R30,LOW(0x3)
	BRNE _0x2000037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000036
	RJMP _0x2100008
_0x2000036:
_0x2000037:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000039
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000038
_0x2000039:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0xD
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x200003B:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x200003D
	MOV  R17,R16
_0x200003E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000040
	CALL SUBOPT_0xE
	RJMP _0x200003E
_0x2000040:
	RJMP _0x200003B
_0x200003D:
_0x2000038:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x2000041
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0xD
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x2000042
	SUBI R19,-LOW(1)
_0x2000042:
	LDI  R18,LOW(0)
_0x2000043:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000045
	LDD  R17,Y+14
_0x2000046:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000048
	CALL SUBOPT_0xE
	RJMP _0x2000046
_0x2000048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0xD
	RJMP _0x2000043
_0x2000045:
_0x2000041:
_0x2000030:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000049:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x200004B
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x200004C
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x200004D
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x2000052
	CPI  R30,LOW(0x3)
	BRNE _0x2000053
_0x2000052:
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x7)
	BRNE _0x2000055
_0x2000054:
	RJMP _0x2000056
_0x2000055:
	CPI  R30,LOW(0x8)
	BRNE _0x2000057
_0x2000056:
	RJMP _0x2000058
_0x2000057:
	CPI  R30,LOW(0x9)
	BRNE _0x2000059
_0x2000058:
	RJMP _0x200005A
_0x2000059:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x200005A:
	ST   -Y,R16
	LDD  R26,Y+16
	RCALL _pcd8544_gotoxy
	RJMP _0x2000050
_0x200005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2000050
	CALL SUBOPT_0xF
_0x2000050:
_0x200005D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2000060
	CALL SUBOPT_0x10
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	LD   R26,Z
	CALL _glcd_writemem
	RJMP _0x2000061
_0x2000060:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000065
	LDI  R21,LOW(0)
	RJMP _0x2000066
_0x2000065:
	CPI  R30,LOW(0xA)
	BRNE _0x2000064
	LDI  R21,LOW(255)
	RJMP _0x2000066
_0x2000064:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x200006D
	CPI  R30,LOW(0x8)
	BRNE _0x200006E
_0x200006D:
_0x2000066:
	CALL SUBOPT_0x12
	MOV  R21,R30
	RJMP _0x200006F
_0x200006E:
	CPI  R30,LOW(0x3)
	BRNE _0x2000071
	COM  R21
	RJMP _0x2000072
_0x2000071:
	CPI  R30,0
	BRNE _0x2000074
_0x2000072:
_0x200006F:
	MOV  R26,R21
	RCALL _pcd8544_wrdata_G100
	RJMP _0x200006B
_0x2000074:
	CALL SUBOPT_0x13
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G100
_0x200006B:
_0x2000061:
	RJMP _0x200005D
_0x200005F:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000075
_0x200004D:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000076
_0x200004C:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000077
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000078
_0x2000077:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000078:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200007C
	CALL SUBOPT_0xF
_0x200007D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200007F
	CALL SUBOPT_0xB
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x14
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x10
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x200007D
_0x200007F:
	RJMP _0x200007B
_0x200007C:
	CPI  R30,LOW(0x9)
	BRNE _0x2000080
	LDI  R21,LOW(0)
	RJMP _0x2000081
_0x2000080:
	CPI  R30,LOW(0xA)
	BRNE _0x2000087
	LDI  R21,LOW(255)
_0x2000081:
	CALL SUBOPT_0x12
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2000084:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000086
	CALL SUBOPT_0x13
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000084
_0x2000086:
	RJMP _0x200007B
_0x2000087:
_0x2000088:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200008A
	CALL SUBOPT_0x15
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000088
_0x200008A:
_0x200007B:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x200008B
	RJMP _0x200004B
_0x200008B:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x200008C
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000A2
_0x200008C:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000A2:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000091
	CALL SUBOPT_0xF
_0x2000092:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000094
	CALL SUBOPT_0xB
	SBIW R30,1
	SUBI R30,LOW(-_gfx_buffer_G100)
	SBCI R31,HIGH(-_gfx_buffer_G100)
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x14
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x10
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2000092
_0x2000094:
	RJMP _0x2000090
_0x2000091:
	CPI  R30,LOW(0x9)
	BRNE _0x2000095
	LDI  R21,LOW(0)
	RJMP _0x2000096
_0x2000095:
	CPI  R30,LOW(0xA)
	BRNE _0x200009C
	LDI  R21,LOW(255)
_0x2000096:
	CALL SUBOPT_0x12
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x2000099:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200009B
	CALL SUBOPT_0x13
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x2000099
_0x200009B:
	RJMP _0x2000090
_0x200009C:
_0x200009D:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200009F
	CALL SUBOPT_0x15
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G100
	RJMP _0x200009D
_0x200009F:
_0x2000090:
_0x2000075:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000049
_0x200004B:
_0x2100008:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x16
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2100003
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	JMP  _0x2100003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2100003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x16
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2100003
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,48
	BRLT _0x2020006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	JMP  _0x2100003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2100003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x17
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100007
_0x202000B:
	CALL SUBOPT_0x18
	STD  Y+7,R0
	CALL SUBOPT_0x18
	STD  Y+6,R0
	CALL SUBOPT_0x18
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100007
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100007
_0x202000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x202000E
	SUBI R20,-LOW(1)
_0x202000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2100007
_0x202000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2100007:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x19
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x17
	SBIW R30,0
	BRNE PC+2
	RJMP _0x202001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020020
	RJMP _0x2020021
_0x2020020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020022
	RJMP _0x2100006
_0x2020022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,85
	BRLO _0x2020023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x19
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x19
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x1A
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RJMP _0x2100006
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
_0x2100006:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2020025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020025
_0x2020027:
	LDD  R17,Y+0
	RJMP _0x2100004
; .FEND
_glcd_putpixelm_G101:
; .FSTART _glcd_putpixelm_G101
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x202003E
	LDS  R30,_glcd_state
	RJMP _0x202003F
_0x202003E:
	__GETB1MN _glcd_state,1
_0x202003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2020041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2020041:
	LD   R30,Y
	RJMP _0x2100002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RJMP _0x2100003
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2020042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2020043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	RJMP _0x2100005
_0x2020043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2020044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2020045
_0x2020044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2020045:
_0x2020047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020049:
	CALL SUBOPT_0x1B
	BRSH _0x202004B
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G101
	STD  Y+7,R30
	RJMP _0x2020049
_0x202004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2020047
	RJMP _0x202004C
_0x2020042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x202004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x202004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x202011B
_0x202004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x202011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2020051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020053:
	CALL SUBOPT_0x1B
	BRSH _0x2020055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x1C
	STD  Y+7,R30
	RJMP _0x2020053
_0x2020055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2020051
	RJMP _0x2020056
_0x202004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020057:
	CALL SUBOPT_0x1B
	BRLO PC+2
	RJMP _0x2020059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x202005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x202005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x202005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x202005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x202005C
_0x202005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x1D
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2020060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x1E
_0x2020060:
	ST   -Y,R17
	CALL SUBOPT_0x1C
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x202005E
	RJMP _0x2020061
_0x202005C:
_0x2020063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x1D
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2020065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x1E
_0x2020065:
	ST   -Y,R17
	CALL SUBOPT_0x1C
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2020063
_0x2020061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2020057
_0x2020059:
_0x2020056:
_0x202004C:
_0x2100005:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2100004:
	ADIW R28,5
	RET
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2100003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2080007
	CPI  R30,LOW(0xA)
	BRNE _0x2080008
_0x2080007:
	LDS  R17,_glcd_state
	RJMP _0x2080009
_0x2080008:
	CPI  R30,LOW(0x9)
	BRNE _0x208000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2080009
_0x208000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2080005
	__GETBRMN 17,_glcd_state,16
_0x2080009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x208000E
	CPI  R17,0
	BREQ _0x208000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2100002
_0x208000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2100002
_0x208000E:
	CPI  R17,0
	BRNE _0x2080011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2100002
_0x2080011:
_0x2080005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2100002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2080015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2100002
_0x2080015:
	CPI  R30,LOW(0x2)
	BRNE _0x2080016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2100002
_0x2080016:
	CPI  R30,LOW(0x3)
	BRNE _0x2080018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2100002
_0x2080018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2100002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x208001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x208001B
_0x208001C:
	CPI  R30,LOW(0x2)
	BRNE _0x208001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x208001B
_0x208001D:
	CPI  R30,LOW(0x3)
	BRNE _0x208001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x208001B:
_0x2100001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_old_miss_count:
	.BYTE 0x1
_score:
	.BYTE 0x2
_tick_seed:
	.BYTE 0x2
_game_delay_ms:
	.BYTE 0x1
_gfx_addr_G100:
	.BYTE 0x2
_gfx_buffer_G100:
	.BYTE 0x1F8
__seed_G106:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	STS  _tick_seed,R30
	STS  _tick_seed+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDD  R30,Y+1
	SUBI R30,-LOW(2)
	ST   -Y,R30
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _glcd_putpixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDD  R30,Y+1
	SUBI R30,-LOW(3)
	ST   -Y,R30
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x5:
	STS  _glcd_state,R30
	LDD  R30,Y+1
	ST   -Y,R30
	ST   -Y,R17
	LDD  R30,Y+3
	SUBI R30,-LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(47)
	CALL _glcd_line
	LDD  R30,Y+1
	SUBI R30,-LOW(18)
	ST   -Y,R30
	ST   -Y,R17
	LDD  R26,Y+3
	SUBI R26,-LOW(18)
	SUBI R26,LOW(3)
	ST   -Y,R26
	LDI  R26,LOW(47)
	CALL _glcd_line
	LDD  R30,Y+1
	SUBI R30,-LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(47)
	ST   -Y,R30
	LDD  R26,Y+3
	SUBI R26,-LOW(18)
	SUBI R26,LOW(3)
	ST   -Y,R26
	LDI  R26,LOW(47)
	CALL _glcd_line
	LDD  R30,Y+1
	SUBI R30,-LOW(2)
	ST   -Y,R30
	MOV  R30,R17
	SUBI R30,-LOW(2)
	ST   -Y,R30
	LDD  R26,Y+3
	SUBI R26,-LOW(18)
	SUBI R26,LOW(2)
	ST   -Y,R26
	MOV  R26,R17
	SUBI R26,-LOW(2)
	JMP  _glcd_line

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	CALL _glcd_outtextxy
	LDS  R30,_score
	LDS  R31,_score+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	JMP  _uint_to_str

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	ST   -Y,R4
	MOV  R26,R7
	CALL _draw_star
	MOV  R26,R5
	JMP  _draw_basket

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x8:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDS  R26,_score
	LDS  R27,_score+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	CALL _glcd_outtextxy
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_gfx_addr_G100)
	LDI  R27,HIGH(_gfx_addr_G100)
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	STS  100,R30
	LDS  R30,101
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xE:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	ST   -Y,R16
	LDD  R26,Y+16
	JMP  _pcd8544_setaddr_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
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

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

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

;END OF CODE MARKER
__END_OF_CODE:
