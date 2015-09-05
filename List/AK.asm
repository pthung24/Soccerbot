
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
	JMP  _timer2_comp_isr
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
_0x20047:
	.DB  0x1
_0x201DA:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x20327:
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
	.DW  _0x20083
	.DW  _0x20000*2+9

	.DW  0x0B
	.DW  _0x20193
	.DW  _0x20000*2+21

	.DW  0x0B
	.DW  _0x201A8
	.DW  _0x20000*2+32

	.DW  0x08
	.DW  _0x201A8+11
	.DW  _0x20000*2+43

	.DW  0x0B
	.DW  _0x201DB
	.DW  _0x20000*2+51

	.DW  0x08
	.DW  _0x201DB+11
	.DW  _0x20000*2+43

	.DW  0x0A
	.DW  _0x20229
	.DW  _0x20000*2+62

	.DW  0x06
	.DW  _0x20229+10
	.DW  _0x20000*2+72

	.DW  0x0B
	.DW  _0x20240
	.DW  _0x20000*2+78

	.DW  0x07
	.DW  _0x20240+11
	.DW  _0x20000*2+89

	.DW  0x07
	.DW  _0x20240+18
	.DW  _0x20000*2+96

	.DW  0x0A
	.DW  _0x20245
	.DW  _0x20000*2+103

	.DW  0x08
	.DW  _0x20246
	.DW  _0x20000*2+113

	.DW  0x03
	.DW  _0x20246+8
	.DW  _0x20000*2+121

	.DW  0x03
	.DW  _0x20246+11
	.DW  _0x20000*2+124

	.DW  0x03
	.DW  _0x20246+14
	.DW  _0x20000*2+127

	.DW  0x03
	.DW  _0x20246+17
	.DW  _0x20000*2+130

	.DW  0x03
	.DW  _0x20246+20
	.DW  _0x20000*2+133

	.DW  0x03
	.DW  _0x20246+23
	.DW  _0x20000*2+136

	.DW  0x03
	.DW  _0x20246+26
	.DW  _0x20000*2+139

	.DW  0x03
	.DW  _0x20246+29
	.DW  _0x20000*2+142

	.DW  0x0C
	.DW  _0x2024A
	.DW  _0x20000*2+145

	.DW  0x0D
	.DW  _0x2024A+12
	.DW  _0x20000*2+157

	.DW  0x09
	.DW  _0x202B3
	.DW  _0x20000*2+170

	.DW  0x0D
	.DW  _0x202BF
	.DW  _0x20000*2+179

	.DW  0x0D
	.DW  _0x202BF+13
	.DW  _0x20000*2+179

	.DW  0x0D
	.DW  _0x202BF+26
	.DW  _0x20000*2+192

	.DW  0x0D
	.DW  _0x202BF+39
	.DW  _0x20000*2+205

	.DW  0x0D
	.DW  _0x202BF+52
	.DW  _0x20000*2+218

	.DW  0x0D
	.DW  _0x202BF+65
	.DW  _0x20000*2+231

	.DW  0x0D
	.DW  _0x202BF+78
	.DW  _0x20000*2+244

	.DW  0x0D
	.DW  _0x202BF+91
	.DW  _0x20000*2+257

	.DW  0x0D
	.DW  _0x202BF+104
	.DW  _0x20000*2+270

	.DW  0x0C
	.DW  _0x202BF+117
	.DW  _0x20000*2+283

	.DW  0x0D
	.DW  _0x202BF+129
	.DW  _0x20000*2+295

	.DW  0x0B
	.DW  _0x20300
	.DW  _0x20000*2+10

	.DW  0x0D
	.DW  _0x20300+11
	.DW  _0x20000*2+157

	.DW  0x0D
	.DW  _0x20300+24
	.DW  _0x20000*2+308

	.DW  0x06
	.DW  0x04
	.DW  _0x20327*2

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
	JMP  _0x20C0008
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
	RJMP _0x20C0009
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
	RJMP _0x20C000D
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
	RJMP _0x20C000E
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
;/* Debug mode definition */
;#define DEBUG_MODE 1    // USE OUR CODE, ask Phat for more details
;//#define DEBUG_EN 1      // Blue tooth mode
;
;/* For Dat */
;#define VBASE 15
;#define KMOVE 25
;
;/* PIN DEFINITION */
;// PIN LED ROBO KIT
;
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
;int leftSpeed = 0;
;int rightSpeed = 0;
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
;#define LDIVR 1
;
;// Robot Control Algorithm
;// The idea is simple. There are two vectors: robot direction (vrb) and robot to target (vdes).
;// The vector vrb will rotate at an  angle of 'delta' which is equal to the  angle between 2 vectors.
;// So that two vectors will be on a same line and the robot can reach its destination.
;// However, in order to achieve robot's arrival with desired orientation, a new vector (vgoal), which
;// shows the desired orientation, is introduced and added to vrb before the rotation.
;
;// Return the absolute value
;int absolute(int a) {
; 0001 00BD int absolute(int a) {

	.CSEG
_absolute:
; 0001 00BE     if (a > 0) return a;
;	a -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	BRGE _0x20008
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x20C0009
; 0001 00BF     return (-a);
_0x20008:
	LD   R30,Y
	LDD  R31,Y+1
	CALL __ANEGW1
	RJMP _0x20C0009
; 0001 00C0 }
;float min3(float a, float b, float c){
; 0001 00C1 float min3(float a, float b, float c){
_min3:
; 0001 00C2    	float m = a;
; 0001 00C3     if (m > b) m = b;
	CALL SUBOPT_0x2
;	a -> Y+12
;	b -> Y+8
;	c -> Y+4
;	m -> Y+0
	BREQ PC+2
	BRCC PC+3
	JMP  _0x20009
	CALL SUBOPT_0x3
; 0001 00C4     if (m > c) m = c;
_0x20009:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000A
	CALL SUBOPT_0x6
; 0001 00C5     return m;
_0x2000A:
	RJMP _0x20C000F
; 0001 00C6 }
;float max3(float a, float b, float c){
; 0001 00C7 float max3(float a, float b, float c){
_max3:
; 0001 00C8    	float m = a;
; 0001 00C9     if (m < b) m = b;
	CALL SUBOPT_0x2
;	a -> Y+12
;	b -> Y+8
;	c -> Y+4
;	m -> Y+0
	BRSH _0x2000B
	CALL SUBOPT_0x3
; 0001 00CA     if (m < c) m = c;
_0x2000B:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRSH _0x2000C
	CALL SUBOPT_0x6
; 0001 00CB     return m;
_0x2000C:
_0x20C000F:
	CALL __GETD1S0
	ADIW R28,16
	RET
; 0001 00CC }
;
;void setSpeed(int leftSpeed, int rightSpeed) {
; 0001 00CE void setSpeed(int leftSpeed, int rightSpeed) {
_setSpeed:
; 0001 00CF     // Reset I of both wheel
; 0001 00D0     seRki=0;//reset thanh phan I
;	leftSpeed -> Y+2
;	rightSpeed -> Y+0
	CALL SUBOPT_0x7
; 0001 00D1     seLki=0;//reset thanh phan I
; 0001 00D2 
; 0001 00D3     // Left speed control
; 0001 00D4     if (leftSpeed > 0) { // forward
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __CPW02
	BRGE _0x2000D
; 0001 00D5         MLdir = 1;
	SBI  0x15,6
; 0001 00D6     } else {
	RJMP _0x20010
_0x2000D:
; 0001 00D7         MLdir = 0;
	CBI  0x15,6
; 0001 00D8         leftSpeed = -leftSpeed;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL __ANEGW1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 00D9     }
_0x20010:
; 0001 00DA     svQEL = leftSpeed; // Don't know this
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x8
; 0001 00DB 
; 0001 00DC     // Right speed control
; 0001 00DD     if (rightSpeed > 0) { // forward
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	BRGE _0x20013
; 0001 00DE         MRdir = 1;
	SBI  0x15,7
; 0001 00DF     } else {
	RJMP _0x20016
_0x20013:
; 0001 00E0         MRdir = 0;
	CBI  0x15,7
; 0001 00E1         rightSpeed = -rightSpeed;
	LD   R30,Y
	LDD  R31,Y+1
	CALL __ANEGW1
	ST   Y,R30
	STD  Y+1,R31
; 0001 00E2     }
_0x20016:
; 0001 00E3     svQER = rightSpeed;
	LD   R30,Y
	LDD  R31,Y+1
	STS  _svQER,R30
	STS  _svQER+1,R31
; 0001 00E4 }
	RJMP _0x20C000E
;
;void kick(int x_des, int y_des, int x_goal, int y_goal, char mode){
; 0001 00E6 void kick(int x_des, int y_des, int x_goal, int y_goal, char mode){
; 0001 00E7 
; 0001 00E8     int vx_des, vy_des, vx_goal, vy_goal;                    // vdes & vgoal coordinates
; 0001 00E9     int rb_angle, des_angle, goal_angle, new_angle;       // angles of vrb, vdes, vgoal & (vdes + vgoal) to x-axis
; 0001 00EA     int rotation_angle;                           // this is needed to calculate motor velocity
; 0001 00EB     int minimum, maximum;                       //  this is needed to check whether vector a is between vector b and c
; 0001 00EC     int wl, wr;
; 0001 00ED     int vx_rb, vy_rb;
; 0001 00EE 
; 0001 00EF     vx_des = x_des - robotctrl.x;            // vdes calculation
;	x_des -> Y+37
;	y_des -> Y+35
;	x_goal -> Y+33
;	y_goal -> Y+31
;	mode -> Y+30
;	vx_des -> R16,R17
;	vy_des -> R18,R19
;	vx_goal -> R20,R21
;	vy_goal -> Y+28
;	rb_angle -> Y+26
;	des_angle -> Y+24
;	goal_angle -> Y+22
;	new_angle -> Y+20
;	rotation_angle -> Y+18
;	minimum -> Y+16
;	maximum -> Y+14
;	wl -> Y+12
;	wr -> Y+10
;	vx_rb -> Y+8
;	vy_rb -> Y+6
; 0001 00F0     vy_des = y_des - robotctrl.y;
; 0001 00F1 
; 0001 00F2     vx_goal = x_goal - x_des;            //vgoal calculation
; 0001 00F3 	vy_goal = y_goal - y_des;
; 0001 00F4 
; 0001 00F5     // Conversion to unit vector
; 0001 00F6 	if (x_goal== 0)
; 0001 00F7         y_goal = y_goal/absolute(y_goal);
; 0001 00F8     else if (y_goal == 0)
; 0001 00F9         x_goal = x_goal/absolute(x_goal);
; 0001 00FA     else {
; 0001 00FB         y_goal = y_goal/absolute(x_goal);
; 0001 00FC         x_goal = x_goal/absolute(x_goal);
; 0001 00FD     }
; 0001 00FE 
; 0001 00FF 	// Angle calculation
; 0001 0100     goal_angle = atan2(vy_goal,vx_goal);
; 0001 0101     rb_angle = atan2(robotctrl.ox, robotctrl.oy);			// done
; 0001 0102     des_angle = atan2(vy_des,vx_des);
; 0001 0103 
; 0001 0104 	// Adding vgoal to vrb
; 0001 0105     // NEED TESTING
; 0001 0106 	vx_rb = robotctrl.ox + vx_goal;
; 0001 0107     vy_rb = robotctrl.oy + vy_goal;
; 0001 0108 
; 0001 0109     new_angle = atan2(vx_rb, vy_rb);
; 0001 010A     rotation_angle = new_angle - des_angle;
; 0001 010B 
; 0001 010C 	//  *rotation_angle > 180* counter-measure
; 0001 010D     if (rotation_angle < -PI) {
; 0001 010E         rotation_angle = 2*PI + rotation_angle;
; 0001 010F         if (new_angle > des_angle)
; 0001 0110             rotation_angle = -rotation_angle;
; 0001 0111     }
; 0001 0112 
; 0001 0113     if (rotation_angle > PI) {
; 0001 0114         rotation_angle = 2*PI - rotation_angle;
; 0001 0115         if (new_angle > des_angle)
; 0001 0116             rotation_angle = -rotation_angle;
; 0001 0117 	}
; 0001 0118 
; 0001 0119 	// *Spiral* counter-measure: Spiral happens when vdes is between the new vector and vrb
; 0001 011A     minimum = min3(rb_angle, des_angle, new_angle);
; 0001 011B     maximum = max3(rb_angle, des_angle, new_angle);
; 0001 011C 
; 0001 011D 	if (absolute(rb_angle - new_angle)>PI) {
; 0001 011E         if (des_angle == maximum || des_angle == minimum)
; 0001 011F             rotation_angle = rotation_angle / 15;
; 0001 0120         else if (minimum < des_angle && des_angle < maximum)
; 0001 0121             rotation_angle = rotation_angle / 15;
; 0001 0122 	}
; 0001 0123 
; 0001 0124 	// Motor speed calculation
; 0001 0125     switch ( mode ) {
; 0001 0126         case 'f': // Going forward
; 0001 0127             wl = 30 + rotation_angle * 50;
; 0001 0128             wr = 30 - rotation_angle * 50;
; 0001 0129             break;
; 0001 012A         case 'b': // Going backward
; 0001 012B             rotation_angle = -rotation_angle;
; 0001 012C             wl = 30 - rotation_angle * 50;
; 0001 012D             wr = 30 +  rotation_angle * 50;
; 0001 012E             break;
; 0001 012F     }
; 0001 0130 
; 0001 0131     // Set the speed immediately
; 0001 0132     leftSpeed = wl;
; 0001 0133     rightSpeed = wr;
; 0001 0134 }
;
;void movePoint(IntRobot rbctrl, int x_des, int y_des, int angle, char mode){
; 0001 0136 void movePoint(IntRobot rbctrl, int x_des, int y_des, int angle, char mode){
_movePoint:
; 0001 0137 
; 0001 0138 	int vx_des, vy_des, vx_goal, vy_goal;	                // vdes & vgoal coordinates
; 0001 0139 	int rb_angle, des_angle, goal_angle, new_angle;       // angles of vrb, vdes, vgoal & (vdes + vgoal) to x-axis
; 0001 013A 	int rotation_angle;
; 0001 013B 	int minimum, maximum;
; 0001 013C     int wl, wr;
; 0001 013D     int vx_rb, vy_rb;
; 0001 013E     int dirx, diry;
; 0001 013F 
; 0001 0140 	vx_des = x_des - rbctrl.x;			// vdes calculation
	SBIW R28,28
	CALL __SAVELOCR6
;	rbctrl -> Y+41
;	x_des -> Y+39
;	y_des -> Y+37
;	angle -> Y+35
;	mode -> Y+34
;	vx_des -> R16,R17
;	vy_des -> R18,R19
;	vx_goal -> R20,R21
;	vy_goal -> Y+32
;	rb_angle -> Y+30
;	des_angle -> Y+28
;	goal_angle -> Y+26
;	new_angle -> Y+24
;	rotation_angle -> Y+22
;	minimum -> Y+20
;	maximum -> Y+18
;	wl -> Y+16
;	wr -> Y+14
;	vx_rb -> Y+12
;	vy_rb -> Y+10
;	dirx -> Y+8
;	diry -> Y+6
	LDD  R26,Y+43
	LDD  R27,Y+43+1
	LDD  R30,Y+39
	LDD  R31,Y+39+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0001 0141 	vy_des = y_des - rbctrl.y;
	LDD  R26,Y+45
	LDD  R27,Y+45+1
	LDD  R30,Y+37
	LDD  R31,Y+37+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R18,R30
; 0001 0142 
; 0001 0143     dirx = rbctrl.ox - rbctrl.x;
	LDD  R26,Y+43
	LDD  R27,Y+43+1
	LDD  R30,Y+47
	LDD  R31,Y+47+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0144     diry = rbctrl.oy - rbctrl.y;
	LDD  R26,Y+45
	LDD  R27,Y+45+1
	LDD  R30,Y+49
	LDD  R31,Y+49+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 0145 
; 0001 0146 	switch ( angle ) { // vgoal calculation
	LDD  R30,Y+35
	LDD  R31,Y+35+1
; 0001 0147 		case 0: 	vx_goal = 1 ; vy_goal = 0;break;
	SBIW R30,0
	BRNE _0x20031
	__GETWRN 20,21,1
	LDI  R30,LOW(0)
	STD  Y+32,R30
	STD  Y+32+1,R30
	RJMP _0x20030
; 0001 0148 		case 90: 	vx_goal = 0 ; vy_goal = 1;break;
_0x20031:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRNE _0x20032
	__GETWRN 20,21,0
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+32,R30
	STD  Y+32+1,R31
	RJMP _0x20030
; 0001 0149 		case 180: vx_goal = -1 ; vy_goal = 0;break;
_0x20032:
	CPI  R30,LOW(0xB4)
	LDI  R26,HIGH(0xB4)
	CPC  R31,R26
	BRNE _0x20033
	__GETWRN 20,21,-1
	LDI  R30,LOW(0)
	STD  Y+32,R30
	STD  Y+32+1,R30
	RJMP _0x20030
; 0001 014A 		case -90: vx_goal = 0; vy_goal = -1;break;
_0x20033:
	CPI  R30,LOW(0xFFFFFFA6)
	LDI  R26,HIGH(0xFFFFFFA6)
	CPC  R31,R26
	BRNE _0x20035
	__GETWRN 20,21,0
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STD  Y+32,R30
	STD  Y+32+1,R31
	RJMP _0x20030
; 0001 014B 		default:	vx_goal = 1; vy_goal = vx_goal * tan(angle);break;
_0x20035:
	__GETWRN 20,21,1
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	CALL SUBOPT_0x9
	CALL _tan
	MOVW R26,R20
	CALL __CWD2
	CALL __CDF2
	CALL __MULF12
	MOVW R26,R28
	ADIW R26,32
	CALL SUBOPT_0xA
; 0001 014C     }
_0x20030:
; 0001 014D 
; 0001 014E 	// Angle calculation
; 0001 014F     rb_angle = atan2(diry, dirx);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x9
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x9
	CALL _atan2
	MOVW R26,R28
	ADIW R26,30
	CALL SUBOPT_0xA
; 0001 0150     des_angle = atan2(vy_des,vx_des);
	MOVW R30,R18
	CALL SUBOPT_0x9
	MOVW R30,R16
	CALL SUBOPT_0x9
	CALL _atan2
	MOVW R26,R28
	ADIW R26,28
	CALL SUBOPT_0xA
; 0001 0151 
; 0001 0152 	// Adding vgoal to vrb
; 0001 0153 	vx_rb = dirx + vx_goal;
	MOVW R30,R20
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0001 0154     vy_rb = diry + vy_goal;
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 0155 
; 0001 0156     new_angle = atan2(vy_rb,vx_rb);
	CALL SUBOPT_0x9
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	CALL SUBOPT_0x9
	CALL _atan2
	MOVW R26,R28
	ADIW R26,24
	CALL SUBOPT_0xA
; 0001 0157     rotation_angle = new_angle - des_angle;
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0001 0158 
; 0001 0159 	//  *rotation_angle > 180* counter-measure
; 0001 015A         	if (rotation_angle < -PI) {
	CALL SUBOPT_0xB
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xC0490FDB
	CALL __CMPF12
	BRSH _0x20036
; 0001 015B             		rotation_angle = 2*PI + rotation_angle;
	CALL SUBOPT_0xB
	__GETD2N 0x40C90FDB
	CALL __ADDF12
	MOVW R26,R28
	ADIW R26,22
	CALL SUBOPT_0xA
; 0001 015C             		if (new_angle > des_angle)               rotation_angle = -rotation_angle;
	CALL SUBOPT_0xC
	BRGE _0x20037
	CALL SUBOPT_0xD
; 0001 015D 	}
_0x20037:
; 0001 015E                 if (rotation_angle > PI) {
_0x20036:
	CALL SUBOPT_0xB
	CALL SUBOPT_0xE
	BREQ PC+2
	BRCC PC+3
	JMP  _0x20038
; 0001 015F             		rotation_angle = 2*PI - rotation_angle;
	CALL SUBOPT_0xB
	__GETD2N 0x40C90FDB
	CALL SUBOPT_0xF
	MOVW R26,R28
	ADIW R26,22
	CALL SUBOPT_0xA
; 0001 0160             		if (new_angle > des_angle)                rotation_angle = -rotation_angle;
	CALL SUBOPT_0xC
	BRGE _0x20039
	CALL SUBOPT_0xD
; 0001 0161 	}
_0x20039:
; 0001 0162 
; 0001 0163 	// *SPIral* counter-measure: SPIral happens when vdes is between the new vector and vrb
; 0001 0164         	minimum = min3(rb_angle,des_angle,new_angle);
_0x20038:
	LDD  R30,Y+30
	LDD  R31,Y+30+1
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	RCALL _min3
	MOVW R26,R28
	ADIW R26,20
	CALL SUBOPT_0xA
; 0001 0165         	maximum = max3(rb_angle,des_angle,new_angle);
	LDD  R30,Y+30
	LDD  R31,Y+30+1
	CALL SUBOPT_0x9
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	RCALL _max3
	MOVW R26,R28
	ADIW R26,18
	CALL SUBOPT_0xA
; 0001 0166 
; 0001 0167 	if (absolute(rb_angle - new_angle)> PI) {
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	LDD  R30,Y+30
	LDD  R31,Y+30+1
	SUB  R30,R26
	SBC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	RCALL _absolute
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0xE
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2003A
; 0001 0168             		if (des_angle == maximum || des_angle == minimum)                rotation_angle = rotation_angle/15;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x2003C
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x2003B
_0x2003C:
	RJMP _0x2030E
; 0001 0169           	else
_0x2003B:
; 0001 016A             		if (minimum < des_angle && des_angle < maximum)               rotation_angle = rotation_angle/15;
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x20040
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x20041
_0x20040:
	RJMP _0x2003F
_0x20041:
_0x2030E:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL __DIVW21
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0001 016B 	}
_0x2003F:
; 0001 016C 
; 0001 016D 	// Motor speed calculation
; 0001 016E 	switch ( mode ) {
_0x2003A:
	LDD  R30,Y+34
	LDI  R31,0
; 0001 016F 		case 'f': // Going forward
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x20045
; 0001 0170     			wl = VBASE + rotation_angle * KMOVE;
	CALL SUBOPT_0x11
	ADIW R30,15
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0001 0171    	 		wr = VBASE -  rotation_angle * KMOVE;
	CALL SUBOPT_0x11
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+14,R26
	STD  Y+14+1,R27
; 0001 0172 			break;
	RJMP _0x20044
; 0001 0173     	case 'b': // Going backward
_0x20045:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x20044
; 0001 0174 			rotation_angle = -rotation_angle;
	CALL SUBOPT_0xD
; 0001 0175 			wl = VBASE - rotation_angle * KMOVE;
	CALL SUBOPT_0x11
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+16,R26
	STD  Y+16+1,R27
; 0001 0176    	 		wr = VBASE +  rotation_angle * KMOVE;
	CALL SUBOPT_0x11
	ADIW R30,15
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0001 0177             break;
; 0001 0178     }
_0x20044:
; 0001 0179 	// Set speed for motor
; 0001 017A     leftSpeed = wl;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	STS  _leftSpeed,R30
	STS  _leftSpeed+1,R31
; 0001 017B     rightSpeed = wr;
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	STS  _rightSpeed,R30
	STS  _rightSpeed+1,R31
; 0001 017C 	// need some function here
; 0001 017D }
	CALL __LOADLOCR6
	ADIW R28,55
	RET
;
;// some function to set speed = 0
;void stop() {
; 0001 0180 void stop() {
; 0001 0181 
; 0001 0182 }
;
;void rotate(int angle){
; 0001 0184 void rotate(int angle){
; 0001 0185 	angle = angle * LDIVR * 0.5;
;	angle -> Y+0
; 0001 0186 	setSpeed(angle, -angle);
; 0001 0187 }
;
;
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

	.DSEG
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
; 0001 0201 {

	.CSEG
_LEDLtoggle:
; 0001 0202     if(LEDL==0){LEDL=1;}else{LEDL=0;}
	SBIC 0x15,4
	RJMP _0x20048
	SBI  0x15,4
	RJMP _0x2004B
_0x20048:
	CBI  0x15,4
_0x2004B:
; 0001 0203 }
	RET
;
;void LEDRtoggle()
; 0001 0206 {
_LEDRtoggle:
; 0001 0207     if(LEDR==0){LEDR=1;}else{LEDR=0;}
	SBIC 0x15,5
	RJMP _0x2004E
	SBI  0x15,5
	RJMP _0x20051
_0x2004E:
	CBI  0x15,5
_0x20051:
; 0001 0208 }
	RET
;
;/* SPI */
;void sPItx(unsigned char temtx)
; 0001 020C {
_sPItx:
; 0001 020D // unsigned char transPI;
; 0001 020E     SPDR = temtx;
;	temtx -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0001 020F     while (!(SPSR & 0x80));
_0x20054:
	SBIS 0xE,7
	RJMP _0x20054
; 0001 0210 }
	RJMP _0x20C0008
;
;/* LCD FUNCTIONS */
;void LcdWrite(unsigned char dc, unsigned char data)
; 0001 0214 {
_LcdWrite:
; 0001 0215     DC = dc;
;	dc -> Y+1
;	data -> Y+0
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x20057
	CBI  0x18,2
	RJMP _0x20058
_0x20057:
	SBI  0x18,2
_0x20058:
; 0001 0216     SCE=1;
	SBI  0x18,1
; 0001 0217     SCE=0;
	CBI  0x18,1
; 0001 0218     sPItx(data);
	LD   R30,Y
	ST   -Y,R30
	RCALL _sPItx
; 0001 0219     SCE=1;
	SBI  0x18,1
; 0001 021A }
	RJMP _0x20C0009
;//This takes a large array of bits and sends them to the LCD
;void LcdBitmap(char my_array[]){
; 0001 021C void LcdBitmap(char my_array[]){
; 0001 021D     int index = 0;
; 0001 021E     for (index = 0 ; index < (LCD_X * LCD_Y / 8) ; index++)
;	my_array -> Y+2
;	index -> R16,R17
; 0001 021F         LcdWrite(LCD_D, my_array[index]);
; 0001 0220 }
;
;void hc(int x, int y) {
; 0001 0222 void hc(int x, int y) {
_hc:
; 0001 0223     LcdWrite(0, 0x40 | x);  // Row.  ?
;	x -> Y+2
;	y -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+3
	ORI  R30,0x40
	CALL SUBOPT_0x12
; 0001 0224     LcdWrite(0, 0x80 | y);  // Column.
	LDD  R30,Y+1
	ORI  R30,0x80
	ST   -Y,R30
	RCALL _LcdWrite
; 0001 0225 }
_0x20C000E:
	ADIW R28,4
	RET
;
;void LcdCharacter(unsigned char character)
; 0001 0228 {
_LcdCharacter:
; 0001 0229     int index = 0;
; 0001 022A     LcdWrite(LCD_D, 0x00);
	CALL SUBOPT_0x13
;	character -> Y+2
;	index -> R16,R17
; 0001 022B     for (index = 0; index < 5; index++)
_0x20063:
	__CPWRN 16,17,5
	BRGE _0x20064
; 0001 022C     {
; 0001 022D         LcdWrite(LCD_D, ASCII[character - 0x20][index]);
	CALL SUBOPT_0x14
; 0001 022E     }
	__ADDWRN 16,17,1
	RJMP _0x20063
_0x20064:
; 0001 022F     LcdWrite(LCD_D, 0x00);
	RJMP _0x20C000C
; 0001 0230 }
;
;void wc(unsigned char character)
; 0001 0233 {
_wc:
; 0001 0234     int index = 0;
; 0001 0235     LcdWrite(LCD_D, 0x00);
	CALL SUBOPT_0x13
;	character -> Y+2
;	index -> R16,R17
; 0001 0236     for (index = 0; index < 5; index++)
_0x20066:
	__CPWRN 16,17,5
	BRGE _0x20067
; 0001 0237     {
; 0001 0238         LcdWrite(LCD_D, ASCII[character - 0x20][index]);
	CALL SUBOPT_0x14
; 0001 0239     }
	__ADDWRN 16,17,1
	RJMP _0x20066
_0x20067:
; 0001 023A     LcdWrite(LCD_D, 0x00);
_0x20C000C:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0001 023B }
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C000D:
	ADIW R28,3
	RET
;
;void ws(unsigned char *characters)
; 0001 023E {
_ws:
; 0001 023F     while (*characters)
;	*characters -> Y+0
_0x20068:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x2006A
; 0001 0240     {
; 0001 0241         LcdCharacter(*characters++);
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	ST   -Y,R30
	RCALL _LcdCharacter
; 0001 0242     }
	RJMP _0x20068
_0x2006A:
; 0001 0243 }
	RJMP _0x20C0009
;
;void LcdClear(void)
; 0001 0246 {
_LcdClear:
; 0001 0247     int index=0;
; 0001 0248     for (index = 0; index < LCD_X * LCD_Y / 8; index++)
	CALL SUBOPT_0x16
;	index -> R16,R17
_0x2006C:
	__CPWRN 16,17,504
	BRGE _0x2006D
; 0001 0249     {
; 0001 024A         LcdWrite(LCD_D, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0001 024B     }
	__ADDWRN 16,17,1
	RJMP _0x2006C
_0x2006D:
; 0001 024C     hc(0, 0); //After we clear the display, return to the home position
	RJMP _0x20C000B
; 0001 024D }
;
;void clear(void)
; 0001 0250 {
_clear:
; 0001 0251     int index=0;
; 0001 0252     for (index = 0; index < LCD_X * LCD_Y / 8; index++)
	CALL SUBOPT_0x16
;	index -> R16,R17
_0x2006F:
	__CPWRN 16,17,504
	BRGE _0x20070
; 0001 0253     {
; 0001 0254         LcdWrite(LCD_D, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0001 0255     }
	__ADDWRN 16,17,1
	RJMP _0x2006F
_0x20070:
; 0001 0256     hc(0, 0); //After we clear the display, return to the home position
_0x20C000B:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x17
; 0001 0257 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void wn164(unsigned int so)
; 0001 025A {
_wn164:
; 0001 025B     unsigned char a[5],i;
; 0001 025C     for(i=0;i<5;i++)
	SBIW R28,5
	ST   -Y,R17
;	so -> Y+6
;	a -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x20072:
	CPI  R17,5
	BRSH _0x20073
; 0001 025D     {
; 0001 025E         a[i]=so%10;        //a[0]= byte thap nhat
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0001 025F         so=so/10;
; 0001 0260     }
	SUBI R17,-1
	RJMP _0x20072
_0x20073:
; 0001 0261     for(i=1;i<5;i++)
	LDI  R17,LOW(1)
_0x20075:
	CPI  R17,5
	BRSH _0x20076
; 0001 0262         {wc(a[4-i]+0x30);}
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	RCALL _wc
	SUBI R17,-1
	RJMP _0x20075
_0x20076:
; 0001 0263 }
	RJMP _0x20C000A
;
;void LcdInitialise()
; 0001 0266 {
_LcdInitialise:
; 0001 0267     //reset
; 0001 0268     RST=0;
	CBI  0x18,0
; 0001 0269     delay_us(10);
	__DELAY_USB 27
; 0001 026A     RST=1;
	SBI  0x18,0
; 0001 026B 
; 0001 026C     delay_ms(1000);
	CALL SUBOPT_0x1B
; 0001 026D     //khoi dong
; 0001 026E     LcdWrite(LCD_C, 0x21 );  //Tell LCD that extended commands follow
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(33)
	CALL SUBOPT_0x12
; 0001 026F     LcdWrite(LCD_C, 0xBF  );  //Set LCD Vop (Contrast): Try 0xB1(good @ 3.3V) or 0xBF = Dam nhat
	LDI  R30,LOW(191)
	CALL SUBOPT_0x12
; 0001 0270     LcdWrite(LCD_C, 0x06 );  // Set Temp coefficent. //0x04
	LDI  R30,LOW(6)
	CALL SUBOPT_0x12
; 0001 0271     LcdWrite(LCD_C, 0x13 );  //LCD bias mode 1:48: Try 0x13 or 0x14
	LDI  R30,LOW(19)
	CALL SUBOPT_0x12
; 0001 0272     LcdWrite(LCD_C, 0x20 );  //We must send 0x20 before modifying the display control mode
	LDI  R30,LOW(32)
	CALL SUBOPT_0x12
; 0001 0273     LcdWrite(LCD_C, 0x0C );  //Set display control, normal mode. 0x0D for inverse, 0x0C normal
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL _LcdWrite
; 0001 0274 }
	RET
;// Hien thi so 16 bits
;void wn16(unsigned int so)
; 0001 0277 {
_wn16:
; 0001 0278     unsigned char a[5],i;
; 0001 0279     for(i=0;i<5;i++)
	SBIW R28,5
	ST   -Y,R17
;	so -> Y+6
;	a -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x2007C:
	CPI  R17,5
	BRSH _0x2007D
; 0001 027A     {
; 0001 027B         a[i]=so%10;        //a[0]= byte thap nhat
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0001 027C         so=so/10;
; 0001 027D     }
	SUBI R17,-1
	RJMP _0x2007C
_0x2007D:
; 0001 027E     for(i=0;i<5;i++)
	LDI  R17,LOW(0)
_0x2007F:
	CPI  R17,5
	BRSH _0x20080
; 0001 027F     {LcdCharacter(a[4-i]+0x30);}
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	RCALL _LcdCharacter
	SUBI R17,-1
	RJMP _0x2007F
_0x20080:
; 0001 0280 }
_0x20C000A:
	LDD  R17,Y+0
	ADIW R28,8
	RET
;// Hien thi so 16 bits co dau
; void wn16s( int so)
; 0001 0283 {
_wn16s:
; 0001 0284     if(so<0){so=0-so; LcdCharacter('-');} else{ LcdCharacter(' ');}
;	so -> Y+0
	LDD  R26,Y+1
	TST  R26
	BRPL _0x20081
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x1C
	LDI  R30,LOW(45)
	RJMP _0x2030F
_0x20081:
	LDI  R30,LOW(32)
_0x2030F:
	ST   -Y,R30
	RCALL _LcdCharacter
; 0001 0285     wn16(so);
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x1D
; 0001 0286 }
_0x20C0009:
	ADIW R28,2
	RET
;// hien thi so 32bit co dau
; void wn32s( int so)
; 0001 0289 {
; 0001 028A     char tmp[20];
; 0001 028B     sprintf(tmp,"%d",so);
;	so -> Y+20
;	tmp -> Y+0
; 0001 028C     ws(tmp);
; 0001 028D }
;// Hien thi so 32bit co dau
; void wnf( float so)
; 0001 0290 {
; 0001 0291     char tmp[30];
; 0001 0292     sprintf(tmp,"%0.2f",so);
;	so -> Y+30
;	tmp -> Y+0
; 0001 0293     ws(tmp);
; 0001 0294 }
;// Hien thi so 32bit co dau
; void wfmt(float so)
; 0001 0297 {
; 0001 0298     char tmp[30];
; 0001 0299     sprintf(tmp,"%0.2f",so);
;	so -> Y+30
;	tmp -> Y+0
; 0001 029A     ws(tmp);
; 0001 029B }
;/* SPI & LCD INIT */
;void SPIinit()
; 0001 029E {
_SPIinit:
; 0001 029F     SPCR |=1<<SPE | 1<<MSTR;                                         //if sPI is used, uncomment this section out
	IN   R30,0xD
	ORI  R30,LOW(0x50)
	OUT  0xD,R30
; 0001 02A0     SPSR |=1<<SPI2X;
	SBI  0xE,0
; 0001 02A1 }
	RET
;void LCDinit()
; 0001 02A3 {
_LCDinit:
; 0001 02A4     LcdInitialise();
	RCALL _LcdInitialise
; 0001 02A5     LcdClear();
	RCALL _LcdClear
; 0001 02A6     ws(" <AKBOTKIT>");
	__POINTW1MN _0x20083,0
	CALL SUBOPT_0x1E
; 0001 02A7 }
	RET

	.DSEG
_0x20083:
	.BYTE 0xC
;
;/* ADC */
;#define ADC_VREF_TYPE 0x40
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0001 02AD {

	.CSEG
_read_adc:
; 0001 02AE     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0001 02AF     // Delay needed for the stabilization of the ADC input voltage
; 0001 02B0     delay_us(10);
	__DELAY_USB 27
; 0001 02B1     // Start the AD conversion
; 0001 02B2     ADCSRA|=0x40;
	SBI  0x6,6
; 0001 02B3     // Wait for the AD conversion to complete
; 0001 02B4     while ((ADCSRA & 0x10)==0);
_0x20084:
	SBIS 0x6,4
	RJMP _0x20084
; 0001 02B5     ADCSRA|=0x10;
	SBI  0x6,4
; 0001 02B6     return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20C0008
; 0001 02B7 }
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
; 0001 02EB {
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0001 02EC     char status,data;
; 0001 02ED     status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0001 02EE     data=UDR;
	IN   R16,12
; 0001 02EF     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x20087
; 0001 02F0     {
; 0001 02F1         rx_buffer[rx_wr_index++]=data;
	LDS  R30,_rx_wr_index
	SUBI R30,-LOW(1)
	STS  _rx_wr_index,R30
	CALL SUBOPT_0x1F
	ST   Z,R16
; 0001 02F2         #if RX_BUFFER_SIZE == 256
; 0001 02F3         // special case for receiver buffer size=256
; 0001 02F4         if (++rx_counter == 0) {
; 0001 02F5         #else
; 0001 02F6         if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDS  R26,_rx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x20088
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0001 02F7         if (++rx_counter == RX_BUFFER_SIZE) {
_0x20088:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x8)
	BRNE _0x20089
; 0001 02F8             rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0001 02F9         #endif
; 0001 02FA             rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0001 02FB         }
; 0001 02FC     }
_0x20089:
; 0001 02FD }
_0x20087:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x20326
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0001 0304 {
_getchar:
; 0001 0305     char data;
; 0001 0306     while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x2008A:
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x2008A
; 0001 0307     data=rx_buffer[rx_rd_index++];
	LDS  R30,_rx_rd_index
	SUBI R30,-LOW(1)
	STS  _rx_rd_index,R30
	CALL SUBOPT_0x1F
	LD   R17,Z
; 0001 0308     #if RX_BUFFER_SIZE != 256
; 0001 0309     if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDS  R26,_rx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0x2008D
	LDI  R30,LOW(0)
	STS  _rx_rd_index,R30
; 0001 030A     #endif
; 0001 030B     #asm("cli")
_0x2008D:
	cli
; 0001 030C     --rx_counter;
	LDS  R30,_rx_counter
	SUBI R30,LOW(1)
	STS  _rx_counter,R30
; 0001 030D     #asm("sei")
	sei
; 0001 030E     return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0001 030F }
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
; 0001 031F {
_usart_tx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0001 0320     if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0x2008E
; 0001 0321        {
; 0001 0322        --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0001 0323        UDR=tx_buffer[tx_rd_index++];
	LDS  R30,_tx_rd_index
	SUBI R30,-LOW(1)
	STS  _tx_rd_index,R30
	CALL SUBOPT_0x20
	LD   R30,Z
	OUT  0xC,R30
; 0001 0324     #if TX_BUFFER_SIZE != 256
; 0001 0325        if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0x2008F
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0001 0326     #endif
; 0001 0327        }
_0x2008F:
; 0001 0328 }
_0x2008E:
_0x20326:
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
; 0001 032F {
_putchar:
; 0001 0330     while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0x20090:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x8)
	BREQ _0x20090
; 0001 0331     #asm("cli")
	cli
; 0001 0332     if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x20094
	SBIC 0xB,5
	RJMP _0x20093
_0x20094:
; 0001 0333        {
; 0001 0334        tx_buffer[tx_wr_index++]=c;
	LDS  R30,_tx_wr_index
	SUBI R30,-LOW(1)
	STS  _tx_wr_index,R30
	CALL SUBOPT_0x20
	LD   R26,Y
	STD  Z+0,R26
; 0001 0335     #if TX_BUFFER_SIZE != 256
; 0001 0336        if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x20096
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0001 0337     #endif
; 0001 0338        ++tx_counter;
_0x20096:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0001 0339        }
; 0001 033A     else
	RJMP _0x20097
_0x20093:
; 0001 033B        UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0001 033C     #asm("sei")
_0x20097:
	sei
; 0001 033D }
	RJMP _0x20C0008
;#pragma used-
;#endif
;void inituart()
; 0001 0341 {
_inituart:
; 0001 0342     // USART initialization
; 0001 0343     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 0344     // USART Receiver: On
; 0001 0345     // USART Transmitter: On
; 0001 0346     // USART Mode: Asynchronous
; 0001 0347     // USART Baud Rate: 38400
; 0001 0348     UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0001 0349     UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0001 034A     UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0001 034B     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0001 034C     UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0001 034D }
	RET
;
;//========================================================
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0001 0352 {
_ext_int0_isr:
	CALL SUBOPT_0x21
; 0001 0353      QEL++;
	LDI  R26,LOW(_QEL)
	LDI  R27,HIGH(_QEL)
	RJMP _0x20325
; 0001 0354 }
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0001 0358 {
_ext_int1_isr:
	CALL SUBOPT_0x21
; 0001 0359     QER++;
	LDI  R26,LOW(_QER)
	LDI  R27,HIGH(_QER)
_0x20325:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0001 035A }
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
; 0001 035E {
_initencoder:
; 0001 035F     // Dem 24 xung / 1 vong banh xe
; 0001 0360     // External Interrupt(s) initialization
; 0001 0361     // INT0: On
; 0001 0362     // INT0 Mode: Any change
; 0001 0363     // INT1: On
; 0001 0364     // INT1 Mode: Any change
; 0001 0365     // INT2: Off
; 0001 0366     GICR|=0xC0;
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0001 0367     MCUCR=0x05;
	LDI  R30,LOW(5)
	OUT  0x35,R30
; 0001 0368     MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0001 0369     GIFR=0xC0;
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0001 036A     // Global enable interrupts
; 0001 036B 
; 0001 036C     //OCR1A=0-255; MOTOR LEFT
; 0001 036D     //OCR1B=0-255; MOTOR RIGHT
; 0001 036E }
	RET
;
;//========================================================
;//control velocity motor
;void vMLtoi(unsigned char v) //congsuat=0-22 (%)
; 0001 0373 {
_vMLtoi:
; 0001 0374     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x7
; 0001 0375     seLki=0;//reset thanh phan I
; 0001 0376     //uRold=0;
; 0001 0377     MLdir = 1;
	SBI  0x15,6
; 0001 0378     svQEL = v;
	CALL SUBOPT_0x22
; 0001 0379 }
	RJMP _0x20C0008
;//========================================================
;void vMLlui(unsigned char v) //congsuat=0-22 (%)
; 0001 037C {
_vMLlui:
; 0001 037D     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x7
; 0001 037E     seLki=0;//reset thanh phan I
; 0001 037F 
; 0001 0380     //uRold=0;
; 0001 0381     MLdir = 0;
	CBI  0x15,6
; 0001 0382     svQEL = v;
	CALL SUBOPT_0x22
; 0001 0383 }
	RJMP _0x20C0008
;//========================================================
;void vMLstop()
; 0001 0386 {
_vMLstop:
; 0001 0387     seRki=0;//reset thanh phan I
	CALL SUBOPT_0x7
; 0001 0388     seLki=0;//reset thanh phan I
; 0001 0389     MLdir = 1;
	SBI  0x15,6
; 0001 038A     OCR1A = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0001 038B     svQEL = 0;
	STS  _svQEL,R30
	STS  _svQEL+1,R30
; 0001 038C }
	RET
;//========================================================
;//========================================================
;void vMRtoi(unsigned char v) //congsuat=0-22 (%)
; 0001 0390 {
_vMRtoi:
; 0001 0391     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x7
; 0001 0392     seLki=0;//reset thanh phan I
; 0001 0393     MRdir = 1;
	SBI  0x15,7
; 0001 0394     svQER = v;
	RJMP _0x20C0007
; 0001 0395 }
;//========================================================
;void vMRlui(unsigned char v) //congsuat=0-22 (%)
; 0001 0398 {
_vMRlui:
; 0001 0399     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x7
; 0001 039A     seLki=0;//reset thanh phan I
; 0001 039B     MRdir = 0;
	CBI  0x15,7
; 0001 039C     svQER = v;
_0x20C0007:
	LD   R30,Y
	LDI  R31,0
	STS  _svQER,R30
	STS  _svQER+1,R31
; 0001 039D }
_0x20C0008:
	ADIW R28,1
	RET
;//========================================================
;void vMRstop()
; 0001 03A0 {
_vMRstop:
; 0001 03A1     seRki=0;//reset thanh phan I
	CALL SUBOPT_0x7
; 0001 03A2     seLki=0;//reset thanh phan I
; 0001 03A3     MRdir = 1;
	SBI  0x15,7
; 0001 03A4     OCR1B = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0001 03A5     svQER=0;
	STS  _svQER,R30
	STS  _svQER+1,R30
; 0001 03A6 }
	RET
;//========================================================
;// ham dieu khien vi tri
;void ctrRobottoi(unsigned int d,unsigned int v)  //v:0-22
; 0001 03AA {
; 0001 03AB      flagwaitctrAngle=0;
;	d -> Y+2
;	v -> Y+0
; 0001 03AC      flagwaitctrRobot=1;
; 0001 03AD      sd=d;// set gia tri khoang cach di chuyen
; 0001 03AE      oldd = (QEL+QER)/2; // luu gia tri vi tri hien tai
; 0001 03AF      vMRtoi(v);
; 0001 03B0      vMLtoi(v);
; 0001 03B1 }
;// ham dieu khien vi tri
;void ctrRobotlui(unsigned int d,unsigned int v)  //v:0-22
; 0001 03B4 {
; 0001 03B5      flagwaitctrAngle=0;
;	d -> Y+2
;	v -> Y+0
; 0001 03B6      flagwaitctrRobot=1;
; 0001 03B7      sd=d;// set gia tri khoang cach di chuyen
; 0001 03B8      oldd = (QEL+QER)/2; // luu gia tri vi tri hien tai
; 0001 03B9      vMRlui(v);
; 0001 03BA      vMLlui(v);
; 0001 03BB }
;// ham dieu khien goc quay
;void ctrRobotXoay(int angle,unsigned int v)  //v:0-22
; 0001 03BE {
; 0001 03BF      float fangle=0;
; 0001 03C0      flagwaitctrRobot=0;
;	angle -> Y+6
;	v -> Y+4
;	fangle -> Y+0
; 0001 03C1      if(angle>0)  { //xoay trai
; 0001 03C2         if(angle > 1) vMRtoi(v);
; 0001 03C3         else vMRtoi(0);
; 0001 03C4         if(angle > 1) vMLlui(v);
; 0001 03C5         else vMLlui(0);
; 0001 03C6      } else  //xoay phai
; 0001 03C7      {
; 0001 03C8         angle=-angle;
; 0001 03C9         if(angle > 1) vMRlui(v);
; 0001 03CA         else vMRlui(0);
; 0001 03CB         if(angle > 1) vMLtoi(v);
; 0001 03CC         else vMLtoi(0);
; 0001 03CD      }
; 0001 03CE      flagwaitctrAngle=1;
; 0001 03CF      fangle=angle*0.35;// nhan chia so float
; 0001 03D0      sa=fangle;
; 0001 03D1      olda = QEL; // luu gia tri vi tri hien tai
; 0001 03D2 }
;
;
;//============Phat==============
;IntRobot convertRobot2IntRobot(Robot robot)
; 0001 03D7 {
_convertRobot2IntRobot:
; 0001 03D8     IntRobot intRb;
; 0001 03D9     intRb.id = (int)robot.id;
	SBIW R28,28
;	robot -> Y+28
;	intRb -> Y+0
	__GETD1S 28
	CALL __CFD1
	ST   Y,R30
	STD  Y+1,R31
; 0001 03DA     intRb.x = (int)robot.x;
	__GETD1S 32
	CALL __CFD1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 03DB     intRb.y = (int)robot.y;
	__GETD1S 36
	CALL __CFD1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0001 03DC     intRb.ox = (int)robot.ox;
	__GETD1S 40
	CALL __CFD1
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 03DD     intRb.oy = (int)robot.oy;
	__GETD1S 44
	CALL __CFD1
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 03DE     intRb.ball.x = (int)robot.ball.x;
	__GETD1S 48
	CALL __CFD1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 03DF     intRb.ball.y = (int)robot.ball.y;
	__GETD1S 52
	CALL __CFD1
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0001 03E0     return intRb;
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
; 0001 03E1 }
;
;//========================================================
;// read  vi tri robot   PHUC
;//========================================================
;/* Comment to return
;unsigned char readposition()
;{
;    unsigned char  i=0;
;    unsigned flagstatus=0;
;
;    if(nRF24L01_RxPacket(RxBuf)==1)         // Neu nhan duoc du lieu
;    {
;        for( i=0;i<28;i++)
;        {
;            *(uint8_t *) ((uint8_t *)&rb + i)=RxBuf[i];
;        }
;
;        idRobot = fmod(rb.id,10); // doc id
;        cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
;
;        switch (idRobot)
;        {
;            case 1:
;                robot11=convertRobot2IntRobot(rb);
;                break;
;            case 2:
;                robot12=convertRobot2IntRobot(rb);
;                break;
;            case 3:
;                robot13=convertRobot2IntRobot(rb);
;            break;
;            case 4:
;                robot21=convertRobot2IntRobot(rb);
;                break;
;            case 5:
;                robot22=convertRobot2IntRobot(rb);
;                break;
;            case 6:
;                robot23=convertRobot2IntRobot(rb);
;                break;
;        }
;
;        if(idRobot==ROBOT_ID)
;        {
;            LEDL=!LEDL;
;            cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
;            flagstatus=1;
;            robotctrl=convertRobot2IntRobot(rb);
;        }
;    }
;    return flagstatus;
;}     */
;//========================================================
;// calc  vi tri robot   so voi mot diem (x,y)        PHUC
;// return goclenh va khoang cach, HUONG TAN CONG
;//========================================================
;void calcvitri(float x,float y)
; 0001 041B {
; 0001 041C     float ahx,ahy,aox,aoy,dah,dao,ahay,cosgoc,anpla0,anpla1,detaanpla;
; 0001 041D     ahx = robotctrl.ox-robotctrl.x;
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
; 0001 041E     ahy = robotctrl.oy-robotctrl.y;
; 0001 041F     aox = x-robotctrl.x;
; 0001 0420     aoy = y-robotctrl.y;
; 0001 0421     dah = sqrt(ahx*ahx+ahy*ahy)  ;
; 0001 0422     dao = sqrt(aox*aox+aoy*aoy)  ;
; 0001 0423     ahay= ahx*aox+ahy*aoy;
; 0001 0424     cosgoc = ahay/(dah*dao);
; 0001 0425 
; 0001 0426     anpla0 = atan2(ahy,ahx);
; 0001 0427     anpla1 = atan2(aoy,aox);
; 0001 0428     detaanpla= anpla0-anpla1;
; 0001 0429 
; 0001 042A     errangle = acos(cosgoc)*180/3.14;
; 0001 042B     if(((detaanpla>0)&&(detaanpla <M_PI))|| (detaanpla <-M_PI))  // xet truong hop goc ben phai
; 0001 042C     {
; 0001 042D          errangle = - errangle; // ben phai
; 0001 042E     }
; 0001 042F     else
; 0001 0430     {
; 0001 0431         errangle = errangle;   // ben trai
; 0001 0432 
; 0001 0433     }
; 0001 0434     distance = sqrt(aox*3.48*aox*3.48+aoy*2.89*aoy*2.89); //tinh khoang cach
; 0001 0435     orentation = atan2(ahy,ahx)*180/M_PI + offestsanco;//tinh huong ra goc
; 0001 0436     if(( 0 < orentation && orentation < 74) ||   ( 0 > orentation && orentation > -80) )
; 0001 0437     {
; 0001 0438        if(SAN_ID == 1)// phan san duong
; 0001 0439        {
; 0001 043A         flagtancong=0;
; 0001 043B         offsetphongthu = 70 ;
; 0001 043C         goctancong = 180;
; 0001 043D        }
; 0001 043E        else // phan san am
; 0001 043F        {
; 0001 0440         flagtancong=1;
; 0001 0441 
; 0001 0442        }
; 0001 0443     }else
; 0001 0444     {
; 0001 0445        if(SAN_ID == 1)
; 0001 0446        {
; 0001 0447        flagtancong=1;
; 0001 0448        }
; 0001 0449        else
; 0001 044A        {
; 0001 044B         flagtancong=0;
; 0001 044C         offsetphongthu = -70 ;
; 0001 044D         goctancong = 0;
; 0001 044E        }
; 0001 044F     }
; 0001 0450 }
;void runEscStuck()
; 0001 0452 {
; 0001 0453     while(cmdCtrlRobot==4)
; 0001 0454     {
; 0001 0455 
; 0001 0456         DDRA    = 0x00;
; 0001 0457         PORTA   = 0x00;
; 0001 0458         IRFL=read_adc(4);
; 0001 0459         IRFR=read_adc(5);
; 0001 045A 
; 0001 045B         if((IRFL<300)&&(IRFR<300))
; 0001 045C         {
; 0001 045D             vMLtoi(22);vMRlui(22);
; 0001 045E             delay_ms(100);
; 0001 045F         }
; 0001 0460          if (IRFL>300 && IRFR<300)
; 0001 0461         {
; 0001 0462             vMLlui(0);vMRlui(25);delay_ms(100);
; 0001 0463         }
; 0001 0464         if (IRFR>300 && IRFL<300 )
; 0001 0465         {
; 0001 0466             vMLlui(25);vMRlui(0);delay_ms(100);
; 0001 0467         }
; 0001 0468         LEDBR=!LEDBR;
; 0001 0469         readposition();//doc RF cap nhat ai robot
; 0001 046A     }
; 0001 046B }
;void runEscStucksethome()
; 0001 046D {
; 0001 046E     while(cmdCtrlRobot==7)
; 0001 046F     {
; 0001 0470         DDRA    = 0x00;
; 0001 0471         PORTA   = 0x00;
; 0001 0472         readposition();//doc RF cap nhat ai robot
; 0001 0473         IRFL=read_adc(4);
; 0001 0474         IRFR=read_adc(5);
; 0001 0475 
; 0001 0476         if((IRFL<300)&&(IRFR<300))
; 0001 0477         {
; 0001 0478             vMLtoi(22);vMRlui(22);
; 0001 0479             delay_ms(100);
; 0001 047A         }
; 0001 047B 
; 0001 047C         if (IRFL>300 && IRFR<300)
; 0001 047D         {
; 0001 047E             vMLlui(0);vMRlui(22);delay_ms(300);
; 0001 047F         }
; 0001 0480         if (IRFR>300 && IRFL<300 )
; 0001 0481         {
; 0001 0482             vMLlui(22);vMRlui(0);delay_ms(300);
; 0001 0483         }
; 0001 0484 
; 0001 0485         LEDBR=!LEDBR;
; 0001 0486     }
; 0001 0487 }
;void runEscBlindSpot()
; 0001 0489 {
; 0001 048A     while(cmdCtrlRobot==3)
; 0001 048B     {
; 0001 048C         DDRA    = 0x00;
; 0001 048D         PORTA   = 0x00;
; 0001 048E         readposition();//doc RF cap nhat ai robot
; 0001 048F         IRFL=read_adc(4);
; 0001 0490         IRFR=read_adc(5);
; 0001 0491         if (IRFL>300 && IRFR<300)
; 0001 0492         {
; 0001 0493             vMLlui(0);vMRlui(22);delay_ms(300);
; 0001 0494         }
; 0001 0495         if (IRFR>300 && IRFL<300 )
; 0001 0496         {
; 0001 0497             vMLlui(22);vMRlui(0);delay_ms(300);
; 0001 0498         }
; 0001 0499 
; 0001 049A         if((IRFL<300)&&(IRFR<300))
; 0001 049B         {
; 0001 049C             vMLtoi(20);vMRtoi(20);
; 0001 049D             delay_ms(20);
; 0001 049E         }
; 0001 049F 
; 0001 04A0         LEDR=!LEDR;
; 0001 04A1     }
; 0001 04A2 }
;
;void runEscBlindSpotsethome()
; 0001 04A5 {
; 0001 04A6     while(cmdCtrlRobot==6)
; 0001 04A7     {
; 0001 04A8         DDRA    = 0x00;
; 0001 04A9         PORTA   = 0x00;
; 0001 04AA         readposition();
; 0001 04AB         IRFL=read_adc(4);
; 0001 04AC         IRFR=read_adc(5);
; 0001 04AD         if (IRFL>300 && IRFR<300)
; 0001 04AE         {
; 0001 04AF             vMLlui(0);vMRlui(22);delay_ms(300);
; 0001 04B0         }
; 0001 04B1         if (IRFR>300 && IRFL<300 )
; 0001 04B2         {
; 0001 04B3             vMLlui(22);vMRlui(0);delay_ms(300);
; 0001 04B4         }
; 0001 04B5 
; 0001 04B6         if((IRFL<300)&&(IRFR<300))
; 0001 04B7         {
; 0001 04B8             vMLtoi(20);vMRtoi(20);
; 0001 04B9             delay_ms(10);
; 0001 04BA         }
; 0001 04BB 
; 0001 04BC         LEDR=!LEDR;
; 0001 04BD     }
; 0001 04BE }
;
;//========================================================
;// SET HOME  vi tri robot, de chuan bi cho tran dau       PHUC//
;//========================================================
;int sethomeRB()
; 0001 04C4 {
; 0001 04C5        while(flagsethome==0)
; 0001 04C6        {
; 0001 04C7             LEDL=!LEDL;
; 0001 04C8               //PHUC SH
; 0001 04C9             if(readposition()==1)//co du lieu moi
; 0001 04CA             {
; 0001 04CB                     //hc(3,40);wn16s(cmdCtrlRobot);
; 0001 04CC                     if(cmdCtrlRobot==1)      // dung ma lenh stop chuong trinh
; 0001 04CD                     {
; 0001 04CE                         flagsethome=0;
; 0001 04CF                          return 0;
; 0001 04D0                     }
; 0001 04D1 
; 0001 04D2                     if(cmdCtrlRobot==2 || cmdCtrlRobot==3 || cmdCtrlRobot==4)      // dung ma lenh stop chuong trinh
; 0001 04D3                     {
; 0001 04D4                         flagsethome=0;
; 0001 04D5                         return 0;
; 0001 04D6                     }
; 0001 04D7 
; 0001 04D8                     if(cmdCtrlRobot==5)  //sethome robot
; 0001 04D9                     {
; 0001 04DA 
; 0001 04DB                         calcvitri(rbctrlHomeX,rbctrlHomeY);
; 0001 04DC                         if(distance>100) //chay den vi tri
; 0001 04DD                         {
; 0001 04DE                             if(errangle>18 || errangle<-18 )
; 0001 04DF                             {
; 0001 04E0                             int nv = errangle*27/180 ;
; 0001 04E1                             int verrangle = calcVangle(errangle);
; 0001 04E2                             ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 04E3                             delay_ms(1);
; 0001 04E4                             }else
; 0001 04E5                             {
; 0001 04E6                             //1xung = 3.14 * 40/24 =5.22
; 0001 04E7                             ctrRobottoi(distance/5.22,15);
; 0001 04E8                             // verranglekisum=0;//RESET I.
; 0001 04E9                             }
; 0001 04EA                         }
; 0001 04EB                         else //XOAY DUNG HUONG
; 0001 04EC                         {
; 0001 04ED                             setRobotAngleX=10*cos(rbctrlHomeAngle*M_PI/180);
; 0001 04EE                             setRobotAngleY=10*sin(rbctrlHomeAngle*M_PI/180);;
; 0001 04EF                             calcvitri(robotctrl.x + setRobotAngleX,robotctrl.y + setRobotAngleY);
; 0001 04F0                             if(errangle>90 || errangle<-90 )
; 0001 04F1                              {
; 0001 04F2 
; 0001 04F3                                int nv = errangle*27/180 ;
; 0001 04F4                                int verrangle = calcVangle(errangle);
; 0001 04F5                                ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 04F6                                delay_ms(1);
; 0001 04F7                              }else
; 0001 04F8                              {
; 0001 04F9 
; 0001 04FA                                  verranglekisum=0;//RESET I.
; 0001 04FB                                  flaghuongtrue=0;
; 0001 04FC                                  flagsethome=1;  // bao da set home khong can set nua
; 0001 04FD                                  vMRstop();
; 0001 04FE                                  vMLstop();
; 0001 04FF                                   return 0;
; 0001 0500 
; 0001 0501                              }
; 0001 0502                         }
; 0001 0503 
; 0001 0504                     }
; 0001 0505 
; 0001 0506                     if(cmdCtrlRobot==7)  //sethome IS STUCKED
; 0001 0507                     {
; 0001 0508 
; 0001 0509                        cntstuckRB++;
; 0001 050A                        if(cntstuckRB > 2)
; 0001 050B                        {
; 0001 050C                          runEscStucksethome();
; 0001 050D                          cntstuckRB=0;
; 0001 050E                        }
; 0001 050F                     }
; 0001 0510 
; 0001 0511                     if(cmdCtrlRobot==6) //sethome IS //roi vao diem mu (blind spot) , mat vi tri hay huong
; 0001 0512                     {
; 0001 0513                        LEDBL=1;
; 0001 0514                        cntunlookRB++;
; 0001 0515                        if(cntunlookRB > 2)
; 0001 0516                        {
; 0001 0517                          runEscBlindSpotsethome();
; 0001 0518                          cntunlookRB=0;
; 0001 0519 
; 0001 051A                        }
; 0001 051B 
; 0001 051C                     }
; 0001 051D 
; 0001 051E 
; 0001 051F             }
; 0001 0520 
; 0001 0521             LEDR=!LEDR;
; 0001 0522 
; 0001 0523        }
; 0001 0524        return 0;
; 0001 0525 
; 0001 0526 }
;
;int codePenalty()
; 0001 0529 {
; 0001 052A    // chay den vi tri duoc dat truoc, sau do da banh 1 lan
; 0001 052B       //PHUC SH
; 0001 052C       if(readposition()==1)//co du lieu moi
; 0001 052D       {
; 0001 052E            if(cmdCtrlRobot==8)  //set vi tri penalty robot
; 0001 052F             {
; 0001 0530                 calcvitri(rbctrlPenaltyX,rbctrlPenaltyY);
; 0001 0531                 if(distance>50) //chay den vi tri
; 0001 0532                 {
; 0001 0533                     if(errangle>18 || errangle<-18 )
; 0001 0534                     {
; 0001 0535                     int nv = errangle*27/180 ;
; 0001 0536                     int verrangle = calcVangle(errangle);
; 0001 0537                     ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0538                     delay_ms(1);
; 0001 0539                     }else
; 0001 053A                     {
; 0001 053B                     //1xung = 3.14 * 40/24 =5.22
; 0001 053C                     ctrRobottoi(distance/5.22,15);
; 0001 053D                     // verranglekisum=0;//RESET I.
; 0001 053E                     }
; 0001 053F                 }
; 0001 0540                 else //XOAY DUNG HUONG
; 0001 0541                 {
; 0001 0542                     setRobotAngleX=10*cos(rbctrlPenaltyAngle*M_PI/180);
; 0001 0543                     setRobotAngleY=10*sin(rbctrlPenaltyAngle*M_PI/180);;
; 0001 0544                     calcvitri(robotctrl.x + setRobotAngleX,robotctrl.y + setRobotAngleY);
; 0001 0545                     if(errangle>10 || errangle<-10 )
; 0001 0546                      {
; 0001 0547 
; 0001 0548                        int nv = errangle*27/180 ;
; 0001 0549                        int verrangle = calcVangle(errangle);
; 0001 054A                        ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 054B                        delay_ms(1);
; 0001 054C                      }else
; 0001 054D                      {
; 0001 054E 
; 0001 054F                          verranglekisum=0;//RESET I.
; 0001 0550                          flaghuongtrue=0;
; 0001 0551                          flagsethome=1;  // bao da set vitri penalty
; 0001 0552                          while(cmdCtrlRobot!=2) //cho nhan nut start
; 0001 0553                          {
; 0001 0554                             readposition();
; 0001 0555                          }
; 0001 0556                          // da banh
; 0001 0557                          vMRtoi(22);
; 0001 0558                          vMLtoi(22);
; 0001 0559                          delay_ms(1000);
; 0001 055A                          vMRlui(10);
; 0001 055B                          vMLlui(10);
; 0001 055C                          delay_ms(1000);
; 0001 055D                          vMRstop();
; 0001 055E                          vMLstop();
; 0001 055F                           return 0;
; 0001 0560 
; 0001 0561                      }
; 0001 0562                 }
; 0001 0563 
; 0001 0564             }
; 0001 0565       }
; 0001 0566 
; 0001 0567 }
;void settoadoHomRB()
; 0001 0569 {
_settoadoHomRB:
; 0001 056A     switch(ROBOT_ID)
	LDI  R30,LOW(4)
; 0001 056B     {
; 0001 056C     //PHUC
; 0001 056D        case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x20127
; 0001 056E 
; 0001 056F 
; 0001 0570             rbctrlPenaltyX = 0;
	CALL SUBOPT_0x23
; 0001 0571             rbctrlPenaltyY = 0;
; 0001 0572 
; 0001 0573             if(SAN_ID==1)
; 0001 0574             {
; 0001 0575               rbctrlPenaltyAngle = 179;
; 0001 0576               rbctrlHomeAngle = 179 ;
; 0001 0577               rbctrlHomeX = 269.7 ;
	CALL SUBOPT_0x24
; 0001 0578               rbctrlHomeY = 1.7  ;
; 0001 0579               setRobotXmin=80;
; 0001 057A               setRobotXmax=260;
; 0001 057B             }
; 0001 057C             else
; 0001 057D             {
; 0001 057E               rbctrlPenaltyAngle = -15;
; 0001 057F               rbctrlHomeAngle = -15 ;
; 0001 0580               rbctrlHomeX =-226.1 ;
; 0001 0581               rbctrlHomeY = 1.6  ;
; 0001 0582               setRobotXmin=-260;
; 0001 0583               setRobotXmax=-80;
_0x20315:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 0584             }
; 0001 0585        break;
	RJMP _0x20126
; 0001 0586        case 2:
_0x20127:
	CPI  R30,LOW(0x2)
	BRNE _0x2012A
; 0001 0587 
; 0001 0588 
; 0001 0589             rbctrlPenaltyX=0;
	CALL SUBOPT_0x23
; 0001 058A             rbctrlPenaltyY=0;
; 0001 058B 
; 0001 058C             if(SAN_ID==1)
; 0001 058D             {
; 0001 058E               rbctrlPenaltyAngle = 179;
; 0001 058F               rbctrlHomeAngle = 179 ;
; 0001 0590               rbctrlHomeX =66.0 ;
	CALL SUBOPT_0x25
; 0001 0591               rbctrlHomeY = 79.4  ;
; 0001 0592               setRobotXmin=-270;
; 0001 0593               setRobotXmax=270;
; 0001 0594             }
; 0001 0595             else
; 0001 0596             {
; 0001 0597               rbctrlPenaltyAngle = -15;
; 0001 0598               rbctrlHomeAngle = -15  ;
; 0001 0599               rbctrlHomeX =-44.3 ;
; 0001 059A               rbctrlHomeY = 82.7  ;
_0x20316:
	STS  _rbctrlHomeY,R30
	STS  _rbctrlHomeY+1,R31
	STS  _rbctrlHomeY+2,R22
	STS  _rbctrlHomeY+3,R23
; 0001 059B               setRobotXmin=-270;
	CALL SUBOPT_0x26
; 0001 059C               setRobotXmax=270;
	CALL SUBOPT_0x27
; 0001 059D             }
; 0001 059E        break;
	RJMP _0x20126
; 0001 059F        case 3:
_0x2012A:
	CPI  R30,LOW(0x3)
	BRNE _0x2012D
; 0001 05A0 
; 0001 05A1 
; 0001 05A2             rbctrlPenaltyX = 0;
	LDI  R30,LOW(0)
	STS  _rbctrlPenaltyX,R30
	STS  _rbctrlPenaltyX+1,R30
	STS  _rbctrlPenaltyX+2,R30
	STS  _rbctrlPenaltyX+3,R30
; 0001 05A3             rbctrlPenaltyY = 0;
	STS  _rbctrlPenaltyY,R30
	STS  _rbctrlPenaltyY+1,R30
	STS  _rbctrlPenaltyY+2,R30
	STS  _rbctrlPenaltyY+3,R30
; 0001 05A4             rbctrlPenaltyAngle = -15;
	__GETD1N 0xC1700000
	CALL SUBOPT_0x28
; 0001 05A5             if(SAN_ID==1)
; 0001 05A6             {
; 0001 05A7               rbctrlPenaltyAngle = 179;
	CALL SUBOPT_0x28
; 0001 05A8               rbctrlHomeAngle = 179 ;
	STS  _rbctrlHomeAngle,R30
	STS  _rbctrlHomeAngle+1,R31
	STS  _rbctrlHomeAngle+2,R22
	STS  _rbctrlHomeAngle+3,R23
; 0001 05A9               rbctrlHomeX =54.1 ;
	CALL SUBOPT_0x29
; 0001 05AA               rbctrlHomeY = -99.9  ;
; 0001 05AB               setRobotXmin=-270;
; 0001 05AC               setRobotXmax=20;
	__GETD1N 0x41A00000
; 0001 05AD             }
; 0001 05AE             else
; 0001 05AF             {
; 0001 05B0               rbctrlPenaltyAngle = -15;
; 0001 05B1               rbctrlHomeAngle = -15  ;
; 0001 05B2               rbctrlHomeX =-53.5 ;
; 0001 05B3               rbctrlHomeY =  -93.8 ;
; 0001 05B4               setRobotXmin=-20;
; 0001 05B5               setRobotXmax=270;
_0x20317:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 05B6             }
; 0001 05B7        break;
	RJMP _0x20126
; 0001 05B8        case 4:
_0x2012D:
	CPI  R30,LOW(0x4)
	BRNE _0x20130
; 0001 05B9 
; 0001 05BA             rbctrlPenaltyX=0;
	CALL SUBOPT_0x23
; 0001 05BB             rbctrlPenaltyY=0;
; 0001 05BC 
; 0001 05BD              if(SAN_ID==1)
; 0001 05BE             {
; 0001 05BF               rbctrlPenaltyAngle = 179;
; 0001 05C0               rbctrlHomeAngle = 179 ;
; 0001 05C1               rbctrlHomeX = 269.7 ;
	CALL SUBOPT_0x24
; 0001 05C2               rbctrlHomeY = 1.7  ;
; 0001 05C3               setRobotXmin=80;
; 0001 05C4               setRobotXmax=260;
; 0001 05C5             }
; 0001 05C6             else
; 0001 05C7             {
; 0001 05C8               rbctrlPenaltyAngle = -15;
; 0001 05C9               rbctrlHomeAngle = -15  ;
; 0001 05CA               rbctrlHomeX =-226.1 ;
; 0001 05CB               rbctrlHomeY = 1.6  ;
; 0001 05CC               setRobotXmin=-260;
; 0001 05CD               setRobotXmax=-80;
_0x20318:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 05CE             }
; 0001 05CF        break;
	RJMP _0x20126
; 0001 05D0        case 5:
_0x20130:
	CPI  R30,LOW(0x5)
	BRNE _0x20133
; 0001 05D1 
; 0001 05D2             rbctrlPenaltyX = 0;
	CALL SUBOPT_0x23
; 0001 05D3             rbctrlPenaltyY = 0;
; 0001 05D4              if(SAN_ID==1)
; 0001 05D5             {
; 0001 05D6                 rbctrlPenaltyAngle = 179;
; 0001 05D7                rbctrlHomeAngle = 179 ;
; 0001 05D8                rbctrlHomeX =66.0 ;
	CALL SUBOPT_0x25
; 0001 05D9               rbctrlHomeY = 79.4  ;
; 0001 05DA               setRobotXmin=-270;
; 0001 05DB               setRobotXmax=270;
; 0001 05DC             }
; 0001 05DD             else
; 0001 05DE             {
; 0001 05DF               rbctrlPenaltyAngle = -15;
; 0001 05E0               rbctrlHomeAngle = -15  ;
; 0001 05E1               rbctrlHomeX =-44.3 ;
; 0001 05E2               rbctrlHomeY = 82.7  ;
_0x20319:
	STS  _rbctrlHomeY,R30
	STS  _rbctrlHomeY+1,R31
	STS  _rbctrlHomeY+2,R22
	STS  _rbctrlHomeY+3,R23
; 0001 05E3               setRobotXmin=-270;
	CALL SUBOPT_0x26
; 0001 05E4               setRobotXmax=270;
	CALL SUBOPT_0x27
; 0001 05E5             }
; 0001 05E6        break;
	RJMP _0x20126
; 0001 05E7        case 6:
_0x20133:
	CPI  R30,LOW(0x6)
	BRNE _0x20126
; 0001 05E8 
; 0001 05E9 
; 0001 05EA             rbctrlPenaltyX = 0;
	CALL SUBOPT_0x23
; 0001 05EB             rbctrlPenaltyY = 0;
; 0001 05EC             if(SAN_ID==1)
; 0001 05ED             {
; 0001 05EE                rbctrlPenaltyAngle = 179;
; 0001 05EF               rbctrlHomeAngle = 179 ;
; 0001 05F0               rbctrlHomeX =54.1 ;
	CALL SUBOPT_0x29
; 0001 05F1               rbctrlHomeY = -99.9  ;
; 0001 05F2               setRobotXmin=-270;
; 0001 05F3               setRobotXmax=20;
	__GETD1N 0x41A00000
; 0001 05F4             }
; 0001 05F5             else
; 0001 05F6             {
; 0001 05F7               rbctrlPenaltyAngle = -15;
; 0001 05F8               rbctrlHomeAngle = -15  ;
; 0001 05F9               rbctrlHomeX =-53.5 ;
; 0001 05FA               rbctrlHomeY =  -93.8 ;
; 0001 05FB               setRobotXmin=-20;
; 0001 05FC               setRobotXmax=270;
_0x2031A:
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
; 0001 05FD             }
; 0001 05FE        break;
; 0001 05FF 
; 0001 0600 
; 0001 0601     }
_0x20126:
; 0001 0602 }
	RET
;//=======================================================
;// Tinh luc theo goc quay de dieu khien robot
;int calcVangle(int angle)
; 0001 0606 {
; 0001 0607     int verrangle=0;
; 0001 0608     //tinh thanh phan I
; 0001 0609     verranglekisum = verranglekisum + angle/20;
;	angle -> Y+2
;	verrangle -> R16,R17
; 0001 060A     if(verranglekisum>15)verranglekisum = 15;
; 0001 060B     if(verranglekisum<-15)verranglekisum = -15;
; 0001 060C     //tinh thanh phan dieu khien
; 0001 060D     verrangle = 10 + angle/12 + verranglekisum ;
; 0001 060E     //gioi han bao hoa
; 0001 060F     if(verrangle<0) verrangle=-verrangle;//lay tri tuyet doi cua van toc v dieu khien
; 0001 0610     if(verrangle>20) verrangle = 20;
; 0001 0611     if(verrangle<8) verrangle = 8;
; 0001 0612     return  verrangle;
; 0001 0613 }
;//ctrl robot
;void ctrrobot()
; 0001 0616 {
; 0001 0617     if(readposition()==1)//co du lieu moi
; 0001 0618     {
; 0001 0619 //          hc(3,40);wn16s(cmdCtrlRobot);
; 0001 061A //        hc(4,40);wn16s(idRobot);
; 0001 061B          //-------------------------------------------------
; 0001 061C         if(cmdCtrlRobot==8)      // dung ma lenh stop chuong trinh
; 0001 061D         {
; 0001 061E             flagsethome=0; //cho phep sethome
; 0001 061F             while(cmdCtrlRobot==8)
; 0001 0620             {
; 0001 0621               codePenalty();
; 0001 0622             }
; 0001 0623         }
; 0001 0624 
; 0001 0625         if(cmdCtrlRobot==1)      // dung ma lenh stop chuong trinh
; 0001 0626         {
; 0001 0627             flagsethome=0; //cho phep sethome
; 0001 0628             while(cmdCtrlRobot==1)
; 0001 0629             {
; 0001 062A               readposition();
; 0001 062B             }
; 0001 062C         }
; 0001 062D 
; 0001 062E         if(cmdCtrlRobot==5)  //sethome robot
; 0001 062F         {
; 0001 0630 
; 0001 0631            cntsethomeRB++;
; 0001 0632            if(cntsethomeRB > 2)
; 0001 0633            {
; 0001 0634              LEDBR=1;
; 0001 0635              if (flagsethome == 0)sethomeRB();
; 0001 0636              cntsethomeRB=0;
; 0001 0637            }
; 0001 0638 
; 0001 0639         }
; 0001 063A 
; 0001 063B         if(cmdCtrlRobot==4)  //sethome robot
; 0001 063C         {
; 0001 063D            flagsethome=0; //cho phep sethome
; 0001 063E            cntstuckRB++;
; 0001 063F            if(cntstuckRB > 2)
; 0001 0640            {
; 0001 0641              runEscStuck();
; 0001 0642              cntstuckRB=0;
; 0001 0643            }
; 0001 0644         }
; 0001 0645 
; 0001 0646         if(cmdCtrlRobot==3)  //roi vao diem mu (blind spot) , mat vi tri hay huong
; 0001 0647         {
; 0001 0648            flagsethome=0; //cho phep sethome
; 0001 0649            cntunlookRB++;
; 0001 064A            if(cntunlookRB > 2)
; 0001 064B            {
; 0001 064C              runEscBlindSpot();
; 0001 064D              cntunlookRB=0;
; 0001 064E            }
; 0001 064F 
; 0001 0650         }
; 0001 0651 
; 0001 0652 
; 0001 0653         //------------------------------------------------
; 0001 0654         if(cmdCtrlRobot==2) {// run chuong trinh
; 0001 0655             flagsethome=0; //cho phep sethome
; 0001 0656             switch(flagtask)
; 0001 0657             {
; 0001 0658               // chay den vi tri duoc set boi nguoi dieu khien
; 0001 0659               case 0:
; 0001 065A                      if(setRobotX < setRobotXmin)   setRobotX =  setRobotXmin;
; 0001 065B                      if(setRobotX >setRobotXmax)    setRobotX =  setRobotXmax;
; 0001 065C                      calcvitri(setRobotX,setRobotY);
; 0001 065D                      if(distance>80) //chay den vi tri
; 0001 065E                      {
; 0001 065F                          if(errangle>18 || errangle<-18 )
; 0001 0660                          {
; 0001 0661                            int nv = errangle*27/180 ;
; 0001 0662                            int verrangle = calcVangle(errangle);
; 0001 0663                            ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0664                            delay_ms(1);
; 0001 0665                          }else
; 0001 0666                          {
; 0001 0667                            //1xung = 3.14 * 40/24 =5.22
; 0001 0668                            ctrRobottoi(distance/5.22,15);
; 0001 0669                           // verranglekisum=0;//RESET I.
; 0001 066A                          }
; 0001 066B                      }
; 0001 066C                      else
; 0001 066D                      {
; 0001 066E                          flagtask=10;
; 0001 066F                      }
; 0001 0670                      break;
; 0001 0671               // quay dung huong duoc set boi nguoi dieu khien
; 0001 0672               case 1:
; 0001 0673 
; 0001 0674                     calcvitri(robotctrl.x + setRobotAngleX,robotctrl.y + setRobotAngleY);
; 0001 0675                     if(errangle>18 || errangle<-18 )
; 0001 0676                      {
; 0001 0677 
; 0001 0678                        int nv = errangle*27/180 ;
; 0001 0679                        int verrangle = calcVangle(errangle);
; 0001 067A                        ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 067B                       // ctrRobotXoay(nv,10);
; 0001 067C                        delay_ms(1);
; 0001 067D                      }else
; 0001 067E                      {
; 0001 067F                        flaghuongtrue++;
; 0001 0680                        if(flaghuongtrue>3)
; 0001 0681                        {
; 0001 0682                         //verranglekisum=0;//RESET I.
; 0001 0683                          flaghuongtrue=0;
; 0001 0684                          flagtask=10;
; 0001 0685                        }
; 0001 0686 
; 0001 0687                      }
; 0001 0688                     break;
; 0001 0689               // chay den vi tri bong
; 0001 068A               case 2:
; 0001 068B 
; 0001 068C                     //PHUC test    rb1 ,s1
; 0001 068D                     if(robotctrl.ball.x < setRobotXmin)   robotctrl.ball.x =  setRobotXmin;
; 0001 068E                     if(robotctrl.ball.x >setRobotXmax)    robotctrl.ball.x =  setRobotXmax;
; 0001 068F                     calcvitri(robotctrl.ball.x,robotctrl.ball.y);
; 0001 0690 
; 0001 0691                      if(errangle>18 || errangle<-18 )
; 0001 0692                      {
; 0001 0693                        int nv = errangle*27/180 ;
; 0001 0694                        int verrangle = calcVangle(errangle);
; 0001 0695                        ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0696                        delay_ms(1);
; 0001 0697                      }else
; 0001 0698                      {
; 0001 0699                          //1xung = 3.14 * 40/24 =5.22
; 0001 069A                          if(distance>10) //chay den vi tri
; 0001 069B                          {
; 0001 069C                            ctrRobottoi(distance/5.22,15);
; 0001 069D                            delay_ms(5);
; 0001 069E                          }else
; 0001 069F                          {
; 0001 06A0                            flagtask=10;
; 0001 06A1                          }
; 0001 06A2                         // verranglekisum=0;//RESET I.
; 0001 06A3                      }
; 0001 06A4 
; 0001 06A5                     break;
; 0001 06A6               // da bong
; 0001 06A7               case 3:
; 0001 06A8                     ctrRobottoi(40,22);
; 0001 06A9                     delay_ms(400);
; 0001 06AA                     ctrRobotlui(40,15);
; 0001 06AB                     delay_ms(400);
; 0001 06AC                     flagtask = 10;
; 0001 06AD                     break;
; 0001 06AE               case 10:
; 0001 06AF                     vMRtoi(0);
; 0001 06B0                     vMLtoi(0);
; 0001 06B1                     break;
; 0001 06B2               //chay theo bong co dinh huong
; 0001 06B3               case 4:
; 0001 06B4                     calcvitri(robotctrl.ball.x,robotctrl.ball.y);
; 0001 06B5                     if(errangle>18 || errangle<-18 )
; 0001 06B6                      {
; 0001 06B7 
; 0001 06B8                        int nv = errangle*27/180 ;
; 0001 06B9                        int verrangle = calcVangle(errangle);
; 0001 06BA                        ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 06BB                       // ctrRobotXoay(nv,10);
; 0001 06BC                        delay_ms(1);
; 0001 06BD                      }else
; 0001 06BE                      {
; 0001 06BF                        flaghuongtrue++;
; 0001 06C0                        if(flaghuongtrue>3)
; 0001 06C1                        {
; 0001 06C2                         //verranglekisum=0;//RESET I.
; 0001 06C3                          flaghuongtrue=0;
; 0001 06C4                          flagtask=10;
; 0001 06C5                        }
; 0001 06C6 
; 0001 06C7                      }
; 0001 06C8                     break;
; 0001 06C9            }
; 0001 06CA        }//end if(cmdCtrlRobot==2)
; 0001 06CB     }else   //khong co tin hieu RF hay khong thay robot
; 0001 06CC     {
; 0001 06CD          //if(flagunlookRB==1) runEscBlindSpot();
; 0001 06CE 
; 0001 06CF     }
; 0001 06D0 
; 0001 06D1 
; 0001 06D2 }
;
;void rb_move(float x,float y)
; 0001 06D5 {
; 0001 06D6    flagtask = 0;
;	x -> Y+4
;	y -> Y+0
; 0001 06D7    flagtaskold=flagtask;
; 0001 06D8    setRobotX=x;
; 0001 06D9    setRobotY=y;
; 0001 06DA }
;void rb_rotate(int angle)     // goc xoay so voi truc x cua toa do
; 0001 06DC {
; 0001 06DD    flagtask = 1;
;	angle -> Y+0
; 0001 06DE    flagtaskold=flagtask;
; 0001 06DF    setRobotAngleX=10*cos(angle*M_PI/180);
; 0001 06E0    setRobotAngleY=10*sin(angle*M_PI/180);;
; 0001 06E1 }
;
;void rb_goball()
; 0001 06E4 {
; 0001 06E5    flagtask = 2;
; 0001 06E6    flagtaskold=flagtask;
; 0001 06E7 }
;void rb_kick()
; 0001 06E9 {
; 0001 06EA    flagtask = 3;
; 0001 06EB    flagtaskold=flagtask;
; 0001 06EC }
;int rb_wait(unsigned long int time )
; 0001 06EE {
; 0001 06EF    time=time*10;
;	time -> Y+0
; 0001 06F0    while(time--)
; 0001 06F1    {
; 0001 06F2      ctrrobot();
; 0001 06F3      if(flagtask==10) return 1 ;// thuc hien xong nhiem vu
; 0001 06F4    }
; 0001 06F5     return 0;
; 0001 06F6 }
;//========================================================
;// Timer1 overflow interrupt service routine
;// period =1/2khz= 0.5ms
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0001 06FB {
_timer1_ovf_isr:
	CALL SUBOPT_0x2A
; 0001 06FC // Place your code here
; 0001 06FD    timerstick++;
	LDI  R26,LOW(_timerstick)
	LDI  R27,HIGH(_timerstick)
	CALL SUBOPT_0x2B
; 0001 06FE    timerstickdis++;
	LDI  R26,LOW(_timerstickdis)
	LDI  R27,HIGH(_timerstickdis)
	CALL SUBOPT_0x2B
; 0001 06FF    timerstickang++;
	LDI  R26,LOW(_timerstickang)
	LDI  R27,HIGH(_timerstickang)
	CALL SUBOPT_0x2B
; 0001 0700    timerstickctr++;
	LDI  R26,LOW(_timerstickctr)
	LDI  R27,HIGH(_timerstickctr)
	CALL SUBOPT_0x2B
; 0001 0701  #ifdef CtrVelocity
; 0001 0702  // dieu khien van toc
; 0001 0703    if(timerstick>250)    // 125ms/0.5ms=250 : dung chu ki lay mau = 125 ms
	LDS  R26,_timerstick
	LDS  R27,_timerstick+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x20179
; 0001 0704    {
; 0001 0705      int eR=0,eL=0;
; 0001 0706 
; 0001 0707      //-------------------------------------------
; 0001 0708      //cap nhat van toc
; 0001 0709      vQER = (QER-oldQER);     //(xung / 10ms)
	SBIW R28,4
	CALL SUBOPT_0x2C
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
;	eR -> Y+2
;	eL -> Y+0
	LDS  R26,_oldQER
	LDS  R27,_oldQER+1
	CALL SUBOPT_0x2D
	SUB  R30,R26
	SBC  R31,R27
	STS  _vQER,R30
	STS  _vQER+1,R31
; 0001 070A      vQEL = (QEL-oldQEL);     //(xung /10ms)
	LDS  R26,_oldQEL
	LDS  R27,_oldQEL+1
	CALL SUBOPT_0x2E
	SUB  R30,R26
	SBC  R31,R27
	STS  _vQEL,R30
	STS  _vQEL+1,R31
; 0001 070B      oldQEL=QEL;
	CALL SUBOPT_0x2E
	STS  _oldQEL,R30
	STS  _oldQEL+1,R31
; 0001 070C      oldQER=QER;
	CALL SUBOPT_0x2D
	STS  _oldQER,R30
	STS  _oldQER+1,R31
; 0001 070D      timerstick=0;
	LDI  R30,LOW(0)
	STS  _timerstick,R30
	STS  _timerstick+1,R30
; 0001 070E 
; 0001 070F      //--------------------------------------------
; 0001 0710      //tinh PID van toc
; 0001 0711      //--------------------------------------------
; 0001 0712      eR=svQER-vQER;
	LDS  R26,_vQER
	LDS  R27,_vQER+1
	LDS  R30,_svQER
	LDS  R31,_svQER+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 0713      //tinh thanh phan I
; 0001 0714      seRki=seRki+KiR*eR;
	LDS  R26,_KiR
	LDS  R27,_KiR+1
	CALL __MULW12
	CALL SUBOPT_0x2F
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x30
; 0001 0715      if(seRki>100) seRki=100;
	CALL SUBOPT_0x2F
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x2017A
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x30
; 0001 0716      if(seRki<-100) seRki = -100;
_0x2017A:
	CALL SUBOPT_0x2F
	CPI  R26,LOW(0xFF9C)
	LDI  R30,HIGH(0xFF9C)
	CPC  R27,R30
	BRGE _0x2017B
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	CALL SUBOPT_0x30
; 0001 0717      //tinh them thanh phan P
; 0001 0718      uR = 100 + KpR*eR + seRki;
_0x2017B:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDS  R26,_KpR
	LDS  R27,_KpR+1
	CALL __MULW12
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x2F
	ADD  R30,R26
	ADC  R31,R27
	STS  _uR,R30
	STS  _uR+1,R31
; 0001 0719      if(uR>255) uR =255;
	LDS  R26,_uR
	LDS  R27,_uR+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x2017C
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _uR,R30
	STS  _uR+1,R31
; 0001 071A      if(uR<0) uR =0;
_0x2017C:
	LDS  R26,_uR+1
	TST  R26
	BRPL _0x2017D
	LDI  R30,LOW(0)
	STS  _uR,R30
	STS  _uR+1,R30
; 0001 071B 
; 0001 071C      eL=svQEL-vQEL;
_0x2017D:
	LDS  R26,_vQEL
	LDS  R27,_vQEL+1
	LDS  R30,_svQEL
	LDS  R31,_svQEL+1
	CALL SUBOPT_0x1C
; 0001 071D      //tinh thanh phan I
; 0001 071E      seLki=seLki+KiL*eL;
	LD   R30,Y
	LDD  R31,Y+1
	LDS  R26,_KiL
	LDS  R27,_KiL+1
	CALL __MULW12
	CALL SUBOPT_0x31
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x32
; 0001 071F      if(seLki>100) seLki=100;
	CALL SUBOPT_0x31
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x2017E
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x32
; 0001 0720      if(seLki<-100) seLki = -100;
_0x2017E:
	CALL SUBOPT_0x31
	CPI  R26,LOW(0xFF9C)
	LDI  R30,HIGH(0xFF9C)
	CPC  R27,R30
	BRGE _0x2017F
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	CALL SUBOPT_0x32
; 0001 0721      //tinh them thanh phan P
; 0001 0722      uL = 100 + KpL*eL + seLki;
_0x2017F:
	LD   R30,Y
	LDD  R31,Y+1
	LDS  R26,_KpL
	LDS  R27,_KpL+1
	CALL __MULW12
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x31
	ADD  R30,R26
	ADC  R31,R27
	STS  _uL,R30
	STS  _uL+1,R31
; 0001 0723      if(uL>255) uL =255;
	LDS  R26,_uL
	LDS  R27,_uL+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x20180
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _uL,R30
	STS  _uL+1,R31
; 0001 0724      if(uL<0) uL =0;
_0x20180:
	LDS  R26,_uL+1
	TST  R26
	BRPL _0x20181
	LDI  R30,LOW(0)
	STS  _uL,R30
	STS  _uL+1,R30
; 0001 0725 
; 0001 0726      if(svQER!=0)OCR1B= uR;
_0x20181:
	LDS  R30,_svQER
	LDS  R31,_svQER+1
	SBIW R30,0
	BREQ _0x20182
	LDS  R30,_uR
	LDS  R31,_uR+1
	RJMP _0x2031C
; 0001 0727      else  OCR1B = 0;
_0x20182:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x2031C:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0001 0728 
; 0001 0729      if(svQEL!=0) OCR1A= uL;
	LDS  R30,_svQEL
	LDS  R31,_svQEL+1
	SBIW R30,0
	BREQ _0x20184
	LDS  R30,_uL
	LDS  R31,_uL+1
	RJMP _0x2031D
; 0001 072A      else  OCR1A = 0;
_0x20184:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x2031D:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0001 072B 
; 0001 072C    }
	ADIW R28,4
; 0001 072D // dieu khien khoang cach
; 0001 072E   if(timerstickdis>10 && (flagwaitctrRobot==1))
_0x20179:
	LDS  R26,_timerstickdis
	LDS  R27,_timerstickdis+1
	SBIW R26,11
	BRLO _0x20187
	LDS  R26,_flagwaitctrRobot
	CPI  R26,LOW(0x1)
	BREQ _0x20188
_0x20187:
	RJMP _0x20186
_0x20188:
; 0001 072F   {
; 0001 0730     unsigned int deltad1=0;
; 0001 0731     deltad1 =(QER + QEL)/2 - oldd;
	SBIW R28,2
	CALL SUBOPT_0x2C
;	deltad1 -> Y+0
	CALL SUBOPT_0x33
	LDS  R26,_oldd
	LDS  R27,_oldd+1
	CALL SUBOPT_0x1C
; 0001 0732     //if(deltad1<0) deltad1=0;// co the am do kieu so
; 0001 0733     //hc(3,0);ws("            ");
; 0001 0734     //hc(3,0);wn16s(deltad1);
; 0001 0735     if(deltad1>sd)
	LDS  R30,_sd
	LDS  R31,_sd+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x20189
; 0001 0736     {
; 0001 0737 
; 0001 0738         vMLstop();
	RCALL _vMLstop
; 0001 0739         vMRstop();
	RCALL _vMRstop
; 0001 073A         flagwaitctrRobot=0;
	LDI  R30,LOW(0)
	STS  _flagwaitctrRobot,R30
; 0001 073B         oldd=(QER+QEL)/2;
	CALL SUBOPT_0x33
	STS  _oldd,R30
	STS  _oldd+1,R31
; 0001 073C 
; 0001 073D     }
; 0001 073E     timerstickdis=0;
_0x20189:
	LDI  R30,LOW(0)
	STS  _timerstickdis,R30
	STS  _timerstickdis+1,R30
; 0001 073F 
; 0001 0740   }
	ADIW R28,2
; 0001 0741   // dieu khien  vi tri goc quay
; 0001 0742   if(timerstickang>10 && (flagwaitctrAngle==1))
_0x20186:
	LDS  R26,_timerstickang
	LDS  R27,_timerstickang+1
	SBIW R26,11
	BRLO _0x2018B
	LDS  R26,_flagwaitctrAngle
	CPI  R26,LOW(0x1)
	BREQ _0x2018C
_0x2018B:
	RJMP _0x2018A
_0x2018C:
; 0001 0743   {
; 0001 0744     unsigned int deltaa=0;
; 0001 0745     deltaa =(QEL) - olda;
	SBIW R28,2
	CALL SUBOPT_0x2C
;	deltaa -> Y+0
	LDS  R26,_olda
	LDS  R27,_olda+1
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x1C
; 0001 0746 //    hc(4,0);ws("            ");
; 0001 0747 //    hc(4,0);wn16s(deltaa);
; 0001 0748     if(deltaa>sa)
	LDS  R30,_sa
	LDS  R31,_sa+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x2018D
; 0001 0749     {
; 0001 074A         vMLstop();
	RCALL _vMLstop
; 0001 074B         vMRstop();
	RCALL _vMRstop
; 0001 074C         flagwaitctrAngle=0;
	LDI  R30,LOW(0)
	STS  _flagwaitctrAngle,R30
; 0001 074D         olda=QEL;
	CALL SUBOPT_0x2E
	STS  _olda,R30
	STS  _olda+1,R31
; 0001 074E     }
; 0001 074F     timerstickang=0;
_0x2018D:
	LDI  R30,LOW(0)
	STS  _timerstickang,R30
	STS  _timerstickang+1,R30
; 0001 0750   }
	ADIW R28,2
; 0001 0751   // dieu khien robot robot
; 0001 0752   if(timerstickctr>1)
_0x2018A:
	LDS  R26,_timerstickctr
	LDS  R27,_timerstickctr+1
	SBIW R26,2
	BRLO _0x2018E
; 0001 0753   {
; 0001 0754     timerstickctr=0;
	LDI  R30,LOW(0)
	STS  _timerstickctr,R30
	STS  _timerstickctr+1,R30
; 0001 0755   }
; 0001 0756 #endif
; 0001 0757 }
_0x2018E:
	CALL SUBOPT_0x34
	RETI
;
;//========================================================
;// read  vi tri robot   PHUC
;//========================================================
;unsigned char testposition()
; 0001 075D {
_testposition:
; 0001 075E         unsigned char  i=0;
; 0001 075F         unsigned flagstatus=0;
; 0001 0760 
; 0001 0761    while(keyKT!=0)
	CALL __SAVELOCR4
;	i -> R17
;	flagstatus -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
_0x2018F:
	SBIS 0x13,0
	RJMP _0x20191
; 0001 0762    {
; 0001 0763         readposition();
	CALL _readposition
; 0001 0764 
; 0001 0765          if(idRobot==ROBOT_ID)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x20192
; 0001 0766          {
; 0001 0767              hc(5,40);wn16s(robotctrl.ball.y);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x35
	__GETW1MN _robotctrl,12
	CALL SUBOPT_0x36
; 0001 0768              hc(4,40);wn16s(robotctrl.ball.x);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x35
	__GETW1MN _robotctrl,10
	CALL SUBOPT_0x36
; 0001 0769              hc(3,20);wn16s(robotctrl.x);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
	CALL SUBOPT_0x36
; 0001 076A              hc(2,20);wn16s(robotctrl.y);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x38
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x36
; 0001 076B              hc(1,1);wn16s(robotctrl.ox);
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3C
	RCALL _hc
	__GETW1MN _robotctrl,6
	CALL SUBOPT_0x36
; 0001 076C              hc(0,1);wn16s(robotctrl.oy);
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3C
	RCALL _hc
	__GETW1MN _robotctrl,8
	CALL SUBOPT_0x36
; 0001 076D              delay_ms(200);
	CALL SUBOPT_0x3E
; 0001 076E          }
; 0001 076F 
; 0001 0770      }
_0x20192:
	RJMP _0x2018F
_0x20191:
; 0001 0771     return flagstatus;
	MOV  R30,R18
	RJMP _0x20C0006
; 0001 0772 }
;//========================================================
;void robotwall()
; 0001 0775 {
_robotwall:
; 0001 0776 unsigned int demled;
; 0001 0777         DDRA    = 0x00;
	ST   -Y,R17
	ST   -Y,R16
;	demled -> R16,R17
	CALL SUBOPT_0x3F
; 0001 0778         PORTA   = 0x00;
; 0001 0779 
; 0001 077A         LcdClear();
; 0001 077B         hc(0,10);
	CALL SUBOPT_0x40
; 0001 077C         ws ("ROBOT WALL");
	__POINTW1MN _0x20193,0
	CALL SUBOPT_0x1E
; 0001 077D         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 077E 
; 0001 077F    while(keyKT!=0)
_0x20198:
	SBIS 0x13,0
	RJMP _0x2019A
; 0001 0780    {
; 0001 0781         IRFL=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	STS  _IRFL,R30
	STS  _IRFL+1,R31
; 0001 0782         IRFR=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	STS  _IRFR,R30
	STS  _IRFR+1,R31
; 0001 0783         hc(1,0) ; wn16(IRFL);
	CALL SUBOPT_0x41
	LDS  R30,_IRFL
	LDS  R31,_IRFL+1
	CALL SUBOPT_0x1D
; 0001 0784         hc(1,42); wn16(IRFR);
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x42
	LDS  R30,_IRFR
	LDS  R31,_IRFR+1
	CALL SUBOPT_0x1D
; 0001 0785 
; 0001 0786         if (IRFL>250)
	LDS  R26,_IRFL
	LDS  R27,_IRFL+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLO _0x2019B
; 0001 0787         {
; 0001 0788             vMLlui(22);vMRlui(10);delay_ms(600);
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _vMLlui
	LDI  R30,LOW(10)
	CALL SUBOPT_0x43
; 0001 0789         }
; 0001 078A         if (IRFR>250)
_0x2019B:
	LDS  R26,_IRFR
	LDS  R27,_IRFR+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLO _0x2019C
; 0001 078B         {
; 0001 078C             vMLlui(10);vMRlui(22);delay_ms(600);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _vMLlui
	LDI  R30,LOW(22)
	CALL SUBOPT_0x43
; 0001 078D         }
; 0001 078E         if((IRFL<300)&(IRFR<300))
_0x2019C:
	LDS  R26,_IRFL
	LDS  R27,_IRFL+1
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
	BREQ _0x2019D
; 0001 078F         {
; 0001 0790             vMLtoi(22);vMRtoi(22);
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _vMLtoi
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 0791         }
; 0001 0792 
; 0001 0793        demled++;
_0x2019D:
	__ADDWRN 16,17,1
; 0001 0794        if(demled>50){demled=0;LEDLtoggle(); LEDRtoggle();}
	__CPWRN 16,17,51
	BRLO _0x2019E
	__GETWRN 16,17,0
	CALL SUBOPT_0x44
; 0001 0795    }
_0x2019E:
	RJMP _0x20198
_0x2019A:
; 0001 0796 
; 0001 0797 }
	LD   R16,Y+
	LD   R17,Y+
	RET

	.DSEG
_0x20193:
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
; 0001 07DE {

	.CSEG
_readline:
; 0001 07DF     int i=0,j=0;
; 0001 07E0     // reset the values
; 0001 07E1         for(i = 0; i < 5; i++)
	CALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 16,17,0
_0x201A0:
	__CPWRN 16,17,5
	BRGE _0x201A1
; 0001 07E2         IRLINE[i] = 0;
	CALL SUBOPT_0x45
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	__ADDWRN 16,17,1
	RJMP _0x201A0
_0x201A1:
; 0001 07E4 for (j = 0; j < 50; j++)
	__GETWRN 18,19,0
_0x201A3:
	__CPWRN 18,19,50
	BRLT PC+3
	JMP _0x201A4
; 0001 07E5         {
; 0001 07E6             IRLINE[0]= IRLINE[0]+read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	LDS  R26,_IRLINE
	LDS  R27,_IRLINE+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _IRLINE,R30
	STS  _IRLINE+1,R31
; 0001 07E7             IRLINE[1]= IRLINE[1]+read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	__GETW2MN _IRLINE,2
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,2
; 0001 07E8             IRLINE[2]= IRLINE[2]+read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	CALL SUBOPT_0x46
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,4
; 0001 07E9             IRLINE[3]= IRLINE[3]+read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	__GETW2MN _IRLINE,6
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,6
; 0001 07EA             IRLINE[4]= IRLINE[4]+read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	__GETW2MN _IRLINE,8
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,8
; 0001 07EB         }
	__ADDWRN 18,19,1
	RJMP _0x201A3
_0x201A4:
; 0001 07EC         // get the rounded average of the readings for each sensor
; 0001 07ED         for (i = 0; i < 5; i++)
	__GETWRN 16,17,0
_0x201A6:
	__CPWRN 16,17,5
	BRGE _0x201A7
; 0001 07EE         IRLINE[i] = (IRLINE[i] + (50 >> 1)) /50;
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	ADIW R30,25
	MOVW R26,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __DIVW21U
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	__ADDWRN 16,17,1
	RJMP _0x201A6
_0x201A7:
; 0001 07EF }
	RJMP _0x20C0006
;//========================================================
;void robotwhiteline() //ANALOG OK
; 0001 07F2 {
_robotwhiteline:
; 0001 07F3     unsigned char i=0,imax;
; 0001 07F4     int imaxlast=0;
; 0001 07F5     unsigned int  admax;
; 0001 07F6     unsigned int  demled=0;
; 0001 07F7     unsigned int flagblindT=0;
; 0001 07F8     unsigned int flagblindP=0;
; 0001 07F9     DDRA =0x00;
	SBIW R28,6
	CALL SUBOPT_0x2C
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
	CALL SUBOPT_0x3F
; 0001 07FA     PORTA=0x00;
; 0001 07FB 
; 0001 07FC         LcdClear();
; 0001 07FD         hc(0,1);
	CALL SUBOPT_0x3C
	RCALL _hc
; 0001 07FE         ws ("WHITE LINE");
	__POINTW1MN _0x201A8,0
	CALL SUBOPT_0x1E
; 0001 07FF         hc(1,10);
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x40
; 0001 0800         ws ("FOLOWER");
	__POINTW1MN _0x201A8,11
	CALL SUBOPT_0x1E
; 0001 0801         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 0802         //doc va khoi dong gia tri cho imaxlast
; 0001 0803          readline();
	CALL SUBOPT_0x48
; 0001 0804         admax = IRLINE[0];imax=0;
; 0001 0805         for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x201AE:
	CPI  R17,5
	BRSH _0x201AF
	CALL SUBOPT_0x49
	CALL SUBOPT_0x47
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x201B0
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
_0x201B0:
	SUBI R17,-1
	RJMP _0x201AE
_0x201AF:
; 0001 0806         imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 0807    while(keyKT!=0)
_0x201B1:
	SBIS 0x13,0
	RJMP _0x201B3
; 0001 0808    {
; 0001 0809         //doc gia tri cam bien
; 0001 080A         readline();
	CALL SUBOPT_0x48
; 0001 080B         admax = IRLINE[0];imax=0;
; 0001 080C         for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x201B5:
	CPI  R17,5
	BRSH _0x201B6
	CALL SUBOPT_0x49
	CALL SUBOPT_0x47
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x201B7
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
_0x201B7:
	SUBI R17,-1
	RJMP _0x201B5
_0x201B6:
; 0001 080D           //imax=2;
; 0001 080E          if((imax-imaxlast > 1)||(imax-imaxlast <-1))  //tranh truong hop nhay bo trang thai
	CALL SUBOPT_0x4B
	SUB  R30,R18
	SBC  R31,R19
	MOVW R26,R30
	SBIW R30,2
	BRGE _0x201B9
	MOVW R30,R26
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRGE _0x201B8
_0x201B9:
; 0001 080F         {
; 0001 0810         }
; 0001 0811         else
	RJMP _0x201BB
_0x201B8:
; 0001 0812         {
; 0001 0813             switch(imax)
	CALL SUBOPT_0x4B
; 0001 0814             {
; 0001 0815               case 0:
	SBIW R30,0
	BRNE _0x201BF
; 0001 0816                   vMLtoi(1); vMRtoi(20) ;
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4D
; 0001 0817                   //flagblindT = 0;
; 0001 0818                   flagblindP = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 0819                 break;
	RJMP _0x201BE
; 0001 081A               case 1:
_0x201BF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x201C0
; 0001 081B                   vMLtoi(1); vMRtoi(15) ;
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4E
; 0001 081C                 break;
	RJMP _0x201BE
; 0001 081D               case 2:
_0x201C0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x201C1
; 0001 081E                   vMLtoi(15);vMRtoi(15) ;
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x4E
; 0001 081F                 break;
	RJMP _0x201BE
; 0001 0820               case 3:
_0x201C1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x201C2
; 0001 0821                  vMLtoi(15); vMRtoi(1) ;
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
; 0001 0822                 break;
	RJMP _0x201BE
; 0001 0823               case 4:
_0x201C2:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x201C4
; 0001 0824                   vMLtoi(20);vMRtoi(1)  ;
	CALL SUBOPT_0x51
; 0001 0825                   flagblindT = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0826                   //flagblindP = 0;
; 0001 0827                 break;
; 0001 0828               default:
_0x201C4:
; 0001 0829                  // vMLtoi(5); vMRtoi(5) ;
; 0001 082A                 break;
; 0001 082B             }
_0x201BE:
; 0001 082C              imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 082D         }
_0x201BB:
; 0001 082E 
; 0001 082F             while(flagblindT ==1 && keyKT!=0) //lac duong ben trai
_0x201C5:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x201C8
	CALL SUBOPT_0x52
	BRNE _0x201C9
_0x201C8:
	RJMP _0x201C7
_0x201C9:
; 0001 0830             {
; 0001 0831                vMLtoi(20);vMRtoi(1)  ;
	CALL SUBOPT_0x51
; 0001 0832                 readline();
	CALL SUBOPT_0x48
; 0001 0833                 admax = IRLINE[0];imax=0;
; 0001 0834                 for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x201CB:
	CPI  R17,5
	BRSH _0x201CC
	CALL SUBOPT_0x49
	CALL SUBOPT_0x47
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x201CD
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
_0x201CD:
	SUBI R17,-1
	RJMP _0x201CB
_0x201CC:
; 0001 0835                 imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 0836                if(IRLINE[2]>500)  flagblindT=0;
	CALL SUBOPT_0x46
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLO _0x201CE
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
; 0001 0837 
; 0001 0838 
; 0001 0839             }
_0x201CE:
	RJMP _0x201C5
_0x201C7:
; 0001 083A             while(flagblindP ==1 && keyKT!=0 ) //lac duong ben phai
_0x201CF:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BRNE _0x201D2
	CALL SUBOPT_0x52
	BRNE _0x201D3
_0x201D2:
	RJMP _0x201D1
_0x201D3:
; 0001 083B             {
; 0001 083C                vMLtoi(1);vMRtoi(20)  ;
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4D
; 0001 083D                 readline();
	CALL SUBOPT_0x48
; 0001 083E                 admax = IRLINE[0];imax=0;
; 0001 083F                 for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x201D5:
	CPI  R17,5
	BRSH _0x201D6
	CALL SUBOPT_0x49
	CALL SUBOPT_0x47
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x201D7
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
_0x201D7:
	SUBI R17,-1
	RJMP _0x201D5
_0x201D6:
; 0001 0840                 imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 0841                if(IRLINE[2]>500)  flagblindP=0;
	CALL SUBOPT_0x46
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLO _0x201D8
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0001 0842 
; 0001 0843             }
_0x201D8:
	RJMP _0x201CF
_0x201D1:
; 0001 0844         hc(3,10);wn16s(imax);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x40
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x36
; 0001 0845         hc(4,10);wn16s(admax);
	CALL SUBOPT_0x53
	ST   -Y,R21
	ST   -Y,R20
	RCALL _wn16s
; 0001 0846 
; 0001 0847        demled++;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 0848        if(demled>30){demled=0;LEDLtoggle();LEDRtoggle(); }
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,31
	BRLO _0x201D9
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	CALL SUBOPT_0x44
; 0001 0849    }
_0x201D9:
	RJMP _0x201B1
_0x201B3:
; 0001 084A }
	CALL __LOADLOCR6
	ADIW R28,12
	RET

	.DSEG
_0x201A8:
	.BYTE 0x13
;
;//========================================================
;void robotblackline() //ANALOG OK
; 0001 084E {

	.CSEG
_robotblackline:
; 0001 084F     long int lastvalueline=0, valueline=0,value=0,online=0;
; 0001 0850     int i=0,j=0
; 0001 0851     ,imin=0;
; 0001 0852     long int avrg=0,sum=0 ;
; 0001 0853     unsigned int admin;
; 0001 0854      unsigned char imax;
; 0001 0855     int imaxlast=0;
; 0001 0856     unsigned int  admax;
; 0001 0857     unsigned int demled=0;
; 0001 0858     unsigned int flagblindT=0;
; 0001 0859     unsigned int flagblindP=0;
; 0001 085A     float udk,sumi=0,err,lasterr;
; 0001 085B 
; 0001 085C     int iminlast=0;
; 0001 085D     DDRA =0x00;
	SBIW R28,55
	LDI  R24,55
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x201DA*2)
	LDI  R31,HIGH(_0x201DA*2)
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
	CALL SUBOPT_0x3F
; 0001 085E     PORTA=0x00;
; 0001 085F 
; 0001 0860         LcdClear();
; 0001 0861         hc(0,1);
	CALL SUBOPT_0x3C
	RCALL _hc
; 0001 0862         ws ("BLACK LINE");
	__POINTW1MN _0x201DB,0
	CALL SUBOPT_0x1E
; 0001 0863         hc(1,10);
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x40
; 0001 0864         ws ("FOLOWER");
	__POINTW1MN _0x201DB,11
	CALL SUBOPT_0x1E
; 0001 0865         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 0866 
; 0001 0867         //doc lan dau tien  de khoi dong gia tri iminlast;
; 0001 0868         readline();
	CALL SUBOPT_0x54
; 0001 0869         admin = IRLINE[0];imin=0;
; 0001 086A         for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x201E1:
	__CPWRN 16,17,5
	BRGE _0x201E2
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	CALL SUBOPT_0x55
	BRSH _0x201E3
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x201E3:
	__ADDWRN 16,17,1
	RJMP _0x201E1
_0x201E2:
; 0001 086B         iminlast=imin;
	__PUTWSR 20,21,6
; 0001 086C         admin = 1024;
	LDI  R30,LOW(1024)
	LDI  R31,HIGH(1024)
	STD  Y+35,R30
	STD  Y+35+1,R31
; 0001 086D         admax = 0;
	STD  Y+30,R30
	STD  Y+30+1,R30
; 0001 086E    //calib
; 0001 086F    while(keyKT!=0)
_0x201E4:
	SBIS 0x13,0
	RJMP _0x201E6
; 0001 0870    {
; 0001 0871       //doc gia tri cam bien
; 0001 0872       readline();
	RCALL _readline
; 0001 0873 
; 0001 0874       for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
	__GETWRN 16,17,1
_0x201E8:
	__CPWRN 16,17,5
	BRGE _0x201E9
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	CALL SUBOPT_0x55
	BRSH _0x201EA
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x201EA:
	__ADDWRN 16,17,1
	RJMP _0x201E8
_0x201E9:
; 0001 0875       //hc(3,10);wn16s(admin);
; 0001 0876       hc(3,10);wn16s(admin);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x40
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	CALL SUBOPT_0x36
; 0001 0877 
; 0001 0878       for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
	__GETWRN 16,17,1
_0x201EC:
	__CPWRN 16,17,5
	BRGE _0x201ED
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x201EE
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	STD  Y+30,R30
	STD  Y+30+1,R31
	__PUTBSR 16,34
_0x201EE:
	__ADDWRN 16,17,1
	RJMP _0x201EC
_0x201ED:
; 0001 0879       hc(4,10);wn16s(admax);
	CALL SUBOPT_0x53
	LDD  R30,Y+30
	LDD  R31,Y+30+1
	CALL SUBOPT_0x36
; 0001 087A    }
	RJMP _0x201E4
_0x201E6:
; 0001 087B    //test gia tri doc line
; 0001 087C    online=0;
	LDI  R30,LOW(0)
	__CLRD1S 45
; 0001 087D    while(1)
_0x201EF:
; 0001 087E    {
; 0001 087F       //doc gia tri cam bien
; 0001 0880       readline();
	RCALL _readline
; 0001 0881       for(i=0;i<5;i++)
	__GETWRN 16,17,0
_0x201F3:
	__CPWRN 16,17,5
	BRLT PC+3
	JMP _0x201F4
; 0001 0882       {
; 0001 0883          value=IRLINE[i];
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	CLR  R22
	CLR  R23
	__PUTD1S 49
; 0001 0884          if(value<280) online=1;
	__GETD2S 49
	__CPD2N 0x118
	BRGE _0x201F5
	__GETD1N 0x1
	__PUTD1S 45
; 0001 0885          avrg = avrg+i*1000*value;
_0x201F5:
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
; 0001 0886          sum = sum+value;
	__GETD1S 49
	__GETD2S 37
	CALL __ADDD12
	__PUTD1S 37
; 0001 0887       }
	__ADDWRN 16,17,1
	RJMP _0x201F3
_0x201F4:
; 0001 0888       //hc(1,10);wn16s(online);
; 0001 0889       if(online==1)
	__GETD2S 45
	__CPD2N 0x1
	BRNE _0x201F6
; 0001 088A       {
; 0001 088B          valueline=(int)(avrg/ sum);
	__GETD1S 37
	__GETD2S 41
	CALL __DIVD21
	CLR  R22
	CLR  R23
	CALL __CWD1
	__PUTD1S 53
; 0001 088C         // hc(2,10);wn16s(valueline);
; 0001 088D          online=0;
	LDI  R30,LOW(0)
	__CLRD1S 45
; 0001 088E          avrg=0;
	__CLRD1S 41
; 0001 088F          sum=0;
	__CLRD1S 37
; 0001 0890       }else
	RJMP _0x201F7
_0x201F6:
; 0001 0891       {
; 0001 0892          if(lastvalueline>1935)
	__GETD2S 57
	__CPD2N 0x790
	BRLT _0x201F8
; 0001 0893          valueline=2000;
	__GETD1N 0x7D0
	RJMP _0x2031E
; 0001 0894          else
_0x201F8:
; 0001 0895          valueline=1800;
	__GETD1N 0x708
_0x2031E:
	__PUTD1S 53
; 0001 0896       }
_0x201F7:
; 0001 0897       err = 1935-valueline;
	__GETD2S 53
	__GETD1N 0x78F
	CALL __SUBD12
	CALL __CDF1
	CALL SUBOPT_0x56
; 0001 0898       if(err>100) err=100;
	CALL SUBOPT_0x57
	__GETD1N 0x42C80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x201FA
	CALL SUBOPT_0x56
; 0001 0899       if(err<-100) err=-100;
_0x201FA:
	CALL SUBOPT_0x57
	__GETD1N 0xC2C80000
	CALL __CMPF12
	BRSH _0x201FB
	CALL SUBOPT_0x56
; 0001 089A       sumi=sumi+ err/35;
_0x201FB:
	CALL SUBOPT_0x57
	__GETD1N 0x420C0000
	CALL SUBOPT_0x58
	CALL SUBOPT_0x59
; 0001 089B       if(sumi>6) sumi=6;
	__GETD2S 16
	__GETD1N 0x40C00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x201FC
	CALL SUBOPT_0x59
; 0001 089C       if(sumi<-6) sumi=-6;
_0x201FC:
	__GETD2S 16
	__GETD1N 0xC0C00000
	CALL __CMPF12
	BRSH _0x201FD
	CALL SUBOPT_0x59
; 0001 089D       udk = err/7 + sumi+(err-lasterr)/30;
_0x201FD:
	CALL SUBOPT_0x57
	__GETD1N 0x40E00000
	CALL SUBOPT_0x58
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5A
	__GETD1S 12
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
	CALL SUBOPT_0x5B
; 0001 089E       if(udk>10) {udk=9;sumi=0;}
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x201FE
	__GETD1N 0x41100000
	CALL SUBOPT_0x5E
; 0001 089F       if(udk<-10){ udk=-9;sumi=0;}
_0x201FE:
	CALL SUBOPT_0x5C
	__GETD1N 0xC1200000
	CALL __CMPF12
	BRSH _0x201FF
	__GETD1N 0xC1100000
	CALL SUBOPT_0x5E
; 0001 08A0       //hc(5,10);wn16s(udk);
; 0001 08A1       vMLtoi(10+udk); vMRtoi(10-udk) ;
_0x201FF:
	__GETD1S 20
	__GETD2N 0x41200000
	CALL __ADDF12
	CALL __CFD1U
	ST   -Y,R30
	RCALL _vMLtoi
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5D
	CALL __SUBF12
	CALL __CFD1U
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 08A2 
; 0001 08A3       lastvalueline=valueline;
	__GETD1S 53
	__PUTD1S 57
; 0001 08A4       lasterr=err;
	__GETD1S 12
	__PUTD1S 8
; 0001 08A5    }
	RJMP _0x201EF
; 0001 08A6 
; 0001 08A7    while(keyKT!=0)
_0x20200:
	SBIS 0x13,0
	RJMP _0x20202
; 0001 08A8    {
; 0001 08A9        //doc gia tri cam bien
; 0001 08AA         readline();
	CALL SUBOPT_0x54
; 0001 08AB         admin = IRLINE[0];imin=0;
; 0001 08AC         for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x20204:
	__CPWRN 16,17,5
	BRGE _0x20205
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	CALL SUBOPT_0x55
	BRSH _0x20206
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x20206:
	__ADDWRN 16,17,1
	RJMP _0x20204
_0x20205:
; 0001 08AD         hc(2,10);wn16s(iminlast);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x40
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x36
; 0001 08AE         hc(3,10);wn16s(imin);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x40
	ST   -Y,R21
	ST   -Y,R20
	CALL _wn16s
; 0001 08AF         hc(4,10);wn16s(admin);
	CALL SUBOPT_0x53
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	CALL SUBOPT_0x36
; 0001 08B0 
; 0001 08B1         if((imin-iminlast > 1)||(imin-iminlast <-1))  //tranh truong hop nhay bo trang thai
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	MOVW R30,R20
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	SBIW R30,2
	BRGE _0x20208
	MOVW R30,R26
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRGE _0x20207
_0x20208:
; 0001 08B2         {
; 0001 08B3         }
; 0001 08B4         else
	RJMP _0x2020A
_0x20207:
; 0001 08B5         {
; 0001 08B6              switch(imin)
	MOVW R30,R20
; 0001 08B7             {
; 0001 08B8               case 0:
	SBIW R30,0
	BRNE _0x2020E
; 0001 08B9                   vMLtoi(1); vMRtoi(15) ;
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4E
; 0001 08BA                   //flagblindT = 0;
; 0001 08BB                   flagblindP = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+24,R30
	STD  Y+24+1,R31
; 0001 08BC                 break;
	RJMP _0x2020D
; 0001 08BD               case 1:
_0x2020E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2020F
; 0001 08BE                   vMLtoi(2); vMRtoi(8) ;
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _vMLtoi
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 08BF                 break;
	RJMP _0x2020D
; 0001 08C0               case 2:
_0x2020F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20210
; 0001 08C1                   vMLtoi(10);vMRtoi(10) ;
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _vMLtoi
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 08C2                 break;
	RJMP _0x2020D
; 0001 08C3               case 3:
_0x20210:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20211
; 0001 08C4                  vMLtoi(8); vMRtoi(2) ;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x5F
; 0001 08C5                 break;
	RJMP _0x2020D
; 0001 08C6               case 4:
_0x20211:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20213
; 0001 08C7                   vMLtoi(15);vMRtoi(1)  ;
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
; 0001 08C8                   flagblindT = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+26,R30
	STD  Y+26+1,R31
; 0001 08C9                   //flagblindP = 0;
; 0001 08CA                 break;
; 0001 08CB               default:
_0x20213:
; 0001 08CC                  // vMLtoi(5); vMRtoi(5) ;
; 0001 08CD                 break;
; 0001 08CE             }
_0x2020D:
; 0001 08CF 
; 0001 08D0               iminlast=imin;
	__PUTWSR 20,21,6
; 0001 08D1          }
_0x2020A:
; 0001 08D2 
; 0001 08D3 
; 0001 08D4             while(flagblindT == 1 && keyKT!=0) //lac duong ben trai
_0x20214:
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	SBIW R26,1
	BRNE _0x20217
	CALL SUBOPT_0x52
	BRNE _0x20218
_0x20217:
	RJMP _0x20216
_0x20218:
; 0001 08D5             {
; 0001 08D6                vMLtoi(20);vMRtoi(2)  ;
	LDI  R30,LOW(20)
	CALL SUBOPT_0x5F
; 0001 08D7                readline();
	CALL SUBOPT_0x54
; 0001 08D8                admin = IRLINE[0];imin=0;
; 0001 08D9                for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x2021A:
	__CPWRN 16,17,5
	BRGE _0x2021B
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	CALL SUBOPT_0x55
	BRSH _0x2021C
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x2021C:
	__ADDWRN 16,17,1
	RJMP _0x2021A
_0x2021B:
; 0001 08DA                iminlast=imin;
	__PUTWSR 20,21,6
; 0001 08DB                if(IRLINE[2]<310)  flagblindT=0;
	CALL SUBOPT_0x46
	CPI  R26,LOW(0x136)
	LDI  R30,HIGH(0x136)
	CPC  R27,R30
	BRSH _0x2021D
	LDI  R30,LOW(0)
	STD  Y+26,R30
	STD  Y+26+1,R30
; 0001 08DC 
; 0001 08DD             }
_0x2021D:
	RJMP _0x20214
_0x20216:
; 0001 08DE             while(flagblindP ==1 && keyKT!=0) //lac duong ben phai
_0x2021E:
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	SBIW R26,1
	BRNE _0x20221
	CALL SUBOPT_0x52
	BRNE _0x20222
_0x20221:
	RJMP _0x20220
_0x20222:
; 0001 08DF             {
; 0001 08E0                vMLtoi(2);vMRtoi(20)  ;
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _vMLtoi
	CALL SUBOPT_0x4D
; 0001 08E1                readline();
	CALL SUBOPT_0x54
; 0001 08E2                admin = IRLINE[0];imin=0;
; 0001 08E3                for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x20224:
	__CPWRN 16,17,5
	BRGE _0x20225
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	CALL SUBOPT_0x55
	BRSH _0x20226
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x20226:
	__ADDWRN 16,17,1
	RJMP _0x20224
_0x20225:
; 0001 08E4                iminlast=imin;
	__PUTWSR 20,21,6
; 0001 08E5                if(IRLINE[2]<310)  flagblindP=0;
	CALL SUBOPT_0x46
	CPI  R26,LOW(0x136)
	LDI  R30,HIGH(0x136)
	CPC  R27,R30
	BRSH _0x20227
	LDI  R30,LOW(0)
	STD  Y+24,R30
	STD  Y+24+1,R30
; 0001 08E6 
; 0001 08E7             }
_0x20227:
	RJMP _0x2021E
_0x20220:
; 0001 08E8 
; 0001 08E9 
; 0001 08EA        demled++;
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	ADIW R30,1
	STD  Y+28,R30
	STD  Y+28+1,R31
; 0001 08EB        if(demled>30){demled=0;LEDLtoggle();LEDRtoggle(); }
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	SBIW R26,31
	BRLO _0x20228
	LDI  R30,LOW(0)
	STD  Y+28,R30
	STD  Y+28+1,R30
	CALL SUBOPT_0x44
; 0001 08EC    }
_0x20228:
	RJMP _0x20200
_0x20202:
; 0001 08ED }
	CALL __LOADLOCR6
	ADIW R28,61
	RET

	.DSEG
_0x201DB:
	.BYTE 0x13
;//========================================================
;void bluetooth()
; 0001 08F0 {  unsigned char kytu;

	.CSEG
_bluetooth:
; 0001 08F1    unsigned int demled;
; 0001 08F2 
; 0001 08F3         LcdClear();
	CALL __SAVELOCR4
;	kytu -> R17
;	demled -> R18,R19
	CALL SUBOPT_0x60
; 0001 08F4         hc(0,10);
	CALL SUBOPT_0x40
; 0001 08F5         ws ("BLUETOOTH");
	__POINTW1MN _0x20229,0
	CALL SUBOPT_0x1E
; 0001 08F6         hc(1,25);
	CALL SUBOPT_0x3C
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CALL SUBOPT_0x61
; 0001 08F7         ws ("DRIVE");
	__POINTW1MN _0x20229,10
	CALL SUBOPT_0x1E
; 0001 08F8 
; 0001 08F9         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 08FA 
; 0001 08FB    while(keyKT!=0)
_0x2022E:
	SBIS 0x13,0
	RJMP _0x20230
; 0001 08FC    {
; 0001 08FD         LEDL=1; LEDR=1;
	CALL SUBOPT_0x62
; 0001 08FE         delay_ms(100);
; 0001 08FF         LEDL=0; LEDR=0;
; 0001 0900         delay_ms(100);
; 0001 0901 
; 0001 0902       if (rx_counter)
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x20239
; 0001 0903       {
; 0001 0904        //LcdClear();
; 0001 0905        hc(2,42);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x42
; 0001 0906        kytu = getchar();
	CALL _getchar
	MOV  R17,R30
; 0001 0907        LcdCharacter(kytu);
	ST   -Y,R17
	CALL _LcdCharacter
; 0001 0908        //putchar(getchar());
; 0001 0909        if(kytu=='S'){vMLtoi(0);vMRtoi(0);}
	CPI  R17,83
	BRNE _0x2023A
	LDI  R30,LOW(0)
	CALL SUBOPT_0x63
; 0001 090A        if(kytu=='F'){vMLtoi(100);vMRtoi(100);}
_0x2023A:
	CPI  R17,70
	BRNE _0x2023B
	LDI  R30,LOW(100)
	CALL SUBOPT_0x64
; 0001 090B        if(kytu=='B'){vMLlui(100);vMRlui(100);}
_0x2023B:
	CPI  R17,66
	BRNE _0x2023C
	LDI  R30,LOW(100)
	ST   -Y,R30
	RCALL _vMLlui
	LDI  R30,LOW(100)
	ST   -Y,R30
	RCALL _vMRlui
; 0001 090C        if(kytu=='R'){vMLtoi(100);vMRtoi(0);}
_0x2023C:
	CPI  R17,82
	BRNE _0x2023D
	LDI  R30,LOW(100)
	CALL SUBOPT_0x63
; 0001 090D        if(kytu=='L'){vMLtoi(0);vMRtoi(100);}
_0x2023D:
	CPI  R17,76
	BRNE _0x2023E
	LDI  R30,LOW(0)
	CALL SUBOPT_0x64
; 0001 090E 
; 0001 090F        demled++;
_0x2023E:
	__ADDWRN 18,19,1
; 0001 0910        if(demled>1000){demled=0;LEDLtoggle(); LEDRtoggle();}
	__CPWRN 18,19,1001
	BRLO _0x2023F
	__GETWRN 18,19,0
	CALL SUBOPT_0x44
; 0001 0911       }
_0x2023F:
; 0001 0912     }
_0x20239:
	RJMP _0x2022E
_0x20230:
; 0001 0913 }
_0x20C0006:
	CALL __LOADLOCR4
	ADIW R28,4
	RET

	.DSEG
_0x20229:
	.BYTE 0x10
;//========================================================
;
;//Chuong trinh test robot
;   void testmotor()
; 0001 0918    {

	.CSEG
_testmotor:
; 0001 0919         LcdClear();
	CALL SUBOPT_0x60
; 0001 091A         hc(0,10);
	CALL SUBOPT_0x40
; 0001 091B         ws ("TEST MOTOR");
	__POINTW1MN _0x20240,0
	CALL SUBOPT_0x1E
; 0001 091C 
; 0001 091D         vMRtoi(20);
	CALL SUBOPT_0x4D
; 0001 091E         vMLtoi(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	RCALL _vMLtoi
; 0001 091F       while(keyKT!=0)
_0x20241:
	SBIS 0x13,0
	RJMP _0x20243
; 0001 0920       {
; 0001 0921         hc(2,0);
	CALL SUBOPT_0x65
; 0001 0922         ws ("MotorL");
	__POINTW1MN _0x20240,11
	CALL SUBOPT_0x1E
; 0001 0923         hc(2,45);
	CALL SUBOPT_0x3A
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CALL SUBOPT_0x61
; 0001 0924         wn16(QEL);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x1D
; 0001 0925         hc(3,0);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x17
; 0001 0926         ws ("MotorR");
	__POINTW1MN _0x20240,18
	CALL SUBOPT_0x1E
; 0001 0927         hc(3,45);
	CALL SUBOPT_0x37
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CALL SUBOPT_0x61
; 0001 0928         wn16(QER);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x1D
; 0001 0929         delay_ms(10);
	CALL SUBOPT_0x66
; 0001 092A       }
	RJMP _0x20241
_0x20243:
; 0001 092B 
; 0001 092C        vMRstop();
	RCALL _vMRstop
; 0001 092D        vMLstop();
	CALL _vMLstop
; 0001 092E    }
	RET

	.DSEG
_0x20240:
	.BYTE 0x19
; //========================================================
; // UART TEST
;   void testuart()
; 0001 0932    {

	.CSEG
_testuart:
; 0001 0933           if (rx_counter)
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x20244
; 0001 0934           {
; 0001 0935           LcdClear();
	CALL SUBOPT_0x60
; 0001 0936            hc(0,10);
	CALL SUBOPT_0x40
; 0001 0937            ws ("TEST UART");
	__POINTW1MN _0x20245,0
	CALL SUBOPT_0x1E
; 0001 0938            putchar(getchar());
	CALL _getchar
	ST   -Y,R30
	CALL _putchar
; 0001 0939           }
; 0001 093A 
; 0001 093B    }
_0x20244:
	RET

	.DSEG
_0x20245:
	.BYTE 0xA
;   //========================================================
; // UART TEST
;   void testrf()
; 0001 093F    {

	.CSEG
_testrf:
; 0001 0940 
; 0001 0941 
; 0001 0942    }
	RET
;
;//========================================================
;   void testir()
; 0001 0946    {    unsigned int AD[8];
_testir:
; 0001 0947 
; 0001 0948         DDRA    = 0x00;
	SBIW R28,16
;	AD -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0001 0949         PORTA   = 0x00;
	OUT  0x1B,R30
; 0001 094A 
; 0001 094B         clear();
	CALL _clear
; 0001 094C         hc(0,10);
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
; 0001 094D         ws ("TEST IR");
	__POINTW1MN _0x20246,0
	CALL SUBOPT_0x1E
; 0001 094E 
; 0001 094F         while(keyKT!=0)
_0x20247:
	SBIS 0x13,0
	RJMP _0x20249
; 0001 0950         {
; 0001 0951 
; 0001 0952         AD[0]=read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _read_adc
	ST   Y,R30
	STD  Y+1,R31
; 0001 0953         AD[1]=read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 0954         AD[2]=read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0001 0955         AD[3]=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 0956         AD[4]=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0957         AD[5]=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 0958         AD[6]=read_adc(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0001 0959         AD[7]=read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0001 095A 
; 0001 095B         hc(1,0) ;ws("0.");wn164(AD[0]);
	CALL SUBOPT_0x41
	__POINTW1MN _0x20246,8
	CALL SUBOPT_0x1E
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x67
; 0001 095C         hc(1,43);ws("1.");wn164(AD[1]);
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x68
	__POINTW1MN _0x20246,11
	CALL SUBOPT_0x1E
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x67
; 0001 095D         hc(2,0) ;ws("2.");wn164(AD[2]);
	CALL SUBOPT_0x65
	__POINTW1MN _0x20246,14
	CALL SUBOPT_0x1E
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x67
; 0001 095E         hc(2,43);ws("3.");wn164(AD[3]);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x68
	__POINTW1MN _0x20246,17
	CALL SUBOPT_0x1E
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x67
; 0001 095F         hc(3,0) ;ws("4.");wn164(AD[4]);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x17
	__POINTW1MN _0x20246,20
	CALL SUBOPT_0x1E
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0x67
; 0001 0960         hc(3,43);ws("5.");wn164(AD[5]);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x68
	__POINTW1MN _0x20246,23
	CALL SUBOPT_0x1E
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL SUBOPT_0x67
; 0001 0961         hc(4,0) ;ws("6.");wn164(AD[6]);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x17
	__POINTW1MN _0x20246,26
	CALL SUBOPT_0x1E
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x67
; 0001 0962         hc(4,43);ws("7.");wn164(AD[7]);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x68
	__POINTW1MN _0x20246,29
	CALL SUBOPT_0x1E
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CALL SUBOPT_0x67
; 0001 0963 
; 0001 0964         delay_ms(1000);
	CALL SUBOPT_0x1B
; 0001 0965         }
	RJMP _0x20247
_0x20249:
; 0001 0966 
; 0001 0967    }
	ADIW R28,16
	RET

	.DSEG
_0x20246:
	.BYTE 0x20
;
;//========================================================
; void outlcd1()
; 0001 096B  {

	.CSEG
_outlcd1:
; 0001 096C      LcdClear();
	CALL SUBOPT_0x60
; 0001 096D      hc(0,5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x61
; 0001 096E      ws("<SELF TEST>");
	__POINTW1MN _0x2024A,0
	CALL SUBOPT_0x1E
; 0001 096F      hc(1,0);
	CALL SUBOPT_0x41
; 0001 0970      ws("************");
	__POINTW1MN _0x2024A,12
	CALL SUBOPT_0x1E
; 0001 0971  }
	RET

	.DSEG
_0x2024A:
	.BYTE 0x19
;//========================================================
;void chopledtheoid()
; 0001 0974 {    unsigned char i;

	.CSEG
_chopledtheoid:
; 0001 0975         DDRA=0xFF;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 0976 
; 0001 0977          switch (id)
	CALL SUBOPT_0x69
; 0001 0978             {
; 0001 0979                 case 1:
	BRNE _0x2024E
; 0001 097A                     LEDR=1;
	SBI  0x15,5
; 0001 097B                     LEDL=1;PORTA.4=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,4
	CALL SUBOPT_0x66
; 0001 097C                     LEDL=0;PORTA.4=0;delay_ms(30);
	CBI  0x15,4
	RJMP _0x2031F
; 0001 097D                 break;
; 0001 097E                 case 2:
_0x2024E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20259
; 0001 097F                     LEDR=1;
	SBI  0x15,5
; 0001 0980                     LEDL=1;PORTA.6=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,6
	CALL SUBOPT_0x66
; 0001 0981                     LEDL=0;PORTA.6=0;delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,6
	RJMP _0x20320
; 0001 0982                 break;
; 0001 0983                 case 3:
_0x20259:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20264
; 0001 0984                     LEDR=1;
	SBI  0x15,5
; 0001 0985                     LEDL=1;PORTA.7=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,7
	CALL SUBOPT_0x66
; 0001 0986                     LEDL=0;PORTA.7=0;delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,7
	RJMP _0x20320
; 0001 0987                 break;
; 0001 0988                 case 4:
_0x20264:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2026F
; 0001 0989                     LEDR=1;
	SBI  0x15,5
; 0001 098A                     LEDL=1;PORTA.5=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,5
	CALL SUBOPT_0x66
; 0001 098B                     LEDL=0;PORTA.5=0;delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,5
	RJMP _0x20320
; 0001 098C                 break;
; 0001 098D                 case 5:
_0x2026F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2027A
; 0001 098E                     LEDL=1;
	SBI  0x15,4
; 0001 098F                     LEDR=1;PORTA.4=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,4
	CALL SUBOPT_0x66
; 0001 0990                     LEDR=0;PORTA.4=0;delay_ms(30);
	RJMP _0x20321
; 0001 0991                 break;
; 0001 0992                 case 6:
_0x2027A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20285
; 0001 0993                     LEDL=1;
	SBI  0x15,4
; 0001 0994                     LEDR=1;PORTA.6=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,6
	CALL SUBOPT_0x66
; 0001 0995                     LEDR=0;PORTA.6=0;delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,6
	RJMP _0x20320
; 0001 0996                 break;
; 0001 0997                 case 7:
_0x20285:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x20290
; 0001 0998                     LEDL=1;
	SBI  0x15,4
; 0001 0999                     LEDR=1;PORTA.7=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,7
	CALL SUBOPT_0x66
; 0001 099A                     LEDR=0;PORTA.7=0;delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,7
	RJMP _0x20320
; 0001 099B                 break;
; 0001 099C                 case 8:
_0x20290:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2029B
; 0001 099D                     LEDL=1;
	SBI  0x15,4
; 0001 099E                     LEDR=1;PORTA.5=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,5
	CALL SUBOPT_0x66
; 0001 099F                     LEDR=0;PORTA.5=0;delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,5
	RJMP _0x20320
; 0001 09A0                 break;
; 0001 09A1                 case 9:
_0x2029B:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x2024D
; 0001 09A2                     LEDL=1;LEDR=1;PORTA.4=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x15,5
	SBI  0x1B,4
	CALL SUBOPT_0x66
; 0001 09A3                     LEDL=0;LEDR=0;PORTA.4=0;delay_ms(30);
	CBI  0x15,4
_0x20321:
	CBI  0x15,5
_0x2031F:
	CBI  0x1B,4
_0x20320:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x6A
; 0001 09A4                 break;
; 0001 09A5             };
_0x2024D:
; 0001 09A6         //LEDL=1;delay_ms(100);
; 0001 09A7         //LEDL=0;delay_ms(100);
; 0001 09A8         //for(i=0;i<id;i++)
; 0001 09A9         //{
; 0001 09AA         //    LEDR=1;delay_ms(150);
; 0001 09AB         //    LEDR=0;delay_ms(150);
; 0001 09AC         //}
; 0001 09AD }
	LD   R17,Y+
	RET
;//========================================================
;//========================================================
;void testRCservo()
; 0001 09B1 {
_testRCservo:
; 0001 09B2         clear();
	CALL _clear
; 0001 09B3         hc(0,10);
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
; 0001 09B4         ws ("RC SERVO");
	__POINTW1MN _0x202B3,0
	CALL SUBOPT_0x1E
; 0001 09B5 // Timer/Counter 0 initialization
; 0001 09B6 // Clock source: System Clock
; 0001 09B7 // Clock value: 7.813 kHz
; 0001 09B8 // Mode: Phase correct PWM top=0xFF
; 0001 09B9 // OC0 output: Non-Inverted PWM
; 0001 09BA TCCR0=0x65;     //15.32Hz
	LDI  R30,LOW(101)
	CALL SUBOPT_0x6B
; 0001 09BB TCNT0=0x00;
; 0001 09BC OCR0=0x00;
; 0001 09BD 
; 0001 09BE // Timer/Counter 2 initialization
; 0001 09BF // Clock source: System Clock
; 0001 09C0 // Clock value: 7.813 kHz
; 0001 09C1 // Mode: Phase correct PWM top=0xFF
; 0001 09C2 // OC2 output: Non-Inverted PWM
; 0001 09C3 ASSR=0x00;      //15.32Hz
; 0001 09C4 TCCR2=0x67;
	LDI  R30,LOW(103)
	OUT  0x25,R30
; 0001 09C5 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0001 09C6 OCR2=0x00;
	OUT  0x23,R30
; 0001 09C7 
; 0001 09C8   while(keyKT!=0)
_0x202B4:
	SBIS 0x13,0
	RJMP _0x202B6
; 0001 09C9    {
; 0001 09CA    LEDL=1;LEDR=1;//PORTB.3=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 09CB    OCR0=2; OCR2=2;
	LDI  R30,LOW(2)
	OUT  0x3C,R30
	OUT  0x23,R30
; 0001 09CC    delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x6A
; 0001 09CD 
; 0001 09CE    LEDL=0;LEDR=0;//PORTB.3=1;
	CBI  0x15,4
	CBI  0x15,5
; 0001 09CF    OCR0=10; OCR2=10;
	LDI  R30,LOW(10)
	OUT  0x3C,R30
	OUT  0x23,R30
; 0001 09D0    delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x6A
; 0001 09D1    }
	RJMP _0x202B4
_0x202B6:
; 0001 09D2 // Timer/Counter 0 initialization
; 0001 09D3 // Clock source: System Clock
; 0001 09D4 // Clock value: Timer 0 Stopped
; 0001 09D5 // Mode: Normal top=0xFF
; 0001 09D6 // OC0 output: Disconnected
; 0001 09D7 TCCR0=0x00;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x6B
; 0001 09D8 TCNT0=0x00;
; 0001 09D9 OCR0=0x00;
; 0001 09DA 
; 0001 09DB // Timer/Counter 2 initialization
; 0001 09DC // Clock source: System Clock
; 0001 09DD // Clock value: Timer2 Stopped
; 0001 09DE // Mode: Normal top=0xFF
; 0001 09DF // OC2 output: Disconnected
; 0001 09E0 ASSR =0x00;
; 0001 09E1 TCCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0001 09E2 TCNT2=0x00;
	OUT  0x24,R30
; 0001 09E3 OCR2 =0x00;
	OUT  0x23,R30
; 0001 09E4 
; 0001 09E5 }
	RET

	.DSEG
_0x202B3:
	.BYTE 0x9
;
;void selftest()
; 0001 09E8 {

	.CSEG
_selftest:
; 0001 09E9     outlcd1();
	CALL SUBOPT_0x6C
; 0001 09EA     hc(2,0);
; 0001 09EB     ws ("1.ROBOT WALL");delay_ms(200);
	__POINTW1MN _0x202BF,0
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x3E
; 0001 09EC      while(flagselftest==1)
_0x202C0:
	LDS  R26,_flagselftest
	LDS  R27,_flagselftest+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x202C2
; 0001 09ED      {
; 0001 09EE         //------------------------------------------------------------------------
; 0001 09EF         //test menu kiem tra  robot
; 0001 09F0          chopledtheoid();
	RCALL _chopledtheoid
; 0001 09F1           if(keyKT==0)
	SBIC 0x13,0
	RJMP _0x202C3
; 0001 09F2             {
; 0001 09F3                 id++;
	LDS  R30,_id
	SUBI R30,-LOW(1)
	STS  _id,R30
; 0001 09F4                 if(id>11){id=1;}
	LDS  R26,_id
	CPI  R26,LOW(0xC)
	BRLO _0x202C4
	LDI  R30,LOW(1)
	STS  _id,R30
; 0001 09F5                 switch (id)
_0x202C4:
	CALL SUBOPT_0x69
; 0001 09F6                 {
; 0001 09F7 
; 0001 09F8                 case 1:
	BRNE _0x202C8
; 0001 09F9                     outlcd1();
	CALL SUBOPT_0x6C
; 0001 09FA                     hc(2,0);
; 0001 09FB                     ws ("1.ROBOT WALL");delay_ms(200);
	__POINTW1MN _0x202BF,13
	RJMP _0x20322
; 0001 09FC                 break;
; 0001 09FD                 case 2:
_0x202C8:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x202C9
; 0001 09FE                     outlcd1();
	CALL SUBOPT_0x6C
; 0001 09FF                     hc(2,0);
; 0001 0A00                     ws ("2.BLUETOOTH ");delay_ms(200);
	__POINTW1MN _0x202BF,26
	RJMP _0x20322
; 0001 0A01                 break;
; 0001 0A02                 case 3:
_0x202C9:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x202CA
; 0001 0A03                     outlcd1();
	CALL SUBOPT_0x6C
; 0001 0A04                     hc(2,0);
; 0001 0A05                     ws ("3.WHITE LINE");delay_ms(200);
	__POINTW1MN _0x202BF,39
	RJMP _0x20322
; 0001 0A06                 break;
; 0001 0A07                 case 4:
_0x202CA:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x202CB
; 0001 0A08                     outlcd1();
	CALL SUBOPT_0x6C
; 0001 0A09                     hc(2,0);
; 0001 0A0A                     ws ("4.BLACK LINE");delay_ms(200);
	__POINTW1MN _0x202BF,52
	RJMP _0x20322
; 0001 0A0B                 break;
; 0001 0A0C                 case 5:
_0x202CB:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x202CC
; 0001 0A0D                     outlcd1();
	CALL SUBOPT_0x6C
; 0001 0A0E                     hc(2,0);
; 0001 0A0F                     ws ("5.TEST MOTOR");delay_ms(200);
	__POINTW1MN _0x202BF,65
	RJMP _0x20322
; 0001 0A10                 break;
; 0001 0A11                 case 6:
_0x202CC:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x202CD
; 0001 0A12                     outlcd1();
	CALL SUBOPT_0x6C
; 0001 0A13                     hc(2,0);
; 0001 0A14                     ws ("6.TEST IR   ");delay_ms(200);
	__POINTW1MN _0x202BF,78
	RJMP _0x20322
; 0001 0A15                 break;
; 0001 0A16                 case 7:
_0x202CD:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x202CE
; 0001 0A17                     outlcd1();
	CALL SUBOPT_0x6C
; 0001 0A18                     hc(2,0);
; 0001 0A19                     ws ("7.TEST RF   ");delay_ms(200);
	__POINTW1MN _0x202BF,91
	RJMP _0x20322
; 0001 0A1A                 break;
; 0001 0A1B                 case 8:
_0x202CE:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x202CF
; 0001 0A1C                     outlcd1();
	CALL SUBOPT_0x6C
; 0001 0A1D                     hc(2,0);
; 0001 0A1E                     ws ("8.TEST UART ");delay_ms(200);
	__POINTW1MN _0x202BF,104
	RJMP _0x20322
; 0001 0A1F                 break;
; 0001 0A20                 case 9:
_0x202CF:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x202D0
; 0001 0A21                     outlcd1();
	CALL SUBOPT_0x6C
; 0001 0A22                     hc(2,0);
; 0001 0A23                     ws ("9.RC SERVO ");delay_ms(200);
	__POINTW1MN _0x202BF,117
	RJMP _0x20322
; 0001 0A24                 break;
; 0001 0A25                 case 10:
_0x202D0:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x202C7
; 0001 0A26                     outlcd1();
	CALL SUBOPT_0x6C
; 0001 0A27                     hc(2,0);
; 0001 0A28                     ws ("10.UPDATE RB");delay_ms(200);
	__POINTW1MN _0x202BF,129
_0x20322:
	ST   -Y,R31
	ST   -Y,R30
	CALL _ws
	CALL SUBOPT_0x3E
; 0001 0A29                 break;
; 0001 0A2A                 };
_0x202C7:
; 0001 0A2B             }
; 0001 0A2C          if(keyKP==0)
_0x202C3:
	SBIC 0x13,1
	RJMP _0x202D2
; 0001 0A2D             {
; 0001 0A2E                 switch (id)
	CALL SUBOPT_0x69
; 0001 0A2F                 {
; 0001 0A30                 case 1:
	BRNE _0x202D6
; 0001 0A31                     robotwall() ;
	RCALL _robotwall
; 0001 0A32                 break;
	RJMP _0x202D5
; 0001 0A33                 case 2:
_0x202D6:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x202D7
; 0001 0A34                     bluetooth() ;
	RCALL _bluetooth
; 0001 0A35                 break;
	RJMP _0x202D5
; 0001 0A36                 case 3:
_0x202D7:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x202D8
; 0001 0A37                     robotwhiteline() ;
	RCALL _robotwhiteline
; 0001 0A38                 break;
	RJMP _0x202D5
; 0001 0A39                 case 4:
_0x202D8:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x202D9
; 0001 0A3A                     robotblackline() ;
	RCALL _robotblackline
; 0001 0A3B                 break;
	RJMP _0x202D5
; 0001 0A3C                 case 5:
_0x202D9:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x202DA
; 0001 0A3D                     testmotor() ;
	RCALL _testmotor
; 0001 0A3E                 break;
	RJMP _0x202D5
; 0001 0A3F                 case 6:
_0x202DA:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x202DB
; 0001 0A40                     testir()    ;
	RCALL _testir
; 0001 0A41                 break;
	RJMP _0x202D5
; 0001 0A42                 case 7:
_0x202DB:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x202DC
; 0001 0A43                     testrf()    ;
	RCALL _testrf
; 0001 0A44                 break;
	RJMP _0x202D5
; 0001 0A45                 case 8:
_0x202DC:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x202DD
; 0001 0A46                     testuart()  ;
	RCALL _testuart
; 0001 0A47                 break;
	RJMP _0x202D5
; 0001 0A48                 case 9:
_0x202DD:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x202DE
; 0001 0A49                     testRCservo()  ;
	RCALL _testRCservo
; 0001 0A4A                 break;
	RJMP _0x202D5
; 0001 0A4B                 case 10:
_0x202DE:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x202D5
; 0001 0A4C                     testposition() ;
	RCALL _testposition
; 0001 0A4D                 break;
; 0001 0A4E 
; 0001 0A4F                 };
_0x202D5:
; 0001 0A50 
; 0001 0A51             }
; 0001 0A52 
; 0001 0A53 
; 0001 0A54      }//end while(1)
_0x202D2:
	RJMP _0x202C0
_0x202C2:
; 0001 0A55 }
	RET

	.DSEG
_0x202BF:
	.BYTE 0x8E
;#ifdef DEBUG_EN
;  char debugMsgBuff[32];
;#endif
;void debug_out(char *pMsg,unsigned char len)
; 0001 0A5A {

	.CSEG
; 0001 0A5B     #ifdef DEBUG_EN
; 0001 0A5C     char i=0;
; 0001 0A5D     for(i=0;i<len;i++)
; 0001 0A5E     {
; 0001 0A5F         putchar(*pMsg++);
; 0001 0A60         delay_us(300);
; 0001 0A61     }
; 0001 0A62     #endif
; 0001 0A63     return ;
;	*pMsg -> Y+1
;	len -> Y+0
; 0001 0A64 }
;//[NGUYEN]Set bit and clear bit
;#define setBit(p,n) ((p) |= (1 << (n)))
;#define clrBit(p,n) ((p) &= (~(1) << (n)))
;
;//[NGUYEN] Update position. 64ms/frame
;//call setUpdateRate() in MAIN to init.
;char timer2Count=0;
;char posUpdateFlag=0;
;#define distThresh 100
;
;IntBall oldPos;
;void initPos()
; 0001 0A71 {
_initPos:
; 0001 0A72     oldPos.x = rbctrlHomeX;
	LDS  R30,_rbctrlHomeX
	LDS  R31,_rbctrlHomeX+1
	LDS  R22,_rbctrlHomeX+2
	LDS  R23,_rbctrlHomeX+3
	LDI  R26,LOW(_oldPos)
	LDI  R27,HIGH(_oldPos)
	CALL SUBOPT_0xA
; 0001 0A73     oldPos.y = rbctrlHomeY;
	__POINTW2MN _oldPos,2
	LDS  R30,_rbctrlHomeY
	LDS  R31,_rbctrlHomeY+1
	LDS  R22,_rbctrlHomeY+2
	LDS  R23,_rbctrlHomeY+3
	CALL SUBOPT_0xA
; 0001 0A74 }
	RET
;
;IntBall estimatePos(IntBall curPos)
; 0001 0A77 {
_estimatePos:
; 0001 0A78 	return curPos;
	SBIW R28,4
;	curPos -> Y+4
	MOVW R30,R28
	ADIW R30,4
	MOVW R26,R28
	LDI  R24,4
	CALL __COPYMML
	MOVW R30,R28
	LDI  R24,4
	IN   R1,SREG
	CLI
	JMP  _0x20C0005
; 0001 0A79 }
;
;void updatePosInit()
; 0001 0A7C {
_updatePosInit:
; 0001 0A7D 	// Timer/Counter 2 initialization
; 0001 0A7E 	// Clock source: System Clock
; 0001 0A7F 	// Clock value: 7.813 kHz
; 0001 0A80 	// Mode: CTC top=OCR2
; 0001 0A81 	// OC2 output: Disconnected
; 0001 0A82 	ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0001 0A83 	TCCR2=0x0F;
	LDI  R30,LOW(15)
	OUT  0x25,R30
; 0001 0A84 	TCNT2=0x12;
	LDI  R30,LOW(18)
	OUT  0x24,R30
; 0001 0A85 	OCR2=254;
	LDI  R30,LOW(254)
	OUT  0x23,R30
; 0001 0A86 	// Timer(s)/Counter(s) Interrupt(s) initialization
; 0001 0A87 	setBit(TIMSK,OCIE2);
	IN   R30,0x39
	ORI  R30,0x80
	OUT  0x39,R30
; 0001 0A88 }
	RET
;//[NGUYEN]
;
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
; 0001 0A8C {
_timer2_comp_isr:
	CALL SUBOPT_0x2A
; 0001 0A8D     unsigned char i=0;
; 0001 0A8E     LEDRtoggle();
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	CALL _LEDRtoggle
; 0001 0A8F     if (timer2Count++<2)
	LDS  R26,_timer2Count
	SUBI R26,-LOW(1)
	STS  _timer2Count,R26
	SUBI R26,LOW(1)
	CPI  R26,LOW(0x2)
	BRSH _0x202E0
; 0001 0A90          return;
	RJMP _0x20324
; 0001 0A91     else
_0x202E0:
; 0001 0A92     {
; 0001 0A93         timer2Count=0;
	LDI  R30,LOW(0)
	STS  _timer2Count,R30
; 0001 0A94     }
; 0001 0A95 
; 0001 0A96 
; 0001 0A97         if(nRF24L01_RxPacket(RxBuf)==1)         // Neu nhan duoc du lieu
	LDI  R30,LOW(_RxBuf)
	LDI  R31,HIGH(_RxBuf)
	ST   -Y,R31
	ST   -Y,R30
	CALL _nRF24L01_RxPacket
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x202E2
; 0001 0A98         {
; 0001 0A99          IntRobot intRb;
; 0001 0A9A          for( i=0;i<28;i++)
	SBIW R28,14
;	intRb -> Y+0
	LDI  R17,LOW(0)
_0x202E4:
	CPI  R17,28
	BRSH _0x202E5
; 0001 0A9B          {
; 0001 0A9C              *(uint8_t *) ((uint8_t *)&rb + i)=RxBuf[i];
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_rb)
	SBCI R27,HIGH(-_rb)
	CALL SUBOPT_0x18
	SUBI R30,LOW(-_RxBuf)
	SBCI R31,HIGH(-_RxBuf)
	LD   R30,Z
	ST   X,R30
; 0001 0A9D          }
	SUBI R17,-1
	RJMP _0x202E4
_0x202E5:
; 0001 0A9E 
; 0001 0A9F 
; 0001 0AA0          idRobot = fmod(rb.id,10); // doc id
	CALL SUBOPT_0x6D
	CALL __PUTPARD1
	CALL SUBOPT_0x5D
	CALL __PUTPARD1
	CALL _fmod
	CALL __CFD1U
	MOVW R12,R30
; 0001 0AA1          cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
	CALL SUBOPT_0x6E
; 0001 0AA2 
; 0001 0AA3          intRb = convertRobot2IntRobot(rb);
	LDI  R30,LOW(_rb)
	LDI  R31,HIGH(_rb)
	LDI  R26,28
	CALL __PUTPARL
	CALL _convertRobot2IntRobot
	MOVW R26,R28
	CALL __COPYMML
	OUT  SREG,R1
; 0001 0AA4 
; 0001 0AA5          switch (idRobot)
	MOVW R30,R12
; 0001 0AA6          {
; 0001 0AA7               case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x202E9
; 0001 0AA8                 robot11=intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot11)
	LDI  R27,HIGH(_robot11)
	RJMP _0x20323
; 0001 0AA9                 break;
; 0001 0AAA               case 2:
_0x202E9:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x202EA
; 0001 0AAB                 robot12=intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot12)
	LDI  R27,HIGH(_robot12)
	RJMP _0x20323
; 0001 0AAC                 break;
; 0001 0AAD               case 3:
_0x202EA:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x202EB
; 0001 0AAE                 robot13=intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot13)
	LDI  R27,HIGH(_robot13)
	RJMP _0x20323
; 0001 0AAF                 break;
; 0001 0AB0               case 4:
_0x202EB:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x202EC
; 0001 0AB1                 robot21=intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot21)
	LDI  R27,HIGH(_robot21)
	RJMP _0x20323
; 0001 0AB2                 break;
; 0001 0AB3               case 5:
_0x202EC:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x202ED
; 0001 0AB4                 robot22=intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot22)
	LDI  R27,HIGH(_robot22)
	RJMP _0x20323
; 0001 0AB5                 break;
; 0001 0AB6               case 6:
_0x202ED:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x202E8
; 0001 0AB7                 robot23=intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robot23)
	LDI  R27,HIGH(_robot23)
_0x20323:
	LDI  R24,14
	CALL __COPYMML
; 0001 0AB8                 break;
; 0001 0AB9 
; 0001 0ABA          }
_0x202E8:
; 0001 0ABB          if(idRobot==ROBOT_ID)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R12
	CPC  R31,R13
	BREQ PC+3
	JMP _0x202EF
; 0001 0ABC          {
; 0001 0ABD              LEDL=!LEDL;
	SBIS 0x15,4
	RJMP _0x202F0
	CBI  0x15,4
	RJMP _0x202F1
_0x202F0:
	SBI  0x15,4
_0x202F1:
; 0001 0ABE              cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
	CALL SUBOPT_0x6E
; 0001 0ABF              posUpdateFlag=1;
	LDI  R30,LOW(1)
	STS  _posUpdateFlag,R30
; 0001 0AC0 			 robotctrl=intRb;
	MOVW R30,R28
	LDI  R26,LOW(_robotctrl)
	LDI  R27,HIGH(_robotctrl)
	LDI  R24,14
	CALL __COPYMML
; 0001 0AC1             if((robotctrl.x - oldPos.x >= distThresh)|| (robotctrl.y - oldPos.y >= distThresh))
	__GETW2MN _robotctrl,2
	LDS  R30,_oldPos
	LDS  R31,_oldPos+1
	SUB  R26,R30
	SBC  R27,R31
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0x202F3
	__GETW2MN _robotctrl,4
	__GETW1MN _oldPos,2
	SUB  R26,R30
	SBC  R27,R31
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x202F2
_0x202F3:
; 0001 0AC2 			 {
; 0001 0AC3 				IntBall estPos;
; 0001 0AC4 				IntBall curPos;
; 0001 0AC5 				curPos.x = robotctrl.x;
	SBIW R28,8
;	intRb -> Y+8
;	estPos -> Y+4
;	curPos -> Y+0
	CALL SUBOPT_0x39
	ST   Y,R30
	STD  Y+1,R31
; 0001 0AC6 				curPos.y = robotctrl.y;
	CALL SUBOPT_0x3B
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 0AC7 				estPos = estimatePos(curPos);
	MOVW R30,R28
	LDI  R26,4
	CALL __PUTPARL
	RCALL _estimatePos
	MOVW R26,R28
	ADIW R26,4
	CALL __COPYMML
	OUT  SREG,R1
; 0001 0AC8 				robotctrl.x = estPos.x;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTW1MN _robotctrl,2
; 0001 0AC9 				robotctrl.y = estPos.y;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__PUTW1MN _robotctrl,4
; 0001 0ACA 
; 0001 0ACB 			 }
	ADIW R28,8
; 0001 0ACC 			 oldPos.x = robotctrl.x;
_0x202F2:
	CALL SUBOPT_0x39
	STS  _oldPos,R30
	STS  _oldPos+1,R31
; 0001 0ACD 			 oldPos.y = robotctrl.y;
	CALL SUBOPT_0x3B
	__PUTW1MN _oldPos,2
; 0001 0ACE 		}
; 0001 0ACF 
; 0001 0AD0      }
_0x202EF:
	ADIW R28,14
; 0001 0AD1 }
_0x202E2:
_0x20324:
	LD   R17,Y+
	CALL SUBOPT_0x34
	RETI
;unsigned char readposition()
; 0001 0AD3 {
_readposition:
; 0001 0AD4     return;
	LDI  R30,LOW(0)
	RET
; 0001 0AD5 }
;
;//========================================================
;//          HAM MAIN
;//========================================================
;void main(void)
; 0001 0ADB {
_main:
; 0001 0ADC     // For Testing purpose only, creating a fake robot
; 0001 0ADD     IntRobot rbFake;
; 0001 0ADE     unsigned char flagreadrb;
; 0001 0ADF     unsigned int adctest;
; 0001 0AE0     unsigned char i;
; 0001 0AE1     float PIdl,PIdr,pl,il,pr,ir,ur,ul;
; 0001 0AE2 
; 0001 0AE3     // Testing robot declaration
; 0001 0AE4     rbFake.id = 4;
	SBIW R28,46
;	rbFake -> Y+32
;	flagreadrb -> R17
;	adctest -> R18,R19
;	i -> R16
;	PIdl -> Y+28
;	PIdr -> Y+24
;	pl -> Y+20
;	il -> Y+16
;	pr -> Y+12
;	ir -> Y+8
;	ur -> Y+4
;	ul -> Y+0
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+32,R30
	STD  Y+32+1,R31
; 0001 0AE5     rbFake.x = -42;
	LDI  R30,LOW(65494)
	LDI  R31,HIGH(65494)
	STD  Y+34,R30
	STD  Y+34+1,R31
; 0001 0AE6     rbFake.y = 48;
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	STD  Y+36,R30
	STD  Y+36+1,R31
; 0001 0AE7     rbFake.ox = -35;
	LDI  R30,LOW(65501)
	LDI  R31,HIGH(65501)
	STD  Y+38,R30
	STD  Y+38+1,R31
; 0001 0AE8     rbFake.oy = -50;
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	STD  Y+40,R30
	STD  Y+40+1,R31
; 0001 0AE9     rbFake.ball.x = 0;
	LDI  R30,LOW(0)
	STD  Y+42,R30
	STD  Y+42+1,R30
; 0001 0AEA     rbFake.ball.y = 0;
	STD  Y+44,R30
	STD  Y+44+1,R30
; 0001 0AEB 
; 0001 0AEC     //------------- khai  bao chuc nang in out cua cac port
; 0001 0AED     DDRA    = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 0AEE     DDRB    = 0b10111111;
	LDI  R30,LOW(191)
	OUT  0x17,R30
; 0001 0AEF     DDRC    = 0b11111100;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0001 0AF0     DDRD    = 0b11110010;
	LDI  R30,LOW(242)
	OUT  0x11,R30
; 0001 0AF1 
; 0001 0AF2     //------------- khai  bao chuc nang cua adc
; 0001 0AF3     // ADC initialization
; 0001 0AF4     // ADC Clock frequency: 1000.000 kHz
; 0001 0AF5     // ADC Voltage Reference: AVCC pin
; 0001 0AF6     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0001 0AF7     ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0001 0AF8     //---------------------------------------------------------------------
; 0001 0AF9     //------------- khai  bao chuc nang cua bo timer dung lam PWM cho 2 dong co
; 0001 0AFA     // Timer/Counter 1 initialization
; 0001 0AFB     // Clock source: System Clock
; 0001 0AFC     // Clock value: 1000.000 kHz   //PWM 2KHz
; 0001 0AFD     // Mode: Ph. correct PWM top=0x00FF
; 0001 0AFE     // OC1A output: Non-Inv.
; 0001 0AFF     // OC1B output: Non-Inv.
; 0001 0B00     // Noise Canceler: Off
; 0001 0B01     // Input Capture on Falling Edge
; 0001 0B02     // Timer1 Overflow Interrupt: On  // voi period =1/2khz= 0.5ms
; 0001 0B03     // Input Capture Interrupt: Off
; 0001 0B04     // Compare A Match Interrupt: Off
; 0001 0B05     // Compare B Match Interrupt: Off
; 0001 0B06     TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0001 0B07     TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0001 0B08     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0001 0B09     TCNT1L=0x00;
	OUT  0x2C,R30
; 0001 0B0A     ICR1H=0x00;
	OUT  0x27,R30
; 0001 0B0B     ICR1L=0x00;
	OUT  0x26,R30
; 0001 0B0C     OCR1AH=0x00;
	OUT  0x2B,R30
; 0001 0B0D     OCR1AL=0x00;
	OUT  0x2A,R30
; 0001 0B0E     OCR1BH=0x00;
	OUT  0x29,R30
; 0001 0B0F     OCR1BL=0x00;
	OUT  0x28,R30
; 0001 0B10     // Timer(s)/Counter(s) Interrupt(s) initialization  timer0
; 0001 0B11     TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0001 0B12 
; 0001 0B13     //OCR1A=0-255; MOTOR LEFT
; 0001 0B14     //OCR1B=0-255; MOTOR RIGHT
; 0001 0B15     for(i=0;i<1;i++)
	LDI  R16,LOW(0)
_0x202F6:
	CPI  R16,1
	BRSH _0x202F7
; 0001 0B16     {
; 0001 0B17         LEDL=1; LEDR=1;
	CALL SUBOPT_0x62
; 0001 0B18         delay_ms(100);
; 0001 0B19         LEDL=0; LEDR=0;
; 0001 0B1A         delay_ms(100);
; 0001 0B1B     }
	SUBI R16,-1
	RJMP _0x202F6
_0x202F7:
; 0001 0B1C 
; 0001 0B1D     //khai  bao su dung cua glcd
; 0001 0B1E     SPIinit();
	CALL _SPIinit
; 0001 0B1F     LCDinit();
	CALL _LCDinit
; 0001 0B20 
; 0001 0B21     // khai  bao su dung rf dung de cap nhat gia tri vi tri cua robot
; 0001 0B22     init_NRF24L01();
	CALL _init_NRF24L01
; 0001 0B23     SetRX_Mode();  // chon kenh tan so phat, va dia chi phat trong file nRF14l01.c
	CALL _SetRX_Mode
; 0001 0B24     // khai bao su dung encoder
; 0001 0B25     initencoder(); //lay 2 canh len  xuong
	CALL _initencoder
; 0001 0B26     // khai bao su dung uart
; 0001 0B27     inituart();
	CALL _inituart
; 0001 0B28 
; 0001 0B29     // Set interrupt timer 2
; 0001 0B2A     updatePosInit();
	RCALL _updatePosInit
; 0001 0B2B     // Set for oldPos variable
; 0001 0B2C     initPos();
	RCALL _initPos
; 0001 0B2D 
; 0001 0B2E     #asm("sei")
	sei
; 0001 0B2F 
; 0001 0B30     //man hinh khoi dong robokit
; 0001 0B31     hc(0,10);
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
; 0001 0B32     ws("<AKBOTKIT>");
	__POINTW1MN _0x20300,0
	CALL SUBOPT_0x1E
; 0001 0B33     hc(1,0);
	CALL SUBOPT_0x41
; 0001 0B34     ws("************");
	__POINTW1MN _0x20300,11
	CALL SUBOPT_0x1E
; 0001 0B35 
; 0001 0B36     //robotwhiteline();
; 0001 0B37     //robotblackline();
; 0001 0B38     //kiem tra neu nhan va giu nut trai se vao chuong trinh selftest (kiem tra hoat dong cua robot)
; 0001 0B39     while (keyKT==0)
_0x20301:
	SBIC 0x13,0
	RJMP _0x20303
; 0001 0B3A     {
; 0001 0B3B       cntselftest++;
	LDI  R26,LOW(_cntselftest)
	LDI  R27,HIGH(_cntselftest)
	CALL SUBOPT_0x2B
; 0001 0B3C       if(cntselftest>10)
	LDS  R26,_cntselftest
	LDS  R27,_cntselftest+1
	SBIW R26,11
	BRLO _0x20304
; 0001 0B3D       {
; 0001 0B3E            while (keyKT==0);//CHO NHA NUT AN
_0x20305:
	SBIS 0x13,0
	RJMP _0x20305
; 0001 0B3F            cntselftest=0;
	LDI  R30,LOW(0)
	STS  _cntselftest,R30
	STS  _cntselftest+1,R30
; 0001 0B40            flagselftest=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _flagselftest,R30
	STS  _flagselftest+1,R31
; 0001 0B41            selftest();
	RCALL _selftest
; 0001 0B42       }
; 0001 0B43       delay_ms(100);
_0x20304:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x6A
; 0001 0B44     }
	RJMP _0x20301
_0x20303:
; 0001 0B45 
; 0001 0B46     // vao chuong trinh chinh sau khi bo qua phan selftest
; 0001 0B47     hc(2,0);
	CALL SUBOPT_0x65
; 0001 0B48     ws("MAIN PROGRAM");
	__POINTW1MN _0x20300,24
	CALL SUBOPT_0x1E
; 0001 0B49     settoadoHomRB();
	CALL _settoadoHomRB
; 0001 0B4A 
; 0001 0B4B     // code you here
; 0001 0B4C 
; 0001 0B4D     while (1)
_0x20308:
; 0001 0B4E     {
; 0001 0B4F         #ifdef !DEBUG_MODE
; 0001 0B50         {
; 0001 0B51      //LEDR=!LEDR;
; 0001 0B52      //PHUC
; 0001 0B53 ////     //=========================================================   PHUC ID
; 0001 0B54 //         chay theo banh co dinh huong tan cong
; 0001 0B55         readposition();
; 0001 0B56         calcvitri(0,0);    // de xac dinh huong tan cong
; 0001 0B57 
; 0001 0B58         //flagtancong=1;
; 0001 0B59         if(flagtancong==1)
; 0001 0B5A         {
; 0001 0B5B             flagtask=2;
; 0001 0B5C             rb_wait(50);
; 0001 0B5D 
; 0001 0B5E         }else
; 0001 0B5F         {
; 0001 0B60             if(offsetphongthu<0)    offsetphongthu=-offsetphongthu;//lay do lon
; 0001 0B61             if(robotctrl.ball.y <= 0)
; 0001 0B62             {
; 0001 0B63                 setRobotX = robotctrl.ball.x;
; 0001 0B64                 setRobotY = robotctrl.ball.y + offsetphongthu;
; 0001 0B65 
; 0001 0B66                 flagtask=0;
; 0001 0B67                 rb_wait(200);
; 0001 0B68 
; 0001 0B69             }else
; 0001 0B6A             {
; 0001 0B6B                 setRobotX = robotctrl.ball.x;
; 0001 0B6C                 setRobotY = robotctrl.ball.y - offsetphongthu;
; 0001 0B6D 
; 0001 0B6E                 flagtask=0;
; 0001 0B6F                 rb_wait(200);
; 0001 0B70 
; 0001 0B71             }
; 0001 0B72 
; 0001 0B73              setRobotX = robotctrl.ball.x+offsetphongthu;
; 0001 0B74              setRobotY = robotctrl.ball.y;
; 0001 0B75              rb_wait(200);
; 0001 0B76              rb_goball();
; 0001 0B77              rb_wait(200);
; 0001 0B78         }
; 0001 0B79         ctrrobot();// can phai luon luon chay de dieu khien robot
; 0001 0B7A         }
; 0001 0B7B         #else
; 0001 0B7C         {
; 0001 0B7D 
; 0001 0B7E 	        #ifdef DEBUG_EN
; 0001 0B7F             {
; 0001 0B80                 char dbgLen;
; 0001 0B81                 // left speed
; 0001 0B82                 dbgLen=sprintf(debugMsgBuff,"Left Speed: %d \n\r", leftSpeed);
; 0001 0B83                 debug_out(debugMsgBuff,dbgLen);
; 0001 0B84 
; 0001 0B85                 dbgLen=sprintf(debugMsgBuff,"Right Speed: %d \n\n\r", rightSpeed);
; 0001 0B86                 debug_out(debugMsgBuff,dbgLen);
; 0001 0B87             }
; 0001 0B88             #endif
; 0001 0B89 
; 0001 0B8A             movePoint(robotctrl, 0, 0, 0, 'f');
	LDI  R30,LOW(_robotctrl)
	LDI  R31,HIGH(_robotctrl)
	LDI  R26,14
	CALL __PUTPARL
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3D
	LDI  R30,LOW(102)
	ST   -Y,R30
	CALL _movePoint
; 0001 0B8B             setSpeed(leftSpeed, rightSpeed);
	LDS  R30,_leftSpeed
	LDS  R31,_leftSpeed+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_rightSpeed
	LDS  R31,_rightSpeed+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _setSpeed
; 0001 0B8C 
; 0001 0B8D         }
; 0001 0B8E         #endif
; 0001 0B8F      } //end while(1)
	RJMP _0x20308
; 0001 0B90 }
_0x2030B:
	RJMP _0x2030B

	.DSEG
_0x20300:
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
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x70
    brne __floor1
__floor0:
	CALL SUBOPT_0x6F
	RJMP _0x20C0002
__floor1:
    brtc __floor0
	CALL SUBOPT_0x71
	CALL __SUBF12
	RJMP _0x20C0002
_ceil:
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x70
    brne __ceil1
__ceil0:
	CALL SUBOPT_0x6F
	RJMP _0x20C0002
__ceil1:
    brts __ceil0
	CALL SUBOPT_0x71
	RJMP _0x20C0003
_fmod:
	SBIW R28,4
	CALL SUBOPT_0x4
	CALL __CPD10
	BRNE _0x2060005
	__GETD1N 0x0
	RJMP _0x20C0001
_0x2060005:
	CALL SUBOPT_0x72
	CALL SUBOPT_0x6F
	CALL __CPD10
	BRNE _0x2060006
	__GETD1N 0x0
	RJMP _0x20C0001
_0x2060006:
	CALL SUBOPT_0x73
	CALL __CPD02
	BRGE _0x2060007
	CALL SUBOPT_0x74
	RCALL _floor
	RJMP _0x2060033
_0x2060007:
	CALL SUBOPT_0x74
	RCALL _ceil
_0x2060033:
	CALL __PUTD1S0
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x75
	CALL __MULF12
	CALL SUBOPT_0x5A
	CALL SUBOPT_0xF
	RJMP _0x20C0001
_sin:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	CALL SUBOPT_0x76
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0x77
	CALL SUBOPT_0x78
	CALL __PUTPARD1
	RCALL _floor
	CALL SUBOPT_0x76
	CALL SUBOPT_0xF
	CALL SUBOPT_0x77
	CALL SUBOPT_0x79
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2060017
	CALL SUBOPT_0x78
	__GETD2N 0x3F000000
	CALL __SUBF12
	CALL SUBOPT_0x77
	LDI  R17,LOW(1)
_0x2060017:
	CALL SUBOPT_0x76
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2060018
	CALL SUBOPT_0x79
	CALL __SUBF12
	CALL SUBOPT_0x77
_0x2060018:
	CPI  R17,0
	BREQ _0x2060019
	CALL SUBOPT_0x78
	CALL __ANEGF1
	CALL SUBOPT_0x77
_0x2060019:
	CALL SUBOPT_0x78
	CALL SUBOPT_0x76
	CALL __MULF12
	__PUTD1S 1
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL SUBOPT_0xF
	CALL SUBOPT_0x7A
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0x76
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 1
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0x7A
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	LDD  R17,Y+0
	ADIW R28,9
	RET
_cos:
	CALL SUBOPT_0x73
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	CALL __PUTPARD1
	RCALL _sin
	RJMP _0x20C0002
_tan:
	SBIW R28,4
	CALL SUBOPT_0x4
	CALL __PUTPARD1
	RCALL _cos
	CALL __PUTD1S0
	CALL __CPD10
	BRNE _0x206001A
	CALL SUBOPT_0x75
	CALL __CPD02
	BRGE _0x206001B
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0005
_0x206001B:
	__GETD1N 0xFF7FFFFF
	RJMP _0x20C0005
_0x206001A:
	CALL SUBOPT_0x4
	CALL __PUTPARD1
	RCALL _sin
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x6F
	RJMP _0x20C0004
_xatan:
	SBIW R28,4
	CALL SUBOPT_0x4
	CALL SUBOPT_0x75
	CALL __MULF12
	CALL __PUTD1S0
	CALL SUBOPT_0x6F
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x75
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6F
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x73
	CALL SUBOPT_0x7B
	POP  R26
	POP  R27
	POP  R24
	POP  R25
_0x20C0004:
	CALL __DIVF21
_0x20C0005:
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x73
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2060020
	CALL SUBOPT_0x74
	RCALL _xatan
	RJMP _0x20C0002
_0x2060020:
	CALL SUBOPT_0x73
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2060021
	CALL SUBOPT_0x71
	CALL SUBOPT_0x7C
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0xF
	RJMP _0x20C0002
_0x2060021:
	CALL SUBOPT_0x71
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x71
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x7C
	__GETD2N 0x3F490FDB
_0x20C0003:
	CALL __ADDF12
_0x20C0002:
	ADIW R28,4
	RET
_atan2:
	SBIW R28,4
	CALL SUBOPT_0x4
	CALL __CPD10
	BRNE _0x206002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x206002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0001
_0x206002E:
	CALL SUBOPT_0x5A
	CALL __CPD02
	BRGE _0x206002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20C0001
_0x206002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20C0001
_0x206002D:
	CALL SUBOPT_0x72
	CALL SUBOPT_0x75
	CALL __CPD02
	BRGE _0x2060030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2060031
	CALL SUBOPT_0x74
	RCALL _yatan
	RJMP _0x20C0001
_0x2060031:
	CALL SUBOPT_0x7D
	CALL __ANEGF1
	RJMP _0x20C0001
_0x2060030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2060032
	CALL SUBOPT_0x7D
	__GETD2N 0x40490FDB
	CALL SUBOPT_0xF
	RJMP _0x20C0001
_0x2060032:
	CALL SUBOPT_0x74
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
_leftSpeed:
	.BYTE 0x2
_rightSpeed:
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
_timer2Count:
	.BYTE 0x1
_posUpdateFlag:
	.BYTE 0x1
_oldPos:
	.BYTE 0x4
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x2:
	SBIW R28,4
	__GETD1S 12
	CALL __PUTD1S0
	__GETD1S 8
	CALL __GETD2S0
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	__GETD1S 8
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	CALL __GETD2S0
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x4
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  _seRki_G001,R30
	STS  _seRki_G001+1,R30
	STS  _seLki_G001,R30
	STS  _seLki_G001+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	STS  _svQEL,R30
	STS  _svQEL+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x9:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA:
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	CALL __ANEGW1
	STD  Y+22,R30
	STD  Y+22+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40490FDB
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x12:
	ST   -Y,R30
	CALL _LcdWrite
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
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
SUBOPT_0x14:
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
SUBOPT_0x15:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _LcdWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x19:
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
SUBOPT_0x1A:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	SUB  R30,R26
	SBC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn16

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _ws

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LD   R30,Y
	LDI  R31,0
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:157 WORDS
SUBOPT_0x23:
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
SUBOPT_0x24:
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
SUBOPT_0x25:
	__GETD1N 0x42840000
	STS  _rbctrlHomeX,R30
	STS  _rbctrlHomeX+1,R31
	STS  _rbctrlHomeX+2,R22
	STS  _rbctrlHomeX+3,R23
	__GETD1N 0x429ECCCD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x26:
	__GETD1N 0xC3870000
	STS  _setRobotXmin,R30
	STS  _setRobotXmin+1,R31
	STS  _setRobotXmin+2,R22
	STS  _setRobotXmin+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x27:
	__GETD1N 0x43870000
	STS  _setRobotXmax,R30
	STS  _setRobotXmax+1,R31
	STS  _setRobotXmax+2,R22
	STS  _setRobotXmax+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	STS  _rbctrlPenaltyAngle,R30
	STS  _rbctrlPenaltyAngle+1,R31
	STS  _rbctrlPenaltyAngle+2,R22
	STS  _rbctrlPenaltyAngle+3,R23
	__GETD1N 0x43330000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x29:
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
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2A:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	LDS  R30,_QER
	LDS  R31,_QER+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2E:
	LDS  R30,_QEL
	LDS  R31,_QEL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	LDS  R26,_seRki_G001
	LDS  R27,_seRki_G001+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	STS  _seRki_G001,R30
	STS  _seRki_G001+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	LDS  R26,_seLki_G001
	LDS  R27,_seLki_G001+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	STS  _seLki_G001,R30
	STS  _seLki_G001+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x33:
	RCALL SUBOPT_0x2E
	LDS  R26,_QER
	LDS  R27,_QER+1
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R26
	LSR  R31
	ROR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x34:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x36:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn16s

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	__GETW1MN _robotctrl,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	__GETW1MN _robotctrl,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x3D:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3F:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	OUT  0x1B,R30
	CALL _LcdClear
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x40:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
	ST   -Y,R30
	CALL _vMRlui
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	CALL _LEDLtoggle
	JMP  _LEDRtoggle

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x45:
	MOVW R30,R16
	LDI  R26,LOW(_IRLINE)
	LDI  R27,HIGH(_IRLINE)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	__GETW2MN _IRLINE,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x47:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x48:
	CALL _readline
	__GETWRMN 20,21,0,_IRLINE
	LDI  R16,LOW(0)
	LDI  R17,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x49:
	MOV  R30,R17
	LDI  R26,LOW(_IRLINE)
	LDI  R27,HIGH(_IRLINE)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4A:
	ADD  R26,R30
	ADC  R27,R31
	LD   R20,X+
	LD   R21,X
	MOV  R16,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _vMLtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	LDI  R30,LOW(20)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	LDI  R30,LOW(15)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	LDI  R30,LOW(15)
	ST   -Y,R30
	JMP  _vMLtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _vMLtoi
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x53:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x40

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x54:
	CALL _readline
	LDS  R30,_IRLINE
	LDS  R31,_IRLINE+1
	STD  Y+35,R30
	STD  Y+35+1,R31
	__GETWRN 20,21,0
	__GETWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x55:
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x57:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x58:
	CALL __DIVF21
	__GETD2S 16
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5A:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	__PUTD1S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	__GETD2S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5E:
	RCALL SUBOPT_0x5B
	LDI  R30,LOW(0)
	__CLRD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5F:
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	CALL _LcdClear
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x61:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x62:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x63:
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x64:
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(100)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x65:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x66:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x67:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn164

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x68:
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	RJMP SUBOPT_0x61

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x69:
	LDS  R30,_id
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6B:
	OUT  0x33,R30
	LDI  R30,LOW(0)
	OUT  0x32,R30
	OUT  0x3C,R30
	OUT  0x22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x6C:
	CALL _outlcd1
	RJMP SUBOPT_0x65

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6D:
	LDS  R30,_rb
	LDS  R31,_rb+1
	LDS  R22,_rb+2
	LDS  R23,_rb+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6E:
	RCALL SUBOPT_0x6D
	CALL __CFD1
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x6F:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x70:
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x71:
	RCALL SUBOPT_0x6F
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x72:
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5A
	CALL __DIVF21
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x73:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x74:
	RCALL SUBOPT_0x6F
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x75:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x76:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x77:
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x78:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x79:
	RCALL SUBOPT_0x76
	__GETD1N 0x3F000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7B:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7C:
	CALL __DIVF21
	CALL __PUTPARD1
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7D:
	RCALL SUBOPT_0x6F
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
