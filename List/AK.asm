
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32A
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _flagtancong=R4
	.DEF _offsetphongthu=R6
	.DEF _goctancong=R8
	.DEF _cmdCtrlRobot=R10
	.DEF _idRobot=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_ASCII:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x32,0x49,0x79,0x41,0x3E,0x7E,0x11,0x11
	.DB  0x11,0x7E,0x7F,0x49,0x49,0x49,0x36,0x3E
	.DB  0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x22
	.DB  0x1C,0x7F,0x49,0x49,0x49,0x41,0x7F,0x9
	.DB  0x9,0x9,0x1,0x3E,0x41,0x49,0x49,0x7A
	.DB  0x7F,0x8,0x8,0x8,0x7F,0x0,0x41,0x7F
	.DB  0x41,0x0,0x20,0x40,0x41,0x3F,0x1,0x7F
	.DB  0x8,0x14,0x22,0x41,0x7F,0x40,0x40,0x40
	.DB  0x40,0x7F,0x2,0xC,0x2,0x7F,0x7F,0x4
	.DB  0x8,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x51
	.DB  0x21,0x5E,0x7F,0x9,0x19,0x29,0x46,0x46
	.DB  0x49,0x49,0x49,0x31,0x1,0x1,0x7F,0x1
	.DB  0x1,0x3F,0x40,0x40,0x40,0x3F,0x1F,0x20
	.DB  0x40,0x20,0x1F,0x3F,0x40,0x38,0x40,0x3F
	.DB  0x63,0x14,0x8,0x14,0x63,0x7,0x8,0x70
	.DB  0x8,0x7,0x61,0x51,0x49,0x45,0x43,0x0
	.DB  0x7F,0x41,0x41,0x0,0x2,0x4,0x8,0x10
	.DB  0x20,0x0,0x41,0x41,0x7F,0x0,0x4,0x2
	.DB  0x1,0x2,0x4,0x40,0x40,0x40,0x40,0x40
	.DB  0x0,0x1,0x2,0x4,0x0,0x20,0x54,0x54
	.DB  0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38
	.DB  0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48
	.DB  0x7F,0x38,0x54,0x54,0x54,0x18,0x8,0x7E
	.DB  0x9,0x1,0x2,0xC,0x52,0x52,0x52,0x3E
	.DB  0x7F,0x8,0x4,0x4,0x78,0x0,0x44,0x7D
	.DB  0x40,0x0,0x20,0x40,0x44,0x3D,0x0,0x7F
	.DB  0x10,0x28,0x44,0x0,0x0,0x41,0x7F,0x40
	.DB  0x0,0x7C,0x4,0x18,0x4,0x78,0x7C,0x8
	.DB  0x4,0x4,0x78,0x38,0x44,0x44,0x44,0x38
	.DB  0x7C,0x14,0x14,0x14,0x8,0x8,0x14,0x14
	.DB  0x18,0x7C,0x7C,0x8,0x4,0x4,0x8,0x48
	.DB  0x54,0x54,0x54,0x20,0x4,0x3F,0x44,0x40
	.DB  0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20
	.DB  0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C
	.DB  0x44,0x28,0x10,0x28,0x44,0xC,0x50,0x50
	.DB  0x50,0x3C,0x44,0x64,0x54,0x4C,0x44,0x0
	.DB  0x8,0x36,0x41,0x0,0x0,0x0,0x7F,0x0
	.DB  0x0,0x0,0x41,0x36,0x8,0x0,0x10,0x8
	.DB  0x8,0x10,0x8,0x78,0x46,0x41,0x46,0x78

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0xE7,0xE7,0xE7,0xE7,0xE7
_0x4:
	.DB  0xE7,0xE7,0xE7,0xE7,0xE7
_0x20003:
	.DB  0x1
_0x20004:
	.DB  0xA
_0x20005:
	.DB  0x1
_0x20006:
	.DB  0xA
_0x20007:
	.DB  0x1
_0x20008:
	.DB  0x1
_0x201AB:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x202E6:
	.DB  0x1,0x0,0x0,0x0,0x0,0x0
_0x20000:
	.DB  0x25,0x64,0x0,0x25,0x30,0x2E,0x32,0x66
	.DB  0x0,0x20,0x3C,0x41,0x4B,0x42,0x4F,0x54
	.DB  0x4B,0x49,0x54,0x3E,0x0,0x52,0x4F,0x42
	.DB  0x4F,0x54,0x20,0x57,0x41,0x4C,0x4C,0x0
	.DB  0x57,0x48,0x49,0x54,0x45,0x20,0x4C,0x49
	.DB  0x4E,0x45,0x0,0x46,0x4F,0x4C,0x4F,0x57
	.DB  0x45,0x52,0x0,0x42,0x4C,0x41,0x43,0x4B
	.DB  0x20,0x4C,0x49,0x4E,0x45,0x0,0x42,0x4C
	.DB  0x55,0x45,0x54,0x4F,0x4F,0x54,0x48,0x0
	.DB  0x44,0x52,0x49,0x56,0x45,0x0,0x54,0x45
	.DB  0x53,0x54,0x20,0x4D,0x4F,0x54,0x4F,0x52
	.DB  0x0,0x4D,0x6F,0x74,0x6F,0x72,0x4C,0x0
	.DB  0x4D,0x6F,0x74,0x6F,0x72,0x52,0x0,0x54
	.DB  0x45,0x53,0x54,0x20,0x55,0x41,0x52,0x54
	.DB  0x0,0x54,0x45,0x53,0x54,0x20,0x49,0x52
	.DB  0x0,0x30,0x2E,0x0,0x31,0x2E,0x0,0x32
	.DB  0x2E,0x0,0x33,0x2E,0x0,0x34,0x2E,0x0
	.DB  0x35,0x2E,0x0,0x36,0x2E,0x0,0x37,0x2E
	.DB  0x0,0x3C,0x53,0x45,0x4C,0x46,0x20,0x54
	.DB  0x45,0x53,0x54,0x3E,0x0,0x2A,0x2A,0x2A
	.DB  0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x2A
	.DB  0x2A,0x0,0x52,0x43,0x20,0x53,0x45,0x52
	.DB  0x56,0x4F,0x0,0x31,0x2E,0x52,0x4F,0x42
	.DB  0x4F,0x54,0x20,0x57,0x41,0x4C,0x4C,0x0
	.DB  0x32,0x2E,0x42,0x4C,0x55,0x45,0x54,0x4F
	.DB  0x4F,0x54,0x48,0x20,0x0,0x33,0x2E,0x57
	.DB  0x48,0x49,0x54,0x45,0x20,0x4C,0x49,0x4E
	.DB  0x45,0x0,0x34,0x2E,0x42,0x4C,0x41,0x43
	.DB  0x4B,0x20,0x4C,0x49,0x4E,0x45,0x0,0x35
	.DB  0x2E,0x54,0x45,0x53,0x54,0x20,0x4D,0x4F
	.DB  0x54,0x4F,0x52,0x0,0x36,0x2E,0x54,0x45
	.DB  0x53,0x54,0x20,0x49,0x52,0x20,0x20,0x20
	.DB  0x0,0x37,0x2E,0x54,0x45,0x53,0x54,0x20
	.DB  0x52,0x46,0x20,0x20,0x20,0x0,0x38,0x2E
	.DB  0x54,0x45,0x53,0x54,0x20,0x55,0x41,0x52
	.DB  0x54,0x20,0x0,0x39,0x2E,0x52,0x43,0x20
	.DB  0x53,0x45,0x52,0x56,0x4F,0x20,0x0,0x31
	.DB  0x30,0x2E,0x55,0x50,0x44,0x41,0x54,0x45
	.DB  0x20,0x52,0x42,0x0,0x4D,0x41,0x49,0x4E
	.DB  0x20,0x50,0x52,0x4F,0x47,0x52,0x41,0x4D
	.DB  0x0
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x05
	.DW  _TX_ADDRESS
	.DW  _0x3*2

	.DW  0x05
	.DW  _RX_ADDRESS
	.DW  _0x4*2

	.DW  0x01
	.DW  _id
	.DW  _0x20003*2

	.DW  0x01
	.DW  _KpR
	.DW  _0x20004*2

	.DW  0x01
	.DW  _KiR
	.DW  _0x20005*2

	.DW  0x01
	.DW  _KpL
	.DW  _0x20006*2

	.DW  0x01
	.DW  _KiL
	.DW  _0x20007*2

	.DW  0x0C
	.DW  _0x20044
	.DW  _0x20000*2+9

	.DW  0x0B
	.DW  _0x20164
	.DW  _0x20000*2+21

	.DW  0x0B
	.DW  _0x20179
	.DW  _0x20000*2+32

	.DW  0x08
	.DW  _0x20179+11
	.DW  _0x20000*2+43

	.DW  0x0B
	.DW  _0x201AC
	.DW  _0x20000*2+51

	.DW  0x08
	.DW  _0x201AC+11
	.DW  _0x20000*2+43

	.DW  0x0A
	.DW  _0x201FA
	.DW  _0x20000*2+62

	.DW  0x06
	.DW  _0x201FA+10
	.DW  _0x20000*2+72

	.DW  0x0B
	.DW  _0x20211
	.DW  _0x20000*2+78

	.DW  0x07
	.DW  _0x20211+11
	.DW  _0x20000*2+89

	.DW  0x07
	.DW  _0x20211+18
	.DW  _0x20000*2+96

	.DW  0x0A
	.DW  _0x20216
	.DW  _0x20000*2+103

	.DW  0x08
	.DW  _0x20217
	.DW  _0x20000*2+113

	.DW  0x03
	.DW  _0x20217+8
	.DW  _0x20000*2+121

	.DW  0x03
	.DW  _0x20217+11
	.DW  _0x20000*2+124

	.DW  0x03
	.DW  _0x20217+14
	.DW  _0x20000*2+127

	.DW  0x03
	.DW  _0x20217+17
	.DW  _0x20000*2+130

	.DW  0x03
	.DW  _0x20217+20
	.DW  _0x20000*2+133

	.DW  0x03
	.DW  _0x20217+23
	.DW  _0x20000*2+136

	.DW  0x03
	.DW  _0x20217+26
	.DW  _0x20000*2+139

	.DW  0x03
	.DW  _0x20217+29
	.DW  _0x20000*2+142

	.DW  0x0C
	.DW  _0x2021B
	.DW  _0x20000*2+145

	.DW  0x0D
	.DW  _0x2021B+12
	.DW  _0x20000*2+157

	.DW  0x09
	.DW  _0x20284
	.DW  _0x20000*2+170

	.DW  0x0D
	.DW  _0x20290
	.DW  _0x20000*2+179

	.DW  0x0D
	.DW  _0x20290+13
	.DW  _0x20000*2+179

	.DW  0x0D
	.DW  _0x20290+26
	.DW  _0x20000*2+192

	.DW  0x0D
	.DW  _0x20290+39
	.DW  _0x20000*2+205

	.DW  0x0D
	.DW  _0x20290+52
	.DW  _0x20000*2+218

	.DW  0x0D
	.DW  _0x20290+65
	.DW  _0x20000*2+231

	.DW  0x0D
	.DW  _0x20290+78
	.DW  _0x20000*2+244

	.DW  0x0D
	.DW  _0x20290+91
	.DW  _0x20000*2+257

	.DW  0x0D
	.DW  _0x20290+104
	.DW  _0x20000*2+270

	.DW  0x0C
	.DW  _0x20290+117
	.DW  _0x20000*2+283

	.DW  0x0D
	.DW  _0x20290+129
	.DW  _0x20000*2+295

	.DW  0x0B
	.DW  _0x202BC
	.DW  _0x20000*2+10

	.DW  0x0D
	.DW  _0x202BC+11
	.DW  _0x20000*2+157

	.DW  0x0D
	.DW  _0x202BC+24
	.DW  _0x20000*2+308

	.DW  0x06
	.DW  0x04
	.DW  _0x202E6*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <string.h>
;#include <nRF24L01/nRF24L01.h>
;#include <delay.h>
;#include <spi.h>
;
;#define CSN    PORTC.2
;#define CE     PORTC.3
;#define SCK    PORTB.7
;#define MISO   PINB.6
;#define MOSI   PORTB.5
;//********************************************************************************
;//unsigned char const TX_ADDRESS[TX_ADR_WIDTH]= {0x34,0x43,0x10,0x10,0x01};	//
;//unsigned char const RX_ADDRESS[RX_ADR_WIDTH]= {0x34,0x43,0x10,0x10,0x01};	//
;unsigned char const TX_ADDRESS[TX_ADR_WIDTH]= {0xE7,0xE7,0xE7,0xE7,0xE7};	// dia chi phat du lieu

	.DSEG
;unsigned char const RX_ADDRESS[RX_ADR_WIDTH]= {0xE7,0xE7,0xE7,0xE7,0xE7};	// dia chi nhan du lieu
;//****************************************************************************************
;//*NRF24L01
;//***************************************************************************************/
;void init_NRF24L01(void)
; 0000 0015 {

	.CSEG
_init_NRF24L01:
; 0000 0016     //init SPI
; 0000 0017     SPCR=0x51; //set this to 0x50 for 1 mbits
	LDI  R30,LOW(81)
	OUT  0xD,R30
; 0000 0018     SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0019 
; 0000 001A     //inerDelay_us(100);
; 0000 001B     delay_us(100);
	__DELAY_USW 200
; 0000 001C  	CE=0;    // chip enable
	CBI  0x15,3
; 0000 001D  	CSN=1;   // Spi disable
	SBI  0x15,2
; 0000 001E  	//SCK=0;   // Spi clock line init high
; 0000 001F 	SPI_Write_Buf(WRITE_REG + TX_ADDR, TX_ADDRESS, TX_ADR_WIDTH);    //
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R30,LOW(_TX_ADDRESS)
	LDI  R31,HIGH(_TX_ADDRESS)
	CALL SUBOPT_0x0
; 0000 0020 	SPI_Write_Buf(WRITE_REG + RX_ADDR_P0, RX_ADDRESS, RX_ADR_WIDTH); //
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(_RX_ADDRESS)
	LDI  R31,HIGH(_RX_ADDRESS)
	CALL SUBOPT_0x0
; 0000 0021 	SPI_RW_Reg(WRITE_REG + EN_AA, 0x00);      // EN P0, 2-->P1
	LDI  R30,LOW(33)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0022 	SPI_RW_Reg(WRITE_REG + EN_RXADDR, 0x01);  //Enable data P0
	LDI  R30,LOW(34)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0023 	SPI_RW_Reg(WRITE_REG + RF_CH, 2);        // Chanel 0 RF = 2400 + RF_CH* (1or 2 M)
	LDI  R30,LOW(37)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0024 	SPI_RW_Reg(WRITE_REG + RX_PW_P0, RX_PLOAD_WIDTH); // Do rong data truyen 32 byte
	LDI  R30,LOW(49)
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0025 	SPI_RW_Reg(WRITE_REG + RF_SETUP, 0x07);   		// 1M, 0dbm
	LDI  R30,LOW(38)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0026 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		 // Enable CRC, 2 byte CRC, Send
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0027 
; 0000 0028 }
	RET
;/****************************************************************************************************/
;//unsigned char SPI_RW(unsigned char Buff)
;//NRF24L01
;/****************************************************************************************************/
;unsigned char SPI_RW(unsigned char Buff)
; 0000 002E {
_SPI_RW:
; 0000 002F    return spi(Buff);
;	Buff -> Y+0
	LD   R30,Y
	ST   -Y,R30
	CALL _spi
	JMP  _0x20C000D
; 0000 0030 }
;/****************************************************************************************************/
;//unsigned char SPI_Read(unsigned char reg)
;//NRF24L01
;/****************************************************************************************************/
;unsigned char SPI_Read(unsigned char reg)
; 0000 0036 {
_SPI_Read:
; 0000 0037 	unsigned char reg_val;
; 0000 0038 
; 0000 0039 	CSN = 0;                // CSN low, initialize SPI communication...
	ST   -Y,R17
;	reg -> Y+1
;	reg_val -> R17
	CBI  0x15,2
; 0000 003A 	SPI_RW(reg);            // Select register to read from..
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _SPI_RW
; 0000 003B 	reg_val = SPI_RW(0);    // ..then read registervalue
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1
; 0000 003C 	CSN = 1;                // CSN high, terminate SPI communication
	SBI  0x15,2
; 0000 003D 
; 0000 003E 	return(reg_val);        // return register value
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C000E
; 0000 003F }
;/****************************************************************************************************/
;//unsigned char SPI_RW_Reg(unsigned char reg, unsigned char value)
;/****************************************************************************************************/
;unsigned char SPI_RW_Reg(unsigned char reg, unsigned char value)
; 0000 0044 {
_SPI_RW_Reg:
; 0000 0045 	unsigned char status;
; 0000 0046 
; 0000 0047 	CSN = 0;                   // CSN low, init SPI transaction
	ST   -Y,R17
;	reg -> Y+2
;	value -> Y+1
;	status -> R17
	CBI  0x15,2
; 0000 0048 	status = SPI_RW(reg);      // select register
	LDD  R30,Y+2
	CALL SUBOPT_0x1
; 0000 0049 	SPI_RW(value);             // ..and write value to it..
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _SPI_RW
; 0000 004A 	CSN = 1;                   // CSN high again
	SBI  0x15,2
; 0000 004B 
; 0000 004C 	return(status);            // return nRF24L01 status uchar
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C0011
; 0000 004D }
;/****************************************************************************************************/
;//unsigned char SPI_Read_Buf(unsigned char reg, unsigned char *pBuf, unsigned char uchars)
;//
;/****************************************************************************************************/
;unsigned char SPI_Read_Buf(unsigned char reg, unsigned char *pBuf, unsigned char uchars)
; 0000 0053 {
_SPI_Read_Buf:
; 0000 0054 	unsigned char status,uchar_ctr;
; 0000 0055 
; 0000 0056 	CSN = 0;                    		// Set CSN low, init SPI tranaction
	ST   -Y,R17
	ST   -Y,R16
;	reg -> Y+5
;	*pBuf -> Y+3
;	uchars -> Y+2
;	status -> R17
;	uchar_ctr -> R16
	CBI  0x15,2
; 0000 0057 	status = SPI_RW(reg);       		// Select register to write to and read status uchar
	LDD  R30,Y+5
	CALL SUBOPT_0x1
; 0000 0058 
; 0000 0059 	for(uchar_ctr=0;uchar_ctr<uchars;uchar_ctr++)
	LDI  R16,LOW(0)
_0x14:
	LDD  R30,Y+2
	CP   R16,R30
	BRSH _0x15
; 0000 005A 		pBuf[uchar_ctr] = SPI_RW(0);    //
	MOV  R30,R16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SPI_RW
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R16,-1
	RJMP _0x14
_0x15:
; 0000 005C PORTC.2 = 1;
	SBI  0x15,2
; 0000 005D 
; 0000 005E 	return(status);                    // return nRF24L01 status uchar
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; 0000 005F }
;/*********************************************************************************************************/
;//uint SPI_Write_Buf(uchar reg, uchar *pBuf, uchar uchars)
;/*****************************************************************************************************/
;unsigned char SPI_Write_Buf(unsigned char reg, unsigned char *pBuf, unsigned uchars)
; 0000 0064 {
_SPI_Write_Buf:
; 0000 0065 	unsigned char status,uchar_ctr;
; 0000 0066 	CSN = 0;            //SPI
	ST   -Y,R17
	ST   -Y,R16
;	reg -> Y+6
;	*pBuf -> Y+4
;	uchars -> Y+2
;	status -> R17
;	uchar_ctr -> R16
	CBI  0x15,2
; 0000 0067 	status = SPI_RW(reg);
	LDD  R30,Y+6
	CALL SUBOPT_0x1
; 0000 0068 	for(uchar_ctr=0; uchar_ctr<uchars; uchar_ctr++) //
	LDI  R16,LOW(0)
_0x1B:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	MOV  R26,R16
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x1C
; 0000 0069 	SPI_RW(*pBuf++);
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X+
	STD  Y+4,R26
	STD  Y+4+1,R27
	ST   -Y,R30
	RCALL _SPI_RW
	SUBI R16,-1
	RJMP _0x1B
_0x1C:
; 0000 006A PORTC.2 = 1;
	SBI  0x15,2
; 0000 006B 	return(status);    //
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
; 0000 006C }
;/****************************************************************************************************/
;//void SetRX_Mode(void)
;//
;/****************************************************************************************************/
;void SetRX_Mode(void)
; 0000 0072 {
_SetRX_Mode:
; 0000 0073 	CE=0;
	CBI  0x15,3
; 0000 0074 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x07);   		// enable power up and prx
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0075 	CE = 1;
	SBI  0x15,3
; 0000 0076 	delay_us(130);    //
	__DELAY_USW 260
; 0000 0077 }
	RET
;/****************************************************************************************************/
;//void SetTX_Mode(void)
;//
;/****************************************************************************************************/
;void SetTX_Mode(void)
; 0000 007D {
; 0000 007E 	CE=0;
; 0000 007F 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		// Enable CRC, 2 byte CRC, Send
; 0000 0080 	CE = 1;
; 0000 0081 	delay_us(130);    //
; 0000 0082 }
;
;/******************************************************************************************************/
;//unsigned char nRF24L01_RxPacket(unsigned char* rx_buf)
;/******************************************************************************************************/
;unsigned char nRF24L01_RxPacket(unsigned char* rx_buf)
; 0000 0088 {
_nRF24L01_RxPacket:
; 0000 0089     unsigned char revale=0;
; 0000 008A     unsigned char sta;
; 0000 008B 	sta=SPI_Read(STATUS);	// Read Status
	ST   -Y,R17
	ST   -Y,R16
;	*rx_buf -> Y+2
;	revale -> R17
;	sta -> R16
	LDI  R17,0
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _SPI_Read
	MOV  R16,R30
; 0000 008C 	//if(RX_DR)				// Data in RX FIFO
; 0000 008D     if((sta&0x40)!=0)		// Data in RX FIFO
	SBRS R16,6
	RJMP _0x27
; 0000 008E 	{
; 0000 008F 	    CE = 0; 			//SPI
	CBI  0x15,3
; 0000 0090 		SPI_Read_Buf(RD_RX_PLOAD,rx_buf,TX_PLOAD_WIDTH);// read receive payload from RX_FIFO buffer
	LDI  R30,LOW(97)
	ST   -Y,R30
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _SPI_Read_Buf
; 0000 0091 		revale =1;
	LDI  R17,LOW(1)
; 0000 0092 	}
; 0000 0093 	SPI_RW_Reg(WRITE_REG+STATUS,sta);
_0x27:
	LDI  R30,LOW(39)
	ST   -Y,R30
	ST   -Y,R16
	RCALL _SPI_RW_Reg
; 0000 0094     CE = 1; 			//SPI
	SBI  0x15,3
; 0000 0095 	return revale;
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20C000A
; 0000 0096 }
;/***********************************************************************************************************/
;//void nRF24L01_TxPacket(unsigned char * tx_buf)
;//
;/**********************************************************************************************************/
;void nRF24L01_TxPacket(unsigned char * tx_buf)
; 0000 009C {
; 0000 009D 	CE=0;
;	*tx_buf -> Y+0
; 0000 009E 	SPI_Write_Buf(WRITE_REG + RX_ADDR_P0, TX_ADDRESS, TX_ADR_WIDTH); // Send Address
; 0000 009F 	SPI_Write_Buf(WR_TX_PLOAD, tx_buf, TX_PLOAD_WIDTH); 			 //send data
; 0000 00A0 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		 // Send Out
; 0000 00A1 	CE=1;
; 0000 00A2 }
;
;// --------------------END OF FILE------------------------
;// -------------------------------------------------------
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Evaluation
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/4/2015
;Author  : Freeware, for evaluation and non-commercial use only
;Company :
;Comments:
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <stdio.h>
;#include <string.h>
;#include <stdarg.h>
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <spi.h>
;#include <nRF24L01/nRF24L01.h>
;#include <math.h>
;
;/* PIN DEFINITION */
;// PIN LED ROBO KIT
;#define LEDL	PORTC.4
;#define LEDR	PORTC.5
;#define LEDFL   PORTA.4
;#define LEDFR   PORTA.5
;#define LEDBL   PORTA.6
;#define LEDBR   PORTA.7
;#define keyKT   PINC.0 // Nut ben trai
;#define keyKP   PINC.1 // Nut ben phai
;#define S0  PINA.0
;#define S1  PINA.1
;#define S2  PINA.2
;#define S3  PINA.3
;#define S4  PINA.7
;#define MLdir   PORTC.6
;#define MRdir   PORTC.7
;// PIN NOKIA 5110
;#define RST    PORTB.0
;#define SCE    PORTB.1
;#define DC     PORTB.2
;#define DIN    PORTB.5
;#define SCK    PORTB.7
;#define LCD_C     0
;#define LCD_D     1
;#define LCD_X     84
;#define LCD_Y     48
;#define Black 1
;#define White 0
;#define Filled 1
;#define NotFilled 0
;// VARIABLES FOR ROBOT CONTROL
;#define CtrVelocity    //uncomment de chon chay pid dieu khien van toc, va su dung cac ham vMLtoi,vMLlui,....
;#define ROBOT_ID 4
;#define SAN_ID 1  //CHON HUONG TAN CONG LA X >0;
;#define M_PI    3.14159265358979323846    /* pi */
;
;typedef   signed          char int8_t;
;typedef   signed           int int16_t;
;typedef   signed  long    int int32_t;
;typedef   unsigned         char uint8_t;
;typedef   unsigned        int  uint16_t;
;typedef   unsigned long    int  uint32_t;
;typedef   float            float32_t;
;typedef struct   {
;        float x;
;        float y;
;} Ball ;
;typedef struct {
;    int x;
;    int y;
;} IntBall;
;typedef struct   {
;        float id;
;        float x;
;        float y;
;        float ox;
;        float oy;
;        Ball ball;
;} Robot;
;typedef struct {
;    int id;
;    int x;
;    int y;
;    int ox;
;    int oy;
;    IntBall ball;
;} IntRobot;
;
;// FUNCTION DECLARATION
;IntRobot convertRobot2IntRobot(Robot robot);
;unsigned char readposition();
;void runEscBlindSpot();
;void ctrrobot();// can phai luon luon chay de dieu khien robot
;void rb_move(float x,float y);
;int rb_wait(unsigned long int time );
;void rb_rotate(int angle);     // goc xoay so voi truc x cua toa do
;void calcvitri(float x,float y);
;int calcVangle(int angle);
;
;// VARIABLES DECLARATION
;Robot rb;
;IntRobot robot11, robot12, robot13, robot21, robot22, robot23, robotctrl;
;float errangle=0, distance=0,orentation=0;
;int flagtancong=1;
;int offsetphongthu=0;
;int goctancong=0;
;unsigned char RxBuf[32];
;float setRobotX=0;
;float setRobotY=0;
;float setRobotXmin=0;
;float setRobotXmax=0;
;float setRobotAngleX=0;
;float setRobotAngleY=0;
;float offestsanco=0;
;float rbctrlHomeX=0;
;float rbctrlHomeY=0;
;float rbctrlPenaltyX=0;
;float rbctrlPenaltyY=0;
;float rbctrlPenaltyAngle=0;
;float rbctrlHomeAngle=0;
;unsigned int cmdCtrlRobot,idRobot;
;unsigned int cntsethomeRB  =0;
;unsigned int cntstuckRB=0;
;unsigned int cntunlookRB=0;
;unsigned int flagunlookRB=0;
;unsigned int cntunsignalRF=0;
;unsigned int flagunsignalRF=0;
;unsigned int flagsethome=0;
;unsigned int flagselftest = 0;
;unsigned int cntselftest = 0;
;
;//======USER VARIABLES=========
;unsigned char id = 1;

	.DSEG
;//======IR READER VARIABLES====
;unsigned int IRFL=0;
;unsigned int IRFR=0;
;unsigned int IRBL=0;
;unsigned int IRLINE[5];
;//======MOTOR CONTROL========
;//------VELOCITY CONTROL=====
;unsigned int timerstick=0,timerstickdis =0,timerstickang=0,timerstickctr=0;
;unsigned int vQEL=0;  //do (xung/250ms)
;unsigned int vQER=0;  //do (xung/250ms)
;unsigned int oldQEL=0;
;unsigned int oldQER=0;
;unsigned int svQEL=0;  //dat (xung/250ms) (range: 0-22)
;unsigned int svQER=0;  //dat (xung/250ms) (range: 0-22)
;static int seRki=0,seLki=0;
;int uL = 0 ;
;int uR = 0;
;int KpR = 10;
;int KiR = 1;
;int KpL = 10;
;int KiL = 1;
;//------POSITION CONTROL-----
;unsigned int sd=0;// dat khoang cach  di chuyen (xung)
;unsigned int oldd=0;// bien luu gia tri vi tri cu
;unsigned char flagwaitctrRobot = 0;
;//-----ANGLES CONTROL----
;unsigned int sa=0;// dat goc quay (xung) ( 54 xung/vong quay)
;unsigned int olda=0;// bien luu gia tri goc cu
;unsigned char  flagwaitctrAngle = 0;
;//-----ROBOT BEHAVIOR CONTROL-----
;unsigned int flagtask=0;
;unsigned int flagtaskold=0;
;unsigned int flaghuongtrue=0;
;int verranglekisum = 0;
;//=====ENCODER======
; unsigned int QEL=0;
; unsigned int QER=0;
;//=====LCD=========
; unsigned char menu=0,test=0,ok=0,runing_test=0,run_robot=0,ft=1,timer=0;
;flash unsigned char ASCII[][5] = {
; {0x00, 0x00, 0x00, 0x00, 0x00} // 20
;,{0x00, 0x00, 0x5f, 0x00, 0x00} // 21 !
;,{0x00, 0x07, 0x00, 0x07, 0x00} // 22 "
;,{0x14, 0x7f, 0x14, 0x7f, 0x14} // 23 #
;,{0x24, 0x2a, 0x7f, 0x2a, 0x12} // 24 $
;,{0x23, 0x13, 0x08, 0x64, 0x62} // 25 %
;,{0x36, 0x49, 0x55, 0x22, 0x50} // 26 &
;,{0x00, 0x05, 0x03, 0x00, 0x00} // 27 '
;,{0x00, 0x1c, 0x22, 0x41, 0x00} // 28 (
;,{0x00, 0x41, 0x22, 0x1c, 0x00} // 29 )
;,{0x14, 0x08, 0x3e, 0x08, 0x14} // 2a *
;,{0x08, 0x08, 0x3e, 0x08, 0x08} // 2b +
;,{0x00, 0x50, 0x30, 0x00, 0x00} // 2c ,
;,{0x08, 0x08, 0x08, 0x08, 0x08} // 2d -
;,{0x00, 0x60, 0x60, 0x00, 0x00} // 2e .
;,{0x20, 0x10, 0x08, 0x04, 0x02} // 2f /
;,{0x3e, 0x51, 0x49, 0x45, 0x3e} // 30 0
;,{0x00, 0x42, 0x7f, 0x40, 0x00} // 31 1
;,{0x42, 0x61, 0x51, 0x49, 0x46} // 32 2
;,{0x21, 0x41, 0x45, 0x4b, 0x31} // 33 3
;,{0x18, 0x14, 0x12, 0x7f, 0x10} // 34 4
;,{0x27, 0x45, 0x45, 0x45, 0x39} // 35 5
;,{0x3c, 0x4a, 0x49, 0x49, 0x30} // 36 6
;,{0x01, 0x71, 0x09, 0x05, 0x03} // 37 7
;,{0x36, 0x49, 0x49, 0x49, 0x36} // 38 8
;,{0x06, 0x49, 0x49, 0x29, 0x1e} // 39 9
;,{0x00, 0x36, 0x36, 0x00, 0x00} // 3a :
;,{0x00, 0x56, 0x36, 0x00, 0x00} // 3b ;
;,{0x08, 0x14, 0x22, 0x41, 0x00} // 3c <
;,{0x14, 0x14, 0x14, 0x14, 0x14} // 3d =
;,{0x00, 0x41, 0x22, 0x14, 0x08} // 3e >
;,{0x02, 0x01, 0x51, 0x09, 0x06} // 3f ?
;,{0x32, 0x49, 0x79, 0x41, 0x3e} // 40 @
;,{0x7e, 0x11, 0x11, 0x11, 0x7e} // 41 A
;,{0x7f, 0x49, 0x49, 0x49, 0x36} // 42 B
;,{0x3e, 0x41, 0x41, 0x41, 0x22} // 43 C
;,{0x7f, 0x41, 0x41, 0x22, 0x1c} // 44 D
;,{0x7f, 0x49, 0x49, 0x49, 0x41} // 45 E
;,{0x7f, 0x09, 0x09, 0x09, 0x01} // 46 F
;,{0x3e, 0x41, 0x49, 0x49, 0x7a} // 47 G
;,{0x7f, 0x08, 0x08, 0x08, 0x7f} // 48 H
;,{0x00, 0x41, 0x7f, 0x41, 0x00} // 49 I
;,{0x20, 0x40, 0x41, 0x3f, 0x01} // 4a J
;,{0x7f, 0x08, 0x14, 0x22, 0x41} // 4b K
;,{0x7f, 0x40, 0x40, 0x40, 0x40} // 4c L
;,{0x7f, 0x02, 0x0c, 0x02, 0x7f} // 4d M
;,{0x7f, 0x04, 0x08, 0x10, 0x7f} // 4e N
;,{0x3e, 0x41, 0x41, 0x41, 0x3e} // 4f O
;,{0x7f, 0x09, 0x09, 0x09, 0x06} // 50 P
;,{0x3e, 0x41, 0x51, 0x21, 0x5e} // 51 Q
;,{0x7f, 0x09, 0x19, 0x29, 0x46} // 52 R
;,{0x46, 0x49, 0x49, 0x49, 0x31} // 53 S
;,{0x01, 0x01, 0x7f, 0x01, 0x01} // 54 T
;,{0x3f, 0x40, 0x40, 0x40, 0x3f} // 55 U
;,{0x1f, 0x20, 0x40, 0x20, 0x1f} // 56 V
;,{0x3f, 0x40, 0x38, 0x40, 0x3f} // 57 W
;,{0x63, 0x14, 0x08, 0x14, 0x63} // 58 X
;,{0x07, 0x08, 0x70, 0x08, 0x07} // 59 Y
;,{0x61, 0x51, 0x49, 0x45, 0x43} // 5a Z
;,{0x00, 0x7f, 0x41, 0x41, 0x00} // 5b [
;,{0x02, 0x04, 0x08, 0x10, 0x20} // 5c ¥
;,{0x00, 0x41, 0x41, 0x7f, 0x00} // 5d ]
;,{0x04, 0x02, 0x01, 0x02, 0x04} // 5e ^
;,{0x40, 0x40, 0x40, 0x40, 0x40} // 5f _
;,{0x00, 0x01, 0x02, 0x04, 0x00} // 60 `
;,{0x20, 0x54, 0x54, 0x54, 0x78} // 61 a
;,{0x7f, 0x48, 0x44, 0x44, 0x38} // 62 b
;,{0x38, 0x44, 0x44, 0x44, 0x20} // 63 c
;,{0x38, 0x44, 0x44, 0x48, 0x7f} // 64 d
;,{0x38, 0x54, 0x54, 0x54, 0x18} // 65 e
;,{0x08, 0x7e, 0x09, 0x01, 0x02} // 66 f
;,{0x0c, 0x52, 0x52, 0x52, 0x3e} // 67 g
;,{0x7f, 0x08, 0x04, 0x04, 0x78} // 68 h
;,{0x00, 0x44, 0x7d, 0x40, 0x00} // 69 i
;,{0x20, 0x40, 0x44, 0x3d, 0x00} // 6a j
;,{0x7f, 0x10, 0x28, 0x44, 0x00} // 6b k
;,{0x00, 0x41, 0x7f, 0x40, 0x00} // 6c l
;,{0x7c, 0x04, 0x18, 0x04, 0x78} // 6d m
;,{0x7c, 0x08, 0x04, 0x04, 0x78} // 6e n
;,{0x38, 0x44, 0x44, 0x44, 0x38} // 6f o
;,{0x7c, 0x14, 0x14, 0x14, 0x08} // 70 p
;,{0x08, 0x14, 0x14, 0x18, 0x7c} // 71 q
;,{0x7c, 0x08, 0x04, 0x04, 0x08} // 72 r
;,{0x48, 0x54, 0x54, 0x54, 0x20} // 73 s
;,{0x04, 0x3f, 0x44, 0x40, 0x20} // 74 t
;,{0x3c, 0x40, 0x40, 0x20, 0x7c} // 75 u
;,{0x1c, 0x20, 0x40, 0x20, 0x1c} // 76 v
;,{0x3c, 0x40, 0x30, 0x40, 0x3c} // 77 w
;,{0x44, 0x28, 0x10, 0x28, 0x44} // 78 x
;,{0x0c, 0x50, 0x50, 0x50, 0x3c} // 79 y
;,{0x44, 0x64, 0x54, 0x4c, 0x44} // 7a z
;,{0x00, 0x08, 0x36, 0x41, 0x00} // 7b {
;,{0x00, 0x00, 0x7f, 0x00, 0x00} // 7c |
;,{0x00, 0x41, 0x36, 0x08, 0x00} // 7d }
;,{0x10, 0x08, 0x08, 0x10, 0x08} // 7e ?
;,{0x78, 0x46, 0x41, 0x46, 0x78} // 7f ?
;};
;
;/* LED FUNCTIONS */
;void LEDLtoggle()
; 0001 011F {

	.CSEG
_LEDLtoggle:
; 0001 0120     if(LEDL==0){LEDL=1;}else{LEDL=0;}
	SBIC 0x15,4
	RJMP _0x20009
	SBI  0x15,4
	RJMP _0x2000C
_0x20009:
	CBI  0x15,4
_0x2000C:
; 0001 0121 }
	RET
;
;void LEDRtoggle()
; 0001 0124 {
_LEDRtoggle:
; 0001 0125     if(LEDR==0){LEDR=1;}else{LEDR=0;}
	SBIC 0x15,5
	RJMP _0x2000F
	SBI  0x15,5
	RJMP _0x20012
_0x2000F:
	CBI  0x15,5
_0x20012:
; 0001 0126 }
	RET
;
;/* SPI */
;void spitx(unsigned char temtx)
; 0001 012A {
_spitx:
; 0001 012B // unsigned char transpi;
; 0001 012C     SPDR = temtx;
;	temtx -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0001 012D     while (!(SPSR & 0x80));
_0x20015:
	SBIS 0xE,7
	RJMP _0x20015
; 0001 012E }
	RJMP _0x20C000D
;
;/* LCD FUNCTIONS */
;void LcdWrite(unsigned char dc, unsigned char data)
; 0001 0132 {
_LcdWrite:
; 0001 0133     DC = dc;
;	dc -> Y+1
;	data -> Y+0
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x20018
	CBI  0x18,2
	RJMP _0x20019
_0x20018:
	SBI  0x18,2
_0x20019:
; 0001 0134     SCE=1;
	SBI  0x18,1
; 0001 0135     SCE=0;
	CBI  0x18,1
; 0001 0136     spitx(data);
	LD   R30,Y
	ST   -Y,R30
	RCALL _spitx
; 0001 0137     SCE=1;
	SBI  0x18,1
; 0001 0138 }
	RJMP _0x20C000E
;//This takes a large array of bits and sends them to the LCD
;void LcdBitmap(char my_array[]){
; 0001 013A void LcdBitmap(char my_array[]){
; 0001 013B     int index = 0;
; 0001 013C     for (index = 0 ; index < (LCD_X * LCD_Y / 8) ; index++)
;	my_array -> Y+2
;	index -> R16,R17
; 0001 013D         LcdWrite(LCD_D, my_array[index]);
; 0001 013E }
;
;void hc(int x, int y) {
; 0001 0140 void hc(int x, int y) {
_hc:
; 0001 0141     LcdWrite(0, 0x40 | x);  // Row.  ?
;	x -> Y+2
;	y -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+3
	ORI  R30,0x40
	CALL SUBOPT_0x2
; 0001 0142     LcdWrite(0, 0x80 | y);  // Column.
	LDD  R30,Y+1
	ORI  R30,0x80
	ST   -Y,R30
	RCALL _LcdWrite
; 0001 0143 }
	RJMP _0x20C000A
;
;void LcdCharacter(unsigned char character)
; 0001 0146 {
_LcdCharacter:
; 0001 0147     int index = 0;
; 0001 0148     LcdWrite(LCD_D, 0x00);
	CALL SUBOPT_0x3
;	character -> Y+2
;	index -> R16,R17
; 0001 0149     for (index = 0; index < 5; index++)
_0x20024:
	__CPWRN 16,17,5
	BRGE _0x20025
; 0001 014A     {
; 0001 014B         LcdWrite(LCD_D, ASCII[character - 0x20][index]);
	CALL SUBOPT_0x4
; 0001 014C     }
	__ADDWRN 16,17,1
	RJMP _0x20024
_0x20025:
; 0001 014D     LcdWrite(LCD_D, 0x00);
	RJMP _0x20C0010
; 0001 014E }
;
;void wc(unsigned char character)
; 0001 0151 {
_wc:
; 0001 0152     int index = 0;
; 0001 0153     LcdWrite(LCD_D, 0x00);
	CALL SUBOPT_0x3
;	character -> Y+2
;	index -> R16,R17
; 0001 0154     for (index = 0; index < 5; index++)
_0x20027:
	__CPWRN 16,17,5
	BRGE _0x20028
; 0001 0155     {
; 0001 0156         LcdWrite(LCD_D, ASCII[character - 0x20][index]);
	CALL SUBOPT_0x4
; 0001 0157     }
	__ADDWRN 16,17,1
	RJMP _0x20027
_0x20028:
; 0001 0158     LcdWrite(LCD_D, 0x00);
_0x20C0010:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
; 0001 0159 }
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0011:
	ADIW R28,3
	RET
;
;void ws(unsigned char *characters)
; 0001 015C {
_ws:
; 0001 015D     while (*characters)
;	*characters -> Y+0
_0x20029:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x2002B
; 0001 015E     {
; 0001 015F         LcdCharacter(*characters++);
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	ST   -Y,R30
	RCALL _LcdCharacter
; 0001 0160     }
	RJMP _0x20029
_0x2002B:
; 0001 0161 }
	RJMP _0x20C000E
;
;void LcdClear(void)
; 0001 0164 {
_LcdClear:
; 0001 0165     int index=0;
; 0001 0166     for (index = 0; index < LCD_X * LCD_Y / 8; index++)
	CALL SUBOPT_0x6
;	index -> R16,R17
_0x2002D:
	__CPWRN 16,17,504
	BRGE _0x2002E
; 0001 0167     {
; 0001 0168         LcdWrite(LCD_D, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
; 0001 0169     }
	__ADDWRN 16,17,1
	RJMP _0x2002D
_0x2002E:
; 0001 016A     hc(0, 0); //After we clear the display, return to the home position
	RJMP _0x20C000F
; 0001 016B }
;
;void clear(void)
; 0001 016E {
_clear:
; 0001 016F     int index=0;
; 0001 0170     for (index = 0; index < LCD_X * LCD_Y / 8; index++)
	CALL SUBOPT_0x6
;	index -> R16,R17
_0x20030:
	__CPWRN 16,17,504
	BRGE _0x20031
; 0001 0171     {
; 0001 0172         LcdWrite(LCD_D, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
; 0001 0173     }
	__ADDWRN 16,17,1
	RJMP _0x20030
_0x20031:
; 0001 0174     hc(0, 0); //After we clear the display, return to the home position
_0x20C000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x7
; 0001 0175 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void wn164(unsigned int so)
; 0001 0178 {
_wn164:
; 0001 0179     unsigned char a[5],i;
; 0001 017A     for(i=0;i<5;i++)
	SBIW R28,5
	ST   -Y,R17
;	so -> Y+6
;	a -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x20033:
	CPI  R17,5
	BRSH _0x20034
; 0001 017B     {
; 0001 017C         a[i]=so%10;        //a[0]= byte thap nhat
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0001 017D         so=so/10;
; 0001 017E     }
	SUBI R17,-1
	RJMP _0x20033
_0x20034:
; 0001 017F     for(i=1;i<5;i++)
	LDI  R17,LOW(1)
_0x20036:
	CPI  R17,5
	BRSH _0x20037
; 0001 0180         {wc(a[4-i]+0x30);}
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
	RCALL _wc
	SUBI R17,-1
	RJMP _0x20036
_0x20037:
; 0001 0181 }
	LDD  R17,Y+0
	RJMP _0x20C000B
;
;void LcdInitialise()
; 0001 0184 {
_LcdInitialise:
; 0001 0185     //reset
; 0001 0186     RST=0;
	CBI  0x18,0
; 0001 0187     delay_us(10);
	__DELAY_USB 27
; 0001 0188     RST=1;
	SBI  0x18,0
; 0001 0189 
; 0001 018A     delay_ms(1000);
	CALL SUBOPT_0xB
; 0001 018B     //khoi dong
; 0001 018C     LcdWrite(LCD_C, 0x21 );  //Tell LCD that extended commands follow
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(33)
	CALL SUBOPT_0x2
; 0001 018D     LcdWrite(LCD_C, 0xBF  );  //Set LCD Vop (Contrast): Try 0xB1(good @ 3.3V) or 0xBF = Dam nhat
	LDI  R30,LOW(191)
	CALL SUBOPT_0x2
; 0001 018E     LcdWrite(LCD_C, 0x06 );  // Set Temp coefficent. //0x04
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2
; 0001 018F     LcdWrite(LCD_C, 0x13 );  //LCD bias mode 1:48: Try 0x13 or 0x14
	LDI  R30,LOW(19)
	CALL SUBOPT_0x2
; 0001 0190     LcdWrite(LCD_C, 0x20 );  //We must send 0x20 before modifying the display control mode
	LDI  R30,LOW(32)
	CALL SUBOPT_0x2
; 0001 0191     LcdWrite(LCD_C, 0x0C );  //Set display control, normal mode. 0x0D for inverse, 0x0C normal
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL _LcdWrite
; 0001 0192 }
	RET
;// Hien thi so 16 bits
;void wn16(unsigned int so)
; 0001 0195 {
_wn16:
; 0001 0196     unsigned char a[5],i;
; 0001 0197     for(i=0;i<5;i++)
	SBIW R28,5
	ST   -Y,R17
;	so -> Y+6
;	a -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x2003D:
	CPI  R17,5
	BRSH _0x2003E
; 0001 0198     {
; 0001 0199         a[i]=so%10;        //a[0]= byte thap nhat
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0001 019A         so=so/10;
; 0001 019B     }
	SUBI R17,-1
	RJMP _0x2003D
_0x2003E:
; 0001 019C     for(i=0;i<5;i++)
	LDI  R17,LOW(0)
_0x20040:
	CPI  R17,5
	BRSH _0x20041
; 0001 019D     {LcdCharacter(a[4-i]+0x30);}
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
	RCALL _LcdCharacter
	SUBI R17,-1
	RJMP _0x20040
_0x20041:
; 0001 019E }
	LDD  R17,Y+0
	RJMP _0x20C000B
;// Hien thi so 16 bits co dau
; void wn16s( int so)
; 0001 01A1 {
_wn16s:
; 0001 01A2     if(so<0){so=0-so; LcdCharacter('-');} else{ LcdCharacter(' ');}
;	so -> Y+0
	LDD  R26,Y+1
	TST  R26
	BRPL _0x20042
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xC
	LDI  R30,LOW(45)
	RJMP _0x202CD
_0x20042:
	LDI  R30,LOW(32)
_0x202CD:
	ST   -Y,R30
	RCALL _LcdCharacter
; 0001 01A3     wn16(so);
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0xD
; 0001 01A4 }
_0x20C000E:
	ADIW R28,2
	RET
;// hien thi so 32bit co dau
; void wn32s( int so)
; 0001 01A7 {
; 0001 01A8     char tmp[20];
; 0001 01A9     sprintf(tmp,"%d",so);
;	so -> Y+20
;	tmp -> Y+0
; 0001 01AA     ws(tmp);
; 0001 01AB }
;// Hien thi so 32bit co dau
; void wnf( float so)
; 0001 01AE {
; 0001 01AF     char tmp[30];
; 0001 01B0     sprintf(tmp,"%0.2f",so);
;	so -> Y+30
;	tmp -> Y+0
; 0001 01B1     ws(tmp);
; 0001 01B2 }
;// Hien thi so 32bit co dau
; void wfmt(float so)
; 0001 01B5 {
; 0001 01B6     char tmp[30];
; 0001 01B7     sprintf(tmp,"%0.2f",so);
;	so -> Y+30
;	tmp -> Y+0
; 0001 01B8     ws(tmp);
; 0001 01B9 }
;/* SPI & LCD INIT */
;void SPIinit()
; 0001 01BC {
_SPIinit:
; 0001 01BD     SPCR |=1<<SPE | 1<<MSTR;                                         //if spi is used, uncomment this section out
	IN   R30,0xD
	ORI  R30,LOW(0x50)
	OUT  0xD,R30
; 0001 01BE     SPSR |=1<<SPI2X;
	SBI  0xE,0
; 0001 01BF }
	RET
;void LCDinit()
; 0001 01C1 {
_LCDinit:
; 0001 01C2     LcdInitialise();
	RCALL _LcdInitialise
; 0001 01C3     LcdClear();
	RCALL _LcdClear
; 0001 01C4     ws(" <AKBOTKIT>");
	__POINTW1MN _0x20044,0
	CALL SUBOPT_0xE
; 0001 01C5 }
	RET

	.DSEG
_0x20044:
	.BYTE 0xC
;
;/* ADC */
;#define ADC_VREF_TYPE 0x40
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0001 01CB {

	.CSEG
_read_adc:
; 0001 01CC     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0001 01CD     // Delay needed for the stabilization of the ADC input voltage
; 0001 01CE     delay_us(10);
	__DELAY_USB 27
; 0001 01CF     // Start the AD conversion
; 0001 01D0     ADCSRA|=0x40;
	SBI  0x6,6
; 0001 01D1     // Wait for the AD conversion to complete
; 0001 01D2     while ((ADCSRA & 0x10)==0);
_0x20045:
	SBIS 0x6,4
	RJMP _0x20045
; 0001 01D3     ADCSRA|=0x10;
	SBI  0x6,4
; 0001 01D4     return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20C000D
; 0001 01D5 }
;
;/* UART BLUETOOTH */
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0001 0209 {
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0001 020A     char status,data;
; 0001 020B     status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0001 020C     data=UDR;
	IN   R16,12
; 0001 020D     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x20048
; 0001 020E     {
; 0001 020F         rx_buffer[rx_wr_index++]=data;
	LDS  R30,_rx_wr_index
	SUBI R30,-LOW(1)
	STS  _rx_wr_index,R30
	CALL SUBOPT_0xF
	ST   Z,R16
; 0001 0210         #if RX_BUFFER_SIZE == 256
; 0001 0211         // special case for receiver buffer size=256
; 0001 0212         if (++rx_counter == 0) {
; 0001 0213         #else
; 0001 0214         if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDS  R26,_rx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x20049
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0001 0215         if (++rx_counter == RX_BUFFER_SIZE) {
_0x20049:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x8)
	BRNE _0x2004A
; 0001 0216             rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0001 0217         #endif
; 0001 0218             rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0001 0219         }
; 0001 021A     }
_0x2004A:
; 0001 021B }
_0x20048:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x202E5
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0001 0222 {
_getchar:
; 0001 0223     char data;
; 0001 0224     while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x2004B:
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x2004B
; 0001 0225     data=rx_buffer[rx_rd_index++];
	LDS  R30,_rx_rd_index
	SUBI R30,-LOW(1)
	STS  _rx_rd_index,R30
	CALL SUBOPT_0xF
	LD   R17,Z
; 0001 0226     #if RX_BUFFER_SIZE != 256
; 0001 0227     if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDS  R26,_rx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0x2004E
	LDI  R30,LOW(0)
	STS  _rx_rd_index,R30
; 0001 0228     #endif
; 0001 0229     #asm("cli")
_0x2004E:
	cli
; 0001 022A     --rx_counter;
	LDS  R30,_rx_counter
	SUBI R30,LOW(1)
	STS  _rx_counter,R30
; 0001 022B     #asm("sei")
	sei
; 0001 022C     return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0001 022D }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0001 023D {
_usart_tx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0001 023E     if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0x2004F
; 0001 023F        {
; 0001 0240        --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0001 0241        UDR=tx_buffer[tx_rd_index++];
	LDS  R30,_tx_rd_index
	SUBI R30,-LOW(1)
	STS  _tx_rd_index,R30
	CALL SUBOPT_0x10
	LD   R30,Z
	OUT  0xC,R30
; 0001 0242     #if TX_BUFFER_SIZE != 256
; 0001 0243        if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0x20050
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0001 0244     #endif
; 0001 0245        }
_0x20050:
; 0001 0246 }
_0x2004F:
_0x202E5:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0001 024D {
_putchar:
; 0001 024E     while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0x20051:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x8)
	BREQ _0x20051
; 0001 024F     #asm("cli")
	cli
; 0001 0250     if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x20055
	SBIC 0xB,5
	RJMP _0x20054
_0x20055:
; 0001 0251        {
; 0001 0252        tx_buffer[tx_wr_index++]=c;
	LDS  R30,_tx_wr_index
	SUBI R30,-LOW(1)
	STS  _tx_wr_index,R30
	CALL SUBOPT_0x10
	LD   R26,Y
	STD  Z+0,R26
; 0001 0253     #if TX_BUFFER_SIZE != 256
; 0001 0254        if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x20057
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0001 0255     #endif
; 0001 0256        ++tx_counter;
_0x20057:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0001 0257        }
; 0001 0258     else
	RJMP _0x20058
_0x20054:
; 0001 0259        UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0001 025A     #asm("sei")
_0x20058:
	sei
; 0001 025B }
	RJMP _0x20C000D
;#pragma used-
;#endif
;void inituart()
; 0001 025F {
_inituart:
; 0001 0260     // USART initialization
; 0001 0261     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 0262     // USART Receiver: On
; 0001 0263     // USART Transmitter: On
; 0001 0264     // USART Mode: Asynchronous
; 0001 0265     // USART Baud Rate: 38400
; 0001 0266     UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0001 0267     UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0001 0268     UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0001 0269     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0001 026A     UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0001 026B }
	RET
;
;//========================================================
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0001 0270 {
_ext_int0_isr:
	CALL SUBOPT_0x11
; 0001 0271      QEL++;
	LDI  R26,LOW(_QEL)
	LDI  R27,HIGH(_QEL)
	RJMP _0x202E4
; 0001 0272 }
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0001 0276 {
_ext_int1_isr:
	CALL SUBOPT_0x11
; 0001 0277     QER++;
	LDI  R26,LOW(_QER)
	LDI  R27,HIGH(_QER)
_0x202E4:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0001 0278 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;//========================================================
;//khoi tao encoder
;void initencoder()
; 0001 027C {
_initencoder:
; 0001 027D     // Dem 24 xung / 1 vong banh xe
; 0001 027E     // External Interrupt(s) initialization
; 0001 027F     // INT0: On
; 0001 0280     // INT0 Mode: Any change
; 0001 0281     // INT1: On
; 0001 0282     // INT1 Mode: Any change
; 0001 0283     // INT2: Off
; 0001 0284     GICR|=0xC0;
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0001 0285     MCUCR=0x05;
	LDI  R30,LOW(5)
	OUT  0x35,R30
; 0001 0286     MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0001 0287     GIFR=0xC0;
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0001 0288     // Global enable interrupts
; 0001 0289 
; 0001 028A     //OCR1A=0-255; MOTOR LEFT
; 0001 028B     //OCR1B=0-255; MOTOR RIGHT
; 0001 028C }
	RET
;
;//========================================================
;//control velocity motor
;void vMLtoi(unsigned char v) //congsuat=0-22 (%)
; 0001 0291 {
_vMLtoi:
; 0001 0292     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 0293     seLki=0;//reset thanh phan I
; 0001 0294     //uRold=0;
; 0001 0295     MLdir = 1;
	SBI  0x15,6
; 0001 0296     svQEL = v;
	CALL SUBOPT_0x13
; 0001 0297 }
	RJMP _0x20C000D
;//========================================================
;void vMLlui(unsigned char v) //congsuat=0-22 (%)
; 0001 029A {
_vMLlui:
; 0001 029B     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 029C     seLki=0;//reset thanh phan I
; 0001 029D 
; 0001 029E     //uRold=0;
; 0001 029F     MLdir = 0;
	CBI  0x15,6
; 0001 02A0     svQEL = v;
	CALL SUBOPT_0x13
; 0001 02A1 }
	RJMP _0x20C000D
;//========================================================
;void vMLstop()
; 0001 02A4 {
_vMLstop:
; 0001 02A5     seRki=0;//reset thanh phan I
	CALL SUBOPT_0x12
; 0001 02A6     seLki=0;//reset thanh phan I
; 0001 02A7     MLdir = 1;
	SBI  0x15,6
; 0001 02A8     OCR1A = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0001 02A9     svQEL = 0;
	STS  _svQEL,R30
	STS  _svQEL+1,R30
; 0001 02AA }
	RET
;//========================================================
;//========================================================
;void vMRtoi(unsigned char v) //congsuat=0-22 (%)
; 0001 02AE {
_vMRtoi:
; 0001 02AF     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 02B0     seLki=0;//reset thanh phan I
; 0001 02B1     MRdir = 1;
	SBI  0x15,7
; 0001 02B2     svQER = v;
	RJMP _0x20C000C
; 0001 02B3 }
;//========================================================
;void vMRlui(unsigned char v) //congsuat=0-22 (%)
; 0001 02B6 {
_vMRlui:
; 0001 02B7     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 02B8     seLki=0;//reset thanh phan I
; 0001 02B9     MRdir = 0;
	CBI  0x15,7
; 0001 02BA     svQER = v;
_0x20C000C:
	LD   R30,Y
	LDI  R31,0
	STS  _svQER,R30
	STS  _svQER+1,R31
; 0001 02BB }
_0x20C000D:
	ADIW R28,1
	RET
;//========================================================
;void vMRstop()
; 0001 02BE {
_vMRstop:
; 0001 02BF     seRki=0;//reset thanh phan I
	CALL SUBOPT_0x12
; 0001 02C0     seLki=0;//reset thanh phan I
; 0001 02C1     MRdir = 1;
	SBI  0x15,7
; 0001 02C2     OCR1B = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0001 02C3     svQER=0;
	STS  _svQER,R30
	STS  _svQER+1,R30
; 0001 02C4 }
	RET
;//========================================================
;// ham dieu khien vi tri
;void ctrRobottoi(unsigned int d,unsigned int v)  //v:0-22
; 0001 02C8 {
_ctrRobottoi:
; 0001 02C9      flagwaitctrAngle=0;
;	d -> Y+2
;	v -> Y+0
	CALL SUBOPT_0x14
; 0001 02CA      flagwaitctrRobot=1;
; 0001 02CB      sd=d;// set gia tri khoang cach di chuyen
; 0001 02CC      oldd = (QEL+QER)/2; // luu gia tri vi tri hien tai
; 0001 02CD      vMRtoi(v);
	RCALL _vMRtoi
; 0001 02CE      vMLtoi(v);
	LD   R30,Y
	ST   -Y,R30
	RCALL _vMLtoi
; 0001 02CF }
	RJMP _0x20C000A
;// ham dieu khien vi tri
;void ctrRobotlui(unsigned int d,unsigned int v)  //v:0-22
; 0001 02D2 {
_ctrRobotlui:
; 0001 02D3      flagwaitctrAngle=0;
;	d -> Y+2
;	v -> Y+0
	CALL SUBOPT_0x14
; 0001 02D4      flagwaitctrRobot=1;
; 0001 02D5      sd=d;// set gia tri khoang cach di chuyen
; 0001 02D6      oldd = (QEL+QER)/2; // luu gia tri vi tri hien tai
; 0001 02D7      vMRlui(v);
	RCALL _vMRlui
; 0001 02D8      vMLlui(v);
	LD   R30,Y
	ST   -Y,R30
	RCALL _vMLlui
; 0001 02D9 }
	RJMP _0x20C000A
;// ham dieu khien goc quay
;void ctrRobotXoay(int angle,unsigned int v)  //v:0-22
; 0001 02DC {
_ctrRobotXoay:
; 0001 02DD      float fangle=0;
; 0001 02DE      flagwaitctrRobot=0;
	CALL SUBOPT_0x15
;	angle -> Y+6
;	v -> Y+4
;	fangle -> Y+0
	LDI  R30,LOW(0)
	STS  _flagwaitctrRobot,R30
; 0001 02DF      if(angle>0)  { //xoay trai
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __CPW02
	BRGE _0x20065
; 0001 02E0         if(angle > 1) vMRtoi(v);
	SBIW R26,2
	BRLT _0x20066
	LDD  R30,Y+4
	RJMP _0x202CE
; 0001 02E1         else vMRtoi(0);
_0x20066:
	LDI  R30,LOW(0)
_0x202CE:
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 02E2         if(angle > 1) vMLlui(v);
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BRLT _0x20068
	LDD  R30,Y+4
	RJMP _0x202CF
; 0001 02E3         else vMLlui(0);
_0x20068:
	LDI  R30,LOW(0)
_0x202CF:
	ST   -Y,R30
	RCALL _vMLlui
; 0001 02E4      } else  //xoay phai
	RJMP _0x2006A
_0x20065:
; 0001 02E5      {
; 0001 02E6         angle=-angle;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __ANEGW1
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 02E7         if(angle > 1) vMRlui(v);
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BRLT _0x2006B
	LDD  R30,Y+4
	RJMP _0x202D0
; 0001 02E8         else vMRlui(0);
_0x2006B:
	LDI  R30,LOW(0)
_0x202D0:
	ST   -Y,R30
	RCALL _vMRlui
; 0001 02E9         if(angle > 1) vMLtoi(v);
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BRLT _0x2006D
	LDD  R30,Y+4
	RJMP _0x202D1
; 0001 02EA         else vMLtoi(0);
_0x2006D:
	LDI  R30,LOW(0)
_0x202D1:
	ST   -Y,R30
	RCALL _vMLtoi
; 0001 02EB      }
_0x2006A:
; 0001 02EC      flagwaitctrAngle=1;
	LDI  R30,LOW(1)
	STS  _flagwaitctrAngle,R30
; 0001 02ED      fangle=angle*0.35;// nhan chia so float
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x16
	__GETD2N 0x3EB33333
	CALL SUBOPT_0x17
; 0001 02EE      sa=fangle;
	LDI  R26,LOW(_sa)
	LDI  R27,HIGH(_sa)
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
; 0001 02EF      olda = QEL; // luu gia tri vi tri hien tai
	CALL SUBOPT_0x18
	STS  _olda,R30
	STS  _olda+1,R31
; 0001 02F0 }
_0x20C000B:
	ADIW R28,8
	RET
;
;
;//============Phat==============
;IntRobot convertRobot2IntRobot(Robot robot)
; 0001 02F5 {
_convertRobot2IntRobot:
; 0001 02F6     IntRobot intRb;
; 0001 02F7     intRb.id = (int)robot.id;
	SBIW R28,28
;	robot -> Y+28
;	intRb -> Y+0
	CALL SUBOPT_0x19
	CALL __CFD1
	ST   Y,R30
	STD  Y+1,R31
; 0001 02F8     intRb.x = (int)robot.x;
	CALL SUBOPT_0x1A
	CALL __CFD1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 02F9     intRb.y = (int)robot.y;
	CALL SUBOPT_0x1B
	CALL __CFD1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0001 02FA     intRb.ox = (int)robot.ox;
	__GETD1S 40
	CALL __CFD1
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 02FB     intRb.oy = (int)robot.oy;
	CALL SUBOPT_0x1C
	CALL __CFD1
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 02FC     intRb.ball.x = (int)robot.ball.x;
	__GETD1S 48
	CALL __CFD1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 02FD     intRb.ball.y = (int)robot.ball.y;
	__GETD1S 52
	CALL __CFD1
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0001 02FE     return intRb;
	MOVW R30,R28
	MOVW R26,R28
	ADIW R26,14
	LDI  R24,14
	CALL __COPYMML
	MOVW R30,R28
	ADIW R30,14
	LDI  R24,14
	IN   R1,SREG
	CLI
	ADIW R28,56
	RET
; 0001 02FF }
;
;//========================================================
;// read  vi tri robot   PHUC
;//========================================================
;unsigned char readposition()
; 0001 0305 {
_readposition:
; 0001 0306     unsigned char  i=0;
; 0001 0307     unsigned flagstatus=0;
; 0001 0308 
; 0001 0309     if(nRF24L01_RxPacket(RxBuf)==1)         // Neu nhan duoc du lieu
	CALL __SAVELOCR4
;	i -> R17
;	flagstatus -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
	LDI  R30,LOW(_RxBuf)
	LDI  R31,HIGH(_RxBuf)
	ST   -Y,R31
	ST   -Y,R30
	CALL _nRF24L01_RxPacket
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x2006F
; 0001 030A     {
; 0001 030B         for( i=0;i<28;i++)
	LDI  R17,LOW(0)
_0x20071:
	CPI  R17,28
	BRSH _0x20072
; 0001 030C         {
; 0001 030D             *(uint8_t *) ((uint8_t *)&rb + i)=RxBuf[i];
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_rb)
	SBCI R27,HIGH(-_rb)
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_RxBuf)
	SBCI R31,HIGH(-_RxBuf)
	LD   R30,Z
	ST   X,R30
; 0001 030E         }
	SUBI R17,-1
	RJMP _0x20071
_0x20072:
; 0001 030F 
; 0001 0310         idRobot = fmod(rb.id,10); // doc id
	CALL SUBOPT_0x1D
	CALL __PUTPARD1
	CALL SUBOPT_0x1E
	CALL __PUTPARD1
	CALL _fmod
	CALL __CFD1U
	MOVW R12,R30
; 0001 0311         cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
	CALL SUBOPT_0x1F
; 0001 0312 
; 0001 0313         switch (idRobot)
	MOVW R30,R12
; 0001 0314         {
; 0001 0315             case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20076
; 0001 0316                 robot11=convertRobot2IntRobot(rb);
	CALL SUBOPT_0x20
	LDI  R26,LOW(_robot11)
	LDI  R27,HIGH(_robot11)
	RJMP _0x202D2
; 0001 0317                 break;
; 0001 0318             case 2:
_0x20076:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20077
; 0001 0319                 robot12=convertRobot2IntRobot(rb);
	CALL SUBOPT_0x20
	LDI  R26,LOW(_robot12)
	LDI  R27,HIGH(_robot12)
	RJMP _0x202D2
; 0001 031A                 break;
; 0001 031B             case 3:
_0x20077:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20078
; 0001 031C                 robot13=convertRobot2IntRobot(rb);
	CALL SUBOPT_0x20
	LDI  R26,LOW(_robot13)
	LDI  R27,HIGH(_robot13)
	RJMP _0x202D2
; 0001 031D             break;
; 0001 031E             case 4:
_0x20078:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20079
; 0001 031F                 robot21=convertRobot2IntRobot(rb);
	CALL SUBOPT_0x20
	LDI  R26,LOW(_robot21)
	LDI  R27,HIGH(_robot21)
	RJMP _0x202D2
; 0001 0320                 break;
; 0001 0321             case 5:
_0x20079:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2007A
; 0001 0322                 robot22=convertRobot2IntRobot(rb);
	CALL SUBOPT_0x20
	LDI  R26,LOW(_robot22)
	LDI  R27,HIGH(_robot22)
	RJMP _0x202D2
; 0001 0323                 break;
; 0001 0324             case 6:
_0x2007A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20075
; 0001 0325                 robot23=convertRobot2IntRobot(rb);
	CALL SUBOPT_0x20
	LDI  R26,LOW(_robot23)
	LDI  R27,HIGH(_robot23)
_0x202D2:
	CALL __COPYMML
	OUT  SREG,R1
; 0001 0326                 break;
; 0001 0327         }
_0x20075:
; 0001 0328 
; 0001 0329         if(idRobot==ROBOT_ID)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x2007C
; 0001 032A         {
; 0001 032B             LEDL=!LEDL;
	SBIS 0x15,4
	RJMP _0x2007D
	CBI  0x15,4
	RJMP _0x2007E
_0x2007D:
	SBI  0x15,4
_0x2007E:
; 0001 032C             cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
	CALL SUBOPT_0x1F
; 0001 032D             flagstatus=1;
	__GETWRN 18,19,1
; 0001 032E             robotctrl=convertRobot2IntRobot(rb);
	CALL SUBOPT_0x20
	LDI  R26,LOW(_robotctrl)
	LDI  R27,HIGH(_robotctrl)
	CALL __COPYMML
	OUT  SREG,R1
; 0001 032F         }
; 0001 0330     }
_0x2007C:
; 0001 0331     return flagstatus;
_0x2006F:
	MOV  R30,R18
	CALL __LOADLOCR4
_0x20C000A:
	ADIW R28,4
	RET
; 0001 0332 }
;//========================================================
;// calc  vi tri robot   so voi mot diem (x,y)        PHUC
;// return goclenh va khoang cach, HUONG TAN CONG
;//========================================================
;void calcvitri(float x,float y)
; 0001 0338 {
_calcvitri:
; 0001 0339     float ahx,ahy,aox,aoy,dah,dao,ahay,cosgoc,anpla0,anpla1,detaanpla;
; 0001 033A     ahx = robotctrl.ox-robotctrl.x;
	SBIW R28,44
;	x -> Y+48
;	y -> Y+44
;	ahx -> Y+40
;	ahy -> Y+36
;	aox -> Y+32
;	aoy -> Y+28
;	dah -> Y+24
;	dao -> Y+20
;	ahay -> Y+16
;	cosgoc -> Y+12
;	anpla0 -> Y+8
;	anpla1 -> Y+4
;	detaanpla -> Y+0
	__GETW1MN _robotctrl,6
	CALL SUBOPT_0x21
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x16
	__PUTD1S 40
; 0001 033B     ahy = robotctrl.oy-robotctrl.y;
	__GETW1MN _robotctrl,8
	CALL SUBOPT_0x22
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x16
	__PUTD1S 36
; 0001 033C     aox = x-robotctrl.x;
	__GETW1MN _robotctrl,2
	__GETD2S 48
	CALL SUBOPT_0x23
	__PUTD1S 32
; 0001 033D     aoy = y-robotctrl.y;
	__GETW1MN _robotctrl,4
	__GETD2S 44
	CALL SUBOPT_0x23
	__PUTD1S 28
; 0001 033E     dah = sqrt(ahx*ahx+ahy*ahy)  ;
	__GETD1S 40
	CALL SUBOPT_0x24
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x25
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x26
	__PUTD1S 24
; 0001 033F     dao = sqrt(aox*aox+aoy*aoy)  ;
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x27
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x19
	CALL SUBOPT_0x28
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x26
	CALL SUBOPT_0x29
; 0001 0340     ahay= ahx*aox+ahy*aoy;
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x24
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x19
	CALL SUBOPT_0x25
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x2A
; 0001 0341     cosgoc = ahay/(dah*dao);
	__GETD1S 20
	__GETD2S 24
	CALL __MULF12
	CALL SUBOPT_0x2B
	CALL __DIVF21
	CALL SUBOPT_0x2C
; 0001 0342 
; 0001 0343     anpla0 = atan2(ahy,ahx);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	__PUTD1S 8
; 0001 0344     anpla1 = atan2(aoy,aox);
	CALL SUBOPT_0x19
	CALL __PUTPARD1
	CALL SUBOPT_0x2D
	CALL _atan2
	__PUTD1S 4
; 0001 0345     detaanpla= anpla0-anpla1;
	CALL SUBOPT_0x2F
	__GETD1S 8
	CALL __SUBF12
	CALL SUBOPT_0x30
; 0001 0346 
; 0001 0347     errangle = acos(cosgoc)*180/3.14;
	CALL SUBOPT_0x31
	CALL __PUTPARD1
	CALL _acos
	CALL SUBOPT_0x32
	__GETD1N 0x4048F5C3
	CALL __DIVF21
	STS  _errangle,R30
	STS  _errangle+1,R31
	STS  _errangle+2,R22
	STS  _errangle+3,R23
; 0001 0348     if(((detaanpla>0)&&(detaanpla <M_PI))|| (detaanpla <-M_PI))  // xet truong hop goc ben phai
	CALL SUBOPT_0x33
	CALL __CPD02
	BRGE _0x20080
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
	CALL __CMPF12
	BRLO _0x20082
_0x20080:
	CALL SUBOPT_0x33
	__GETD1N 0xC0490FDB
	CALL __CMPF12
	BRSH _0x2007F
_0x20082:
; 0001 0349     {
; 0001 034A          errangle = - errangle; // ben phai
	CALL SUBOPT_0x35
	CALL __ANEGF1
	RJMP _0x202D3
; 0001 034B     }
; 0001 034C     else
_0x2007F:
; 0001 034D     {
; 0001 034E         errangle = errangle;   // ben trai
	CALL SUBOPT_0x35
_0x202D3:
	STS  _errangle,R30
	STS  _errangle+1,R31
	STS  _errangle+2,R22
	STS  _errangle+3,R23
; 0001 034F 
; 0001 0350     }
; 0001 0351     distance = sqrt(aox*3.48*aox*3.48+aoy*2.89*aoy*2.89); //tinh khoang cach
	CALL SUBOPT_0x27
	__GETD1N 0x405EB852
	CALL __MULF12
	CALL SUBOPT_0x27
	CALL __MULF12
	__GETD2N 0x405EB852
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x28
	__GETD1N 0x4038F5C3
	CALL __MULF12
	CALL SUBOPT_0x28
	CALL __MULF12
	__GETD2N 0x4038F5C3
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x26
	STS  _distance,R30
	STS  _distance+1,R31
	STS  _distance+2,R22
	STS  _distance+3,R23
; 0001 0352     orentation = atan2(ahy,ahx)*180/M_PI + offestsanco;//tinh huong ra goc
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
	CALL __DIVF21
	LDS  R26,_offestsanco
	LDS  R27,_offestsanco+1
	LDS  R24,_offestsanco+2
	LDS  R25,_offestsanco+3
	CALL __ADDF12
	STS  _orentation,R30
	STS  _orentation+1,R31
	STS  _orentation+2,R22
	STS  _orentation+3,R23
; 0001 0353     if(( 0 < orentation && orentation < 74) ||   ( 0 > orentation && orentation > -80) )
	CALL __CPD01
	BRGE _0x20086
	CALL SUBOPT_0x36
	__GETD1N 0x42940000
	CALL __CMPF12
	BRLO _0x20088
_0x20086:
	LDS  R30,_orentation+3
	TST  R30
	BRPL _0x20089
	CALL SUBOPT_0x36
	__GETD1N 0xC2A00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x20089
	RJMP _0x20088
_0x20089:
	RJMP _0x20085
_0x20088:
; 0001 0354     {
; 0001 0355        if(SAN_ID == 1)// phan san duong
; 0001 0356        {
; 0001 0357         flagtancong=0;
	CLR  R4
	CLR  R5
; 0001 0358         offsetphongthu = 70 ;
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	MOVW R6,R30
; 0001 0359         goctancong = 180;
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	MOVW R8,R30
; 0001 035A        }
; 0001 035B        else // phan san am
; 0001 035C        {
; 0001 035D         flagtancong=1;
; 0001 035E 
; 0001 035F        }
; 0001 0360     }else
	RJMP _0x2008E
_0x20085:
; 0001 0361     {
; 0001 0362        if(SAN_ID == 1)
; 0001 0363        {
; 0001 0364        flagtancong=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0001 0365        }
; 0001 0366        else
; 0001 0367        {
; 0001 0368         flagtancong=0;
; 0001 0369         offsetphongthu = -70 ;
; 0001 036A         goctancong = 0;
; 0001 036B        }
; 0001 036C     }
_0x2008E:
; 0001 036D }
	ADIW R28,52
	RET
;void runEscStuck()
; 0001 036F {
_runEscStuck:
; 0001 0370     while(cmdCtrlRobot==4)
_0x20091:
	CALL SUBOPT_0x37
	BRNE _0x20093
; 0001 0371     {
; 0001 0372 
; 0001 0373         DDRA    = 0x00;
	CALL SUBOPT_0x38
; 0001 0374         PORTA   = 0x00;
; 0001 0375         IRFL=read_adc(4);
	CALL SUBOPT_0x39
; 0001 0376         IRFR=read_adc(5);
; 0001 0377 
; 0001 0378         if((IRFL<300)&&(IRFR<300))
	BRSH _0x20095
	CALL SUBOPT_0x3A
	BRLO _0x20096
_0x20095:
	RJMP _0x20094
_0x20096:
; 0001 0379         {
; 0001 037A             vMLtoi(22);vMRlui(22);
	CALL SUBOPT_0x3B
; 0001 037B             delay_ms(100);
; 0001 037C         }
; 0001 037D          if (IRFL>300 && IRFR<300)
_0x20094:
	CALL SUBOPT_0x3C
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRLO _0x20098
	CALL SUBOPT_0x3A
	BRLO _0x20099
_0x20098:
	RJMP _0x20097
_0x20099:
; 0001 037E         {
; 0001 037F             vMLlui(0);vMRlui(25);delay_ms(100);
	CALL SUBOPT_0x3D
	LDI  R30,LOW(25)
	CALL SUBOPT_0x3E
; 0001 0380         }
; 0001 0381         if (IRFR>300 && IRFL<300 )
_0x20097:
	CALL SUBOPT_0x3F
	BRLO _0x2009B
	CALL SUBOPT_0x40
	BRLO _0x2009C
_0x2009B:
	RJMP _0x2009A
_0x2009C:
; 0001 0382         {
; 0001 0383             vMLlui(25);vMRlui(0);delay_ms(100);
	LDI  R30,LOW(25)
	CALL SUBOPT_0x41
	CALL SUBOPT_0x3E
; 0001 0384         }
; 0001 0385         LEDBR=!LEDBR;
_0x2009A:
	SBIS 0x1B,7
	RJMP _0x2009D
	CBI  0x1B,7
	RJMP _0x2009E
_0x2009D:
	SBI  0x1B,7
_0x2009E:
; 0001 0386         readposition();//doc RF cap nhat ai robot
	RCALL _readposition
; 0001 0387     }
	RJMP _0x20091
_0x20093:
; 0001 0388 }
	RET
;void runEscStucksethome()
; 0001 038A {
_runEscStucksethome:
; 0001 038B     while(cmdCtrlRobot==7)
_0x2009F:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x200A1
; 0001 038C     {
; 0001 038D         DDRA    = 0x00;
	CALL SUBOPT_0x38
; 0001 038E         PORTA   = 0x00;
; 0001 038F         readposition();//doc RF cap nhat ai robot
	RCALL _readposition
; 0001 0390         IRFL=read_adc(4);
	CALL SUBOPT_0x39
; 0001 0391         IRFR=read_adc(5);
; 0001 0392 
; 0001 0393         if((IRFL<300)&&(IRFR<300))
	BRSH _0x200A3
	CALL SUBOPT_0x3A
	BRLO _0x200A4
_0x200A3:
	RJMP _0x200A2
_0x200A4:
; 0001 0394         {
; 0001 0395             vMLtoi(22);vMRlui(22);
	CALL SUBOPT_0x3B
; 0001 0396             delay_ms(100);
; 0001 0397         }
; 0001 0398 
; 0001 0399         if (IRFL>300 && IRFR<300)
_0x200A2:
	CALL SUBOPT_0x42
	BRLO _0x200A6
	CALL SUBOPT_0x3A
	BRLO _0x200A7
_0x200A6:
	RJMP _0x200A5
_0x200A7:
; 0001 039A         {
; 0001 039B             vMLlui(0);vMRlui(22);delay_ms(300);
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x43
; 0001 039C         }
; 0001 039D         if (IRFR>300 && IRFL<300 )
_0x200A5:
	CALL SUBOPT_0x3F
	BRLO _0x200A9
	CALL SUBOPT_0x40
	BRLO _0x200AA
_0x200A9:
	RJMP _0x200A8
_0x200AA:
; 0001 039E         {
; 0001 039F             vMLlui(22);vMRlui(0);delay_ms(300);
	LDI  R30,LOW(22)
	CALL SUBOPT_0x41
	CALL SUBOPT_0x44
; 0001 03A0         }
; 0001 03A1 
; 0001 03A2         LEDBR=!LEDBR;
_0x200A8:
	SBIS 0x1B,7
	RJMP _0x200AB
	CBI  0x1B,7
	RJMP _0x200AC
_0x200AB:
	SBI  0x1B,7
_0x200AC:
; 0001 03A3     }
	RJMP _0x2009F
_0x200A1:
; 0001 03A4 }
	RET
;void runEscBlindSpot()
; 0001 03A6 {
_runEscBlindSpot:
; 0001 03A7     while(cmdCtrlRobot==3)
_0x200AD:
	CALL SUBOPT_0x45
	BRNE _0x200AF
; 0001 03A8     {
; 0001 03A9         DDRA    = 0x00;
	CALL SUBOPT_0x38
; 0001 03AA         PORTA   = 0x00;
; 0001 03AB         readposition();//doc RF cap nhat ai robot
	CALL SUBOPT_0x46
; 0001 03AC         IRFL=read_adc(4);
; 0001 03AD         IRFR=read_adc(5);
; 0001 03AE         if (IRFL>300 && IRFR<300)
	BRLO _0x200B1
	CALL SUBOPT_0x3A
	BRLO _0x200B2
_0x200B1:
	RJMP _0x200B0
_0x200B2:
; 0001 03AF         {
; 0001 03B0             vMLlui(0);vMRlui(22);delay_ms(300);
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x43
; 0001 03B1         }
; 0001 03B2         if (IRFR>300 && IRFL<300 )
_0x200B0:
	CALL SUBOPT_0x3F
	BRLO _0x200B4
	CALL SUBOPT_0x40
	BRLO _0x200B5
_0x200B4:
	RJMP _0x200B3
_0x200B5:
; 0001 03B3         {
; 0001 03B4             vMLlui(22);vMRlui(0);delay_ms(300);
	LDI  R30,LOW(22)
	CALL SUBOPT_0x41
	CALL SUBOPT_0x44
; 0001 03B5         }
; 0001 03B6 
; 0001 03B7         if((IRFL<300)&&(IRFR<300))
_0x200B3:
	CALL SUBOPT_0x40
	BRSH _0x200B7
	CALL SUBOPT_0x3A
	BRLO _0x200B8
_0x200B7:
	RJMP _0x200B6
_0x200B8:
; 0001 03B8         {
; 0001 03B9             vMLtoi(20);vMRtoi(20);
	CALL SUBOPT_0x47
; 0001 03BA             delay_ms(20);
	CALL SUBOPT_0x48
	CALL _delay_ms
; 0001 03BB         }
; 0001 03BC 
; 0001 03BD         LEDR=!LEDR;
_0x200B6:
	SBIS 0x15,5
	RJMP _0x200B9
	CBI  0x15,5
	RJMP _0x200BA
_0x200B9:
	SBI  0x15,5
_0x200BA:
; 0001 03BE     }
	RJMP _0x200AD
_0x200AF:
; 0001 03BF }
	RET
;
;void runEscBlindSpotsethome()
; 0001 03C2 {
_runEscBlindSpotsethome:
; 0001 03C3     while(cmdCtrlRobot==6)
_0x200BB:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x200BD
; 0001 03C4     {
; 0001 03C5         DDRA    = 0x00;
	CALL SUBOPT_0x38
; 0001 03C6         PORTA   = 0x00;
; 0001 03C7         readposition();
	CALL SUBOPT_0x46
; 0001 03C8         IRFL=read_adc(4);
; 0001 03C9         IRFR=read_adc(5);
; 0001 03CA         if (IRFL>300 && IRFR<300)
	BRLO _0x200BF
	CALL SUBOPT_0x3A
	BRLO _0x200C0
_0x200BF:
	RJMP _0x200BE
_0x200C0:
; 0001 03CB         {
; 0001 03CC             vMLlui(0);vMRlui(22);delay_ms(300);
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x43
; 0001 03CD         }
; 0001 03CE         if (IRFR>300 && IRFL<300 )
_0x200BE:
	CALL SUBOPT_0x3F
	BRLO _0x200C2
	CALL SUBOPT_0x40
	BRLO _0x200C3
_0x200C2:
	RJMP _0x200C1
_0x200C3:
; 0001 03CF         {
; 0001 03D0             vMLlui(22);vMRlui(0);delay_ms(300);
	LDI  R30,LOW(22)
	CALL SUBOPT_0x41
	CALL SUBOPT_0x44
; 0001 03D1         }
; 0001 03D2 
; 0001 03D3         if((IRFL<300)&&(IRFR<300))
_0x200C1:
	CALL SUBOPT_0x40
	BRSH _0x200C5
	CALL SUBOPT_0x3A
	BRLO _0x200C6
_0x200C5:
	RJMP _0x200C4
_0x200C6:
; 0001 03D4         {
; 0001 03D5             vMLtoi(20);vMRtoi(20);
	CALL SUBOPT_0x47
; 0001 03D6             delay_ms(10);
	CALL SUBOPT_0x49
	CALL _delay_ms
; 0001 03D7         }
; 0001 03D8 
; 0001 03D9         LEDR=!LEDR;
_0x200C4:
	SBIS 0x15,5
	RJMP _0x200C7
	CBI  0x15,5
	RJMP _0x200C8
_0x200C7:
	SBI  0x15,5
_0x200C8:
; 0001 03DA     }
	RJMP _0x200BB
_0x200BD:
; 0001 03DB }
	RET
;
;//========================================================
;// SET HOME  vi tri robot, de chuan bi cho tran dau       PHUC//
;//========================================================
;int sethomeRB()
; 0001 03E1 {
_sethomeRB:
; 0001 03E2        while(flagsethome==0)
_0x200C9:
	LDS  R30,_flagsethome
	LDS  R31,_flagsethome+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x200CB
; 0001 03E3        {
; 0001 03E4             LEDL=!LEDL;
	SBIS 0x15,4
	RJMP _0x200CC
	CBI  0x15,4
	RJMP _0x200CD
_0x200CC:
	SBI  0x15,4
_0x200CD:
; 0001 03E5               //PHUC SH
; 0001 03E6             if(readposition()==1)//co du lieu moi
	RCALL _readposition
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x200CE
; 0001 03E7             {
; 0001 03E8                     //hc(3,40);wn16s(cmdCtrlRobot);
; 0001 03E9                     if(cmdCtrlRobot==1)      // dung ma lenh stop chuong trinh
	CALL SUBOPT_0x4A
	BRNE _0x200CF
; 0001 03EA                     {
; 0001 03EB                         flagsethome=0;
	CALL SUBOPT_0x4B
; 0001 03EC                          return 0;
	RJMP _0x20C0008
; 0001 03ED                     }
; 0001 03EE 
; 0001 03EF                     if(cmdCtrlRobot==2 || cmdCtrlRobot==3 || cmdCtrlRobot==4)      // dung ma lenh stop chuong trinh
_0x200CF:
	CALL SUBOPT_0x4C
	BREQ _0x200D1
	CALL SUBOPT_0x45
	BREQ _0x200D1
	CALL SUBOPT_0x37
	BRNE _0x200D0
_0x200D1:
; 0001 03F0                     {
; 0001 03F1                         flagsethome=0;
	CALL SUBOPT_0x4B
; 0001 03F2                         return 0;
	RJMP _0x20C0008
; 0001 03F3                     }
; 0001 03F4 
; 0001 03F5                     if(cmdCtrlRobot==5)  //sethome robot
_0x200D0:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R10
	CPC  R31,R11
	BREQ PC+3
	JMP _0x200D3
; 0001 03F6                     {
; 0001 03F7 
; 0001 03F8                         calcvitri(rbctrlHomeX,rbctrlHomeY);
	LDS  R30,_rbctrlHomeX
	LDS  R31,_rbctrlHomeX+1
	LDS  R22,_rbctrlHomeX+2
	LDS  R23,_rbctrlHomeX+3
	CALL __PUTPARD1
	LDS  R30,_rbctrlHomeY
	LDS  R31,_rbctrlHomeY+1
	LDS  R22,_rbctrlHomeY+2
	LDS  R23,_rbctrlHomeY+3
	CALL SUBOPT_0x4D
; 0001 03F9                         if(distance>100) //chay den vi tri
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
	BREQ PC+2
	BRCC PC+3
	JMP  _0x200D4
; 0001 03FA                         {
; 0001 03FB                             if(errangle>18 || errangle<-18 )
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
	BREQ PC+4
	BRCS PC+3
	JMP  _0x200D6
	CALL SUBOPT_0x52
	BRSH _0x200D5
_0x200D6:
; 0001 03FC                             {
; 0001 03FD                             int nv = errangle*27/180 ;
; 0001 03FE                             int verrangle = calcVangle(errangle);
; 0001 03FF                             ctrRobotXoay(nv,verrangle);
	CALL SUBOPT_0x53
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0400                             delay_ms(1);
; 0001 0401                             }else
	RJMP _0x200D8
_0x200D5:
; 0001 0402                             {
; 0001 0403                             //1xung = 3.14 * 40/24 =5.22
; 0001 0404                             ctrRobottoi(distance/5.22,15);
	CALL SUBOPT_0x54
; 0001 0405                             // verranglekisum=0;//RESET I.
; 0001 0406                             }
_0x200D8:
; 0001 0407                         }
; 0001 0408                         else //XOAY DUNG HUONG
	RJMP _0x200D9
_0x200D4:
; 0001 0409                         {
; 0001 040A                             setRobotAngleX=10*cos(rbctrlHomeAngle*M_PI/180);
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
; 0001 040B                             setRobotAngleY=10*sin(rbctrlHomeAngle*M_PI/180);;
	CALL SUBOPT_0x55
	CALL SUBOPT_0x57
; 0001 040C                             calcvitri(robotctrl.x + setRobotAngleX,robotctrl.y + setRobotAngleY);
	CALL SUBOPT_0x58
	CALL SUBOPT_0x59
; 0001 040D                             if(errangle>90 || errangle<-90 )
	CALL SUBOPT_0x50
	__GETD1N 0x42B40000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x200DB
	CALL SUBOPT_0x50
	__GETD1N 0xC2B40000
	CALL __CMPF12
	BRSH _0x200DA
_0x200DB:
; 0001 040E                              {
; 0001 040F 
; 0001 0410                                int nv = errangle*27/180 ;
; 0001 0411                                int verrangle = calcVangle(errangle);
; 0001 0412                                ctrRobotXoay(nv,verrangle);
	CALL SUBOPT_0x53
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0413                                delay_ms(1);
; 0001 0414                              }else
	RJMP _0x200DD
_0x200DA:
; 0001 0415                              {
; 0001 0416 
; 0001 0417                                  verranglekisum=0;//RESET I.
	CALL SUBOPT_0x5A
; 0001 0418                                  flaghuongtrue=0;
; 0001 0419                                  flagsethome=1;  // bao da set home khong can set nua
; 0001 041A                                  vMRstop();
	RJMP _0x20C0009
; 0001 041B                                  vMLstop();
; 0001 041C                                   return 0;
; 0001 041D 
; 0001 041E                              }
_0x200DD:
; 0001 041F                         }
_0x200D9:
; 0001 0420 
; 0001 0421                     }
; 0001 0422 
; 0001 0423                     if(cmdCtrlRobot==7)  //sethome IS STUCKED
_0x200D3:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x200DE
; 0001 0424                     {
; 0001 0425 
; 0001 0426                        cntstuckRB++;
	CALL SUBOPT_0x5B
; 0001 0427                        if(cntstuckRB > 2)
	BRLO _0x200DF
; 0001 0428                        {
; 0001 0429                          runEscStucksethome();
	RCALL _runEscStucksethome
; 0001 042A                          cntstuckRB=0;
	LDI  R30,LOW(0)
	STS  _cntstuckRB,R30
	STS  _cntstuckRB+1,R30
; 0001 042B                        }
; 0001 042C                     }
_0x200DF:
; 0001 042D 
; 0001 042E                     if(cmdCtrlRobot==6) //sethome IS //roi vao diem mu (blind spot) , mat vi tri hay huong
_0x200DE:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x200E0
; 0001 042F                     {
; 0001 0430                        LEDBL=1;
	SBI  0x1B,6
; 0001 0431                        cntunlookRB++;
	CALL SUBOPT_0x5C
; 0001 0432                        if(cntunlookRB > 2)
	BRLO _0x200E3
; 0001 0433                        {
; 0001 0434                          runEscBlindSpotsethome();
	RCALL _runEscBlindSpotsethome
; 0001 0435                          cntunlookRB=0;
	LDI  R30,LOW(0)
	STS  _cntunlookRB,R30
	STS  _cntunlookRB+1,R30
; 0001 0436 
; 0001 0437                        }
; 0001 0438 
; 0001 0439                     }
_0x200E3:
; 0001 043A 
; 0001 043B 
; 0001 043C             }
_0x200E0:
; 0001 043D 
; 0001 043E             LEDR=!LEDR;
_0x200CE:
	SBIS 0x15,5
	RJMP _0x200E4
	CBI  0x15,5
	RJMP _0x200E5
_0x200E4:
	SBI  0x15,5
_0x200E5:
; 0001 043F 
; 0001 0440        }
	RJMP _0x200C9
_0x200CB:
; 0001 0441        return 0;
	RJMP _0x20C0008
; 0001 0442 
; 0001 0443 }
;
;int codePenalty()
; 0001 0446 {
_codePenalty:
; 0001 0447    // chay den vi tri duoc dat truoc, sau do da banh 1 lan
; 0001 0448       //PHUC SH
; 0001 0449       if(readposition()==1)//co du lieu moi
	RCALL _readposition
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x200E6
; 0001 044A       {
; 0001 044B            if(cmdCtrlRobot==8)  //set vi tri penalty robot
	CALL SUBOPT_0x5D
	BREQ PC+3
	JMP _0x200E7
; 0001 044C             {
; 0001 044D                 calcvitri(rbctrlPenaltyX,rbctrlPenaltyY);
	LDS  R30,_rbctrlPenaltyX
	LDS  R31,_rbctrlPenaltyX+1
	LDS  R22,_rbctrlPenaltyX+2
	LDS  R23,_rbctrlPenaltyX+3
	CALL __PUTPARD1
	LDS  R30,_rbctrlPenaltyY
	LDS  R31,_rbctrlPenaltyY+1
	LDS  R22,_rbctrlPenaltyY+2
	LDS  R23,_rbctrlPenaltyY+3
	CALL SUBOPT_0x4D
; 0001 044E                 if(distance>50) //chay den vi tri
	CALL SUBOPT_0x4E
	__GETD1N 0x42480000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x200E8
; 0001 044F                 {
; 0001 0450                     if(errangle>18 || errangle<-18 )
	CALL SUBOPT_0x5E
	BREQ PC+4
	BRCS PC+3
	JMP  _0x200EA
	CALL SUBOPT_0x52
	BRSH _0x200E9
_0x200EA:
; 0001 0451                     {
; 0001 0452                     int nv = errangle*27/180 ;
; 0001 0453                     int verrangle = calcVangle(errangle);
; 0001 0454                     ctrRobotXoay(nv,verrangle);
	CALL SUBOPT_0x53
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0455                     delay_ms(1);
; 0001 0456                     }else
	RJMP _0x200EC
_0x200E9:
; 0001 0457                     {
; 0001 0458                     //1xung = 3.14 * 40/24 =5.22
; 0001 0459                     ctrRobottoi(distance/5.22,15);
	CALL SUBOPT_0x54
; 0001 045A                     // verranglekisum=0;//RESET I.
; 0001 045B                     }
_0x200EC:
; 0001 045C                 }
; 0001 045D                 else //XOAY DUNG HUONG
	RJMP _0x200ED
_0x200E8:
; 0001 045E                 {
; 0001 045F                     setRobotAngleX=10*cos(rbctrlPenaltyAngle*M_PI/180);
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x56
; 0001 0460                     setRobotAngleY=10*sin(rbctrlPenaltyAngle*M_PI/180);;
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x57
; 0001 0461                     calcvitri(robotctrl.x + setRobotAngleX,robotctrl.y + setRobotAngleY);
	CALL SUBOPT_0x58
	CALL SUBOPT_0x59
; 0001 0462                     if(errangle>10 || errangle<-10 )
	CALL SUBOPT_0x50
	CALL SUBOPT_0x60
	BREQ PC+4
	BRCS PC+3
	JMP  _0x200EF
	CALL SUBOPT_0x50
	CALL SUBOPT_0x61
	BRSH _0x200EE
_0x200EF:
; 0001 0463                      {
; 0001 0464 
; 0001 0465                        int nv = errangle*27/180 ;
; 0001 0466                        int verrangle = calcVangle(errangle);
; 0001 0467                        ctrRobotXoay(nv,verrangle);
	CALL SUBOPT_0x53
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0468                        delay_ms(1);
; 0001 0469                      }else
	RJMP _0x200F1
_0x200EE:
; 0001 046A                      {
; 0001 046B 
; 0001 046C                          verranglekisum=0;//RESET I.
	CALL SUBOPT_0x5A
; 0001 046D                          flaghuongtrue=0;
; 0001 046E                          flagsethome=1;  // bao da set vitri penalty
; 0001 046F                          while(cmdCtrlRobot!=2) //cho nhan nut start
_0x200F2:
	CALL SUBOPT_0x4C
	BREQ _0x200F4
; 0001 0470                          {
; 0001 0471                             readposition();
	RCALL _readposition
; 0001 0472                          }
	RJMP _0x200F2
_0x200F4:
; 0001 0473                          // da banh
; 0001 0474                          vMRtoi(22);
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 0475                          vMLtoi(22);
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _vMLtoi
; 0001 0476                          delay_ms(1000);
	CALL SUBOPT_0xB
; 0001 0477                          vMRlui(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _vMRlui
; 0001 0478                          vMLlui(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _vMLlui
; 0001 0479                          delay_ms(1000);
	CALL SUBOPT_0xB
; 0001 047A                          vMRstop();
_0x20C0009:
	RCALL _vMRstop
; 0001 047B                          vMLstop();
	RCALL _vMLstop
; 0001 047C                           return 0;
_0x20C0008:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0001 047D 
; 0001 047E                      }
_0x200F1:
; 0001 047F                 }
_0x200ED:
; 0001 0480 
; 0001 0481             }
; 0001 0482       }
_0x200E7:
; 0001 0483 
; 0001 0484 }
_0x200E6:
	RET
;void settoadoHomRB()
; 0001 0486 {
_settoadoHomRB:
; 0001 0487     switch(ROBOT_ID)
	LDI  R30,LOW(4)
; 0001 0488     {
; 0001 0489     //PHUC
; 0001 048A        case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x200F8
; 0001 048B 
; 0001 048C 
; 0001 048D             rbctrlPenaltyX = 0;
	CALL SUBOPT_0x62
; 0001 048E             rbctrlPenaltyY = 0;
; 0001 048F 
; 0001 0490             if(SAN_ID==1)
; 0001 0491             {
; 0001 0492               rbctrlPenaltyAngle = 179;
; 0001 0493               rbctrlHomeAngle = 179 ;
; 0001 0494               rbctrlHomeX = 269.7 ;
	CALL SUBOPT_0x63
; 0001 0495               rbctrlHomeY = 1.7  ;
; 0001 0496               setRobotXmin=80;
; 0001 0497               setRobotXmax=260;
; 0001 0498             }
; 0001 0499             else
; 0001 049A             {
; 0001 049B               rbctrlPenaltyAngle = -15;
; 0001 049C               rbctrlHomeAngle = -15 ;
; 0001 049D               rbctrlHomeX =-226.1 ;
; 0001 049E               rbctrlHomeY = 1.6  ;
; 0001 049F               setRobotXmin=-260;
; 0001 04A0               setRobotXmax=-80;
_0x202D4:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 04A1             }
; 0001 04A2        break;
	RJMP _0x200F7
; 0001 04A3        case 2:
_0x200F8:
	CPI  R30,LOW(0x2)
	BRNE _0x200FB
; 0001 04A4 
; 0001 04A5 
; 0001 04A6             rbctrlPenaltyX=0;
	CALL SUBOPT_0x62
; 0001 04A7             rbctrlPenaltyY=0;
; 0001 04A8 
; 0001 04A9             if(SAN_ID==1)
; 0001 04AA             {
; 0001 04AB               rbctrlPenaltyAngle = 179;
; 0001 04AC               rbctrlHomeAngle = 179 ;
; 0001 04AD               rbctrlHomeX =66.0 ;
	CALL SUBOPT_0x64
; 0001 04AE               rbctrlHomeY = 79.4  ;
; 0001 04AF               setRobotXmin=-270;
; 0001 04B0               setRobotXmax=270;
; 0001 04B1             }
; 0001 04B2             else
; 0001 04B3             {
; 0001 04B4               rbctrlPenaltyAngle = -15;
; 0001 04B5               rbctrlHomeAngle = -15  ;
; 0001 04B6               rbctrlHomeX =-44.3 ;
; 0001 04B7               rbctrlHomeY = 82.7  ;
_0x202D5:
	STS  _rbctrlHomeY,R30
	STS  _rbctrlHomeY+1,R31
	STS  _rbctrlHomeY+2,R22
	STS  _rbctrlHomeY+3,R23
; 0001 04B8               setRobotXmin=-270;
	CALL SUBOPT_0x65
; 0001 04B9               setRobotXmax=270;
	CALL SUBOPT_0x66
; 0001 04BA             }
; 0001 04BB        break;
	RJMP _0x200F7
; 0001 04BC        case 3:
_0x200FB:
	CPI  R30,LOW(0x3)
	BRNE _0x200FE
; 0001 04BD 
; 0001 04BE 
; 0001 04BF             rbctrlPenaltyX = 0;
	LDI  R30,LOW(0)
	STS  _rbctrlPenaltyX,R30
	STS  _rbctrlPenaltyX+1,R30
	STS  _rbctrlPenaltyX+2,R30
	STS  _rbctrlPenaltyX+3,R30
; 0001 04C0             rbctrlPenaltyY = 0;
	STS  _rbctrlPenaltyY,R30
	STS  _rbctrlPenaltyY+1,R30
	STS  _rbctrlPenaltyY+2,R30
	STS  _rbctrlPenaltyY+3,R30
; 0001 04C1             rbctrlPenaltyAngle = -15;
	__GETD1N 0xC1700000
	CALL SUBOPT_0x67
; 0001 04C2             if(SAN_ID==1)
; 0001 04C3             {
; 0001 04C4               rbctrlPenaltyAngle = 179;
	CALL SUBOPT_0x67
; 0001 04C5               rbctrlHomeAngle = 179 ;
	STS  _rbctrlHomeAngle,R30
	STS  _rbctrlHomeAngle+1,R31
	STS  _rbctrlHomeAngle+2,R22
	STS  _rbctrlHomeAngle+3,R23
; 0001 04C6               rbctrlHomeX =54.1 ;
	CALL SUBOPT_0x68
; 0001 04C7               rbctrlHomeY = -99.9  ;
; 0001 04C8               setRobotXmin=-270;
; 0001 04C9               setRobotXmax=20;
	__GETD1N 0x41A00000
; 0001 04CA             }
; 0001 04CB             else
; 0001 04CC             {
; 0001 04CD               rbctrlPenaltyAngle = -15;
; 0001 04CE               rbctrlHomeAngle = -15  ;
; 0001 04CF               rbctrlHomeX =-53.5 ;
; 0001 04D0               rbctrlHomeY =  -93.8 ;
; 0001 04D1               setRobotXmin=-20;
; 0001 04D2               setRobotXmax=270;
_0x202D6:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 04D3             }
; 0001 04D4        break;
	RJMP _0x200F7
; 0001 04D5        case 4:
_0x200FE:
	CPI  R30,LOW(0x4)
	BRNE _0x20101
; 0001 04D6 
; 0001 04D7             rbctrlPenaltyX=0;
	CALL SUBOPT_0x62
; 0001 04D8             rbctrlPenaltyY=0;
; 0001 04D9 
; 0001 04DA              if(SAN_ID==1)
; 0001 04DB             {
; 0001 04DC               rbctrlPenaltyAngle = 179;
; 0001 04DD               rbctrlHomeAngle = 179 ;
; 0001 04DE               rbctrlHomeX = 269.7 ;
	CALL SUBOPT_0x63
; 0001 04DF               rbctrlHomeY = 1.7  ;
; 0001 04E0               setRobotXmin=80;
; 0001 04E1               setRobotXmax=260;
; 0001 04E2             }
; 0001 04E3             else
; 0001 04E4             {
; 0001 04E5               rbctrlPenaltyAngle = -15;
; 0001 04E6               rbctrlHomeAngle = -15  ;
; 0001 04E7               rbctrlHomeX =-226.1 ;
; 0001 04E8               rbctrlHomeY = 1.6  ;
; 0001 04E9               setRobotXmin=-260;
; 0001 04EA               setRobotXmax=-80;
_0x202D7:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 04EB             }
; 0001 04EC        break;
	RJMP _0x200F7
; 0001 04ED        case 5:
_0x20101:
	CPI  R30,LOW(0x5)
	BRNE _0x20104
; 0001 04EE 
; 0001 04EF             rbctrlPenaltyX = 0;
	CALL SUBOPT_0x62
; 0001 04F0             rbctrlPenaltyY = 0;
; 0001 04F1              if(SAN_ID==1)
; 0001 04F2             {
; 0001 04F3                 rbctrlPenaltyAngle = 179;
; 0001 04F4                rbctrlHomeAngle = 179 ;
; 0001 04F5                rbctrlHomeX =66.0 ;
	CALL SUBOPT_0x64
; 0001 04F6               rbctrlHomeY = 79.4  ;
; 0001 04F7               setRobotXmin=-270;
; 0001 04F8               setRobotXmax=270;
; 0001 04F9             }
; 0001 04FA             else
; 0001 04FB             {
; 0001 04FC               rbctrlPenaltyAngle = -15;
; 0001 04FD               rbctrlHomeAngle = -15  ;
; 0001 04FE               rbctrlHomeX =-44.3 ;
; 0001 04FF               rbctrlHomeY = 82.7  ;
_0x202D8:
	STS  _rbctrlHomeY,R30
	STS  _rbctrlHomeY+1,R31
	STS  _rbctrlHomeY+2,R22
	STS  _rbctrlHomeY+3,R23
; 0001 0500               setRobotXmin=-270;
	CALL SUBOPT_0x65
; 0001 0501               setRobotXmax=270;
	CALL SUBOPT_0x66
; 0001 0502             }
; 0001 0503        break;
	RJMP _0x200F7
; 0001 0504        case 6:
_0x20104:
	CPI  R30,LOW(0x6)
	BRNE _0x200F7
; 0001 0505 
; 0001 0506 
; 0001 0507             rbctrlPenaltyX = 0;
	CALL SUBOPT_0x62
; 0001 0508             rbctrlPenaltyY = 0;
; 0001 0509             if(SAN_ID==1)
; 0001 050A             {
; 0001 050B                rbctrlPenaltyAngle = 179;
; 0001 050C               rbctrlHomeAngle = 179 ;
; 0001 050D               rbctrlHomeX =54.1 ;
	CALL SUBOPT_0x68
; 0001 050E               rbctrlHomeY = -99.9  ;
; 0001 050F               setRobotXmin=-270;
; 0001 0510               setRobotXmax=20;
	__GETD1N 0x41A00000
; 0001 0511             }
; 0001 0512             else
; 0001 0513             {
; 0001 0514               rbctrlPenaltyAngle = -15;
; 0001 0515               rbctrlHomeAngle = -15  ;
; 0001 0516               rbctrlHomeX =-53.5 ;
; 0001 0517               rbctrlHomeY =  -93.8 ;
; 0001 0518               setRobotXmin=-20;
; 0001 0519               setRobotXmax=270;
_0x202D9:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 051A             }
; 0001 051B        break;
; 0001 051C 
; 0001 051D 
; 0001 051E     }
_0x200F7:
; 0001 051F }
	RET
;//=======================================================
;// Tinh luc theo goc quay de dieu khien robot
;int calcVangle(int angle)
; 0001 0523 {
_calcVangle:
; 0001 0524     int verrangle=0;
; 0001 0525     //tinh thanh phan I
; 0001 0526     verranglekisum = verranglekisum + angle/20;
	ST   -Y,R17
	ST   -Y,R16
;	angle -> Y+2
;	verrangle -> R16,R17
	__GETWRN 16,17,0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21
	CALL SUBOPT_0x69
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x6A
; 0001 0527     if(verranglekisum>15)verranglekisum = 15;
	CALL SUBOPT_0x69
	SBIW R26,16
	BRLT _0x2010A
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x6A
; 0001 0528     if(verranglekisum<-15)verranglekisum = -15;
_0x2010A:
	CALL SUBOPT_0x69
	CPI  R26,LOW(0xFFF1)
	LDI  R30,HIGH(0xFFF1)
	CPC  R27,R30
	BRGE _0x2010B
	LDI  R30,LOW(65521)
	LDI  R31,HIGH(65521)
	CALL SUBOPT_0x6A
; 0001 0529     //tinh thanh phan dieu khien
; 0001 052A     verrangle = 10 + angle/12 + verranglekisum ;
_0x2010B:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL __DIVW21
	ADIW R30,10
	CALL SUBOPT_0x69
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
; 0001 052B     //gioi han bao hoa
; 0001 052C     if(verrangle<0) verrangle=-verrangle;//lay tri tuyet doi cua van toc v dieu khien
	TST  R17
	BRPL _0x2010C
	MOVW R30,R16
	CALL __ANEGW1
	MOVW R16,R30
; 0001 052D     if(verrangle>20) verrangle = 20;
_0x2010C:
	__CPWRN 16,17,21
	BRLT _0x2010D
	__GETWRN 16,17,20
; 0001 052E     if(verrangle<8) verrangle = 8;
_0x2010D:
	__CPWRN 16,17,8
	BRGE _0x2010E
	__GETWRN 16,17,8
; 0001 052F     return  verrangle;
_0x2010E:
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0007
; 0001 0530 }
;//ctrl robot
;void ctrrobot()
; 0001 0533 {
_ctrrobot:
; 0001 0534     if(readposition()==1)//co du lieu moi
	RCALL _readposition
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x2010F
; 0001 0535     {
; 0001 0536 //          hc(3,40);wn16s(cmdCtrlRobot);
; 0001 0537 //        hc(4,40);wn16s(idRobot);
; 0001 0538          //-------------------------------------------------
; 0001 0539         if(cmdCtrlRobot==8)      // dung ma lenh stop chuong trinh
	CALL SUBOPT_0x5D
	BRNE _0x20110
; 0001 053A         {
; 0001 053B             flagsethome=0; //cho phep sethome
	CALL SUBOPT_0x4B
; 0001 053C             while(cmdCtrlRobot==8)
_0x20111:
	CALL SUBOPT_0x5D
	BRNE _0x20113
; 0001 053D             {
; 0001 053E               codePenalty();
	RCALL _codePenalty
; 0001 053F             }
	RJMP _0x20111
_0x20113:
; 0001 0540         }
; 0001 0541 
; 0001 0542         if(cmdCtrlRobot==1)      // dung ma lenh stop chuong trinh
_0x20110:
	CALL SUBOPT_0x4A
	BRNE _0x20114
; 0001 0543         {
; 0001 0544             flagsethome=0; //cho phep sethome
	CALL SUBOPT_0x4B
; 0001 0545             while(cmdCtrlRobot==1)
_0x20115:
	CALL SUBOPT_0x4A
	BRNE _0x20117
; 0001 0546             {
; 0001 0547               readposition();
	RCALL _readposition
; 0001 0548             }
	RJMP _0x20115
_0x20117:
; 0001 0549         }
; 0001 054A 
; 0001 054B         if(cmdCtrlRobot==5)  //sethome robot
_0x20114:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x20118
; 0001 054C         {
; 0001 054D 
; 0001 054E            cntsethomeRB++;
	LDI  R26,LOW(_cntsethomeRB)
	LDI  R27,HIGH(_cntsethomeRB)
	CALL SUBOPT_0x6B
; 0001 054F            if(cntsethomeRB > 2)
	LDS  R26,_cntsethomeRB
	LDS  R27,_cntsethomeRB+1
	SBIW R26,3
	BRLO _0x20119
; 0001 0550            {
; 0001 0551              LEDBR=1;
	SBI  0x1B,7
; 0001 0552              if (flagsethome == 0)sethomeRB();
	LDS  R30,_flagsethome
	LDS  R31,_flagsethome+1
	SBIW R30,0
	BRNE _0x2011C
	RCALL _sethomeRB
; 0001 0553              cntsethomeRB=0;
_0x2011C:
	LDI  R30,LOW(0)
	STS  _cntsethomeRB,R30
	STS  _cntsethomeRB+1,R30
; 0001 0554            }
; 0001 0555 
; 0001 0556         }
_0x20119:
; 0001 0557 
; 0001 0558         if(cmdCtrlRobot==4)  //sethome robot
_0x20118:
	CALL SUBOPT_0x37
	BRNE _0x2011D
; 0001 0559         {
; 0001 055A            flagsethome=0; //cho phep sethome
	CALL SUBOPT_0x4B
; 0001 055B            cntstuckRB++;
	CALL SUBOPT_0x5B
; 0001 055C            if(cntstuckRB > 2)
	BRLO _0x2011E
; 0001 055D            {
; 0001 055E              runEscStuck();
	RCALL _runEscStuck
; 0001 055F              cntstuckRB=0;
	LDI  R30,LOW(0)
	STS  _cntstuckRB,R30
	STS  _cntstuckRB+1,R30
; 0001 0560            }
; 0001 0561         }
_0x2011E:
; 0001 0562 
; 0001 0563         if(cmdCtrlRobot==3)  //roi vao diem mu (blind spot) , mat vi tri hay huong
_0x2011D:
	CALL SUBOPT_0x45
	BRNE _0x2011F
; 0001 0564         {
; 0001 0565            flagsethome=0; //cho phep sethome
	CALL SUBOPT_0x4B
; 0001 0566            cntunlookRB++;
	CALL SUBOPT_0x5C
; 0001 0567            if(cntunlookRB > 2)
	BRLO _0x20120
; 0001 0568            {
; 0001 0569              runEscBlindSpot();
	RCALL _runEscBlindSpot
; 0001 056A              cntunlookRB=0;
	LDI  R30,LOW(0)
	STS  _cntunlookRB,R30
	STS  _cntunlookRB+1,R30
; 0001 056B            }
; 0001 056C 
; 0001 056D         }
_0x20120:
; 0001 056E 
; 0001 056F 
; 0001 0570         //------------------------------------------------
; 0001 0571         if(cmdCtrlRobot==2) {// run chuong trinh
_0x2011F:
	CALL SUBOPT_0x4C
	BREQ PC+3
	JMP _0x20121
; 0001 0572             flagsethome=0; //cho phep sethome
	CALL SUBOPT_0x4B
; 0001 0573             switch(flagtask)
	LDS  R30,_flagtask
	LDS  R31,_flagtask+1
; 0001 0574             {
; 0001 0575               // chay den vi tri duoc set boi nguoi dieu khien
; 0001 0576               case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x20125
; 0001 0577                      if(setRobotX < setRobotXmin)   setRobotX =  setRobotXmin;
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
	BRSH _0x20126
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6E
; 0001 0578                      if(setRobotX >setRobotXmax)    setRobotX =  setRobotXmax;
_0x20126:
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x6D
	BREQ PC+2
	BRCC PC+3
	JMP  _0x20127
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x6E
; 0001 0579                      calcvitri(setRobotX,setRobotY);
_0x20127:
	LDS  R30,_setRobotX
	LDS  R31,_setRobotX+1
	LDS  R22,_setRobotX+2
	LDS  R23,_setRobotX+3
	CALL __PUTPARD1
	LDS  R30,_setRobotY
	LDS  R31,_setRobotY+1
	LDS  R22,_setRobotY+2
	LDS  R23,_setRobotY+3
	CALL SUBOPT_0x4D
; 0001 057A                      if(distance>80) //chay den vi tri
	CALL SUBOPT_0x4E
	__GETD1N 0x42A00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x20128
; 0001 057B                      {
; 0001 057C                          if(errangle>18 || errangle<-18 )
	CALL SUBOPT_0x5E
	BREQ PC+4
	BRCS PC+3
	JMP  _0x2012A
	CALL SUBOPT_0x52
	BRSH _0x20129
_0x2012A:
; 0001 057D                          {
; 0001 057E                            int nv = errangle*27/180 ;
; 0001 057F                            int verrangle = calcVangle(errangle);
; 0001 0580                            ctrRobotXoay(nv,verrangle);
	CALL SUBOPT_0x53
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0581                            delay_ms(1);
; 0001 0582                          }else
	RJMP _0x2012C
_0x20129:
; 0001 0583                          {
; 0001 0584                            //1xung = 3.14 * 40/24 =5.22
; 0001 0585                            ctrRobottoi(distance/5.22,15);
	CALL SUBOPT_0x54
; 0001 0586                           // verranglekisum=0;//RESET I.
; 0001 0587                          }
_0x2012C:
; 0001 0588                      }
; 0001 0589                      else
	RJMP _0x2012D
_0x20128:
; 0001 058A                      {
; 0001 058B                          flagtask=10;
	CALL SUBOPT_0x70
; 0001 058C                      }
_0x2012D:
; 0001 058D                      break;
	RJMP _0x20124
; 0001 058E               // quay dung huong duoc set boi nguoi dieu khien
; 0001 058F               case 1:
_0x20125:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2012E
; 0001 0590 
; 0001 0591                     calcvitri(robotctrl.x + setRobotAngleX,robotctrl.y + setRobotAngleY);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x58
	CALL SUBOPT_0x59
; 0001 0592                     if(errangle>18 || errangle<-18 )
	CALL SUBOPT_0x5E
	BREQ PC+4
	BRCS PC+3
	JMP  _0x20130
	CALL SUBOPT_0x52
	BRSH _0x2012F
_0x20130:
; 0001 0593                      {
; 0001 0594 
; 0001 0595                        int nv = errangle*27/180 ;
; 0001 0596                        int verrangle = calcVangle(errangle);
; 0001 0597                        ctrRobotXoay(nv,verrangle);
	CALL SUBOPT_0x53
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0598                       // ctrRobotXoay(nv,10);
; 0001 0599                        delay_ms(1);
; 0001 059A                      }else
	RJMP _0x20132
_0x2012F:
; 0001 059B                      {
; 0001 059C                        flaghuongtrue++;
	LDI  R26,LOW(_flaghuongtrue)
	LDI  R27,HIGH(_flaghuongtrue)
	CALL SUBOPT_0x6B
; 0001 059D                        if(flaghuongtrue>3)
	LDS  R26,_flaghuongtrue
	LDS  R27,_flaghuongtrue+1
	SBIW R26,4
	BRLO _0x20133
; 0001 059E                        {
; 0001 059F                         //verranglekisum=0;//RESET I.
; 0001 05A0                          flaghuongtrue=0;
	LDI  R30,LOW(0)
	STS  _flaghuongtrue,R30
	STS  _flaghuongtrue+1,R30
; 0001 05A1                          flagtask=10;
	CALL SUBOPT_0x70
; 0001 05A2                        }
; 0001 05A3 
; 0001 05A4                      }
_0x20133:
_0x20132:
; 0001 05A5                     break;
	RJMP _0x20124
; 0001 05A6               // chay den vi tri bong
; 0001 05A7               case 2:
_0x2012E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x20134
; 0001 05A8 
; 0001 05A9                     //PHUC test    rb1 ,s1
; 0001 05AA                     if(robotctrl.ball.x < setRobotXmin)   robotctrl.ball.x =  setRobotXmin;
	__GETW2MN _robotctrl,10
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x71
	BRSH _0x20135
	__POINTW2MN _robotctrl,10
	CALL SUBOPT_0x6C
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0001 05AB                     if(robotctrl.ball.x >setRobotXmax)    robotctrl.ball.x =  setRobotXmax;
_0x20135:
	__GETW2MN _robotctrl,10
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x71
	BREQ PC+2
	BRCC PC+3
	JMP  _0x20136
	__POINTW2MN _robotctrl,10
	CALL SUBOPT_0x6F
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0001 05AC                     calcvitri(robotctrl.ball.x,robotctrl.ball.y);
_0x20136:
	CALL SUBOPT_0x72
; 0001 05AD 
; 0001 05AE                      if(errangle>18 || errangle<-18 )
	CALL SUBOPT_0x5E
	BREQ PC+4
	BRCS PC+3
	JMP  _0x20138
	CALL SUBOPT_0x52
	BRSH _0x20137
_0x20138:
; 0001 05AF                      {
; 0001 05B0                        int nv = errangle*27/180 ;
; 0001 05B1                        int verrangle = calcVangle(errangle);
; 0001 05B2                        ctrRobotXoay(nv,verrangle);
	CALL SUBOPT_0x53
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 05B3                        delay_ms(1);
; 0001 05B4                      }else
	RJMP _0x2013A
_0x20137:
; 0001 05B5                      {
; 0001 05B6                          //1xung = 3.14 * 40/24 =5.22
; 0001 05B7                          if(distance>10) //chay den vi tri
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x60
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2013B
; 0001 05B8                          {
; 0001 05B9                            ctrRobottoi(distance/5.22,15);
	CALL SUBOPT_0x54
; 0001 05BA                            delay_ms(5);
	CALL SUBOPT_0x73
	CALL _delay_ms
; 0001 05BB                          }else
	RJMP _0x2013C
_0x2013B:
; 0001 05BC                          {
; 0001 05BD                            flagtask=10;
	CALL SUBOPT_0x70
; 0001 05BE                          }
_0x2013C:
; 0001 05BF                         // verranglekisum=0;//RESET I.
; 0001 05C0                      }
_0x2013A:
; 0001 05C1 
; 0001 05C2                     break;
	RJMP _0x20124
; 0001 05C3               // da bong
; 0001 05C4               case 3:
_0x20134:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2013D
; 0001 05C5                     ctrRobottoi(40,22);
	CALL SUBOPT_0x74
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ctrRobottoi
; 0001 05C6                     delay_ms(400);
	CALL SUBOPT_0x75
; 0001 05C7                     ctrRobotlui(40,15);
	CALL SUBOPT_0x74
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ctrRobotlui
; 0001 05C8                     delay_ms(400);
	CALL SUBOPT_0x75
; 0001 05C9                     flagtask = 10;
	RJMP _0x202DA
; 0001 05CA                     break;
; 0001 05CB               case 10:
_0x2013D:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x2013E
; 0001 05CC                     vMRtoi(0);
	CALL SUBOPT_0x76
; 0001 05CD                     vMLtoi(0);
	CALL SUBOPT_0x77
; 0001 05CE                     break;
	RJMP _0x20124
; 0001 05CF               //chay theo bong co dinh huong
; 0001 05D0               case 4:
_0x2013E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20124
; 0001 05D1                     calcvitri(robotctrl.ball.x,robotctrl.ball.y);
	CALL SUBOPT_0x72
; 0001 05D2                     if(errangle>18 || errangle<-18 )
	CALL SUBOPT_0x5E
	BREQ PC+4
	BRCS PC+3
	JMP  _0x20141
	CALL SUBOPT_0x52
	BRSH _0x20140
_0x20141:
; 0001 05D3                      {
; 0001 05D4 
; 0001 05D5                        int nv = errangle*27/180 ;
; 0001 05D6                        int verrangle = calcVangle(errangle);
; 0001 05D7                        ctrRobotXoay(nv,verrangle);
	CALL SUBOPT_0x53
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 05D8                       // ctrRobotXoay(nv,10);
; 0001 05D9                        delay_ms(1);
; 0001 05DA                      }else
	RJMP _0x20143
_0x20140:
; 0001 05DB                      {
; 0001 05DC                        flaghuongtrue++;
	LDI  R26,LOW(_flaghuongtrue)
	LDI  R27,HIGH(_flaghuongtrue)
	CALL SUBOPT_0x6B
; 0001 05DD                        if(flaghuongtrue>3)
	LDS  R26,_flaghuongtrue
	LDS  R27,_flaghuongtrue+1
	SBIW R26,4
	BRLO _0x20144
; 0001 05DE                        {
; 0001 05DF                         //verranglekisum=0;//RESET I.
; 0001 05E0                          flaghuongtrue=0;
	LDI  R30,LOW(0)
	STS  _flaghuongtrue,R30
	STS  _flaghuongtrue+1,R30
; 0001 05E1                          flagtask=10;
_0x202DA:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x78
; 0001 05E2                        }
; 0001 05E3 
; 0001 05E4                      }
_0x20144:
_0x20143:
; 0001 05E5                     break;
; 0001 05E6            }
_0x20124:
; 0001 05E7        }//end if(cmdCtrlRobot==2)
; 0001 05E8     }else   //khong co tin hieu RF hay khong thay robot
_0x20121:
_0x2010F:
; 0001 05E9     {
; 0001 05EA          //if(flagunlookRB==1) runEscBlindSpot();
; 0001 05EB 
; 0001 05EC     }
; 0001 05ED 
; 0001 05EE 
; 0001 05EF }
	RET
;
;void rb_move(float x,float y)
; 0001 05F2 {
; 0001 05F3    flagtask = 0;
;	x -> Y+4
;	y -> Y+0
; 0001 05F4    flagtaskold=flagtask;
; 0001 05F5    setRobotX=x;
; 0001 05F6    setRobotY=y;
; 0001 05F7 }
;void rb_rotate(int angle)     // goc xoay so voi truc x cua toa do
; 0001 05F9 {
; 0001 05FA    flagtask = 1;
;	angle -> Y+0
; 0001 05FB    flagtaskold=flagtask;
; 0001 05FC    setRobotAngleX=10*cos(angle*M_PI/180);
; 0001 05FD    setRobotAngleY=10*sin(angle*M_PI/180);;
; 0001 05FE }
;
;void rb_goball()
; 0001 0601 {
_rb_goball:
; 0001 0602    flagtask = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x78
; 0001 0603    flagtaskold=flagtask;
	LDS  R30,_flagtask
	LDS  R31,_flagtask+1
	STS  _flagtaskold,R30
	STS  _flagtaskold+1,R31
; 0001 0604 }
	RET
;void rb_kick()
; 0001 0606 {
; 0001 0607    flagtask = 3;
; 0001 0608    flagtaskold=flagtask;
; 0001 0609 }
;int rb_wait(unsigned long int time )
; 0001 060B {
_rb_wait:
; 0001 060C    time=time*10;
;	time -> Y+0
	CALL SUBOPT_0x79
	__GETD2N 0xA
	CALL __MULD12U
	CALL SUBOPT_0x30
; 0001 060D    while(time--)
_0x20146:
	CALL SUBOPT_0x79
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL SUBOPT_0x30
	__SUBD1N -1
	BREQ _0x20148
; 0001 060E    {
; 0001 060F      ctrrobot();
	RCALL _ctrrobot
; 0001 0610      if(flagtask==10) return 1 ;// thuc hien xong nhiem vu
	LDS  R26,_flagtask
	LDS  R27,_flagtask+1
	SBIW R26,10
	BRNE _0x20149
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20C0007
; 0001 0611    }
_0x20149:
	RJMP _0x20146
_0x20148:
; 0001 0612     return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x20C0007:
	ADIW R28,4
	RET
; 0001 0613 }
;//========================================================
;// Timer1 overflow interrupt service routine
;// period =1/2khz= 0.5ms
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0001 0618 {
_timer1_ovf_isr:
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
; 0001 0619 // Place your code here
; 0001 061A    timerstick++;
	LDI  R26,LOW(_timerstick)
	LDI  R27,HIGH(_timerstick)
	CALL SUBOPT_0x6B
; 0001 061B    timerstickdis++;
	LDI  R26,LOW(_timerstickdis)
	LDI  R27,HIGH(_timerstickdis)
	CALL SUBOPT_0x6B
; 0001 061C    timerstickang++;
	LDI  R26,LOW(_timerstickang)
	LDI  R27,HIGH(_timerstickang)
	CALL SUBOPT_0x6B
; 0001 061D    timerstickctr++;
	LDI  R26,LOW(_timerstickctr)
	LDI  R27,HIGH(_timerstickctr)
	CALL SUBOPT_0x6B
; 0001 061E  #ifdef CtrVelocity
; 0001 061F  // dieu khien van toc
; 0001 0620    if(timerstick>250)    // 125ms/0.5ms=250 : dung chu ki lay mau = 125 ms
	LDS  R26,_timerstick
	LDS  R27,_timerstick+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x2014A
; 0001 0621    {
; 0001 0622      int eR=0,eL=0;
; 0001 0623 
; 0001 0624      //-------------------------------------------
; 0001 0625      //cap nhat van toc
; 0001 0626      vQER = (QER-oldQER);     //(xung / 10ms)
	CALL SUBOPT_0x15
;	eR -> Y+2
;	eL -> Y+0
	LDS  R26,_oldQER
	LDS  R27,_oldQER+1
	CALL SUBOPT_0x7A
	SUB  R30,R26
	SBC  R31,R27
	STS  _vQER,R30
	STS  _vQER+1,R31
; 0001 0627      vQEL = (QEL-oldQEL);     //(xung /10ms)
	LDS  R26,_oldQEL
	LDS  R27,_oldQEL+1
	CALL SUBOPT_0x18
	SUB  R30,R26
	SBC  R31,R27
	STS  _vQEL,R30
	STS  _vQEL+1,R31
; 0001 0628      oldQEL=QEL;
	CALL SUBOPT_0x18
	STS  _oldQEL,R30
	STS  _oldQEL+1,R31
; 0001 0629      oldQER=QER;
	CALL SUBOPT_0x7A
	STS  _oldQER,R30
	STS  _oldQER+1,R31
; 0001 062A      timerstick=0;
	LDI  R30,LOW(0)
	STS  _timerstick,R30
	STS  _timerstick+1,R30
; 0001 062B 
; 0001 062C      //--------------------------------------------
; 0001 062D      //tinh PID van toc
; 0001 062E      //--------------------------------------------
; 0001 062F      eR=svQER-vQER;
	LDS  R26,_vQER
	LDS  R27,_vQER+1
	LDS  R30,_svQER
	LDS  R31,_svQER+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 0630      //tinh thanh phan I
; 0001 0631      seRki=seRki+KiR*eR;
	LDS  R26,_KiR
	LDS  R27,_KiR+1
	CALL __MULW12
	CALL SUBOPT_0x7B
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x7C
; 0001 0632      if(seRki>100) seRki=100;
	CALL SUBOPT_0x7B
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x2014B
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x7C
; 0001 0633      if(seRki<-100) seRki = -100;
_0x2014B:
	CALL SUBOPT_0x7B
	CPI  R26,LOW(0xFF9C)
	LDI  R30,HIGH(0xFF9C)
	CPC  R27,R30
	BRGE _0x2014C
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	CALL SUBOPT_0x7C
; 0001 0634      //tinh them thanh phan P
; 0001 0635      uR = 100 + KpR*eR + seRki;
_0x2014C:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDS  R26,_KpR
	LDS  R27,_KpR+1
	CALL __MULW12
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x7B
	ADD  R30,R26
	ADC  R31,R27
	STS  _uR,R30
	STS  _uR+1,R31
; 0001 0636      if(uR>255) uR =255;
	LDS  R26,_uR
	LDS  R27,_uR+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x2014D
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _uR,R30
	STS  _uR+1,R31
; 0001 0637      if(uR<0) uR =0;
_0x2014D:
	LDS  R26,_uR+1
	TST  R26
	BRPL _0x2014E
	LDI  R30,LOW(0)
	STS  _uR,R30
	STS  _uR+1,R30
; 0001 0638 
; 0001 0639      eL=svQEL-vQEL;
_0x2014E:
	LDS  R26,_vQEL
	LDS  R27,_vQEL+1
	LDS  R30,_svQEL
	LDS  R31,_svQEL+1
	CALL SUBOPT_0xC
; 0001 063A      //tinh thanh phan I
; 0001 063B      seLki=seLki+KiL*eL;
	LD   R30,Y
	LDD  R31,Y+1
	LDS  R26,_KiL
	LDS  R27,_KiL+1
	CALL __MULW12
	CALL SUBOPT_0x7D
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x7E
; 0001 063C      if(seLki>100) seLki=100;
	CALL SUBOPT_0x7D
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x2014F
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x7E
; 0001 063D      if(seLki<-100) seLki = -100;
_0x2014F:
	CALL SUBOPT_0x7D
	CPI  R26,LOW(0xFF9C)
	LDI  R30,HIGH(0xFF9C)
	CPC  R27,R30
	BRGE _0x20150
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	CALL SUBOPT_0x7E
; 0001 063E      //tinh them thanh phan P
; 0001 063F      uL = 100 + KpL*eL + seLki;
_0x20150:
	LD   R30,Y
	LDD  R31,Y+1
	LDS  R26,_KpL
	LDS  R27,_KpL+1
	CALL __MULW12
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x7D
	ADD  R30,R26
	ADC  R31,R27
	STS  _uL,R30
	STS  _uL+1,R31
; 0001 0640      if(uL>255) uL =255;
	LDS  R26,_uL
	LDS  R27,_uL+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x20151
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _uL,R30
	STS  _uL+1,R31
; 0001 0641      if(uL<0) uL =0;
_0x20151:
	LDS  R26,_uL+1
	TST  R26
	BRPL _0x20152
	LDI  R30,LOW(0)
	STS  _uL,R30
	STS  _uL+1,R30
; 0001 0642 
; 0001 0643      if(svQER!=0)OCR1B= uR;
_0x20152:
	LDS  R30,_svQER
	LDS  R31,_svQER+1
	SBIW R30,0
	BREQ _0x20153
	LDS  R30,_uR
	LDS  R31,_uR+1
	RJMP _0x202DB
; 0001 0644      else  OCR1B = 0;
_0x20153:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x202DB:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0001 0645 
; 0001 0646      if(svQEL!=0) OCR1A= uL;
	LDS  R30,_svQEL
	LDS  R31,_svQEL+1
	SBIW R30,0
	BREQ _0x20155
	LDS  R30,_uL
	LDS  R31,_uL+1
	RJMP _0x202DC
; 0001 0647      else  OCR1A = 0;
_0x20155:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x202DC:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0001 0648 
; 0001 0649    }
	ADIW R28,4
; 0001 064A // dieu khien khoang cach
; 0001 064B   if(timerstickdis>10 && (flagwaitctrRobot==1))
_0x2014A:
	LDS  R26,_timerstickdis
	LDS  R27,_timerstickdis+1
	SBIW R26,11
	BRLO _0x20158
	LDS  R26,_flagwaitctrRobot
	CPI  R26,LOW(0x1)
	BREQ _0x20159
_0x20158:
	RJMP _0x20157
_0x20159:
; 0001 064C   {
; 0001 064D     unsigned int deltad1=0;
; 0001 064E     deltad1 =(QER + QEL)/2 - oldd;
	SBIW R28,2
	CALL SUBOPT_0x7F
;	deltad1 -> Y+0
	CALL SUBOPT_0x80
	LDS  R26,_oldd
	LDS  R27,_oldd+1
	CALL SUBOPT_0xC
; 0001 064F     //if(deltad1<0) deltad1=0;// co the am do kieu so
; 0001 0650     //hc(3,0);ws("            ");
; 0001 0651     //hc(3,0);wn16s(deltad1);
; 0001 0652     if(deltad1>sd)
	LDS  R30,_sd
	LDS  R31,_sd+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x2015A
; 0001 0653     {
; 0001 0654 
; 0001 0655         vMLstop();
	CALL _vMLstop
; 0001 0656         vMRstop();
	CALL _vMRstop
; 0001 0657         flagwaitctrRobot=0;
	LDI  R30,LOW(0)
	STS  _flagwaitctrRobot,R30
; 0001 0658         oldd=(QER+QEL)/2;
	CALL SUBOPT_0x80
	STS  _oldd,R30
	STS  _oldd+1,R31
; 0001 0659 
; 0001 065A     }
; 0001 065B     timerstickdis=0;
_0x2015A:
	LDI  R30,LOW(0)
	STS  _timerstickdis,R30
	STS  _timerstickdis+1,R30
; 0001 065C 
; 0001 065D   }
	ADIW R28,2
; 0001 065E   // dieu khien  vi tri goc quay
; 0001 065F   if(timerstickang>10 && (flagwaitctrAngle==1))
_0x20157:
	LDS  R26,_timerstickang
	LDS  R27,_timerstickang+1
	SBIW R26,11
	BRLO _0x2015C
	LDS  R26,_flagwaitctrAngle
	CPI  R26,LOW(0x1)
	BREQ _0x2015D
_0x2015C:
	RJMP _0x2015B
_0x2015D:
; 0001 0660   {
; 0001 0661     unsigned int deltaa=0;
; 0001 0662     deltaa =(QEL) - olda;
	SBIW R28,2
	CALL SUBOPT_0x7F
;	deltaa -> Y+0
	LDS  R26,_olda
	LDS  R27,_olda+1
	CALL SUBOPT_0x18
	CALL SUBOPT_0xC
; 0001 0663 //    hc(4,0);ws("            ");
; 0001 0664 //    hc(4,0);wn16s(deltaa);
; 0001 0665     if(deltaa>sa)
	LDS  R30,_sa
	LDS  R31,_sa+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x2015E
; 0001 0666     {
; 0001 0667         vMLstop();
	CALL _vMLstop
; 0001 0668         vMRstop();
	CALL _vMRstop
; 0001 0669         flagwaitctrAngle=0;
	LDI  R30,LOW(0)
	STS  _flagwaitctrAngle,R30
; 0001 066A         olda=QEL;
	CALL SUBOPT_0x18
	STS  _olda,R30
	STS  _olda+1,R31
; 0001 066B     }
; 0001 066C     timerstickang=0;
_0x2015E:
	LDI  R30,LOW(0)
	STS  _timerstickang,R30
	STS  _timerstickang+1,R30
; 0001 066D   }
	ADIW R28,2
; 0001 066E   // dieu khien robot robot
; 0001 066F   if(timerstickctr>1)
_0x2015B:
	LDS  R26,_timerstickctr
	LDS  R27,_timerstickctr+1
	SBIW R26,2
	BRLO _0x2015F
; 0001 0670   {
; 0001 0671     timerstickctr=0;
	LDI  R30,LOW(0)
	STS  _timerstickctr,R30
	STS  _timerstickctr+1,R30
; 0001 0672   }
; 0001 0673 #endif
; 0001 0674 }
_0x2015F:
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
;
;//========================================================
;// read  vi tri robot   PHUC
;//========================================================
;unsigned char testposition()
; 0001 067A {
_testposition:
; 0001 067B         unsigned char  i=0;
; 0001 067C         unsigned flagstatus=0;
; 0001 067D 
; 0001 067E    while(keyKT!=0)
	CALL __SAVELOCR4
;	i -> R17
;	flagstatus -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
_0x20160:
	SBIS 0x13,0
	RJMP _0x20162
; 0001 067F    {
; 0001 0680         readposition();
	RCALL _readposition
; 0001 0681 
; 0001 0682          if(idRobot==ROBOT_ID)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R12
	CPC  R31,R13
	BREQ PC+3
	JMP _0x20163
; 0001 0683          {
; 0001 0684              hc(5,40);wn16s(robotctrl.ball.y);
	CALL SUBOPT_0x73
	CALL SUBOPT_0x74
	CALL _hc
	CALL SUBOPT_0x81
	CALL SUBOPT_0x82
; 0001 0685              hc(4,40);wn16s(robotctrl.ball.x);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x74
	CALL _hc
	CALL SUBOPT_0x84
	CALL SUBOPT_0x82
; 0001 0686              hc(3,20);wn16s(robotctrl.x);
	CALL SUBOPT_0x85
	CALL SUBOPT_0x48
	CALL _hc
	__GETW1MN _robotctrl,2
	CALL SUBOPT_0x82
; 0001 0687              hc(2,20);wn16s(robotctrl.y);
	CALL SUBOPT_0x86
	CALL SUBOPT_0x48
	CALL _hc
	__GETW1MN _robotctrl,4
	CALL SUBOPT_0x82
; 0001 0688              hc(1,1);wn16s(robotctrl.ox);
	CALL SUBOPT_0x87
	CALL SUBOPT_0x87
	CALL _hc
	__GETW1MN _robotctrl,6
	CALL SUBOPT_0x82
; 0001 0689              hc(0,1);wn16s(robotctrl.oy);
	CALL SUBOPT_0x88
	CALL SUBOPT_0x87
	CALL _hc
	__GETW1MN _robotctrl,8
	CALL SUBOPT_0x82
; 0001 068A              delay_ms(200);
	CALL SUBOPT_0x89
; 0001 068B          }
; 0001 068C 
; 0001 068D      }
_0x20163:
	RJMP _0x20160
_0x20162:
; 0001 068E     return flagstatus;
	MOV  R30,R18
	RJMP _0x20C0006
; 0001 068F }
;//========================================================
;void robotwall()
; 0001 0692 {
_robotwall:
; 0001 0693 unsigned int demled;
; 0001 0694         DDRA    = 0x00;
	ST   -Y,R17
	ST   -Y,R16
;	demled -> R16,R17
	CALL SUBOPT_0x38
; 0001 0695         PORTA   = 0x00;
; 0001 0696 
; 0001 0697         LcdClear();
	CALL SUBOPT_0x8A
; 0001 0698         hc(0,10);
	CALL SUBOPT_0x49
	CALL _hc
; 0001 0699         ws ("ROBOT WALL");
	__POINTW1MN _0x20164,0
	CALL SUBOPT_0xE
; 0001 069A         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 069B 
; 0001 069C    while(keyKT!=0)
_0x20169:
	SBIS 0x13,0
	RJMP _0x2016B
; 0001 069D    {
; 0001 069E         IRFL=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _read_adc
	STS  _IRFL,R30
	STS  _IRFL+1,R31
; 0001 069F         IRFR=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _read_adc
	STS  _IRFR,R30
	STS  _IRFR+1,R31
; 0001 06A0         hc(1,0) ; wn16(IRFL);
	CALL SUBOPT_0x8B
	LDS  R30,_IRFL
	LDS  R31,_IRFL+1
	CALL SUBOPT_0xD
; 0001 06A1         hc(1,42); wn16(IRFR);
	CALL SUBOPT_0x87
	CALL SUBOPT_0x8C
	LDS  R30,_IRFR
	LDS  R31,_IRFR+1
	CALL SUBOPT_0xD
; 0001 06A2 
; 0001 06A3         if (IRFL>250)
	CALL SUBOPT_0x3C
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLO _0x2016C
; 0001 06A4         {
; 0001 06A5             vMLlui(22);vMRlui(10);delay_ms(600);
	LDI  R30,LOW(22)
	ST   -Y,R30
	CALL _vMLlui
	LDI  R30,LOW(10)
	CALL SUBOPT_0x8D
; 0001 06A6         }
; 0001 06A7         if (IRFR>250)
_0x2016C:
	LDS  R26,_IRFR
	LDS  R27,_IRFR+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLO _0x2016D
; 0001 06A8         {
; 0001 06A9             vMLlui(10);vMRlui(22);delay_ms(600);
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _vMLlui
	LDI  R30,LOW(22)
	CALL SUBOPT_0x8D
; 0001 06AA         }
; 0001 06AB         if((IRFL<300)&(IRFR<300))
_0x2016D:
	CALL SUBOPT_0x3C
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL __LTW12U
	MOV  R0,R30
	LDS  R26,_IRFR
	LDS  R27,_IRFR+1
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL __LTW12U
	AND  R30,R0
	BREQ _0x2016E
; 0001 06AC         {
; 0001 06AD             vMLtoi(22);vMRtoi(22);
	LDI  R30,LOW(22)
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(22)
	ST   -Y,R30
	CALL _vMRtoi
; 0001 06AE         }
; 0001 06AF 
; 0001 06B0        demled++;
_0x2016E:
	__ADDWRN 16,17,1
; 0001 06B1        if(demled>50){demled=0;LEDLtoggle(); LEDRtoggle();}
	__CPWRN 16,17,51
	BRLO _0x2016F
	__GETWRN 16,17,0
	CALL SUBOPT_0x8E
; 0001 06B2    }
_0x2016F:
	RJMP _0x20169
_0x2016B:
; 0001 06B3 
; 0001 06B4 }
	LD   R16,Y+
	LD   R17,Y+
	RET

	.DSEG
_0x20164:
	.BYTE 0xB
;////========================================================
;//void robotline() //DIGITAL I/O
;//{
;//    unsigned char status=2;
;//    unsigned char prestatus=2;
;//
;//    DDRA =0x00;
;//    PORTA=0xFF;
;////#define S0  PINA.0 status 0
;////#define S1  PINA.1 status 1
;////#define S2  PINA.2 status 2
;////#define S3  PINA.3 status 3
;////#define S4  PINA.7 status 4
;//        LcdClear();
;//        hc(0,1);
;//        ws ("LINE FOLOWER");
;//        hc(1,20);
;//        ws (" ROBOT");
;//        LEDL=1;LEDR=1;
;//
;//   while(keyKT!=0)
;//   {
;//      if (S2==0)
;//      {
;//          status=2;
;//          vMLtoi(80);vMRtoi(80);
;//      }
;//      //===========================
;//      if ((prestatus==2)&(S1==0))
;//      {
;//          status=1;
;//          vMLtoi(80);vMRtoi(50);
;//      }
;//      if ((prestatus==2)&(S0==0))
;//      {
;//          status=0;
;//          vMLtoi(80);vMRtoi(30);
;//      }
;//       //===========================
;//      if ((prestatus==2)&(S3==0))
;//      {
;//          status=1;
;//          vMLtoi(50);vMRtoi(80);
;//      }
;//      if ((prestatus==2)&(S4==0))
;//      {
;//          status=0;
;//          vMLtoi(30);vMRtoi(80);
;//      }
;//       //===========================
;//      if ((prestatus==1)&(S0==0))
;//      {
;//          status=1;
;//          vMLtoi(80);vMRtoi(40);
;//      }
;//      if ((prestatus==3)&(S4==0))
;//      {
;//          status=0;
;//          vMLtoi(40);vMRtoi(80);
;//      }
;//
;//      prestatus=status;
;//      delay_ms(200);LEDLtoggle();LEDRtoggle();
;//
;//  }
;// }
;
;
;//========================================================
;void readline()
; 0001 06FB {

	.CSEG
_readline:
; 0001 06FC     int i=0,j=0;
; 0001 06FD     // reset the values
; 0001 06FE         for(i = 0; i < 5; i++)
	CALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 16,17,0
_0x20171:
	__CPWRN 16,17,5
	BRGE _0x20172
; 0001 06FF         IRLINE[i] = 0;
	CALL SUBOPT_0x8F
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	__ADDWRN 16,17,1
	RJMP _0x20171
_0x20172:
; 0001 0701 for (j = 0; j < 50; j++)
	__GETWRN 18,19,0
_0x20174:
	__CPWRN 18,19,50
	BRLT PC+3
	JMP _0x20175
; 0001 0702         {
; 0001 0703             IRLINE[0]= IRLINE[0]+read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _read_adc
	LDS  R26,_IRLINE
	LDS  R27,_IRLINE+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _IRLINE,R30
	STS  _IRLINE+1,R31
; 0001 0704             IRLINE[1]= IRLINE[1]+read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _read_adc
	__GETW2MN _IRLINE,2
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,2
; 0001 0705             IRLINE[2]= IRLINE[2]+read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _read_adc
	CALL SUBOPT_0x90
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,4
; 0001 0706             IRLINE[3]= IRLINE[3]+read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _read_adc
	__GETW2MN _IRLINE,6
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,6
; 0001 0707             IRLINE[4]= IRLINE[4]+read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _read_adc
	__GETW2MN _IRLINE,8
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,8
; 0001 0708         }
	__ADDWRN 18,19,1
	RJMP _0x20174
_0x20175:
; 0001 0709         // get the rounded average of the readings for each sensor
; 0001 070A         for (i = 0; i < 5; i++)
	__GETWRN 16,17,0
_0x20177:
	__CPWRN 16,17,5
	BRGE _0x20178
; 0001 070B         IRLINE[i] = (IRLINE[i] + (50 >> 1)) /50;
	CALL SUBOPT_0x8F
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	ADIW R30,25
	MOVW R26,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __DIVW21U
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	__ADDWRN 16,17,1
	RJMP _0x20177
_0x20178:
; 0001 070C }
	RJMP _0x20C0006
;//========================================================
;void robotwhiteline() //ANALOG OK
; 0001 070F {
_robotwhiteline:
; 0001 0710     unsigned char i=0,imax;
; 0001 0711     int imaxlast=0;
; 0001 0712     unsigned int  admax;
; 0001 0713     unsigned int  demled=0;
; 0001 0714     unsigned int flagblindT=0;
; 0001 0715     unsigned int flagblindP=0;
; 0001 0716     DDRA =0x00;
	SBIW R28,6
	CALL SUBOPT_0x7F
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	CALL __SAVELOCR6
;	i -> R17
;	imax -> R16
;	imaxlast -> R18,R19
;	admax -> R20,R21
;	demled -> Y+10
;	flagblindT -> Y+8
;	flagblindP -> Y+6
	LDI  R17,0
	__GETWRN 18,19,0
	CALL SUBOPT_0x38
; 0001 0717     PORTA=0x00;
; 0001 0718 
; 0001 0719         LcdClear();
	CALL SUBOPT_0x8A
; 0001 071A         hc(0,1);
	CALL SUBOPT_0x87
	CALL _hc
; 0001 071B         ws ("WHITE LINE");
	__POINTW1MN _0x20179,0
	CALL SUBOPT_0xE
; 0001 071C         hc(1,10);
	CALL SUBOPT_0x87
	CALL SUBOPT_0x49
	CALL _hc
; 0001 071D         ws ("FOLOWER");
	__POINTW1MN _0x20179,11
	CALL SUBOPT_0xE
; 0001 071E         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 071F         //doc va khoi dong gia tri cho imaxlast
; 0001 0720          readline();
	CALL SUBOPT_0x92
; 0001 0721         admax = IRLINE[0];imax=0;
; 0001 0722         for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x2017F:
	CPI  R17,5
	BRSH _0x20180
	CALL SUBOPT_0x93
	CALL SUBOPT_0x91
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x20181
	CALL SUBOPT_0x93
	CALL SUBOPT_0x94
_0x20181:
	SUBI R17,-1
	RJMP _0x2017F
_0x20180:
; 0001 0723         imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 0724    while(keyKT!=0)
_0x20182:
	SBIS 0x13,0
	RJMP _0x20184
; 0001 0725    {
; 0001 0726         //doc gia tri cam bien
; 0001 0727         readline();
	CALL SUBOPT_0x92
; 0001 0728         admax = IRLINE[0];imax=0;
; 0001 0729         for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x20186:
	CPI  R17,5
	BRSH _0x20187
	CALL SUBOPT_0x93
	CALL SUBOPT_0x91
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x20188
	CALL SUBOPT_0x93
	CALL SUBOPT_0x94
_0x20188:
	SUBI R17,-1
	RJMP _0x20186
_0x20187:
; 0001 072A           //imax=2;
; 0001 072B          if((imax-imaxlast > 1)||(imax-imaxlast <-1))  //tranh truong hop nhay bo trang thai
	CALL SUBOPT_0x95
	SUB  R30,R18
	SBC  R31,R19
	MOVW R26,R30
	SBIW R30,2
	BRGE _0x2018A
	MOVW R30,R26
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRGE _0x20189
_0x2018A:
; 0001 072C         {
; 0001 072D         }
; 0001 072E         else
	RJMP _0x2018C
_0x20189:
; 0001 072F         {
; 0001 0730             switch(imax)
	CALL SUBOPT_0x95
; 0001 0731             {
; 0001 0732               case 0:
	SBIW R30,0
	BRNE _0x20190
; 0001 0733                   vMLtoi(1); vMRtoi(20) ;
	CALL SUBOPT_0x96
	CALL SUBOPT_0x97
; 0001 0734                   //flagblindT = 0;
; 0001 0735                   flagblindP = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 0736                 break;
	RJMP _0x2018F
; 0001 0737               case 1:
_0x20190:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20191
; 0001 0738                   vMLtoi(1); vMRtoi(15) ;
	CALL SUBOPT_0x96
	CALL SUBOPT_0x98
; 0001 0739                 break;
	RJMP _0x2018F
; 0001 073A               case 2:
_0x20191:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20192
; 0001 073B                   vMLtoi(15);vMRtoi(15) ;
	CALL SUBOPT_0x99
	CALL SUBOPT_0x98
; 0001 073C                 break;
	RJMP _0x2018F
; 0001 073D               case 3:
_0x20192:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20193
; 0001 073E                  vMLtoi(15); vMRtoi(1) ;
	CALL SUBOPT_0x99
	CALL SUBOPT_0x9A
; 0001 073F                 break;
	RJMP _0x2018F
; 0001 0740               case 4:
_0x20193:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20195
; 0001 0741                   vMLtoi(20);vMRtoi(1)  ;
	CALL SUBOPT_0x9B
; 0001 0742                   flagblindT = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0743                   //flagblindP = 0;
; 0001 0744                 break;
; 0001 0745               default:
_0x20195:
; 0001 0746                  // vMLtoi(5); vMRtoi(5) ;
; 0001 0747                 break;
; 0001 0748             }
_0x2018F:
; 0001 0749              imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 074A         }
_0x2018C:
; 0001 074B 
; 0001 074C             while(flagblindT ==1 && keyKT!=0) //lac duong ben trai
_0x20196:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x20199
	CALL SUBOPT_0x9C
	BRNE _0x2019A
_0x20199:
	RJMP _0x20198
_0x2019A:
; 0001 074D             {
; 0001 074E                vMLtoi(20);vMRtoi(1)  ;
	CALL SUBOPT_0x9B
; 0001 074F                 readline();
	CALL SUBOPT_0x92
; 0001 0750                 admax = IRLINE[0];imax=0;
; 0001 0751                 for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x2019C:
	CPI  R17,5
	BRSH _0x2019D
	CALL SUBOPT_0x93
	CALL SUBOPT_0x91
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x2019E
	CALL SUBOPT_0x93
	CALL SUBOPT_0x94
_0x2019E:
	SUBI R17,-1
	RJMP _0x2019C
_0x2019D:
; 0001 0752                 imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 0753                if(IRLINE[2]>500)  flagblindT=0;
	CALL SUBOPT_0x90
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLO _0x2019F
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
; 0001 0754 
; 0001 0755 
; 0001 0756             }
_0x2019F:
	RJMP _0x20196
_0x20198:
; 0001 0757             while(flagblindP ==1 && keyKT!=0 ) //lac duong ben phai
_0x201A0:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BRNE _0x201A3
	CALL SUBOPT_0x9C
	BRNE _0x201A4
_0x201A3:
	RJMP _0x201A2
_0x201A4:
; 0001 0758             {
; 0001 0759                vMLtoi(1);vMRtoi(20)  ;
	CALL SUBOPT_0x96
	CALL SUBOPT_0x97
; 0001 075A                 readline();
	CALL SUBOPT_0x92
; 0001 075B                 admax = IRLINE[0];imax=0;
; 0001 075C                 for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x201A6:
	CPI  R17,5
	BRSH _0x201A7
	CALL SUBOPT_0x93
	CALL SUBOPT_0x91
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x201A8
	CALL SUBOPT_0x93
	CALL SUBOPT_0x94
_0x201A8:
	SUBI R17,-1
	RJMP _0x201A6
_0x201A7:
; 0001 075D                 imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 075E                if(IRLINE[2]>500)  flagblindP=0;
	CALL SUBOPT_0x90
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLO _0x201A9
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0001 075F 
; 0001 0760             }
_0x201A9:
	RJMP _0x201A0
_0x201A2:
; 0001 0761         hc(3,10);wn16s(imax);
	CALL SUBOPT_0x85
	CALL SUBOPT_0x49
	CALL _hc
	CALL SUBOPT_0x95
	CALL SUBOPT_0x82
; 0001 0762         hc(4,10);wn16s(admax);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x49
	CALL SUBOPT_0x9D
; 0001 0763 
; 0001 0764        demled++;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 0765        if(demled>30){demled=0;LEDLtoggle();LEDRtoggle(); }
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,31
	BRLO _0x201AA
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	CALL SUBOPT_0x8E
; 0001 0766    }
_0x201AA:
	RJMP _0x20182
_0x20184:
; 0001 0767 }
	CALL __LOADLOCR6
	ADIW R28,12
	RET

	.DSEG
_0x20179:
	.BYTE 0x13
;
;//========================================================
;void robotblackline() //ANALOG OK
; 0001 076B {

	.CSEG
_robotblackline:
; 0001 076C     long int lastvalueline=0, valueline=0,value=0,online=0;
; 0001 076D     int i=0,j=0
; 0001 076E     ,imin=0;
; 0001 076F     long int avrg=0,sum=0 ;
; 0001 0770     unsigned int admin;
; 0001 0771      unsigned char imax;
; 0001 0772     int imaxlast=0;
; 0001 0773     unsigned int  admax;
; 0001 0774     unsigned int demled=0;
; 0001 0775     unsigned int flagblindT=0;
; 0001 0776     unsigned int flagblindP=0;
; 0001 0777     float udk,sumi=0,err,lasterr;
; 0001 0778 
; 0001 0779     int iminlast=0;
; 0001 077A     DDRA =0x00;
	SBIW R28,55
	LDI  R24,55
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x201AB*2)
	LDI  R31,HIGH(_0x201AB*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	lastvalueline -> Y+57
;	valueline -> Y+53
;	value -> Y+49
;	online -> Y+45
;	i -> R16,R17
;	j -> R18,R19
;	imin -> R20,R21
;	avrg -> Y+41
;	sum -> Y+37
;	admin -> Y+35
;	imax -> Y+34
;	imaxlast -> Y+32
;	admax -> Y+30
;	demled -> Y+28
;	flagblindT -> Y+26
;	flagblindP -> Y+24
;	udk -> Y+20
;	sumi -> Y+16
;	err -> Y+12
;	lasterr -> Y+8
;	iminlast -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	CALL SUBOPT_0x38
; 0001 077B     PORTA=0x00;
; 0001 077C 
; 0001 077D         LcdClear();
	CALL SUBOPT_0x8A
; 0001 077E         hc(0,1);
	CALL SUBOPT_0x87
	CALL _hc
; 0001 077F         ws ("BLACK LINE");
	__POINTW1MN _0x201AC,0
	CALL SUBOPT_0xE
; 0001 0780         hc(1,10);
	CALL SUBOPT_0x87
	CALL SUBOPT_0x49
	CALL _hc
; 0001 0781         ws ("FOLOWER");
	__POINTW1MN _0x201AC,11
	CALL SUBOPT_0xE
; 0001 0782         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 0783 
; 0001 0784         //doc lan dau tien  de khoi dong gia tri iminlast;
; 0001 0785         readline();
	CALL SUBOPT_0x9E
; 0001 0786         admin = IRLINE[0];imin=0;
; 0001 0787         for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x201B2:
	__CPWRN 16,17,5
	BRGE _0x201B3
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	CALL SUBOPT_0x9F
	BRSH _0x201B4
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x201B4:
	__ADDWRN 16,17,1
	RJMP _0x201B2
_0x201B3:
; 0001 0788         iminlast=imin;
	__PUTWSR 20,21,6
; 0001 0789         admin = 1024;
	LDI  R30,LOW(1024)
	LDI  R31,HIGH(1024)
	STD  Y+35,R30
	STD  Y+35+1,R31
; 0001 078A         admax = 0;
	STD  Y+30,R30
	STD  Y+30+1,R30
; 0001 078B    //calib
; 0001 078C    while(keyKT!=0)
_0x201B5:
	SBIS 0x13,0
	RJMP _0x201B7
; 0001 078D    {
; 0001 078E       //doc gia tri cam bien
; 0001 078F       readline();
	RCALL _readline
; 0001 0790 
; 0001 0791       for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
	__GETWRN 16,17,1
_0x201B9:
	__CPWRN 16,17,5
	BRGE _0x201BA
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	CALL SUBOPT_0x9F
	BRSH _0x201BB
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x201BB:
	__ADDWRN 16,17,1
	RJMP _0x201B9
_0x201BA:
; 0001 0792       //hc(3,10);wn16s(admin);
; 0001 0793       hc(3,10);wn16s(admin);
	CALL SUBOPT_0x85
	CALL SUBOPT_0x49
	CALL SUBOPT_0xA0
; 0001 0794 
; 0001 0795       for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
	__GETWRN 16,17,1
_0x201BD:
	__CPWRN 16,17,5
	BRGE _0x201BE
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x201BF
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	STD  Y+30,R30
	STD  Y+30+1,R31
	__PUTBSR 16,34
_0x201BF:
	__ADDWRN 16,17,1
	RJMP _0x201BD
_0x201BE:
; 0001 0796       hc(4,10);wn16s(admax);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x49
	CALL _hc
	LDD  R30,Y+30
	LDD  R31,Y+30+1
	CALL SUBOPT_0x82
; 0001 0797    }
	RJMP _0x201B5
_0x201B7:
; 0001 0798    //test gia tri doc line
; 0001 0799    online=0;
	LDI  R30,LOW(0)
	__CLRD1S 45
; 0001 079A    while(1)
_0x201C0:
; 0001 079B    {
; 0001 079C       //doc gia tri cam bien
; 0001 079D       readline();
	RCALL _readline
; 0001 079E       for(i=0;i<5;i++)
	__GETWRN 16,17,0
_0x201C4:
	__CPWRN 16,17,5
	BRLT PC+3
	JMP _0x201C5
; 0001 079F       {
; 0001 07A0          value=IRLINE[i];
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	CLR  R22
	CLR  R23
	__PUTD1S 49
; 0001 07A1          if(value<280) online=1;
	__GETD2S 49
	__CPD2N 0x118
	BRGE _0x201C6
	__GETD1N 0x1
	__PUTD1S 45
; 0001 07A2          avrg = avrg+i*1000*value;
_0x201C6:
	MOVW R30,R16
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	MOVW R26,R30
	__GETD1S 49
	CALL __CWD2
	CALL __MULD12
	__GETD2S 41
	CALL __ADDD12
	__PUTD1S 41
; 0001 07A3          sum = sum+value;
	__GETD1S 49
	__GETD2S 37
	CALL __ADDD12
	__PUTD1S 37
; 0001 07A4       }
	__ADDWRN 16,17,1
	RJMP _0x201C4
_0x201C5:
; 0001 07A5       //hc(1,10);wn16s(online);
; 0001 07A6       if(online==1)
	__GETD2S 45
	__CPD2N 0x1
	BRNE _0x201C7
; 0001 07A7       {
; 0001 07A8          valueline=(int)(avrg/ sum);
	__GETD1S 37
	__GETD2S 41
	CALL __DIVD21
	CLR  R22
	CLR  R23
	CALL __CWD1
	__PUTD1S 53
; 0001 07A9         // hc(2,10);wn16s(valueline);
; 0001 07AA          online=0;
	LDI  R30,LOW(0)
	__CLRD1S 45
; 0001 07AB          avrg=0;
	__CLRD1S 41
; 0001 07AC          sum=0;
	__CLRD1S 37
; 0001 07AD       }else
	RJMP _0x201C8
_0x201C7:
; 0001 07AE       {
; 0001 07AF          if(lastvalueline>1935)
	__GETD2S 57
	__CPD2N 0x790
	BRLT _0x201C9
; 0001 07B0          valueline=2000;
	__GETD1N 0x7D0
	RJMP _0x202DD
; 0001 07B1          else
_0x201C9:
; 0001 07B2          valueline=1800;
	__GETD1N 0x708
_0x202DD:
	__PUTD1S 53
; 0001 07B3       }
_0x201C8:
; 0001 07B4       err = 1935-valueline;
	__GETD2S 53
	__GETD1N 0x78F
	CALL __SUBD12
	CALL __CDF1
	CALL SUBOPT_0x2C
; 0001 07B5       if(err>100) err=100;
	CALL SUBOPT_0xA1
	CALL SUBOPT_0x4F
	BREQ PC+2
	BRCC PC+3
	JMP  _0x201CB
	__GETD1N 0x42C80000
	CALL SUBOPT_0x2C
; 0001 07B6       if(err<-100) err=-100;
_0x201CB:
	CALL SUBOPT_0xA1
	__GETD1N 0xC2C80000
	CALL __CMPF12
	BRSH _0x201CC
	CALL SUBOPT_0x2C
; 0001 07B7       sumi=sumi+ err/35;
_0x201CC:
	CALL SUBOPT_0xA1
	__GETD1N 0x420C0000
	CALL __DIVF21
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2A
; 0001 07B8       if(sumi>6) sumi=6;
	CALL SUBOPT_0x2B
	__GETD1N 0x40C00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x201CD
	__PUTD1S 16
; 0001 07B9       if(sumi<-6) sumi=-6;
_0x201CD:
	CALL SUBOPT_0x2B
	__GETD1N 0xC0C00000
	CALL __CMPF12
	BRSH _0x201CE
	__PUTD1S 16
; 0001 07BA       udk = err/7 + sumi+(err-lasterr)/30;
_0x201CE:
	CALL SUBOPT_0xA1
	__GETD1N 0x40E00000
	CALL __DIVF21
	CALL SUBOPT_0x2B
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA2
	CALL SUBOPT_0x31
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41F00000
	CALL __DIVF21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	CALL SUBOPT_0x29
; 0001 07BB       if(udk>10) {udk=9;sumi=0;}
	CALL SUBOPT_0xA3
	CALL SUBOPT_0x60
	BREQ PC+2
	BRCC PC+3
	JMP  _0x201CF
	__GETD1N 0x41100000
	CALL SUBOPT_0xA4
; 0001 07BC       if(udk<-10){ udk=-9;sumi=0;}
_0x201CF:
	CALL SUBOPT_0xA3
	CALL SUBOPT_0x61
	BRSH _0x201D0
	__GETD1N 0xC1100000
	CALL SUBOPT_0xA4
; 0001 07BD       //hc(5,10);wn16s(udk);
; 0001 07BE       vMLtoi(10+udk); vMRtoi(10-udk) ;
_0x201D0:
	__GETD1S 20
	__GETD2N 0x41200000
	CALL __ADDF12
	CALL __CFD1U
	ST   -Y,R30
	CALL _vMLtoi
	CALL SUBOPT_0xA3
	CALL SUBOPT_0x1E
	CALL __SUBF12
	CALL __CFD1U
	ST   -Y,R30
	CALL _vMRtoi
; 0001 07BF 
; 0001 07C0       lastvalueline=valueline;
	__GETD1S 53
	__PUTD1S 57
; 0001 07C1       lasterr=err;
	CALL SUBOPT_0x31
	__PUTD1S 8
; 0001 07C2    }
	RJMP _0x201C0
; 0001 07C3 
; 0001 07C4    while(keyKT!=0)
_0x201D1:
	SBIS 0x13,0
	RJMP _0x201D3
; 0001 07C5    {
; 0001 07C6        //doc gia tri cam bien
; 0001 07C7         readline();
	CALL SUBOPT_0x9E
; 0001 07C8         admin = IRLINE[0];imin=0;
; 0001 07C9         for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x201D5:
	__CPWRN 16,17,5
	BRGE _0x201D6
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	CALL SUBOPT_0x9F
	BRSH _0x201D7
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x201D7:
	__ADDWRN 16,17,1
	RJMP _0x201D5
_0x201D6:
; 0001 07CA         hc(2,10);wn16s(iminlast);
	CALL SUBOPT_0x86
	CALL SUBOPT_0x49
	CALL _hc
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x82
; 0001 07CB         hc(3,10);wn16s(imin);
	CALL SUBOPT_0x85
	CALL SUBOPT_0x49
	CALL SUBOPT_0x9D
; 0001 07CC         hc(4,10);wn16s(admin);
	CALL SUBOPT_0x83
	CALL SUBOPT_0x49
	CALL SUBOPT_0xA0
; 0001 07CD 
; 0001 07CE         if((imin-iminlast > 1)||(imin-iminlast <-1))  //tranh truong hop nhay bo trang thai
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	MOVW R30,R20
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	SBIW R30,2
	BRGE _0x201D9
	MOVW R30,R26
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRGE _0x201D8
_0x201D9:
; 0001 07CF         {
; 0001 07D0         }
; 0001 07D1         else
	RJMP _0x201DB
_0x201D8:
; 0001 07D2         {
; 0001 07D3              switch(imin)
	MOVW R30,R20
; 0001 07D4             {
; 0001 07D5               case 0:
	SBIW R30,0
	BRNE _0x201DF
; 0001 07D6                   vMLtoi(1); vMRtoi(15) ;
	CALL SUBOPT_0x96
	CALL SUBOPT_0x98
; 0001 07D7                   //flagblindT = 0;
; 0001 07D8                   flagblindP = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+24,R30
	STD  Y+24+1,R31
; 0001 07D9                 break;
	RJMP _0x201DE
; 0001 07DA               case 1:
_0x201DF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x201E0
; 0001 07DB                   vMLtoi(2); vMRtoi(8) ;
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _vMRtoi
; 0001 07DC                 break;
	RJMP _0x201DE
; 0001 07DD               case 2:
_0x201E0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x201E1
; 0001 07DE                   vMLtoi(10);vMRtoi(10) ;
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _vMRtoi
; 0001 07DF                 break;
	RJMP _0x201DE
; 0001 07E0               case 3:
_0x201E1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x201E2
; 0001 07E1                  vMLtoi(8); vMRtoi(2) ;
	LDI  R30,LOW(8)
	CALL SUBOPT_0xA5
; 0001 07E2                 break;
	RJMP _0x201DE
; 0001 07E3               case 4:
_0x201E2:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x201E4
; 0001 07E4                   vMLtoi(15);vMRtoi(1)  ;
	CALL SUBOPT_0x99
	CALL SUBOPT_0x9A
; 0001 07E5                   flagblindT = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+26,R30
	STD  Y+26+1,R31
; 0001 07E6                   //flagblindP = 0;
; 0001 07E7                 break;
; 0001 07E8               default:
_0x201E4:
; 0001 07E9                  // vMLtoi(5); vMRtoi(5) ;
; 0001 07EA                 break;
; 0001 07EB             }
_0x201DE:
; 0001 07EC 
; 0001 07ED               iminlast=imin;
	__PUTWSR 20,21,6
; 0001 07EE          }
_0x201DB:
; 0001 07EF 
; 0001 07F0 
; 0001 07F1             while(flagblindT == 1 && keyKT!=0) //lac duong ben trai
_0x201E5:
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	SBIW R26,1
	BRNE _0x201E8
	CALL SUBOPT_0x9C
	BRNE _0x201E9
_0x201E8:
	RJMP _0x201E7
_0x201E9:
; 0001 07F2             {
; 0001 07F3                vMLtoi(20);vMRtoi(2)  ;
	LDI  R30,LOW(20)
	CALL SUBOPT_0xA5
; 0001 07F4                readline();
	CALL SUBOPT_0x9E
; 0001 07F5                admin = IRLINE[0];imin=0;
; 0001 07F6                for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x201EB:
	__CPWRN 16,17,5
	BRGE _0x201EC
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	CALL SUBOPT_0x9F
	BRSH _0x201ED
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x201ED:
	__ADDWRN 16,17,1
	RJMP _0x201EB
_0x201EC:
; 0001 07F7                iminlast=imin;
	__PUTWSR 20,21,6
; 0001 07F8                if(IRLINE[2]<310)  flagblindT=0;
	CALL SUBOPT_0x90
	CPI  R26,LOW(0x136)
	LDI  R30,HIGH(0x136)
	CPC  R27,R30
	BRSH _0x201EE
	LDI  R30,LOW(0)
	STD  Y+26,R30
	STD  Y+26+1,R30
; 0001 07F9 
; 0001 07FA             }
_0x201EE:
	RJMP _0x201E5
_0x201E7:
; 0001 07FB             while(flagblindP ==1 && keyKT!=0) //lac duong ben phai
_0x201EF:
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	SBIW R26,1
	BRNE _0x201F2
	CALL SUBOPT_0x9C
	BRNE _0x201F3
_0x201F2:
	RJMP _0x201F1
_0x201F3:
; 0001 07FC             {
; 0001 07FD                vMLtoi(2);vMRtoi(20)  ;
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _vMLtoi
	CALL SUBOPT_0x97
; 0001 07FE                readline();
	CALL SUBOPT_0x9E
; 0001 07FF                admin = IRLINE[0];imin=0;
; 0001 0800                for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x201F5:
	__CPWRN 16,17,5
	BRGE _0x201F6
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	CALL SUBOPT_0x9F
	BRSH _0x201F7
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x91
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x201F7:
	__ADDWRN 16,17,1
	RJMP _0x201F5
_0x201F6:
; 0001 0801                iminlast=imin;
	__PUTWSR 20,21,6
; 0001 0802                if(IRLINE[2]<310)  flagblindP=0;
	CALL SUBOPT_0x90
	CPI  R26,LOW(0x136)
	LDI  R30,HIGH(0x136)
	CPC  R27,R30
	BRSH _0x201F8
	LDI  R30,LOW(0)
	STD  Y+24,R30
	STD  Y+24+1,R30
; 0001 0803 
; 0001 0804             }
_0x201F8:
	RJMP _0x201EF
_0x201F1:
; 0001 0805 
; 0001 0806 
; 0001 0807        demled++;
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	ADIW R30,1
	STD  Y+28,R30
	STD  Y+28+1,R31
; 0001 0808        if(demled>30){demled=0;LEDLtoggle();LEDRtoggle(); }
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	SBIW R26,31
	BRLO _0x201F9
	LDI  R30,LOW(0)
	STD  Y+28,R30
	STD  Y+28+1,R30
	CALL SUBOPT_0x8E
; 0001 0809    }
_0x201F9:
	RJMP _0x201D1
_0x201D3:
; 0001 080A }
	CALL __LOADLOCR6
	ADIW R28,61
	RET

	.DSEG
_0x201AC:
	.BYTE 0x13
;//========================================================
;void bluetooth()
; 0001 080D {  unsigned char kytu;

	.CSEG
_bluetooth:
; 0001 080E    unsigned int demled;
; 0001 080F 
; 0001 0810         LcdClear();
	CALL __SAVELOCR4
;	kytu -> R17
;	demled -> R18,R19
	CALL SUBOPT_0x8A
; 0001 0811         hc(0,10);
	CALL SUBOPT_0x49
	CALL _hc
; 0001 0812         ws ("BLUETOOTH");
	__POINTW1MN _0x201FA,0
	CALL SUBOPT_0xE
; 0001 0813         hc(1,25);
	CALL SUBOPT_0x87
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CALL SUBOPT_0xA6
; 0001 0814         ws ("DRIVE");
	__POINTW1MN _0x201FA,10
	CALL SUBOPT_0xE
; 0001 0815 
; 0001 0816         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 0817 
; 0001 0818    while(keyKT!=0)
_0x201FF:
	SBIS 0x13,0
	RJMP _0x20201
; 0001 0819    {
; 0001 081A         LEDL=1; LEDR=1;
	CALL SUBOPT_0xA7
; 0001 081B         delay_ms(100);
; 0001 081C         LEDL=0; LEDR=0;
; 0001 081D         delay_ms(100);
; 0001 081E 
; 0001 081F       if (rx_counter)
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x2020A
; 0001 0820       {
; 0001 0821        //LcdClear();
; 0001 0822        hc(2,42);
	CALL SUBOPT_0x86
	CALL SUBOPT_0x8C
; 0001 0823        kytu = getchar();
	CALL _getchar
	MOV  R17,R30
; 0001 0824        LcdCharacter(kytu);
	ST   -Y,R17
	CALL _LcdCharacter
; 0001 0825        //putchar(getchar());
; 0001 0826        if(kytu=='S'){vMLtoi(0);vMRtoi(0);}
	CPI  R17,83
	BRNE _0x2020B
	CALL SUBOPT_0x77
	CALL SUBOPT_0x76
; 0001 0827        if(kytu=='F'){vMLtoi(100);vMRtoi(100);}
_0x2020B:
	CPI  R17,70
	BRNE _0x2020C
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL _vMRtoi
; 0001 0828        if(kytu=='B'){vMLlui(100);vMRlui(100);}
_0x2020C:
	CPI  R17,66
	BRNE _0x2020D
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL _vMLlui
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL _vMRlui
; 0001 0829        if(kytu=='R'){vMLtoi(100);vMRtoi(0);}
_0x2020D:
	CPI  R17,82
	BRNE _0x2020E
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL _vMLtoi
	CALL SUBOPT_0x76
; 0001 082A        if(kytu=='L'){vMLtoi(0);vMRtoi(100);}
_0x2020E:
	CPI  R17,76
	BRNE _0x2020F
	CALL SUBOPT_0x77
	LDI  R30,LOW(100)
	ST   -Y,R30
	CALL _vMRtoi
; 0001 082B 
; 0001 082C        demled++;
_0x2020F:
	__ADDWRN 18,19,1
; 0001 082D        if(demled>1000){demled=0;LEDLtoggle(); LEDRtoggle();}
	__CPWRN 18,19,1001
	BRLO _0x20210
	__GETWRN 18,19,0
	CALL SUBOPT_0x8E
; 0001 082E       }
_0x20210:
; 0001 082F     }
_0x2020A:
	RJMP _0x201FF
_0x20201:
; 0001 0830 }
_0x20C0006:
	CALL __LOADLOCR4
	ADIW R28,4
	RET

	.DSEG
_0x201FA:
	.BYTE 0x10
;//========================================================
;
;//Chuong trinh test robot
;   void testmotor()
; 0001 0835    {

	.CSEG
_testmotor:
; 0001 0836         LcdClear();
	CALL SUBOPT_0x8A
; 0001 0837         hc(0,10);
	CALL SUBOPT_0x49
	CALL _hc
; 0001 0838         ws ("TEST MOTOR");
	__POINTW1MN _0x20211,0
	CALL SUBOPT_0xE
; 0001 0839 
; 0001 083A         vMRtoi(20);
	CALL SUBOPT_0x97
; 0001 083B         vMLtoi(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _vMLtoi
; 0001 083C       while(keyKT!=0)
_0x20212:
	SBIS 0x13,0
	RJMP _0x20214
; 0001 083D       {
; 0001 083E         hc(2,0);
	CALL SUBOPT_0xA8
; 0001 083F         ws ("MotorL");
	__POINTW1MN _0x20211,11
	CALL SUBOPT_0xE
; 0001 0840         hc(2,45);
	CALL SUBOPT_0x86
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CALL SUBOPT_0xA6
; 0001 0841         wn16(QEL);
	CALL SUBOPT_0x18
	CALL SUBOPT_0xD
; 0001 0842         hc(3,0);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x7
; 0001 0843         ws ("MotorR");
	__POINTW1MN _0x20211,18
	CALL SUBOPT_0xE
; 0001 0844         hc(3,45);
	CALL SUBOPT_0x85
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CALL SUBOPT_0xA6
; 0001 0845         wn16(QER);
	CALL SUBOPT_0x7A
	CALL SUBOPT_0xD
; 0001 0846         delay_ms(10);
	CALL SUBOPT_0x49
	CALL _delay_ms
; 0001 0847       }
	RJMP _0x20212
_0x20214:
; 0001 0848 
; 0001 0849        vMRstop();
	CALL _vMRstop
; 0001 084A        vMLstop();
	CALL _vMLstop
; 0001 084B    }
	RET

	.DSEG
_0x20211:
	.BYTE 0x19
; //========================================================
; // UART TEST
;   void testuart()
; 0001 084F    {

	.CSEG
_testuart:
; 0001 0850           if (rx_counter)
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x20215
; 0001 0851           {
; 0001 0852           LcdClear();
	CALL SUBOPT_0x8A
; 0001 0853            hc(0,10);
	CALL SUBOPT_0x49
	CALL _hc
; 0001 0854            ws ("TEST UART");
	__POINTW1MN _0x20216,0
	CALL SUBOPT_0xE
; 0001 0855            putchar(getchar());
	CALL _getchar
	ST   -Y,R30
	CALL _putchar
; 0001 0856           }
; 0001 0857 
; 0001 0858    }
_0x20215:
	RET

	.DSEG
_0x20216:
	.BYTE 0xA
;   //========================================================
; // UART TEST
;   void testrf()
; 0001 085C    {

	.CSEG
_testrf:
; 0001 085D 
; 0001 085E 
; 0001 085F    }
	RET
;
;//========================================================
;   void testir()
; 0001 0863    {    unsigned int AD[8];
_testir:
; 0001 0864 
; 0001 0865         DDRA    = 0x00;
	SBIW R28,16
;	AD -> Y+0
	CALL SUBOPT_0x38
; 0001 0866         PORTA   = 0x00;
; 0001 0867 
; 0001 0868         clear();
	CALL _clear
; 0001 0869         hc(0,10);
	CALL SUBOPT_0x88
	CALL SUBOPT_0x49
	CALL _hc
; 0001 086A         ws ("TEST IR");
	__POINTW1MN _0x20217,0
	CALL SUBOPT_0xE
; 0001 086B 
; 0001 086C         while(keyKT!=0)
_0x20218:
	SBIS 0x13,0
	RJMP _0x2021A
; 0001 086D         {
; 0001 086E 
; 0001 086F         AD[0]=read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _read_adc
	ST   Y,R30
	STD  Y+1,R31
; 0001 0870         AD[1]=read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 0871         AD[2]=read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0001 0872         AD[3]=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 0873         AD[4]=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0874         AD[5]=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 0875         AD[6]=read_adc(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0001 0876         AD[7]=read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0001 0877 
; 0001 0878         hc(1,0) ;ws("0.");wn164(AD[0]);
	CALL SUBOPT_0x8B
	__POINTW1MN _0x20217,8
	CALL SUBOPT_0xE
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0xA9
; 0001 0879         hc(1,43);ws("1.");wn164(AD[1]);
	CALL SUBOPT_0x87
	CALL SUBOPT_0xAA
	__POINTW1MN _0x20217,11
	CALL SUBOPT_0xE
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0xA9
; 0001 087A         hc(2,0) ;ws("2.");wn164(AD[2]);
	CALL SUBOPT_0xA8
	__POINTW1MN _0x20217,14
	CALL SUBOPT_0xE
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0xA9
; 0001 087B         hc(2,43);ws("3.");wn164(AD[3]);
	CALL SUBOPT_0x86
	CALL SUBOPT_0xAA
	__POINTW1MN _0x20217,17
	CALL SUBOPT_0xE
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0xA9
; 0001 087C         hc(3,0) ;ws("4.");wn164(AD[4]);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x7
	__POINTW1MN _0x20217,20
	CALL SUBOPT_0xE
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0xA9
; 0001 087D         hc(3,43);ws("5.");wn164(AD[5]);
	CALL SUBOPT_0x85
	CALL SUBOPT_0xAA
	__POINTW1MN _0x20217,23
	CALL SUBOPT_0xE
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL SUBOPT_0xA9
; 0001 087E         hc(4,0) ;ws("6.");wn164(AD[6]);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x7
	__POINTW1MN _0x20217,26
	CALL SUBOPT_0xE
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0xA9
; 0001 087F         hc(4,43);ws("7.");wn164(AD[7]);
	CALL SUBOPT_0x83
	CALL SUBOPT_0xAA
	__POINTW1MN _0x20217,29
	CALL SUBOPT_0xE
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CALL SUBOPT_0xA9
; 0001 0880 
; 0001 0881         delay_ms(1000);
	CALL SUBOPT_0xB
; 0001 0882         }
	RJMP _0x20218
_0x2021A:
; 0001 0883 
; 0001 0884    }
	ADIW R28,16
	RET

	.DSEG
_0x20217:
	.BYTE 0x20
;
;//========================================================
; void outlcd1()
; 0001 0888  {

	.CSEG
_outlcd1:
; 0001 0889      LcdClear();
	CALL SUBOPT_0x8A
; 0001 088A      hc(0,5);
	CALL SUBOPT_0x73
	CALL _hc
; 0001 088B      ws("<SELF TEST>");
	__POINTW1MN _0x2021B,0
	CALL SUBOPT_0xE
; 0001 088C      hc(1,0);
	CALL SUBOPT_0x8B
; 0001 088D      ws("************");
	__POINTW1MN _0x2021B,12
	CALL SUBOPT_0xE
; 0001 088E  }
	RET

	.DSEG
_0x2021B:
	.BYTE 0x19
;//========================================================
;void chopledtheoid()
; 0001 0891 {    unsigned char i;

	.CSEG
_chopledtheoid:
; 0001 0892         DDRA=0xFF;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 0893 
; 0001 0894          switch (id)
	CALL SUBOPT_0xAB
; 0001 0895             {
; 0001 0896                 case 1:
	BRNE _0x2021F
; 0001 0897                     LEDR=1;
	SBI  0x15,5
; 0001 0898                     LEDL=1;PORTA.4=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,4
	CALL SUBOPT_0x49
	CALL _delay_ms
; 0001 0899                     LEDL=0;PORTA.4=0;delay_ms(30);
	CBI  0x15,4
	RJMP _0x202DE
; 0001 089A                 break;
; 0001 089B                 case 2:
_0x2021F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2022A
; 0001 089C                     LEDR=1;
	SBI  0x15,5
; 0001 089D                     LEDL=1;PORTA.6=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,6
	CALL SUBOPT_0x49
	CALL _delay_ms
; 0001 089E                     LEDL=0;PORTA.6=0;delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,6
	RJMP _0x202DF
; 0001 089F                 break;
; 0001 08A0                 case 3:
_0x2022A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20235
; 0001 08A1                     LEDR=1;
	SBI  0x15,5
; 0001 08A2                     LEDL=1;PORTA.7=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,7
	CALL SUBOPT_0x49
	CALL _delay_ms
; 0001 08A3                     LEDL=0;PORTA.7=0;delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,7
	RJMP _0x202DF
; 0001 08A4                 break;
; 0001 08A5                 case 4:
_0x20235:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20240
; 0001 08A6                     LEDR=1;
	SBI  0x15,5
; 0001 08A7                     LEDL=1;PORTA.5=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,5
	CALL SUBOPT_0x49
	CALL _delay_ms
; 0001 08A8                     LEDL=0;PORTA.5=0;delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,5
	RJMP _0x202DF
; 0001 08A9                 break;
; 0001 08AA                 case 5:
_0x20240:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2024B
; 0001 08AB                     LEDL=1;
	SBI  0x15,4
; 0001 08AC                     LEDR=1;PORTA.4=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,4
	CALL SUBOPT_0x49
	CALL _delay_ms
; 0001 08AD                     LEDR=0;PORTA.4=0;delay_ms(30);
	RJMP _0x202E0
; 0001 08AE                 break;
; 0001 08AF                 case 6:
_0x2024B:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20256
; 0001 08B0                     LEDL=1;
	SBI  0x15,4
; 0001 08B1                     LEDR=1;PORTA.6=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,6
	CALL SUBOPT_0x49
	CALL _delay_ms
; 0001 08B2                     LEDR=0;PORTA.6=0;delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,6
	RJMP _0x202DF
; 0001 08B3                 break;
; 0001 08B4                 case 7:
_0x20256:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x20261
; 0001 08B5                     LEDL=1;
	SBI  0x15,4
; 0001 08B6                     LEDR=1;PORTA.7=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,7
	CALL SUBOPT_0x49
	CALL _delay_ms
; 0001 08B7                     LEDR=0;PORTA.7=0;delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,7
	RJMP _0x202DF
; 0001 08B8                 break;
; 0001 08B9                 case 8:
_0x20261:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2026C
; 0001 08BA                     LEDL=1;
	SBI  0x15,4
; 0001 08BB                     LEDR=1;PORTA.5=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,5
	CALL SUBOPT_0x49
	CALL _delay_ms
; 0001 08BC                     LEDR=0;PORTA.5=0;delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,5
	RJMP _0x202DF
; 0001 08BD                 break;
; 0001 08BE                 case 9:
_0x2026C:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x2021E
; 0001 08BF                     LEDL=1;LEDR=1;PORTA.4=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x15,5
	SBI  0x1B,4
	CALL SUBOPT_0x49
	CALL _delay_ms
; 0001 08C0                     LEDL=0;LEDR=0;PORTA.4=0;delay_ms(30);
	CBI  0x15,4
_0x202E0:
	CBI  0x15,5
_0x202DE:
	CBI  0x1B,4
_0x202DF:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0xAC
; 0001 08C1                 break;
; 0001 08C2             };
_0x2021E:
; 0001 08C3         //LEDL=1;delay_ms(100);
; 0001 08C4         //LEDL=0;delay_ms(100);
; 0001 08C5         //for(i=0;i<id;i++)
; 0001 08C6         //{
; 0001 08C7         //    LEDR=1;delay_ms(150);
; 0001 08C8         //    LEDR=0;delay_ms(150);
; 0001 08C9         //}
; 0001 08CA }
	LD   R17,Y+
	RET
;//========================================================
;//========================================================
;void testRCservo()
; 0001 08CE {
_testRCservo:
; 0001 08CF         clear();
	CALL _clear
; 0001 08D0         hc(0,10);
	CALL SUBOPT_0x88
	CALL SUBOPT_0x49
	CALL _hc
; 0001 08D1         ws ("RC SERVO");
	__POINTW1MN _0x20284,0
	CALL SUBOPT_0xE
; 0001 08D2 // Timer/Counter 0 initialization
; 0001 08D3 // Clock source: System Clock
; 0001 08D4 // Clock value: 7.813 kHz
; 0001 08D5 // Mode: Phase correct PWM top=0xFF
; 0001 08D6 // OC0 output: Non-Inverted PWM
; 0001 08D7 TCCR0=0x65;     //15.32Hz
	LDI  R30,LOW(101)
	CALL SUBOPT_0xAD
; 0001 08D8 TCNT0=0x00;
; 0001 08D9 OCR0=0x00;
; 0001 08DA 
; 0001 08DB // Timer/Counter 2 initialization
; 0001 08DC // Clock source: System Clock
; 0001 08DD // Clock value: 7.813 kHz
; 0001 08DE // Mode: Phase correct PWM top=0xFF
; 0001 08DF // OC2 output: Non-Inverted PWM
; 0001 08E0 ASSR=0x00;      //15.32Hz
; 0001 08E1 TCCR2=0x67;
	LDI  R30,LOW(103)
	OUT  0x25,R30
; 0001 08E2 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0001 08E3 OCR2=0x00;
	OUT  0x23,R30
; 0001 08E4 
; 0001 08E5   while(keyKT!=0)
_0x20285:
	SBIS 0x13,0
	RJMP _0x20287
; 0001 08E6    {
; 0001 08E7    LEDL=1;LEDR=1;//PORTB.3=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 08E8    OCR0=2; OCR2=2;
	LDI  R30,LOW(2)
	OUT  0x3C,R30
	OUT  0x23,R30
; 0001 08E9    delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0xAC
; 0001 08EA 
; 0001 08EB    LEDL=0;LEDR=0;//PORTB.3=1;
	CBI  0x15,4
	CBI  0x15,5
; 0001 08EC    OCR0=10; OCR2=10;
	LDI  R30,LOW(10)
	OUT  0x3C,R30
	OUT  0x23,R30
; 0001 08ED    delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0xAC
; 0001 08EE    }
	RJMP _0x20285
_0x20287:
; 0001 08EF // Timer/Counter 0 initialization
; 0001 08F0 // Clock source: System Clock
; 0001 08F1 // Clock value: Timer 0 Stopped
; 0001 08F2 // Mode: Normal top=0xFF
; 0001 08F3 // OC0 output: Disconnected
; 0001 08F4 TCCR0=0x00;
	LDI  R30,LOW(0)
	CALL SUBOPT_0xAD
; 0001 08F5 TCNT0=0x00;
; 0001 08F6 OCR0=0x00;
; 0001 08F7 
; 0001 08F8 // Timer/Counter 2 initialization
; 0001 08F9 // Clock source: System Clock
; 0001 08FA // Clock value: Timer2 Stopped
; 0001 08FB // Mode: Normal top=0xFF
; 0001 08FC // OC2 output: Disconnected
; 0001 08FD ASSR =0x00;
; 0001 08FE TCCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0001 08FF TCNT2=0x00;
	OUT  0x24,R30
; 0001 0900 OCR2 =0x00;
	OUT  0x23,R30
; 0001 0901 
; 0001 0902 }
	RET

	.DSEG
_0x20284:
	.BYTE 0x9
;
;void selftest()
; 0001 0905 {

	.CSEG
_selftest:
; 0001 0906     outlcd1();
	CALL SUBOPT_0xAE
; 0001 0907     hc(2,0);
; 0001 0908     ws ("1.ROBOT WALL");delay_ms(200);
	__POINTW1MN _0x20290,0
	CALL SUBOPT_0xE
	CALL SUBOPT_0x89
; 0001 0909      while(flagselftest==1)
_0x20291:
	LDS  R26,_flagselftest
	LDS  R27,_flagselftest+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x20293
; 0001 090A      {
; 0001 090B         //------------------------------------------------------------------------
; 0001 090C         //test menu kiem tra  robot
; 0001 090D          chopledtheoid();
	RCALL _chopledtheoid
; 0001 090E           if(keyKT==0)
	SBIC 0x13,0
	RJMP _0x20294
; 0001 090F             {
; 0001 0910                 id++;
	LDS  R30,_id
	SUBI R30,-LOW(1)
	STS  _id,R30
; 0001 0911                 if(id>11){id=1;}
	LDS  R26,_id
	CPI  R26,LOW(0xC)
	BRLO _0x20295
	LDI  R30,LOW(1)
	STS  _id,R30
; 0001 0912                 switch (id)
_0x20295:
	CALL SUBOPT_0xAB
; 0001 0913                 {
; 0001 0914 
; 0001 0915                 case 1:
	BRNE _0x20299
; 0001 0916                     outlcd1();
	CALL SUBOPT_0xAE
; 0001 0917                     hc(2,0);
; 0001 0918                     ws ("1.ROBOT WALL");delay_ms(200);
	__POINTW1MN _0x20290,13
	RJMP _0x202E1
; 0001 0919                 break;
; 0001 091A                 case 2:
_0x20299:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2029A
; 0001 091B                     outlcd1();
	CALL SUBOPT_0xAE
; 0001 091C                     hc(2,0);
; 0001 091D                     ws ("2.BLUETOOTH ");delay_ms(200);
	__POINTW1MN _0x20290,26
	RJMP _0x202E1
; 0001 091E                 break;
; 0001 091F                 case 3:
_0x2029A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2029B
; 0001 0920                     outlcd1();
	CALL SUBOPT_0xAE
; 0001 0921                     hc(2,0);
; 0001 0922                     ws ("3.WHITE LINE");delay_ms(200);
	__POINTW1MN _0x20290,39
	RJMP _0x202E1
; 0001 0923                 break;
; 0001 0924                 case 4:
_0x2029B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2029C
; 0001 0925                     outlcd1();
	CALL SUBOPT_0xAE
; 0001 0926                     hc(2,0);
; 0001 0927                     ws ("4.BLACK LINE");delay_ms(200);
	__POINTW1MN _0x20290,52
	RJMP _0x202E1
; 0001 0928                 break;
; 0001 0929                 case 5:
_0x2029C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2029D
; 0001 092A                     outlcd1();
	CALL SUBOPT_0xAE
; 0001 092B                     hc(2,0);
; 0001 092C                     ws ("5.TEST MOTOR");delay_ms(200);
	__POINTW1MN _0x20290,65
	RJMP _0x202E1
; 0001 092D                 break;
; 0001 092E                 case 6:
_0x2029D:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2029E
; 0001 092F                     outlcd1();
	CALL SUBOPT_0xAE
; 0001 0930                     hc(2,0);
; 0001 0931                     ws ("6.TEST IR   ");delay_ms(200);
	__POINTW1MN _0x20290,78
	RJMP _0x202E1
; 0001 0932                 break;
; 0001 0933                 case 7:
_0x2029E:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2029F
; 0001 0934                     outlcd1();
	CALL SUBOPT_0xAE
; 0001 0935                     hc(2,0);
; 0001 0936                     ws ("7.TEST RF   ");delay_ms(200);
	__POINTW1MN _0x20290,91
	RJMP _0x202E1
; 0001 0937                 break;
; 0001 0938                 case 8:
_0x2029F:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x202A0
; 0001 0939                     outlcd1();
	CALL SUBOPT_0xAE
; 0001 093A                     hc(2,0);
; 0001 093B                     ws ("8.TEST UART ");delay_ms(200);
	__POINTW1MN _0x20290,104
	RJMP _0x202E1
; 0001 093C                 break;
; 0001 093D                 case 9:
_0x202A0:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x202A1
; 0001 093E                     outlcd1();
	CALL SUBOPT_0xAE
; 0001 093F                     hc(2,0);
; 0001 0940                     ws ("9.RC SERVO ");delay_ms(200);
	__POINTW1MN _0x20290,117
	RJMP _0x202E1
; 0001 0941                 break;
; 0001 0942                 case 10:
_0x202A1:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x20298
; 0001 0943                     outlcd1();
	CALL SUBOPT_0xAE
; 0001 0944                     hc(2,0);
; 0001 0945                     ws ("10.UPDATE RB");delay_ms(200);
	__POINTW1MN _0x20290,129
_0x202E1:
	ST   -Y,R31
	ST   -Y,R30
	CALL _ws
	CALL SUBOPT_0x89
; 0001 0946                 break;
; 0001 0947                 };
_0x20298:
; 0001 0948             }
; 0001 0949          if(keyKP==0)
_0x20294:
	SBIC 0x13,1
	RJMP _0x202A3
; 0001 094A             {
; 0001 094B                 switch (id)
	CALL SUBOPT_0xAB
; 0001 094C                 {
; 0001 094D                 case 1:
	BRNE _0x202A7
; 0001 094E                     robotwall() ;
	RCALL _robotwall
; 0001 094F                 break;
	RJMP _0x202A6
; 0001 0950                 case 2:
_0x202A7:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x202A8
; 0001 0951                     bluetooth() ;
	RCALL _bluetooth
; 0001 0952                 break;
	RJMP _0x202A6
; 0001 0953                 case 3:
_0x202A8:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x202A9
; 0001 0954                     robotwhiteline() ;
	RCALL _robotwhiteline
; 0001 0955                 break;
	RJMP _0x202A6
; 0001 0956                 case 4:
_0x202A9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x202AA
; 0001 0957                     robotblackline() ;
	RCALL _robotblackline
; 0001 0958                 break;
	RJMP _0x202A6
; 0001 0959                 case 5:
_0x202AA:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x202AB
; 0001 095A                     testmotor() ;
	RCALL _testmotor
; 0001 095B                 break;
	RJMP _0x202A6
; 0001 095C                 case 6:
_0x202AB:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x202AC
; 0001 095D                     testir()    ;
	RCALL _testir
; 0001 095E                 break;
	RJMP _0x202A6
; 0001 095F                 case 7:
_0x202AC:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x202AD
; 0001 0960                     testrf()    ;
	RCALL _testrf
; 0001 0961                 break;
	RJMP _0x202A6
; 0001 0962                 case 8:
_0x202AD:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x202AE
; 0001 0963                     testuart()  ;
	RCALL _testuart
; 0001 0964                 break;
	RJMP _0x202A6
; 0001 0965                 case 9:
_0x202AE:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x202AF
; 0001 0966                     testRCservo()  ;
	RCALL _testRCservo
; 0001 0967                 break;
	RJMP _0x202A6
; 0001 0968                 case 10:
_0x202AF:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x202A6
; 0001 0969                     testposition() ;
	CALL _testposition
; 0001 096A                 break;
; 0001 096B 
; 0001 096C                 };
_0x202A6:
; 0001 096D 
; 0001 096E             }
; 0001 096F 
; 0001 0970 
; 0001 0971      }//end while(1)
_0x202A3:
	RJMP _0x20291
_0x20293:
; 0001 0972 }
	RET

	.DSEG
_0x20290:
	.BYTE 0x8E
;//========================================================
;//          HAM MAIN
;//========================================================
;void main(void)
; 0001 0977 {

	.CSEG
_main:
; 0001 0978     unsigned char flagreadrb;
; 0001 0979     unsigned int adctest;
; 0001 097A     unsigned char i;
; 0001 097B     float pidl,pidr,pl,il,pr,ir,ur,ul;
; 0001 097C 
; 0001 097D     //------------- khai  bao chuc nang in out cua cac port
; 0001 097E     DDRA    = 0xFF;
	SBIW R28,32
;	flagreadrb -> R17
;	adctest -> R18,R19
;	i -> R16
;	pidl -> Y+28
;	pidr -> Y+24
;	pl -> Y+20
;	il -> Y+16
;	pr -> Y+12
;	ir -> Y+8
;	ur -> Y+4
;	ul -> Y+0
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 097F     DDRB    = 0b10111111;
	LDI  R30,LOW(191)
	OUT  0x17,R30
; 0001 0980     DDRC    = 0b11111100;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0001 0981     DDRD    = 0b11110010;
	LDI  R30,LOW(242)
	OUT  0x11,R30
; 0001 0982 
; 0001 0983     //------------- khai  bao chuc nang cua adc
; 0001 0984     // ADC initialization
; 0001 0985     // ADC Clock frequency: 1000.000 kHz
; 0001 0986     // ADC Voltage Reference: AVCC pin
; 0001 0987     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0001 0988     ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0001 0989     //---------------------------------------------------------------------
; 0001 098A     //------------- khai  bao chuc nang cua bo timer dung lam PWM cho 2 dong co
; 0001 098B     // Timer/Counter 1 initialization
; 0001 098C     // Clock source: System Clock
; 0001 098D     // Clock value: 1000.000 kHz   //PWM 2KHz
; 0001 098E     // Mode: Ph. correct PWM top=0x00FF
; 0001 098F     // OC1A output: Non-Inv.
; 0001 0990     // OC1B output: Non-Inv.
; 0001 0991     // Noise Canceler: Off
; 0001 0992     // Input Capture on Falling Edge
; 0001 0993     // Timer1 Overflow Interrupt: On  // voi period =1/2khz= 0.5ms
; 0001 0994     // Input Capture Interrupt: Off
; 0001 0995     // Compare A Match Interrupt: Off
; 0001 0996     // Compare B Match Interrupt: Off
; 0001 0997     TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0001 0998     TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0001 0999     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0001 099A     TCNT1L=0x00;
	OUT  0x2C,R30
; 0001 099B     ICR1H=0x00;
	OUT  0x27,R30
; 0001 099C     ICR1L=0x00;
	OUT  0x26,R30
; 0001 099D     OCR1AH=0x00;
	OUT  0x2B,R30
; 0001 099E     OCR1AL=0x00;
	OUT  0x2A,R30
; 0001 099F     OCR1BH=0x00;
	OUT  0x29,R30
; 0001 09A0     OCR1BL=0x00;
	OUT  0x28,R30
; 0001 09A1     // Timer(s)/Counter(s) Interrupt(s) initialization  timer0
; 0001 09A2     TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0001 09A3 
; 0001 09A4     //OCR1A=0-255; MOTOR LEFT
; 0001 09A5     //OCR1B=0-255; MOTOR RIGHT
; 0001 09A6     for(i=0;i<1;i++)
	LDI  R16,LOW(0)
_0x202B2:
	CPI  R16,1
	BRSH _0x202B3
; 0001 09A7     {
; 0001 09A8         LEDL=1; LEDR=1;
	CALL SUBOPT_0xA7
; 0001 09A9         delay_ms(100);
; 0001 09AA         LEDL=0; LEDR=0;
; 0001 09AB         delay_ms(100);
; 0001 09AC     }
	SUBI R16,-1
	RJMP _0x202B2
_0x202B3:
; 0001 09AD 
; 0001 09AE     //khai  bao su dung cua glcd
; 0001 09AF     SPIinit();
	CALL _SPIinit
; 0001 09B0     LCDinit();
	CALL _LCDinit
; 0001 09B1 
; 0001 09B2     // khai  bao su dung rf dung de cap nhat gia tri vi tri cua robot
; 0001 09B3     init_NRF24L01();
	CALL _init_NRF24L01
; 0001 09B4     SetRX_Mode();  // chon kenh tan so phat, va dia chi phat trong file nRF14l01.c
	CALL _SetRX_Mode
; 0001 09B5     // khai bao su dung encoder
; 0001 09B6     initencoder(); //lay 2 canh len  xuong
	CALL _initencoder
; 0001 09B7     // khai bao su dung uart
; 0001 09B8     inituart();
	CALL _inituart
; 0001 09B9     #asm("sei")
	sei
; 0001 09BA 
; 0001 09BB     //man hinh khoi dong robokit
; 0001 09BC     hc(0,10);
	CALL SUBOPT_0x88
	CALL SUBOPT_0x49
	CALL _hc
; 0001 09BD     ws("<AKBOTKIT>");
	__POINTW1MN _0x202BC,0
	CALL SUBOPT_0xE
; 0001 09BE     hc(1,0);
	CALL SUBOPT_0x8B
; 0001 09BF     ws("************");
	__POINTW1MN _0x202BC,11
	CALL SUBOPT_0xE
; 0001 09C0 
; 0001 09C1     //robotwhiteline();
; 0001 09C2     //robotblackline();
; 0001 09C3     //kiem tra neu nhan va giu nut trai se vao chuong trinh selftest (kiem tra hoat dong cua robot)
; 0001 09C4     while (keyKT==0)
_0x202BD:
	SBIC 0x13,0
	RJMP _0x202BF
; 0001 09C5     {
; 0001 09C6       cntselftest++;
	LDI  R26,LOW(_cntselftest)
	LDI  R27,HIGH(_cntselftest)
	CALL SUBOPT_0x6B
; 0001 09C7       if(cntselftest>10)
	LDS  R26,_cntselftest
	LDS  R27,_cntselftest+1
	SBIW R26,11
	BRLO _0x202C0
; 0001 09C8       {
; 0001 09C9            while (keyKT==0);//CHO NHA NUT AN
_0x202C1:
	SBIS 0x13,0
	RJMP _0x202C1
; 0001 09CA            cntselftest=0;
	LDI  R30,LOW(0)
	STS  _cntselftest,R30
	STS  _cntselftest+1,R30
; 0001 09CB            flagselftest=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _flagselftest,R30
	STS  _flagselftest+1,R31
; 0001 09CC            selftest();
	RCALL _selftest
; 0001 09CD       }
; 0001 09CE       delay_ms(100);
_0x202C0:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0xAC
; 0001 09CF     }
	RJMP _0x202BD
_0x202BF:
; 0001 09D0 
; 0001 09D1     // vao chuong trinh chinh sau khi bo qua phan selftest
; 0001 09D2     hc(2,0);
	CALL SUBOPT_0xA8
; 0001 09D3     ws("MAIN PROGRAM");
	__POINTW1MN _0x202BC,24
	CALL SUBOPT_0xE
; 0001 09D4     settoadoHomRB();
	CALL _settoadoHomRB
; 0001 09D5     // code you here
; 0001 09D6     while (1)
_0x202C4:
; 0001 09D7     {
; 0001 09D8      //LEDR=!LEDR;
; 0001 09D9      //PHUC
; 0001 09DA ////     //=========================================================   PHUC ID
; 0001 09DB //         chay theo banh co dinh huong tan cong
; 0001 09DC         readposition();
	CALL _readposition
; 0001 09DD         calcvitri(0,0);    // de xac dinh huong tan cong
	CALL SUBOPT_0xAF
	CALL __PUTPARD1
	CALL SUBOPT_0xAF
	CALL SUBOPT_0x4D
; 0001 09DE 
; 0001 09DF         //flagtancong=1;
; 0001 09E0         if(flagtancong==1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x202C7
; 0001 09E1         {
; 0001 09E2             flagtask=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x78
; 0001 09E3             rb_wait(50);
	__GETD1N 0x32
	RJMP _0x202E2
; 0001 09E4 
; 0001 09E5         }else
_0x202C7:
; 0001 09E6         {
; 0001 09E7             if(offsetphongthu<0)    offsetphongthu=-offsetphongthu;//lay do lon
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x202C9
	MOVW R30,R6
	CALL __ANEGW1
	MOVW R6,R30
; 0001 09E8             if(robotctrl.ball.y <= 0)
_0x202C9:
	__GETW2MN _robotctrl,12
	CALL __CPW02
	BRLT _0x202CA
; 0001 09E9             {
; 0001 09EA                 setRobotX = robotctrl.ball.x;
	CALL SUBOPT_0x84
	CALL SUBOPT_0xB0
; 0001 09EB                 setRobotY = robotctrl.ball.y + offsetphongthu;
	ADD  R30,R6
	ADC  R31,R7
	RJMP _0x202E3
; 0001 09EC 
; 0001 09ED                 flagtask=0;
; 0001 09EE                 rb_wait(200);
; 0001 09EF 
; 0001 09F0             }else
_0x202CA:
; 0001 09F1             {
; 0001 09F2                 setRobotX = robotctrl.ball.x;
	CALL SUBOPT_0x84
	CALL SUBOPT_0xB0
; 0001 09F3                 setRobotY = robotctrl.ball.y - offsetphongthu;
	SUB  R30,R6
	SBC  R31,R7
_0x202E3:
	LDI  R26,LOW(_setRobotY)
	LDI  R27,HIGH(_setRobotY)
	CALL SUBOPT_0x16
	CALL __PUTDP1
; 0001 09F4 
; 0001 09F5                 flagtask=0;
	LDI  R30,LOW(0)
	STS  _flagtask,R30
	STS  _flagtask+1,R30
; 0001 09F6                 rb_wait(200);
	CALL SUBOPT_0xB1
; 0001 09F7 
; 0001 09F8             }
; 0001 09F9 
; 0001 09FA              setRobotX = robotctrl.ball.x+offsetphongthu;
	CALL SUBOPT_0x84
	ADD  R30,R6
	ADC  R31,R7
	CALL SUBOPT_0xB0
; 0001 09FB              setRobotY = robotctrl.ball.y;
	LDI  R26,LOW(_setRobotY)
	LDI  R27,HIGH(_setRobotY)
	CALL SUBOPT_0x16
	CALL __PUTDP1
; 0001 09FC              rb_wait(200);
	CALL SUBOPT_0xB1
; 0001 09FD              rb_goball();
	CALL _rb_goball
; 0001 09FE              rb_wait(200);
	__GETD1N 0xC8
_0x202E2:
	CALL __PUTPARD1
	CALL _rb_wait
; 0001 09FF 
; 0001 0A00 
; 0001 0A01         }
; 0001 0A02         ctrrobot();// can phai luon luon chay de dieu khien robot
	CALL _ctrrobot
; 0001 0A03      } //end while(1)
	RJMP _0x202C4
; 0001 0A04 }
_0x202CC:
	RJMP _0x202CC

	.DSEG
_0x202BC:
	.BYTE 0x25
;

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_spi:
	LD   R30,Y
	OUT  0xF,R30
_0x2020003:
	SBIS 0xE,7
	RJMP _0x2020003
	IN   R30,0xF
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0xB2
    brne __floor1
__floor0:
	CALL SUBOPT_0x79
	RJMP _0x20C0002
__floor1:
    brtc __floor0
	CALL SUBOPT_0xB3
	RJMP _0x20C0004
_ceil:
	CALL SUBOPT_0xB2
    brne __ceil1
__ceil0:
	CALL SUBOPT_0x79
	RJMP _0x20C0002
__ceil1:
    brts __ceil0
	CALL SUBOPT_0xB3
	CALL __ADDF12
	RJMP _0x20C0002
_fmod:
	CALL SUBOPT_0xB4
	CALL __CPD10
	BRNE _0x2060005
	CALL SUBOPT_0xAF
	RJMP _0x20C0001
_0x2060005:
	CALL SUBOPT_0xB5
	CALL SUBOPT_0x79
	CALL __CPD10
	BRNE _0x2060006
	CALL SUBOPT_0xAF
	RJMP _0x20C0001
_0x2060006:
	CALL SUBOPT_0x33
	CALL __CPD02
	BRGE _0x2060007
	CALL SUBOPT_0xB6
	RCALL _floor
	RJMP _0x2060033
_0x2060007:
	CALL SUBOPT_0xB6
	RCALL _ceil
_0x2060033:
	CALL __PUTD1S0
	CALL SUBOPT_0x79
	CALL SUBOPT_0x2F
	CALL __MULF12
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xB7
	RJMP _0x20C0001
_sin:
	CALL SUBOPT_0xB8
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBA
	CALL __PUTPARD1
	RCALL _floor
	CALL SUBOPT_0xBB
	CALL SUBOPT_0xB7
	CALL SUBOPT_0xB9
	CALL SUBOPT_0xBC
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2060017
	CALL SUBOPT_0xBA
	__GETD2N 0x3F000000
	CALL __SUBF12
	CALL SUBOPT_0xB9
	LDI  R17,LOW(1)
_0x2060017:
	CALL SUBOPT_0xBB
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2060018
	CALL SUBOPT_0xBC
	CALL __SUBF12
	CALL SUBOPT_0xB9
_0x2060018:
	CPI  R17,0
	BREQ _0x2060019
	CALL SUBOPT_0xBD
_0x2060019:
	CALL SUBOPT_0xBE
	__PUTD1S 1
	CALL SUBOPT_0xBF
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL SUBOPT_0xB7
	CALL SUBOPT_0xC0
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0xBB
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xBF
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0xC0
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RJMP _0x20C0005
_cos:
	CALL SUBOPT_0x33
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	CALL __PUTPARD1
	RCALL _sin
	RJMP _0x20C0002
_xatan:
	CALL SUBOPT_0xB4
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x17
	__GETD2N 0x40CBD065
	CALL SUBOPT_0xC1
	CALL SUBOPT_0x2F
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x79
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x33
	CALL SUBOPT_0xC1
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x33
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2060020
	CALL SUBOPT_0xB6
	RCALL _xatan
	RJMP _0x20C0002
_0x2060020:
	CALL SUBOPT_0x33
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2060021
	CALL SUBOPT_0xB3
	CALL SUBOPT_0xC2
	RJMP _0x20C0003
_0x2060021:
	CALL SUBOPT_0xB3
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB3
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xC2
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	RJMP _0x20C0002
_asin:
	CALL SUBOPT_0xB8
	CALL SUBOPT_0xC3
	BRLO _0x2060023
	CALL SUBOPT_0xBB
	CALL SUBOPT_0xC4
	BREQ PC+4
	BRCS PC+3
	JMP  _0x2060023
	RJMP _0x2060022
_0x2060023:
	CALL SUBOPT_0xC5
	RJMP _0x20C0005
_0x2060022:
	LDD  R26,Y+8
	TST  R26
	BRPL _0x2060025
	CALL SUBOPT_0xBD
	LDI  R17,LOW(1)
_0x2060025:
	CALL SUBOPT_0xBE
	__GETD2N 0x3F800000
	CALL SUBOPT_0xB7
	CALL __PUTPARD1
	CALL _sqrt
	__PUTD1S 1
	CALL SUBOPT_0xBB
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2060026
	CALL SUBOPT_0xBA
	__GETD2S 1
	CALL SUBOPT_0xC6
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0xB7
	RJMP _0x2060035
_0x2060026:
	CALL SUBOPT_0xBF
	CALL SUBOPT_0xBB
	CALL SUBOPT_0xC6
_0x2060035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2060028
	CALL SUBOPT_0xBF
	CALL __ANEGF1
	RJMP _0x20C0005
_0x2060028:
	CALL SUBOPT_0xBF
_0x20C0005:
	LDD  R17,Y+0
	ADIW R28,9
	RET
_acos:
	CALL SUBOPT_0x33
	CALL SUBOPT_0xC3
	BRLO _0x206002A
	CALL SUBOPT_0x33
	CALL SUBOPT_0xC4
	BREQ PC+4
	BRCS PC+3
	JMP  _0x206002A
	RJMP _0x2060029
_0x206002A:
	CALL SUBOPT_0xC5
	RJMP _0x20C0002
_0x2060029:
	CALL SUBOPT_0xB6
	RCALL _asin
_0x20C0003:
	__GETD2N 0x3FC90FDB
	CALL __SWAPD12
_0x20C0004:
	CALL __SUBF12
_0x20C0002:
	ADIW R28,4
	RET
_atan2:
	CALL SUBOPT_0xB4
	CALL __CPD10
	BRNE _0x206002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x206002E
	CALL SUBOPT_0xC5
	RJMP _0x20C0001
_0x206002E:
	CALL SUBOPT_0xA2
	CALL __CPD02
	BRGE _0x206002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20C0001
_0x206002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20C0001
_0x206002D:
	CALL SUBOPT_0xB5
	CALL SUBOPT_0x2F
	CALL __CPD02
	BRGE _0x2060030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2060031
	CALL SUBOPT_0xB6
	RCALL _yatan
	RJMP _0x20C0001
_0x2060031:
	CALL SUBOPT_0xC7
	CALL __ANEGF1
	RJMP _0x20C0001
_0x2060030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2060032
	CALL SUBOPT_0xC7
	__GETD2N 0x40490FDB
	CALL SUBOPT_0xB7
	RJMP _0x20C0001
_0x2060032:
	CALL SUBOPT_0xB6
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x20C0001:
	ADIW R28,12
	RET

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_TX_ADDRESS:
	.BYTE 0x5
_RX_ADDRESS:
	.BYTE 0x5
_rb:
	.BYTE 0x1C
_robot11:
	.BYTE 0xE
_robot12:
	.BYTE 0xE
_robot13:
	.BYTE 0xE
_robot21:
	.BYTE 0xE
_robot22:
	.BYTE 0xE
_robot23:
	.BYTE 0xE
_robotctrl:
	.BYTE 0xE
_errangle:
	.BYTE 0x4
_distance:
	.BYTE 0x4
_orentation:
	.BYTE 0x4
_RxBuf:
	.BYTE 0x20
_setRobotX:
	.BYTE 0x4
_setRobotY:
	.BYTE 0x4
_setRobotXmin:
	.BYTE 0x4
_setRobotXmax:
	.BYTE 0x4
_setRobotAngleX:
	.BYTE 0x4
_setRobotAngleY:
	.BYTE 0x4
_offestsanco:
	.BYTE 0x4
_rbctrlHomeX:
	.BYTE 0x4
_rbctrlHomeY:
	.BYTE 0x4
_rbctrlPenaltyX:
	.BYTE 0x4
_rbctrlPenaltyY:
	.BYTE 0x4
_rbctrlPenaltyAngle:
	.BYTE 0x4
_rbctrlHomeAngle:
	.BYTE 0x4
_cntsethomeRB:
	.BYTE 0x2
_cntstuckRB:
	.BYTE 0x2
_cntunlookRB:
	.BYTE 0x2
_flagsethome:
	.BYTE 0x2
_flagselftest:
	.BYTE 0x2
_cntselftest:
	.BYTE 0x2
_id:
	.BYTE 0x1
_IRFL:
	.BYTE 0x2
_IRFR:
	.BYTE 0x2
_IRLINE:
	.BYTE 0xA
_timerstick:
	.BYTE 0x2
_timerstickdis:
	.BYTE 0x2
_timerstickang:
	.BYTE 0x2
_timerstickctr:
	.BYTE 0x2
_vQEL:
	.BYTE 0x2
_vQER:
	.BYTE 0x2
_oldQEL:
	.BYTE 0x2
_oldQER:
	.BYTE 0x2
_svQEL:
	.BYTE 0x2
_svQER:
	.BYTE 0x2
_seRki_G001:
	.BYTE 0x2
_seLki_G001:
	.BYTE 0x2
_uL:
	.BYTE 0x2
_uR:
	.BYTE 0x2
_KpR:
	.BYTE 0x2
_KiR:
	.BYTE 0x2
_KpL:
	.BYTE 0x2
_KiL:
	.BYTE 0x2
_sd:
	.BYTE 0x2
_oldd:
	.BYTE 0x2
_flagwaitctrRobot:
	.BYTE 0x1
_sa:
	.BYTE 0x2
_olda:
	.BYTE 0x2
_flagwaitctrAngle:
	.BYTE 0x1
_flagtask:
	.BYTE 0x2
_flagtaskold:
	.BYTE 0x2
_flaghuongtrue:
	.BYTE 0x2
_verranglekisum:
	.BYTE 0x2
_QEL:
	.BYTE 0x2
_QER:
	.BYTE 0x2
_rx_buffer:
	.BYTE 0x8
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_tx_buffer:
	.BYTE 0x8
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _SPI_Write_Buf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	CALL _SPI_RW
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	CALL _LcdWrite
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _LcdWrite
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+3
	LDI  R31,0
	SBIW R30,32
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __MULW12U
	SUBI R30,LOW(-_ASCII*2)
	SBCI R31,HIGH(-_ASCII*2)
	ADD  R30,R16
	ADC  R31,R17
	LPM  R30,Z
	ST   -Y,R30
	JMP  _LcdWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _LcdWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x9:
	MOVW R26,R28
	ADIW R26,1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	SUB  R30,R26
	SBC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn16

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _ws

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	STS  _seRki_G001,R30
	STS  _seRki_G001+1,R30
	STS  _seLki_G001,R30
	STS  _seLki_G001+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LD   R30,Y
	LDI  R31,0
	STS  _svQEL,R30
	STS  _svQEL+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _flagwaitctrAngle,R30
	LDI  R30,LOW(1)
	STS  _flagwaitctrRobot,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	STS  _sd,R30
	STS  _sd+1,R31
	LDS  R30,_QER
	LDS  R31,_QER+1
	LDS  R26,_QEL
	LDS  R27,_QEL+1
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R26
	LSR  R31
	ROR  R30
	STS  _oldd,R30
	STS  _oldd+1,R31
	LD   R30,Y
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x16:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	CALL __MULF12
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x18:
	LDS  R30,_QEL
	LDS  R31,_QEL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	__GETD1S 28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	__GETD1S 32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	__GETD1S 36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	__GETD1S 44
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	LDS  R30,_rb
	LDS  R31,_rb+1
	LDS  R22,_rb+2
	LDS  R23,_rb+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x1D
	CALL __CFD1
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(_rb)
	LDI  R31,HIGH(_rb)
	LDI  R26,28
	CALL __PUTPARL
	JMP  _convertRobot2IntRobot

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	__GETW2MN _robotctrl,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	__GETW2MN _robotctrl,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x16
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__GETD2S 40
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__GETD2S 36
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	CALL __ADDF12
	CALL __PUTPARD1
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	__GETD2S 32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	__GETD2S 28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	__PUTD1S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	CALL __ADDF12
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	__GETD2S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	RCALL SUBOPT_0x1B
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	RCALL SUBOPT_0x1C
	CALL __PUTPARD1
	JMP  _atan2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x30:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	__GETD2N 0x43340000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x33:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	__GETD1N 0x40490FDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x35:
	LDS  R30,_errangle
	LDS  R31,_errangle+1
	LDS  R22,_errangle+2
	LDS  R23,_errangle+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	LDS  R26,_orentation
	LDS  R27,_orentation+1
	LDS  R24,_orentation+2
	LDS  R25,_orentation+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	OUT  0x1B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _read_adc
	STS  _IRFL,R30
	STS  _IRFL+1,R31
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _read_adc
	STS  _IRFR,R30
	STS  _IRFR+1,R31
	LDS  R26,_IRFL
	LDS  R27,_IRFL+1
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x3A:
	LDS  R26,_IRFR
	LDS  R27,_IRFR+1
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3B:
	LDI  R30,LOW(22)
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(22)
	ST   -Y,R30
	CALL _vMRlui
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x3C:
	LDS  R26,_IRFL
	LDS  R27,_IRFL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _vMLlui

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3E:
	ST   -Y,R30
	CALL _vMRlui
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3F:
	LDS  R26,_IRFR
	LDS  R27,_IRFR+1
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x40:
	RCALL SUBOPT_0x3C
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	ST   -Y,R30
	CALL _vMLlui
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	RCALL SUBOPT_0x3C
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x43:
	LDI  R30,LOW(22)
	ST   -Y,R30
	CALL _vMRlui
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x44:
	ST   -Y,R30
	CALL _vMRlui
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x46:
	CALL _readposition
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _read_adc
	STS  _IRFL,R30
	STS  _IRFL+1,R31
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _read_adc
	STS  _IRFR,R30
	STS  _IRFR+1,R31
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(20)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4B:
	LDI  R30,LOW(0)
	STS  _flagsethome,R30
	STS  _flagsethome+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4D:
	CALL __PUTPARD1
	JMP  _calcvitri

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x4E:
	LDS  R26,_distance
	LDS  R27,_distance+1
	LDS  R24,_distance+2
	LDS  R25,_distance+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	__GETD1N 0x42C80000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:135 WORDS
SUBOPT_0x50:
	LDS  R26,_errangle
	LDS  R27,_errangle+1
	LDS  R24,_errangle+2
	LDS  R25,_errangle+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x51:
	__GETD1N 0x41900000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x52:
	RCALL SUBOPT_0x50
	__GETD1N 0xC1900000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:319 WORDS
SUBOPT_0x53:
	SBIW R28,4
	RCALL SUBOPT_0x50
	__GETD1N 0x41D80000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43340000
	CALL __DIVF21
	CALL __CFD1U
	STD  Y+2,R30
	STD  Y+2+1,R31
	RCALL SUBOPT_0x35
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	CALL _calcVangle
	ST   Y,R30
	STD  Y+1,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ctrRobotXoay
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x54:
	RCALL SUBOPT_0x4E
	__GETD1N 0x40A70A3D
	CALL __DIVF21
	CALL __CFD1U
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _ctrRobottoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x55:
	LDS  R26,_rbctrlHomeAngle
	LDS  R27,_rbctrlHomeAngle+1
	LDS  R24,_rbctrlHomeAngle+2
	LDS  R25,_rbctrlHomeAngle+3
	RCALL SUBOPT_0x34
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43340000
	CALL __DIVF21
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x56:
	CALL _cos
	__GETD2N 0x41200000
	CALL __MULF12
	STS  _setRobotAngleX,R30
	STS  _setRobotAngleX+1,R31
	STS  _setRobotAngleX+2,R22
	STS  _setRobotAngleX+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x57:
	CALL _sin
	__GETD2N 0x41200000
	CALL __MULF12
	STS  _setRobotAngleY,R30
	STS  _setRobotAngleY+1,R31
	STS  _setRobotAngleY+2,R22
	STS  _setRobotAngleY+3,R23
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x58:
	LDS  R30,_setRobotAngleX
	LDS  R31,_setRobotAngleX+1
	LDS  R22,_setRobotAngleX+2
	LDS  R23,_setRobotAngleX+3
	CALL __CWD2
	CALL __CDF2
	CALL __ADDF12
	CALL __PUTPARD1
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x59:
	LDS  R30,_setRobotAngleY
	LDS  R31,_setRobotAngleY+1
	LDS  R22,_setRobotAngleY+2
	LDS  R23,_setRobotAngleY+3
	CALL __CWD2
	CALL __CDF2
	CALL __ADDF12
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5A:
	LDI  R30,LOW(0)
	STS  _verranglekisum,R30
	STS  _verranglekisum+1,R30
	STS  _flaghuongtrue,R30
	STS  _flaghuongtrue+1,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _flagsethome,R30
	STS  _flagsethome+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5B:
	LDI  R26,LOW(_cntstuckRB)
	LDI  R27,HIGH(_cntstuckRB)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R26,_cntstuckRB
	LDS  R27,_cntstuckRB+1
	SBIW R26,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5C:
	LDI  R26,LOW(_cntunlookRB)
	LDI  R27,HIGH(_cntunlookRB)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R26,_cntunlookRB
	LDS  R27,_cntunlookRB+1
	SBIW R26,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5E:
	RCALL SUBOPT_0x50
	RJMP SUBOPT_0x51

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5F:
	LDS  R26,_rbctrlPenaltyAngle
	LDS  R27,_rbctrlPenaltyAngle+1
	LDS  R24,_rbctrlPenaltyAngle+2
	LDS  R25,_rbctrlPenaltyAngle+3
	RCALL SUBOPT_0x34
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43340000
	CALL __DIVF21
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	RCALL SUBOPT_0x1E
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	__GETD1N 0xC1200000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:157 WORDS
SUBOPT_0x62:
	LDI  R30,LOW(0)
	STS  _rbctrlPenaltyX,R30
	STS  _rbctrlPenaltyX+1,R30
	STS  _rbctrlPenaltyX+2,R30
	STS  _rbctrlPenaltyX+3,R30
	STS  _rbctrlPenaltyY,R30
	STS  _rbctrlPenaltyY+1,R30
	STS  _rbctrlPenaltyY+2,R30
	STS  _rbctrlPenaltyY+3,R30
	__GETD1N 0x43330000
	STS  _rbctrlPenaltyAngle,R30
	STS  _rbctrlPenaltyAngle+1,R31
	STS  _rbctrlPenaltyAngle+2,R22
	STS  _rbctrlPenaltyAngle+3,R23
	STS  _rbctrlHomeAngle,R30
	STS  _rbctrlHomeAngle+1,R31
	STS  _rbctrlHomeAngle+2,R22
	STS  _rbctrlHomeAngle+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x63:
	__GETD1N 0x4386D99A
	STS  _rbctrlHomeX,R30
	STS  _rbctrlHomeX+1,R31
	STS  _rbctrlHomeX+2,R22
	STS  _rbctrlHomeX+3,R23
	__GETD1N 0x3FD9999A
	STS  _rbctrlHomeY,R30
	STS  _rbctrlHomeY+1,R31
	STS  _rbctrlHomeY+2,R22
	STS  _rbctrlHomeY+3,R23
	__GETD1N 0x42A00000
	STS  _setRobotXmin,R30
	STS  _setRobotXmin+1,R31
	STS  _setRobotXmin+2,R22
	STS  _setRobotXmin+3,R23
	__GETD1N 0x43820000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x64:
	__GETD1N 0x42840000
	STS  _rbctrlHomeX,R30
	STS  _rbctrlHomeX+1,R31
	STS  _rbctrlHomeX+2,R22
	STS  _rbctrlHomeX+3,R23
	__GETD1N 0x429ECCCD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x65:
	__GETD1N 0xC3870000
	STS  _setRobotXmin,R30
	STS  _setRobotXmin+1,R31
	STS  _setRobotXmin+2,R22
	STS  _setRobotXmin+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x66:
	__GETD1N 0x43870000
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x67:
	STS  _rbctrlPenaltyAngle,R30
	STS  _rbctrlPenaltyAngle+1,R31
	STS  _rbctrlPenaltyAngle+2,R22
	STS  _rbctrlPenaltyAngle+3,R23
	__GETD1N 0x43330000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x68:
	__GETD1N 0x42586666
	STS  _rbctrlHomeX,R30
	STS  _rbctrlHomeX+1,R31
	STS  _rbctrlHomeX+2,R22
	STS  _rbctrlHomeX+3,R23
	__GETD1N 0xC2C7CCCD
	STS  _rbctrlHomeY,R30
	STS  _rbctrlHomeY+1,R31
	STS  _rbctrlHomeY+2,R22
	STS  _rbctrlHomeY+3,R23
	RJMP SUBOPT_0x65

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x69:
	LDS  R26,_verranglekisum
	LDS  R27,_verranglekisum+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	STS  _verranglekisum,R30
	STS  _verranglekisum+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x6B:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6C:
	LDS  R30,_setRobotXmin
	LDS  R31,_setRobotXmin+1
	LDS  R22,_setRobotXmin+2
	LDS  R23,_setRobotXmin+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6D:
	LDS  R26,_setRobotX
	LDS  R27,_setRobotX+1
	LDS  R24,_setRobotX+2
	LDS  R25,_setRobotX+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6E:
	STS  _setRobotX,R30
	STS  _setRobotX+1,R31
	STS  _setRobotX+2,R22
	STS  _setRobotX+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6F:
	LDS  R30,_setRobotXmax
	LDS  R31,_setRobotXmax+1
	LDS  R22,_setRobotXmax+2
	LDS  R23,_setRobotXmax+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x70:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _flagtask,R30
	STS  _flagtask+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	CALL __CWD2
	CALL __CDF2
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x72:
	__GETW1MN _robotctrl,10
	RCALL SUBOPT_0x16
	CALL __PUTPARD1
	__GETW1MN _robotctrl,12
	RCALL SUBOPT_0x16
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x74:
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x75:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x76:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _vMLtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x78:
	STS  _flagtask,R30
	STS  _flagtask+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x79:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	LDS  R30,_QER
	LDS  R31,_QER+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7B:
	LDS  R26,_seRki_G001
	LDS  R27,_seRki_G001+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7C:
	STS  _seRki_G001,R30
	STS  _seRki_G001+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7D:
	LDS  R26,_seLki_G001
	LDS  R27,_seLki_G001+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7E:
	STS  _seLki_G001,R30
	STS  _seLki_G001+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7F:
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x80:
	RCALL SUBOPT_0x18
	LDS  R26,_QER
	LDS  R27,_QER+1
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R26
	LSR  R31
	ROR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x81:
	__GETW1MN _robotctrl,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x82:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn16s

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x83:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x84:
	__GETW1MN _robotctrl,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x85:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x86:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x87:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x88:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x89:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8A:
	CALL _LcdClear
	RJMP SUBOPT_0x88

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8C:
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8D:
	ST   -Y,R30
	CALL _vMRlui
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8E:
	CALL _LEDLtoggle
	JMP  _LEDRtoggle

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x8F:
	MOVW R30,R16
	LDI  R26,LOW(_IRLINE)
	LDI  R27,HIGH(_IRLINE)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x90:
	__GETW2MN _IRLINE,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x91:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x92:
	CALL _readline
	__GETWRMN 20,21,0,_IRLINE
	LDI  R16,LOW(0)
	LDI  R17,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x93:
	MOV  R30,R17
	LDI  R26,LOW(_IRLINE)
	LDI  R27,HIGH(_IRLINE)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x94:
	ADD  R26,R30
	ADC  R27,R31
	LD   R20,X+
	LD   R21,X
	MOV  R16,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x95:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x96:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _vMLtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x97:
	LDI  R30,LOW(20)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x98:
	LDI  R30,LOW(15)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x99:
	LDI  R30,LOW(15)
	ST   -Y,R30
	JMP  _vMLtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9A:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9B:
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _vMLtoi
	RJMP SUBOPT_0x9A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9C:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9D:
	CALL _hc
	ST   -Y,R21
	ST   -Y,R20
	JMP  _wn16s

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x9E:
	CALL _readline
	LDS  R30,_IRLINE
	LDS  R31,_IRLINE+1
	STD  Y+35,R30
	STD  Y+35+1,R31
	__GETWRN 20,21,0
	__GETWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9F:
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA0:
	CALL _hc
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	RJMP SUBOPT_0x82

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA1:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA2:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA3:
	__GETD2S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA4:
	RCALL SUBOPT_0x29
	LDI  R30,LOW(0)
	__CLRD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA5:
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA6:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA7:
	SBI  0x15,4
	SBI  0x15,5
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CBI  0x15,4
	CBI  0x15,5
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xA8:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA9:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn164

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAA:
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	RJMP SUBOPT_0xA6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAB:
	LDS  R30,_id
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAC:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xAD:
	OUT  0x33,R30
	LDI  R30,LOW(0)
	OUT  0x32,R30
	OUT  0x3C,R30
	OUT  0x22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xAE:
	CALL _outlcd1
	RJMP SUBOPT_0xA8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAF:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB0:
	LDI  R26,LOW(_setRobotX)
	LDI  R27,HIGH(_setRobotX)
	RCALL SUBOPT_0x16
	CALL __PUTDP1
	RJMP SUBOPT_0x81

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB1:
	__GETD1N 0xC8
	CALL __PUTPARD1
	JMP  _rb_wait

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB2:
	RCALL SUBOPT_0x79
	CALL __PUTPARD1
	CALL _ftrunc
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB3:
	RCALL SUBOPT_0x79
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB4:
	SBIW R28,4
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB5:
	__GETD1S 4
	RCALL SUBOPT_0xA2
	CALL __DIVF21
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB6:
	RCALL SUBOPT_0x79
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB7:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB8:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB9:
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xBA:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xBB:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBC:
	RCALL SUBOPT_0xBB
	__GETD1N 0x3F000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBD:
	RCALL SUBOPT_0xBA
	CALL __ANEGF1
	RJMP SUBOPT_0xB9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBE:
	RCALL SUBOPT_0xBA
	RCALL SUBOPT_0xBB
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBF:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC0:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC1:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC2:
	CALL __DIVF21
	CALL __PUTPARD1
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC3:
	__GETD1N 0xBF800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC4:
	__GETD1N 0x3F800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC5:
	__GETD1N 0x7F7FFFFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC6:
	CALL __DIVF21
	CALL __PUTPARD1
	JMP  _yatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC7:
	RCALL SUBOPT_0x79
	CALL __ANEGF1
	CALL __PUTPARD1
	JMP  _yatan


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

_sqrt:
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__LTW12U:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLO __LTW12UT
	CLR  R30
__LTW12UT:
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

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
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

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARL:
	CLR  R27
__PUTPAR:
	ADD  R30,R26
	ADC  R31,R27
__PUTPAR0:
	LD   R0,-Z
	ST   -Y,R0
	SBIW R26,1
	BRNE __PUTPAR0
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__COPYMML:
	CLR  R25
__COPYMM:
	PUSH R30
	PUSH R31
__COPYMM0:
	LD   R22,Z+
	ST   X+,R22
	SBIW R24,1
	BRNE __COPYMM0
	POP  R31
	POP  R30
	RET

__CPD01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	CPC  R0,R22
	CPC  R0,R23
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
