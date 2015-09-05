/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Evaluation
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 6/4/2015
Author  : Freeware, for evaluation and non-commercial use only
Company :
Comments:


Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <mega32a.h>
#include <delay.h>
#include <spi.h>
#include <nRF24L01/nRF24L01.h>
#include <math.h>

/* Debug mode definition */
#define DEBUG_MODE 1    // USE OUR CODE, ask Phat for more details
//#define DEBUG_EN 1      // Blue tooth mode

/* PIN DEFINITION */
// PIN LED ROBO KIT

//Hung comment a xamlin thing

#define LEDL	PORTC.4	
#define LEDR	PORTC.5
#define LEDFL   PORTA.4
#define LEDFR   PORTA.5
#define LEDBL   PORTA.6
#define LEDBR   PORTA.7
#define keyKT   PINC.0 // Nut ben trai
#define keyKP   PINC.1 // Nut ben phai
#define S0  PINA.0
#define S1  PINA.1
#define S2  PINA.2
#define S3  PINA.3
#define S4  PINA.7
#define MLdir   PORTC.6
#define MRdir   PORTC.7
// PIN NOKIA 5110
#define RST    PORTB.0
#define SCE    PORTB.1
#define DC     PORTB.2
#define DIN    PORTB.5
#define SCK    PORTB.7
#define LCD_C     0
#define LCD_D     1
#define LCD_X     84
#define LCD_Y     48
#define Black 1
#define White 0
#define Filled 1
#define NotFilled 0
// VARIABLES FOR ROBOT CONTROL
#define CtrVelocity    //uncomment de chon chay pid dieu khien van toc, va su dung cac ham vMLtoi,vMLlui,.... 
#define ROBOT_ID 4
#define SAN_ID 1  //CHON HUONG TAN CONG LA X >0;
#define M_PI    3.14159265358979323846    /* pi */

typedef   signed          char int8_t;
typedef   signed           int int16_t;
typedef   signed  long    int int32_t;
typedef   unsigned         char uint8_t;
typedef   unsigned        int  uint16_t;
typedef   unsigned long    int  uint32_t;
typedef   float            float32_t;
typedef struct   {
	float x;
	float y;
} Ball;
typedef struct {
	int x;
	int y;
} IntBall;
typedef struct   {
	float id;
	float x;
	float y;
	float ox;
	float oy;
	Ball ball;
} Robot;
typedef struct {
	int id;
	int x;
	int y;
	int ox;
	int oy;
	IntBall ball;
} IntRobot;

// FUNCTION DECLARATION
IntRobot convertRobot2IntRobot(Robot robot);
unsigned char readposition();
void runEscBlindSpot();
void ctrrobot();// can phai luon luon chay de dieu khien robot    
void rb_move(float x, float y);
int rb_wait(unsigned long int time);
void rb_rotate(int angle);     // goc xoay so voi truc x cua toa do
void calcvitri(float x, float y);
int calcVangle(int angle);

// VARIABLES DECLARATION
Robot rb;
IntRobot robot11, robot12, robot13, robot21, robot22, robot23, robotctrl;
float errangle = 0, distance = 0, orentation = 0;
int flagtancong = 1;
int offsetphongthu = 0;
int goctancong = 0;
unsigned char RxBuf[32];
float setRobotX = 0;
float setRobotY = 0;
float setRobotXmin = 0;
float setRobotXmax = 0;
float setRobotAngleX = 0;
float setRobotAngleY = 0;
float offestsanco = 0;
float rbctrlHomeX = 0;
float rbctrlHomeY = 0;
float rbctrlPenaltyX = 0;
float rbctrlPenaltyY = 0;
float rbctrlPenaltyAngle = 0;
float rbctrlHomeAngle = 0;
unsigned int cmdCtrlRobot, idRobot;
unsigned int cntsethomeRB = 0;
unsigned int cntstuckRB = 0;
unsigned int cntunlookRB = 0;
unsigned int flagunlookRB = 0;
unsigned int cntunsignalRF = 0;
unsigned int flagunsignalRF = 0;
unsigned int flagsethome = 0;
unsigned int flagselftest = 0;
unsigned int cntselftest = 0;
int leftSpeed = 0;
int rightSpeed = 0;

//======USER VARIABLES=========
unsigned char id = 1;
//======IR READER VARIABLES====
unsigned int IRFL = 0;
unsigned int IRFR = 0;
unsigned int IRBL = 0;
unsigned int IRLINE[5];
//======MOTOR CONTROL========
//------VELOCITY CONTROL=====
unsigned int timerstick = 0, timerstickdis = 0, timerstickang = 0, timerstickctr = 0;
unsigned int vQEL = 0;  //do (xung/250ms)
unsigned int vQER = 0;  //do (xung/250ms)
unsigned int oldQEL = 0;
unsigned int oldQER = 0;
unsigned int svQEL = 0;  //dat (xung/250ms) (range: 0-22)
unsigned int svQER = 0;  //dat (xung/250ms) (range: 0-22) 
static int seRki = 0, seLki = 0;
int uL = 0;
int uR = 0;
int KpR = 10;
int KiR = 1;
int KpL = 10;
int KiL = 1;
#define LDIVR 1

// Robot Control Algorithm
// The idea is simple. There are two vectors: robot direction (vrb) and robot to target (vdes). 
// The vector vrb will rotate at an  angle of 'delta' which is equal to the  angle between 2 vectors.
// So that two vectors will be on a same line and the robot can reach its destination.
// However, in order to achieve robot's arrival with desired orientation, a new vector (vgoal), which
// shows the desired orientation, is introduced and added to vrb before the rotation. 

// Return the absolute value
int absolute(int a) {
	if (a > 0) return a;
	return (-a);
}
float min3(float a, float b, float c){
	float m = a;
	if (m > b) m = b;
	if (m > c) m = c;
	return m;
}
float max3(float a, float b, float c){
	float m = a;
	if (m < b) m = b;
	if (m < c) m = c;
	return m;
}

void setSpeed(int leftSpeed, int rightSpeed) {
	// Reset I of both wheel
	seRki = 0;//reset thanh phan I     
	seLki = 0;//reset thanh phan I     

	// Left speed control
	if (leftSpeed > 0) { // forward
		MLdir = 1;
	}
	else {
		MLdir = 0;
		leftSpeed = -leftSpeed;
	}
	svQEL = leftSpeed; // Don't know this

	// Right speed control
	if (rightSpeed > 0) { // forward
		MRdir = 1;
	}
	else {
		MRdir = 0;
		rightSpeed = -rightSpeed;
	}
	svQER = rightSpeed;
}

/* For Dat */
#define VBASE 15
#define KMOVE 25

void kick(int x_des, int y_des, int x_goal, int y_goal, char mode){

	int vx_des, vy_des, vx_goal, vy_goal;                    // vdes & vgoal coordinates
	int rb_angle, des_angle, goal_angle, new_angle;       // angles of vrb, vdes, vgoal & (vdes + vgoal) to x-axis
	int rotation_angle;                           // this is needed to calculate motor velocity    
	int minimum, maximum;                       //  this is needed to check whether vector a is between vector b and c
	int wl, wr;
	int vx_rb, vy_rb;

	vx_des = x_des - robotctrl.x;            // vdes calculation
	vy_des = y_des - robotctrl.y;

	vx_goal = x_goal - x_des;            //vgoal calculation
	vy_goal = y_goal - y_des;

	// Conversion to unit vector
	if (x_goal == 0)
		y_goal = y_goal / absolute(y_goal);
	else if (y_goal == 0)
		x_goal = x_goal / absolute(x_goal);
	else {
		y_goal = y_goal / absolute(x_goal);
		x_goal = x_goal / absolute(x_goal);
	}

	// Angle calculation
	goal_angle = atan2(vy_goal, vx_goal);
	rb_angle = atan2(robotctrl.ox, robotctrl.oy);			// done
	des_angle = atan2(vy_des, vx_des);

	// Adding vgoal to vrb 
	// NEED TESTING
	vx_rb = robotctrl.ox + vx_goal;
	vy_rb = robotctrl.oy + vy_goal;

	new_angle = atan2(vx_rb, vy_rb);
	rotation_angle = new_angle - des_angle;

	//  *rotation_angle > 180* counter-measure
	if (rotation_angle < -PI) {
		rotation_angle = 2 * PI + rotation_angle;
		if (new_angle > des_angle)
			rotation_angle = -rotation_angle;
	}

	if (rotation_angle > PI) {
		rotation_angle = 2 * PI - rotation_angle;
		if (new_angle > des_angle)
			rotation_angle = -rotation_angle;
	}

	// *Spiral* counter-measure: Spiral happens when vdes is between the new vector and vrb
	minimum = min3(rb_angle, des_angle, new_angle);
	maximum = max3(rb_angle, des_angle, new_angle);

	if (absolute(rb_angle - new_angle) > PI) {
		if (des_angle == maximum || des_angle == minimum)
			rotation_angle = rotation_angle / 15;
		else if (minimum < des_angle && des_angle < maximum)
			rotation_angle = rotation_angle / 15;
	}

	// Motor speed calculation
	switch (mode) {
	case 'f': // Going forward			
		wl = 30 + rotation_angle * 50;
		wr = 30 - rotation_angle * 50;
		break;
	case 'b': // Going backward
		rotation_angle = -rotation_angle;
		wl = 30 - rotation_angle * 50;
		wr = 30 + rotation_angle * 50;
		break;
	}

	// Set the speed immediately 
	leftSpeed = wl;
	rightSpeed = wr;
}

void movePoint(IntRobot rbctrl, int x_des, int y_des, int angle, char mode){

	int vx_des, vy_des, vx_goal, vy_goal;	                // vdes & vgoal coordinates
	int rb_angle, des_angle, goal_angle, new_angle;       // angles of vrb, vdes, vgoal & (vdes + vgoal) to x-axis
	int rotation_angle;
	int minimum, maximum;
	int wl, wr;
	int vx_rb, vy_rb;
	int dirx, diry;

	vx_des = x_des - rbctrl.x;			// vdes calculation
	vy_des = y_des - rbctrl.y;

	dirx = rbctrl.ox - rbctrl.x;
	diry = rbctrl.oy - rbctrl.y;

	switch (angle) { // vgoal calculation
	case 0: 	vx_goal = 1; vy_goal = 0; break;
	case 90: 	vx_goal = 0; vy_goal = 1; break;
	case 180: vx_goal = -1; vy_goal = 0; break;
	case -90: vx_goal = 0; vy_goal = -1; break;
	default:	vx_goal = 1; vy_goal = vx_goal * tan(angle); break;
	}

	// Angle calculation
	rb_angle = atan2(diry, dirx);
	des_angle = atan2(vy_des, vx_des);

	// Adding vgoal to vrb
	vx_rb = dirx + vx_goal;
	vy_rb = diry + vy_goal;

	new_angle = atan2(vy_rb, vx_rb);
	rotation_angle = new_angle - des_angle;

	//  *rotation_angle > 180* counter-measure
	if (rotation_angle < -PI) {
		rotation_angle = 2 * PI + rotation_angle;
		if (new_angle > des_angle)               rotation_angle = -rotation_angle;
	}
	if (rotation_angle > PI) {
		rotation_angle = 2 * PI - rotation_angle;
		if (new_angle > des_angle)                rotation_angle = -rotation_angle;
	}

	// *SPIral* counter-measure: SPIral happens when vdes is between the new vector and vrb
	minimum = min3(rb_angle, des_angle, new_angle);
	maximum = max3(rb_angle, des_angle, new_angle);

	if (absolute(rb_angle - new_angle) > PI) {
		if (des_angle == maximum || des_angle == minimum)                rotation_angle = rotation_angle / 15;
		else
			if (minimum < des_angle && des_angle < maximum)               rotation_angle = rotation_angle / 15;
	}

	// Motor speed calculation
	switch (mode) {
	case 'f': // Going forward			
		wl = VBASE + rotation_angle * KMOVE;
		wr = VBASE - rotation_angle * KMOVE;
		break;
	case 'b': // Going backward
		rotation_angle = -rotation_angle;
		wl = VBASE - rotation_angle * KMOVE;
		wr = VBASE + rotation_angle * KMOVE;
		break;
	}
	// Set speed for motor   
	leftSpeed = wl;
	rightSpeed = wr;
	// need some function here
}

// some function to set speed = 0
void stop() {

}

void rotate(int angle){
	angle = angle * LDIVR * 0.5;
	setSpeed(angle, -angle);
}


//------POSITION CONTROL-----   
unsigned int sd = 0;// dat khoang cach  di chuyen (xung)
unsigned int oldd = 0;// bien luu gia tri vi tri cu  
unsigned char flagwaitctrRobot = 0;
//-----ANGLES CONTROL----
unsigned int sa = 0;// dat goc quay (xung) ( 54 xung/vong quay)
unsigned int olda = 0;// bien luu gia tri goc cu
unsigned char  flagwaitctrAngle = 0;
//-----ROBOT BEHAVIOR CONTROL-----
unsigned int flagtask = 0;
unsigned int flagtaskold = 0;
unsigned int flaghuongtrue = 0;
int verranglekisum = 0;
//=====ENCODER======
unsigned int QEL = 0;
unsigned int QER = 0;
//=====LCD=========
unsigned char menu = 0, test = 0, ok = 0, runing_test = 0, run_robot = 0, ft = 1, timer = 0;
flash unsigned char ASCII[][5] = {
	{ 0x00, 0x00, 0x00, 0x00, 0x00 } // 20
	, { 0x00, 0x00, 0x5f, 0x00, 0x00 } // 21 !
	, { 0x00, 0x07, 0x00, 0x07, 0x00 } // 22 "
	, { 0x14, 0x7f, 0x14, 0x7f, 0x14 } // 23 #
	, { 0x24, 0x2a, 0x7f, 0x2a, 0x12 } // 24 $
	, { 0x23, 0x13, 0x08, 0x64, 0x62 } // 25 %
	, { 0x36, 0x49, 0x55, 0x22, 0x50 } // 26 &
	, { 0x00, 0x05, 0x03, 0x00, 0x00 } // 27 '
	, { 0x00, 0x1c, 0x22, 0x41, 0x00 } // 28 (
	, { 0x00, 0x41, 0x22, 0x1c, 0x00 } // 29 )
	, { 0x14, 0x08, 0x3e, 0x08, 0x14 } // 2a *
	, { 0x08, 0x08, 0x3e, 0x08, 0x08 } // 2b +
	, { 0x00, 0x50, 0x30, 0x00, 0x00 } // 2c ,
	, { 0x08, 0x08, 0x08, 0x08, 0x08 } // 2d -
	, { 0x00, 0x60, 0x60, 0x00, 0x00 } // 2e .
	, { 0x20, 0x10, 0x08, 0x04, 0x02 } // 2f /
	, { 0x3e, 0x51, 0x49, 0x45, 0x3e } // 30 0
	, { 0x00, 0x42, 0x7f, 0x40, 0x00 } // 31 1
	, { 0x42, 0x61, 0x51, 0x49, 0x46 } // 32 2
	, { 0x21, 0x41, 0x45, 0x4b, 0x31 } // 33 3
	, { 0x18, 0x14, 0x12, 0x7f, 0x10 } // 34 4
	, { 0x27, 0x45, 0x45, 0x45, 0x39 } // 35 5
	, { 0x3c, 0x4a, 0x49, 0x49, 0x30 } // 36 6
	, { 0x01, 0x71, 0x09, 0x05, 0x03 } // 37 7
	, { 0x36, 0x49, 0x49, 0x49, 0x36 } // 38 8
	, { 0x06, 0x49, 0x49, 0x29, 0x1e } // 39 9
	, { 0x00, 0x36, 0x36, 0x00, 0x00 } // 3a :
	, { 0x00, 0x56, 0x36, 0x00, 0x00 } // 3b ;
	, { 0x08, 0x14, 0x22, 0x41, 0x00 } // 3c <
	, { 0x14, 0x14, 0x14, 0x14, 0x14 } // 3d =
	, { 0x00, 0x41, 0x22, 0x14, 0x08 } // 3e >
	, { 0x02, 0x01, 0x51, 0x09, 0x06 } // 3f ?
	, { 0x32, 0x49, 0x79, 0x41, 0x3e } // 40 @
	, { 0x7e, 0x11, 0x11, 0x11, 0x7e } // 41 A
	, { 0x7f, 0x49, 0x49, 0x49, 0x36 } // 42 B
	, { 0x3e, 0x41, 0x41, 0x41, 0x22 } // 43 C
	, { 0x7f, 0x41, 0x41, 0x22, 0x1c } // 44 D
	, { 0x7f, 0x49, 0x49, 0x49, 0x41 } // 45 E
	, { 0x7f, 0x09, 0x09, 0x09, 0x01 } // 46 F
	, { 0x3e, 0x41, 0x49, 0x49, 0x7a } // 47 G
	, { 0x7f, 0x08, 0x08, 0x08, 0x7f } // 48 H
	, { 0x00, 0x41, 0x7f, 0x41, 0x00 } // 49 I
	, { 0x20, 0x40, 0x41, 0x3f, 0x01 } // 4a J
	, { 0x7f, 0x08, 0x14, 0x22, 0x41 } // 4b K
	, { 0x7f, 0x40, 0x40, 0x40, 0x40 } // 4c L
	, { 0x7f, 0x02, 0x0c, 0x02, 0x7f } // 4d M
	, { 0x7f, 0x04, 0x08, 0x10, 0x7f } // 4e N
	, { 0x3e, 0x41, 0x41, 0x41, 0x3e } // 4f O
	, { 0x7f, 0x09, 0x09, 0x09, 0x06 } // 50 P
	, { 0x3e, 0x41, 0x51, 0x21, 0x5e } // 51 Q
	, { 0x7f, 0x09, 0x19, 0x29, 0x46 } // 52 R
	, { 0x46, 0x49, 0x49, 0x49, 0x31 } // 53 S
	, { 0x01, 0x01, 0x7f, 0x01, 0x01 } // 54 T
	, { 0x3f, 0x40, 0x40, 0x40, 0x3f } // 55 U
	, { 0x1f, 0x20, 0x40, 0x20, 0x1f } // 56 V
	, { 0x3f, 0x40, 0x38, 0x40, 0x3f } // 57 W
	, { 0x63, 0x14, 0x08, 0x14, 0x63 } // 58 X
	, { 0x07, 0x08, 0x70, 0x08, 0x07 } // 59 Y
	, { 0x61, 0x51, 0x49, 0x45, 0x43 } // 5a Z
	, { 0x00, 0x7f, 0x41, 0x41, 0x00 } // 5b [
	, { 0x02, 0x04, 0x08, 0x10, 0x20 } // 5c �
	, { 0x00, 0x41, 0x41, 0x7f, 0x00 } // 5d ]
	, { 0x04, 0x02, 0x01, 0x02, 0x04 } // 5e ^
	, { 0x40, 0x40, 0x40, 0x40, 0x40 } // 5f _
	, { 0x00, 0x01, 0x02, 0x04, 0x00 } // 60 `
	, { 0x20, 0x54, 0x54, 0x54, 0x78 } // 61 a
	, { 0x7f, 0x48, 0x44, 0x44, 0x38 } // 62 b
	, { 0x38, 0x44, 0x44, 0x44, 0x20 } // 63 c
	, { 0x38, 0x44, 0x44, 0x48, 0x7f } // 64 d
	, { 0x38, 0x54, 0x54, 0x54, 0x18 } // 65 e
	, { 0x08, 0x7e, 0x09, 0x01, 0x02 } // 66 f
	, { 0x0c, 0x52, 0x52, 0x52, 0x3e } // 67 g
	, { 0x7f, 0x08, 0x04, 0x04, 0x78 } // 68 h
	, { 0x00, 0x44, 0x7d, 0x40, 0x00 } // 69 i
	, { 0x20, 0x40, 0x44, 0x3d, 0x00 } // 6a j
	, { 0x7f, 0x10, 0x28, 0x44, 0x00 } // 6b k
	, { 0x00, 0x41, 0x7f, 0x40, 0x00 } // 6c l
	, { 0x7c, 0x04, 0x18, 0x04, 0x78 } // 6d m
	, { 0x7c, 0x08, 0x04, 0x04, 0x78 } // 6e n
	, { 0x38, 0x44, 0x44, 0x44, 0x38 } // 6f o
	, { 0x7c, 0x14, 0x14, 0x14, 0x08 } // 70 p
	, { 0x08, 0x14, 0x14, 0x18, 0x7c } // 71 q
	, { 0x7c, 0x08, 0x04, 0x04, 0x08 } // 72 r
	, { 0x48, 0x54, 0x54, 0x54, 0x20 } // 73 s
	, { 0x04, 0x3f, 0x44, 0x40, 0x20 } // 74 t
	, { 0x3c, 0x40, 0x40, 0x20, 0x7c } // 75 u
	, { 0x1c, 0x20, 0x40, 0x20, 0x1c } // 76 v
	, { 0x3c, 0x40, 0x30, 0x40, 0x3c } // 77 w
	, { 0x44, 0x28, 0x10, 0x28, 0x44 } // 78 x
	, { 0x0c, 0x50, 0x50, 0x50, 0x3c } // 79 y
	, { 0x44, 0x64, 0x54, 0x4c, 0x44 } // 7a z
	, { 0x00, 0x08, 0x36, 0x41, 0x00 } // 7b {
	, { 0x00, 0x00, 0x7f, 0x00, 0x00 } // 7c |
	, { 0x00, 0x41, 0x36, 0x08, 0x00 } // 7d }
	, { 0x10, 0x08, 0x08, 0x10, 0x08 } // 7e ?
	, { 0x78, 0x46, 0x41, 0x46, 0x78 } // 7f ?
};

/* LED FUNCTIONS */
void LEDLtoggle()
{
	if (LEDL == 0){ LEDL = 1; }
	else{ LEDL = 0; }
}

void LEDRtoggle()
{
	if (LEDR == 0){ LEDR = 1; }
	else{ LEDR = 0; }
}

/* SPI */
void sPItx(unsigned char temtx)
{
	// unsigned char transPI;
	SPDR = temtx;
	while (!(SPSR & 0x80));
}

/* LCD FUNCTIONS */
void LcdWrite(unsigned char dc, unsigned char data)
{
	DC = dc;
	SCE = 1;
	SCE = 0;
	sPItx(data);
	SCE = 1;
}
//This takes a large array of bits and sends them to the LCD
void LcdBitmap(char my_array[]){
	int index = 0;
	for (index = 0; index < (LCD_X * LCD_Y / 8); index++)
		LcdWrite(LCD_D, my_array[index]);
}

void hc(int x, int y) {
	LcdWrite(0, 0x40 | x);  // Row.  ?
	LcdWrite(0, 0x80 | y);  // Column.
}

void LcdCharacter(unsigned char character)
{
	int index = 0;
	LcdWrite(LCD_D, 0x00);
	for (index = 0; index < 5; index++)
	{
		LcdWrite(LCD_D, ASCII[character - 0x20][index]);
	}
	LcdWrite(LCD_D, 0x00);
}

void wc(unsigned char character)
{
	int index = 0;
	LcdWrite(LCD_D, 0x00);
	for (index = 0; index < 5; index++)
	{
		LcdWrite(LCD_D, ASCII[character - 0x20][index]);
	}
	LcdWrite(LCD_D, 0x00);
}

void ws(unsigned char *characters)
{
	while (*characters)
	{
		LcdCharacter(*characters++);
	}
}

void LcdClear(void)
{
	int index = 0;
	for (index = 0; index < LCD_X * LCD_Y / 8; index++)
	{
		LcdWrite(LCD_D, 0);
	}
	hc(0, 0); //After we clear the display, return to the home position
}

void clear(void)
{
	int index = 0;
	for (index = 0; index < LCD_X * LCD_Y / 8; index++)
	{
		LcdWrite(LCD_D, 0);
	}
	hc(0, 0); //After we clear the display, return to the home position
}

void wn164(unsigned int so)
{
	unsigned char a[5], i;
	for (i = 0; i < 5; i++)
	{
		a[i] = so % 10;        //a[0]= byte thap nhat
		so = so / 10;
	}
	for (i = 1; i < 5; i++)
	{
		wc(a[4 - i] + 0x30);
	}
}

void LcdInitialise()
{
	//reset
	RST = 0;
	delay_us(10);
	RST = 1;

	delay_ms(1000);
	//khoi dong
	LcdWrite(LCD_C, 0x21);  //Tell LCD that extended commands follow
	LcdWrite(LCD_C, 0xBF);  //Set LCD Vop (Contrast): Try 0xB1(good @ 3.3V) or 0xBF = Dam nhat
	LcdWrite(LCD_C, 0x06);  // Set Temp coefficent. //0x04
	LcdWrite(LCD_C, 0x13);  //LCD bias mode 1:48: Try 0x13 or 0x14
	LcdWrite(LCD_C, 0x20);  //We must send 0x20 before modifying the display control mode
	LcdWrite(LCD_C, 0x0C);  //Set display control, normal mode. 0x0D for inverse, 0x0C normal
}
// Hien thi so 16 bits
void wn16(unsigned int so)
{
	unsigned char a[5], i;
	for (i = 0; i < 5; i++)
	{
		a[i] = so % 10;        //a[0]= byte thap nhat
		so = so / 10;
	}
	for (i = 0; i < 5; i++)
	{
		LcdCharacter(a[4 - i] + 0x30);
	}
}
// Hien thi so 16 bits co dau
void wn16s(int so)
{
	if (so < 0){ so = 0 - so; LcdCharacter('-'); }
	else{ LcdCharacter(' '); }
	wn16(so);
}
// hien thi so 32bit co dau
void wn32s(int so)
{
	char tmp[20];
	sprintf(tmp, "%d", so);
	ws(tmp);
}
// Hien thi so 32bit co dau
void wnf(float so)
{
	char tmp[30];
	sprintf(tmp, "%0.2f", so);
	ws(tmp);
}
// Hien thi so 32bit co dau
void wfmt(float so)
{
	char tmp[30];
	sprintf(tmp, "%0.2f", so);
	ws(tmp);
}
/* SPI & LCD INIT */
void SPIinit()
{
	SPCR |= 1 << SPE | 1 << MSTR;                                         //if sPI is used, uncomment this section out
	SPSR |= 1 << SPI2X;
}
void LCDinit()
{
	LcdInitialise();
	LcdClear();
	ws(" <AKBOTKIT>");
}

/* ADC */
#define ADC_VREF_TYPE 0x40
// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
	ADMUX = adc_input | (ADC_VREF_TYPE & 0xff);
	// Delay needed for the stabilization of the ADC input voltage
	delay_us(10);
	// Start the AD conversion
	ADCSRA |= 0x40;
	// Wait for the AD conversion to complete
	while ((ADCSRA & 0x10) == 0);
	ADCSRA |= 0x10;
	return ADCW;
}

/* UART BLUETOOTH */
#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index, rx_rd_index, rx_counter;
#else
unsigned int rx_wr_index, rx_rd_index, rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt[USART_RXC] void usart_rx_isr(void)
{
	char status, data;
	status = UCSRA;
	data = UDR;
	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN)) == 0)
	{
		rx_buffer[rx_wr_index++] = data;
#if RX_BUFFER_SIZE == 256
		// special case for receiver buffer size=256
		if (++rx_counter == 0) {
#else
		if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index = 0;
		if (++rx_counter == RX_BUFFER_SIZE) {
			rx_counter = 0;
#endif
			rx_buffer_overflow = 1;
		}
		}
	}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
	char data;
	while (rx_counter == 0);
	data = rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
	if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index = 0;
#endif
	#asm("cli")
	--rx_counter;
	#asm("sei")
	return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index, tx_rd_index, tx_counter;
#else
unsigned int tx_wr_index, tx_rd_index, tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt[USART_TXC] void usart_tx_isr(void)
{
	if (tx_counter)
	{
		--tx_counter;
		UDR = tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
		if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index = 0;
#endif
	}
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
	while (tx_counter == TX_BUFFER_SIZE);
	#asm("cli")
	if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY) == 0))
	{
		tx_buffer[tx_wr_index++] = c;
#if TX_BUFFER_SIZE != 256
		if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index = 0;
#endif
		++tx_counter;
	}
	else
		UDR = c;
	#asm("sei")
}
#pragma used-
#endif
void inituart()
{
	// USART initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART Receiver: On
	// USART Transmitter: On
	// USART Mode: Asynchronous
	// USART Baud Rate: 38400
	UCSRA = 0x00;
	UCSRB = 0xD8;
	UCSRC = 0x06;
	UBRRH = 0x00;
	UBRRL = 0x0C;
}

//========================================================
// External Interrupt 0 service routine
interrupt[EXT_INT0] void ext_int0_isr(void)
{
	QEL++;
}

// External Interrupt 1 service routine
interrupt[EXT_INT1] void ext_int1_isr(void)
{
	QER++;
}
//========================================================
//khoi tao encoder
void initencoder()
{
	// Dem 24 xung / 1 vong banh xe
	// External Interrupt(s) initialization
	// INT0: On
	// INT0 Mode: Any change
	// INT1: On
	// INT1 Mode: Any change
	// INT2: Off
	GICR |= 0xC0;
	MCUCR = 0x05;
	MCUCSR = 0x00;
	GIFR = 0xC0;
	// Global enable interrupts

	//OCR1A=0-255; MOTOR LEFT
	//OCR1B=0-255; MOTOR RIGHT
}

//========================================================
//control velocity motor
void vMLtoi(unsigned char v) //congsuat=0-22 (%)
{
	seRki = 0;//reset thanh phan I     
	seLki = 0;//reset thanh phan I     
	//uRold=0;
	MLdir = 1;
	svQEL = v;
}
//========================================================
void vMLlui(unsigned char v) //congsuat=0-22 (%)
{
	seRki = 0;//reset thanh phan I     
	seLki = 0;//reset thanh phan I 

	//uRold=0;
	MLdir = 0;
	svQEL = v;
}
//========================================================
void vMLstop()
{
	seRki = 0;//reset thanh phan I     
	seLki = 0;//reset thanh phan I
	MLdir = 1;
	OCR1A = 0;
	svQEL = 0;
}
//========================================================
//========================================================
void vMRtoi(unsigned char v) //congsuat=0-22 (%)
{
	seRki = 0;//reset thanh phan I     
	seLki = 0;//reset thanh phan I
	MRdir = 1;
	svQER = v;
}
//========================================================
void vMRlui(unsigned char v) //congsuat=0-22 (%)
{
	seRki = 0;//reset thanh phan I     
	seLki = 0;//reset thanh phan I
	MRdir = 0;
	svQER = v;
}
//========================================================
void vMRstop()
{
	seRki = 0;//reset thanh phan I     
	seLki = 0;//reset thanh phan I
	MRdir = 1;
	OCR1B = 0;
	svQER = 0;
}
//========================================================
// ham dieu khien vi tri
void ctrRobottoi(unsigned int d, unsigned int v)  //v:0-22
{
	flagwaitctrAngle = 0;
	flagwaitctrRobot = 1;
	sd = d;// set gia tri khoang cach di chuyen
	oldd = (QEL + QER) / 2; // luu gia tri vi tri hien tai
	vMRtoi(v);
	vMLtoi(v);
}
// ham dieu khien vi tri
void ctrRobotlui(unsigned int d, unsigned int v)  //v:0-22
{
	flagwaitctrAngle = 0;
	flagwaitctrRobot = 1;
	sd = d;// set gia tri khoang cach di chuyen
	oldd = (QEL + QER) / 2; // luu gia tri vi tri hien tai
	vMRlui(v);
	vMLlui(v);
}
// ham dieu khien goc quay
void ctrRobotXoay(int angle, unsigned int v)  //v:0-22
{
	float fangle = 0;
	flagwaitctrRobot = 0;
	if (angle > 0)  { //xoay trai 
		if (angle > 1) vMRtoi(v);
		else vMRtoi(0);
		if (angle > 1) vMLlui(v);
		else vMLlui(0);
	}
	else  //xoay phai
	{
		angle = -angle;
		if (angle > 1) vMRlui(v);
		else vMRlui(0);
		if (angle > 1) vMLtoi(v);
		else vMLtoi(0);
	}
	flagwaitctrAngle = 1;
	fangle = angle*0.35;// nhan chia so float
	sa = fangle;
	olda = QEL; // luu gia tri vi tri hien tai
}


//============Phat==============
IntRobot convertRobot2IntRobot(Robot robot)
{
	IntRobot intRb;
	intRb.id = (int)robot.id;
	intRb.x = (int)robot.x;
	intRb.y = (int)robot.y;
	intRb.ox = (int)robot.ox;
	intRb.oy = (int)robot.oy;
	intRb.ball.x = (int)robot.ball.x;
	intRb.ball.y = (int)robot.ball.y;
	return intRb;
}

//========================================================
// read  vi tri robot   PHUC
//========================================================
/* Comment to return
unsigned char readposition()
{
unsigned char  i=0;
unsigned flagstatus=0;

if(nRF24L01_RxPacket(RxBuf)==1)         // Neu nhan duoc du lieu
{
for( i=0;i<28;i++)
{
*(uint8_t *) ((uint8_t *)&rb + i)=RxBuf[i];
}

idRobot = fmod(rb.id,10); // doc id
cmdCtrlRobot = (int)rb.id/10; // doc ma lenh

switch (idRobot)
{
case 1:
robot11=convertRobot2IntRobot(rb);
break;
case 2:
robot12=convertRobot2IntRobot(rb);
break;
case 3:
robot13=convertRobot2IntRobot(rb);
break;
case 4:
robot21=convertRobot2IntRobot(rb);
break;
case 5:
robot22=convertRobot2IntRobot(rb);
break;
case 6:
robot23=convertRobot2IntRobot(rb);
break;
}

if(idRobot==ROBOT_ID)
{
LEDL=!LEDL;
cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
flagstatus=1;
robotctrl=convertRobot2IntRobot(rb);
}
}
return flagstatus;
}     */
//========================================================
// calc  vi tri robot   so voi mot diem (x,y)        PHUC
// return goclenh va khoang cach, HUONG TAN CONG
//========================================================
void calcvitri(float x, float y)
{
	float ahx, ahy, aox, aoy, dah, dao, ahay, cosgoc, anpla0, anpla1, detaanpla;
	ahx = robotctrl.ox - robotctrl.x;
	ahy = robotctrl.oy - robotctrl.y;
	aox = x - robotctrl.x;
	aoy = y - robotctrl.y;
	dah = sqrt(ahx*ahx + ahy*ahy);
	dao = sqrt(aox*aox + aoy*aoy);
	ahay = ahx*aox + ahy*aoy;
	cosgoc = ahay / (dah*dao);

	anpla0 = atan2(ahy, ahx);
	anpla1 = atan2(aoy, aox);
	detaanpla = anpla0 - anpla1;

	errangle = acos(cosgoc) * 180 / 3.14;
	if (((detaanpla > 0) && (detaanpla < M_PI)) || (detaanpla < -M_PI))  // xet truong hop goc ben phai
	{
		errangle = -errangle; // ben phai    
	}
	else
	{
		errangle = errangle;   // ben trai

	}
	distance = sqrt(aox*3.48*aox*3.48 + aoy*2.89*aoy*2.89); //tinh khoang cach   
	orentation = atan2(ahy, ahx) * 180 / M_PI + offestsanco;//tinh huong ra goc 
	if ((0 < orentation && orentation < 74) || (0 > orentation && orentation > -80))
	{
		if (SAN_ID == 1)// phan san duong
		{
			flagtancong = 0;
			offsetphongthu = 70;
			goctancong = 180;
		}
		else // phan san am
		{
			flagtancong = 1;

		}
	}
	else
	{
		if (SAN_ID == 1)
		{
			flagtancong = 1;
		}
		else
		{
			flagtancong = 0;
			offsetphongthu = -70;
			goctancong = 0;
		}
	}
}
void runEscStuck()
{
	while (cmdCtrlRobot == 4)
	{

		DDRA = 0x00;
		PORTA = 0x00;
		IRFL = read_adc(4);
		IRFR = read_adc(5);

		if ((IRFL < 300) && (IRFR < 300))
		{
			vMLtoi(22); vMRlui(22);
			delay_ms(100);
		}
		if (IRFL > 300 && IRFR < 300)
		{
			vMLlui(0); vMRlui(25); delay_ms(100);
		}
		if (IRFR>300 && IRFL < 300)
		{
			vMLlui(25); vMRlui(0); delay_ms(100);
		}
		LEDBR = !LEDBR;
		readposition();//doc RF cap nhat ai robot
	}
}
void runEscStucksethome()
{
	while (cmdCtrlRobot == 7)
	{
		DDRA = 0x00;
		PORTA = 0x00;
		readposition();//doc RF cap nhat ai robot
		IRFL = read_adc(4);
		IRFR = read_adc(5);

		if ((IRFL < 300) && (IRFR < 300))
		{
			vMLtoi(22); vMRlui(22);
			delay_ms(100);
		}

		if (IRFL > 300 && IRFR < 300)
		{
			vMLlui(0); vMRlui(22); delay_ms(300);
		}
		if (IRFR>300 && IRFL < 300)
		{
			vMLlui(22); vMRlui(0); delay_ms(300);
		}

		LEDBR = !LEDBR;
	}
}
void runEscBlindSpot()
{
	while (cmdCtrlRobot == 3)
	{
		DDRA = 0x00;
		PORTA = 0x00;
		readposition();//doc RF cap nhat ai robot
		IRFL = read_adc(4);
		IRFR = read_adc(5);
		if (IRFL>300 && IRFR < 300)
		{
			vMLlui(0); vMRlui(22); delay_ms(300);
		}
		if (IRFR>300 && IRFL < 300)
		{
			vMLlui(22); vMRlui(0); delay_ms(300);
		}

		if ((IRFL < 300) && (IRFR < 300))
		{
			vMLtoi(20); vMRtoi(20);
			delay_ms(20);
		}

		LEDR = !LEDR;
	}
}

void runEscBlindSpotsethome()
{
	while (cmdCtrlRobot == 6)
	{
		DDRA = 0x00;
		PORTA = 0x00;
		readposition();
		IRFL = read_adc(4);
		IRFR = read_adc(5);
		if (IRFL > 300 && IRFR < 300)
		{
			vMLlui(0); vMRlui(22); delay_ms(300);
		}
		if (IRFR>300 && IRFL < 300)
		{
			vMLlui(22); vMRlui(0); delay_ms(300);
		}

		if ((IRFL < 300) && (IRFR < 300))
		{
			vMLtoi(20); vMRtoi(20);
			delay_ms(10);
		}

		LEDR = !LEDR;
	}
}

//========================================================
// SET HOME  vi tri robot, de chuan bi cho tran dau       PHUC// 
//========================================================
int sethomeRB()
{
	while (flagsethome == 0)
	{
		LEDL = !LEDL;
		//PHUC SH
		if (readposition() == 1)//co du lieu moi
		{
			//hc(3,40);wn16s(cmdCtrlRobot); 
			if (cmdCtrlRobot == 1)      // dung ma lenh stop chuong trinh
			{
				flagsethome = 0;
				return 0;
			}

			if (cmdCtrlRobot == 2 || cmdCtrlRobot == 3 || cmdCtrlRobot == 4)      // dung ma lenh stop chuong trinh
			{
				flagsethome = 0;
				return 0;
			}

			if (cmdCtrlRobot == 5)  //sethome robot
			{

				calcvitri(rbctrlHomeX, rbctrlHomeY);
				if (distance > 100) //chay den vi tri 
				{
					if (errangle > 18 || errangle < -18)
					{
						int nv = errangle * 27 / 180;
						int verrangle = calcVangle(errangle);
						ctrRobotXoay(nv, verrangle);
						delay_ms(1);
					}
					else
					{
						//1xung = 3.14 * 40/24 =5.22                 
						ctrRobottoi(distance / 5.22, 15);
						// verranglekisum=0;//RESET I.
					}
				}
				else //XOAY DUNG HUONG
				{
					setRobotAngleX = 10 * cos(rbctrlHomeAngle*M_PI / 180);
					setRobotAngleY = 10 * sin(rbctrlHomeAngle*M_PI / 180);;
					calcvitri(robotctrl.x + setRobotAngleX, robotctrl.y + setRobotAngleY);
					if (errangle>90 || errangle < -90)
					{

						int nv = errangle * 27 / 180;
						int verrangle = calcVangle(errangle);
						ctrRobotXoay(nv, verrangle);
						delay_ms(1);
					}
					else
					{

						verranglekisum = 0;//RESET I.
						flaghuongtrue = 0;
						flagsethome = 1;  // bao da set home khong can set nua
						vMRstop();
						vMLstop();
						return 0;

					}
				}

			}

			if (cmdCtrlRobot == 7)  //sethome IS STUCKED
			{

				cntstuckRB++;
				if (cntstuckRB > 2)
				{
					runEscStucksethome();
					cntstuckRB = 0;
				}
			}

			if (cmdCtrlRobot == 6) //sethome IS //roi vao diem mu (blind spot) , mat vi tri hay huong
			{
				LEDBL = 1;
				cntunlookRB++;
				if (cntunlookRB > 2)
				{
					runEscBlindSpotsethome();
					cntunlookRB = 0;

				}

			}


		}

		LEDR = !LEDR;

	}
	return 0;

}

int codePenalty()
{
	// chay den vi tri duoc dat truoc, sau do da banh 1 lan 
	//PHUC SH
	if (readposition() == 1)//co du lieu moi
	{
		if (cmdCtrlRobot == 8)  //set vi tri penalty robot
		{
			calcvitri(rbctrlPenaltyX, rbctrlPenaltyY);
			if (distance > 50) //chay den vi tri 
			{
				if (errangle > 18 || errangle < -18)
				{
					int nv = errangle * 27 / 180;
					int verrangle = calcVangle(errangle);
					ctrRobotXoay(nv, verrangle);
					delay_ms(1);
				}
				else
				{
					//1xung = 3.14 * 40/24 =5.22                 
					ctrRobottoi(distance / 5.22, 15);
					// verranglekisum=0;//RESET I.
				}
			}
			else //XOAY DUNG HUONG
			{
				setRobotAngleX = 10 * cos(rbctrlPenaltyAngle*M_PI / 180);
				setRobotAngleY = 10 * sin(rbctrlPenaltyAngle*M_PI / 180);;
				calcvitri(robotctrl.x + setRobotAngleX, robotctrl.y + setRobotAngleY);
				if (errangle>10 || errangle < -10)
				{

					int nv = errangle * 27 / 180;
					int verrangle = calcVangle(errangle);
					ctrRobotXoay(nv, verrangle);
					delay_ms(1);
				}
				else
				{

					verranglekisum = 0;//RESET I.
					flaghuongtrue = 0;
					flagsethome = 1;  // bao da set vitri penalty  
					while (cmdCtrlRobot != 2) //cho nhan nut start
					{
						readposition();
					}
					// da banh
					vMRtoi(22);
					vMLtoi(22);
					delay_ms(1000);
					vMRlui(10);
					vMLlui(10);
					delay_ms(1000);
					vMRstop();
					vMLstop();
					return 0;

				}
			}

		}
	}

}
void settoadoHomRB()
{
	switch (ROBOT_ID)
	{
		//PHUC
	case 1:


		rbctrlPenaltyX = 0;
		rbctrlPenaltyY = 0;

		if (SAN_ID == 1)
		{
			rbctrlPenaltyAngle = 179;
			rbctrlHomeAngle = 179;
			rbctrlHomeX = 269.7;
			rbctrlHomeY = 1.7;
			setRobotXmin = 80;
			setRobotXmax = 260;
		}
		else
		{
			rbctrlPenaltyAngle = -15;
			rbctrlHomeAngle = -15;
			rbctrlHomeX = -226.1;
			rbctrlHomeY = 1.6;
			setRobotXmin = -260;
			setRobotXmax = -80;
		}
		break;
	case 2:


		rbctrlPenaltyX = 0;
		rbctrlPenaltyY = 0;

		if (SAN_ID == 1)
		{
			rbctrlPenaltyAngle = 179;
			rbctrlHomeAngle = 179;
			rbctrlHomeX = 66.0;
			rbctrlHomeY = 79.4;
			setRobotXmin = -270;
			setRobotXmax = 270;
		}
		else
		{
			rbctrlPenaltyAngle = -15;
			rbctrlHomeAngle = -15;
			rbctrlHomeX = -44.3;
			rbctrlHomeY = 82.7;
			setRobotXmin = -270;
			setRobotXmax = 270;
		}
		break;
	case 3:


		rbctrlPenaltyX = 0;
		rbctrlPenaltyY = 0;
		rbctrlPenaltyAngle = -15;
		if (SAN_ID == 1)
		{
			rbctrlPenaltyAngle = 179;
			rbctrlHomeAngle = 179;
			rbctrlHomeX = 54.1;
			rbctrlHomeY = -99.9;
			setRobotXmin = -270;
			setRobotXmax = 20;
		}
		else
		{
			rbctrlPenaltyAngle = -15;
			rbctrlHomeAngle = -15;
			rbctrlHomeX = -53.5;
			rbctrlHomeY = -93.8;
			setRobotXmin = -20;
			setRobotXmax = 270;
		}
		break;
	case 4:

		rbctrlPenaltyX = 0;
		rbctrlPenaltyY = 0;

		if (SAN_ID == 1)
		{
			rbctrlPenaltyAngle = 179;
			rbctrlHomeAngle = 179;
			rbctrlHomeX = 269.7;
			rbctrlHomeY = 1.7;
			setRobotXmin = 80;
			setRobotXmax = 260;
		}
		else
		{
			rbctrlPenaltyAngle = -15;
			rbctrlHomeAngle = -15;
			rbctrlHomeX = -226.1;
			rbctrlHomeY = 1.6;
			setRobotXmin = -260;
			setRobotXmax = -80;
		}
		break;
	case 5:

		rbctrlPenaltyX = 0;
		rbctrlPenaltyY = 0;
		if (SAN_ID == 1)
		{
			rbctrlPenaltyAngle = 179;
			rbctrlHomeAngle = 179;
			rbctrlHomeX = 66.0;
			rbctrlHomeY = 79.4;
			setRobotXmin = -270;
			setRobotXmax = 270;
		}
		else
		{
			rbctrlPenaltyAngle = -15;
			rbctrlHomeAngle = -15;
			rbctrlHomeX = -44.3;
			rbctrlHomeY = 82.7;
			setRobotXmin = -270;
			setRobotXmax = 270;
		}
		break;
	case 6:


		rbctrlPenaltyX = 0;
		rbctrlPenaltyY = 0;
		if (SAN_ID == 1)
		{
			rbctrlPenaltyAngle = 179;
			rbctrlHomeAngle = 179;
			rbctrlHomeX = 54.1;
			rbctrlHomeY = -99.9;
			setRobotXmin = -270;
			setRobotXmax = 20;
		}
		else
		{
			rbctrlPenaltyAngle = -15;
			rbctrlHomeAngle = -15;
			rbctrlHomeX = -53.5;
			rbctrlHomeY = -93.8;
			setRobotXmin = -20;
			setRobotXmax = 270;
		}
		break;


	}
}
//=======================================================   
// Tinh luc theo goc quay de dieu khien robot
int calcVangle(int angle)
{
	int verrangle = 0;
	//tinh thanh phan I 
	verranglekisum = verranglekisum + angle / 20;
	if (verranglekisum > 15)verranglekisum = 15;
	if (verranglekisum < -15)verranglekisum = -15;
	//tinh thanh phan dieu khien
	verrangle = 10 + angle / 12 + verranglekisum;
	//gioi han bao hoa  
	if (verrangle < 0) verrangle = -verrangle;//lay tri tuyet doi cua van toc v dieu khien 
	if (verrangle > 20) verrangle = 20;
	if (verrangle < 8) verrangle = 8;
	return  verrangle;
}
//ctrl robot
void ctrrobot()
{
	if (readposition() == 1)//co du lieu moi
	{
		//          hc(3,40);wn16s(cmdCtrlRobot); 
		//        hc(4,40);wn16s(idRobot);
		//-------------------------------------------------  
		if (cmdCtrlRobot == 8)      // dung ma lenh stop chuong trinh
		{
			flagsethome = 0; //cho phep sethome
			while (cmdCtrlRobot == 8)
			{
				codePenalty();
			}
		}

		if (cmdCtrlRobot == 1)      // dung ma lenh stop chuong trinh
		{
			flagsethome = 0; //cho phep sethome
			while (cmdCtrlRobot == 1)
			{
				readposition();
			}
		}

		if (cmdCtrlRobot == 5)  //sethome robot
		{

			cntsethomeRB++;
			if (cntsethomeRB > 2)
			{
				LEDBR = 1;
				if (flagsethome == 0)sethomeRB();
				cntsethomeRB = 0;
			}

		}

		if (cmdCtrlRobot == 4)  //sethome robot
		{
			flagsethome = 0; //cho phep sethome
			cntstuckRB++;
			if (cntstuckRB > 2)
			{
				runEscStuck();
				cntstuckRB = 0;
			}
		}

		if (cmdCtrlRobot == 3)  //roi vao diem mu (blind spot) , mat vi tri hay huong
		{
			flagsethome = 0; //cho phep sethome
			cntunlookRB++;
			if (cntunlookRB > 2)
			{
				runEscBlindSpot();
				cntunlookRB = 0;
			}

		}


		//------------------------------------------------
		if (cmdCtrlRobot == 2) {// run chuong trinh 
			flagsethome = 0; //cho phep sethome
			switch (flagtask)
			{
				// chay den vi tri duoc set boi nguoi dieu khien       
			case 0:
				if (setRobotX < setRobotXmin)   setRobotX = setRobotXmin;
				if (setRobotX > setRobotXmax)    setRobotX = setRobotXmax;
				calcvitri(setRobotX, setRobotY);
				if (distance > 80) //chay den vi tri 
				{
					if (errangle > 18 || errangle < -18)
					{
						int nv = errangle * 27 / 180;
						int verrangle = calcVangle(errangle);
						ctrRobotXoay(nv, verrangle);
						delay_ms(1);
					}
					else
					{
						//1xung = 3.14 * 40/24 =5.22                 
						ctrRobottoi(distance / 5.22, 15);
						// verranglekisum=0;//RESET I.
					}
				}
				else
				{
					flagtask = 10;
				}
				break;
				// quay dung huong duoc set boi nguoi dieu khien
			case 1:

				calcvitri(robotctrl.x + setRobotAngleX, robotctrl.y + setRobotAngleY);
				if (errangle > 18 || errangle < -18)
				{

					int nv = errangle * 27 / 180;
					int verrangle = calcVangle(errangle);
					ctrRobotXoay(nv, verrangle);
					// ctrRobotXoay(nv,10);
					delay_ms(1);
				}
				else
				{
					flaghuongtrue++;
					if (flaghuongtrue > 3)
					{
						//verranglekisum=0;//RESET I.
						flaghuongtrue = 0;
						flagtask = 10;
					}

				}
				break;
				// chay den vi tri bong
			case 2:

				//PHUC test    rb1 ,s1
				if (robotctrl.ball.x < setRobotXmin)   robotctrl.ball.x = setRobotXmin;
				if (robotctrl.ball.x > setRobotXmax)    robotctrl.ball.x = setRobotXmax;
				calcvitri(robotctrl.ball.x, robotctrl.ball.y);

				if (errangle > 18 || errangle < -18)
				{
					int nv = errangle * 27 / 180;
					int verrangle = calcVangle(errangle);
					ctrRobotXoay(nv, verrangle);
					delay_ms(1);
				}
				else
				{
					//1xung = 3.14 * 40/24 =5.22                 
					if (distance > 10) //chay den vi tri 
					{
						ctrRobottoi(distance / 5.22, 15);
						delay_ms(5);
					}
					else
					{
						flagtask = 10;
					}
					// verranglekisum=0;//RESET I.
				}

				break;
				// da bong
			case 3:
				ctrRobottoi(40, 22);
				delay_ms(400);
				ctrRobotlui(40, 15);
				delay_ms(400);
				flagtask = 10;
				break;
			case 10:
				vMRtoi(0);
				vMLtoi(0);
				break;
				//chay theo bong co dinh huong   
			case 4:
				calcvitri(robotctrl.ball.x, robotctrl.ball.y);
				if (errangle > 18 || errangle < -18)
				{

					int nv = errangle * 27 / 180;
					int verrangle = calcVangle(errangle);
					ctrRobotXoay(nv, verrangle);
					// ctrRobotXoay(nv,10);
					delay_ms(1);
				}
				else
				{
					flaghuongtrue++;
					if (flaghuongtrue > 3)
					{
						//verranglekisum=0;//RESET I.
						flaghuongtrue = 0;
						flagtask = 10;
					}

				}
				break;
			}
		}//end if(cmdCtrlRobot==2)  
	}
	else   //khong co tin hieu RF hay khong thay robot
	{
		//if(flagunlookRB==1) runEscBlindSpot();

	}


}

void rb_move(float x, float y)
{
	flagtask = 0;
	flagtaskold = flagtask;
	setRobotX = x;
	setRobotY = y;
}
void rb_rotate(int angle)     // goc xoay so voi truc x cua toa do
{
	flagtask = 1;
	flagtaskold = flagtask;
	setRobotAngleX = 10 * cos(angle*M_PI / 180);
	setRobotAngleY = 10 * sin(angle*M_PI / 180);;
}

void rb_goball()
{
	flagtask = 2;
	flagtaskold = flagtask;
}
void rb_kick()
{
	flagtask = 3;
	flagtaskold = flagtask;
}
int rb_wait(unsigned long int time)
{
	time = time * 10;
	while (time--)
	{
		ctrrobot();
		if (flagtask == 10) return 1;// thuc hien xong nhiem vu
	}
	return 0;
}
//========================================================
// Timer1 overflow interrupt service routine
// period =1/2khz= 0.5ms
interrupt[TIM1_OVF] void timer1_ovf_isr(void)
{
	// Place your code here
	timerstick++;
	timerstickdis++;
	timerstickang++;
	timerstickctr++;
#ifdef CtrVelocity 
	// dieu khien van toc   
	if (timerstick > 250)    // 125ms/0.5ms=250 : dung chu ki lay mau = 125 ms     
	{
		int eR = 0, eL = 0;

		//-------------------------------------------
		//cap nhat van toc  
		vQER = (QER - oldQER);     //(xung / 10ms)
		vQEL = (QEL - oldQEL);     //(xung /10ms)
		oldQEL = QEL;
		oldQER = QER;
		timerstick = 0;

		//--------------------------------------------
		//tinh PID van toc 
		//--------------------------------------------
		eR = svQER - vQER;
		//tinh thanh phan I 
		seRki = seRki + KiR*eR;
		if (seRki > 100) seRki = 100;
		if (seRki < -100) seRki = -100;
		//tinh them thanh phan P
		uR = 100 + KpR*eR + seRki;
		if (uR > 255) uR = 255;
		if (uR < 0) uR = 0;

		eL = svQEL - vQEL;
		//tinh thanh phan I
		seLki = seLki + KiL*eL;
		if (seLki > 100) seLki = 100;
		if (seLki < -100) seLki = -100;
		//tinh them thanh phan P
		uL = 100 + KpL*eL + seLki;
		if (uL > 255) uL = 255;
		if (uL < 0) uL = 0;

		if (svQER != 0)OCR1B = uR;
		else  OCR1B = 0;

		if (svQEL != 0) OCR1A = uL;
		else  OCR1A = 0;

	}
	// dieu khien khoang cach 
	if (timerstickdis > 10 && (flagwaitctrRobot == 1))
	{
		unsigned int deltad1 = 0;
		deltad1 = (QER + QEL) / 2 - oldd;
		//if(deltad1<0) deltad1=0;// co the am do kieu so
		//hc(3,0);ws("            ");
		//hc(3,0);wn16s(deltad1); 
		if (deltad1 > sd)
		{

			vMLstop();
			vMRstop();
			flagwaitctrRobot = 0;
			oldd = (QER + QEL) / 2;

		}
		timerstickdis = 0;

	}
	// dieu khien  vi tri goc quay
	if (timerstickang > 10 && (flagwaitctrAngle == 1))
	{
		unsigned int deltaa = 0;
		deltaa = (QEL)-olda;
		//    hc(4,0);ws("            ");
		//    hc(4,0);wn16s(deltaa); 
		if (deltaa > sa)
		{
			vMLstop();
			vMRstop();
			flagwaitctrAngle = 0;
			olda = QEL;
		}
		timerstickang = 0;
	}
	// dieu khien robot robot
	if (timerstickctr > 1)
	{
		timerstickctr = 0;
	}
#endif
}

//========================================================
// read  vi tri robot   PHUC
//========================================================
unsigned char testposition()
{
	unsigned char  i = 0;
	unsigned flagstatus = 0;

	while (keyKT != 0)
	{
		readposition();

		if (idRobot == ROBOT_ID)
		{
			hc(5, 40); wn16s(robotctrl.ball.y);
			hc(4, 40); wn16s(robotctrl.ball.x);
			hc(3, 20); wn16s(robotctrl.x);
			hc(2, 20); wn16s(robotctrl.y);
			hc(1, 1); wn16s(robotctrl.ox);
			hc(0, 1); wn16s(robotctrl.oy);
			delay_ms(200);
		}

	}
	return flagstatus;
}
//========================================================
void robotwall()
{
	unsigned int demled;
	DDRA = 0x00;
	PORTA = 0x00;

	LcdClear();
	hc(0, 10);
	ws("ROBOT WALL");
	LEDL = 1; LEDR = 1;

	while (keyKT != 0)
	{
		IRFL = read_adc(4);
		IRFR = read_adc(5);
		hc(1, 0); wn16(IRFL);
		hc(1, 42); wn16(IRFR);

		if (IRFL > 250)
		{
			vMLlui(22); vMRlui(10); delay_ms(600);
		}
		if (IRFR > 250)
		{
			vMLlui(10); vMRlui(22); delay_ms(600);
		}
		if ((IRFL < 300)&(IRFR < 300))
		{
			vMLtoi(22); vMRtoi(22);
		}

		demled++;
		if (demled > 50){ demled = 0; LEDLtoggle(); LEDRtoggle(); }
	}

}
////========================================================
//void robotline() //DIGITAL I/O
//{
//    unsigned char status=2;
//    unsigned char prestatus=2;
//
//    DDRA =0x00;
//    PORTA=0xFF;
////#define S0  PINA.0 status 0
////#define S1  PINA.1 status 1
////#define S2  PINA.2 status 2
////#define S3  PINA.3 status 3
////#define S4  PINA.7 status 4
//        LcdClear();
//        hc(0,1);
//        ws ("LINE FOLOWER");
//        hc(1,20);
//        ws (" ROBOT");
//        LEDL=1;LEDR=1;
//
//   while(keyKT!=0)
//   {
//      if (S2==0)
//      {
//          status=2;
//          vMLtoi(80);vMRtoi(80);
//      }
//      //===========================
//      if ((prestatus==2)&(S1==0))
//      {
//          status=1;
//          vMLtoi(80);vMRtoi(50);
//      }
//      if ((prestatus==2)&(S0==0))
//      {
//          status=0;
//          vMLtoi(80);vMRtoi(30);
//      }
//       //===========================
//      if ((prestatus==2)&(S3==0))
//      {
//          status=1;
//          vMLtoi(50);vMRtoi(80);
//      }
//      if ((prestatus==2)&(S4==0))
//      {
//          status=0;
//          vMLtoi(30);vMRtoi(80);
//      }
//       //===========================
//      if ((prestatus==1)&(S0==0))
//      {
//          status=1;
//          vMLtoi(80);vMRtoi(40);
//      }
//      if ((prestatus==3)&(S4==0))
//      {
//          status=0;
//          vMLtoi(40);vMRtoi(80);
//      }
//
//      prestatus=status;
//      delay_ms(200);LEDLtoggle();LEDRtoggle();
//
//  }
// }


//========================================================
void readline()
{
	int i = 0, j = 0;
	// reset the values
	for (i = 0; i < 5; i++)
		IRLINE[i] = 0;

	for (j = 0; j < 50; j++)
	{
		IRLINE[0] = IRLINE[0] + read_adc(0);
		IRLINE[1] = IRLINE[1] + read_adc(1);
		IRLINE[2] = IRLINE[2] + read_adc(2);
		IRLINE[3] = IRLINE[3] + read_adc(3);
		IRLINE[4] = IRLINE[4] + read_adc(7);
	}
	// get the rounded average of the readings for each sensor
	for (i = 0; i < 5; i++)
		IRLINE[i] = (IRLINE[i] + (50 >> 1)) / 50;
}
//========================================================
void robotwhiteline() //ANALOG OK
{
	unsigned char i = 0, imax;
	int imaxlast = 0;
	unsigned int  admax;
	unsigned int  demled = 0;
	unsigned int flagblindT = 0;
	unsigned int flagblindP = 0;
	DDRA = 0x00;
	PORTA = 0x00;

	LcdClear();
	hc(0, 1);
	ws("WHITE LINE");
	hc(1, 10);
	ws("FOLOWER");
	LEDL = 1; LEDR = 1;
	//doc va khoi dong gia tri cho imaxlast
	readline();
	admax = IRLINE[0]; imax = 0;
	for (i = 1; i < 5; i++){ if (admax < IRLINE[i]){ admax = IRLINE[i]; imax = i; } }
	imaxlast = imax;
	while (keyKT != 0)
	{
		//doc gia tri cam bien
		readline();
		admax = IRLINE[0]; imax = 0;
		for (i = 1; i < 5; i++){ if (admax < IRLINE[i]){ admax = IRLINE[i]; imax = i; } }
		//imax=2; 
		if ((imax - imaxlast > 1) || (imax - imaxlast < -1))  //tranh truong hop nhay bo trang thai
		{
		}
		else
		{
			switch (imax)
			{
			case 0:
				vMLtoi(1); vMRtoi(20);
				//flagblindT = 0; 
				flagblindP = 1;
				break;
			case 1:
				vMLtoi(1); vMRtoi(15);
				break;
			case 2:
				vMLtoi(15); vMRtoi(15);
				break;
			case 3:
				vMLtoi(15); vMRtoi(1);
				break;
			case 4:
				vMLtoi(20); vMRtoi(1);
				flagblindT = 1;
				//flagblindP = 0;
				break;
			default:
				// vMLtoi(5); vMRtoi(5) ;
				break;
			}
			imaxlast = imax;
		}

		while (flagblindT == 1 && keyKT != 0) //lac duong ben trai
		{
			vMLtoi(20); vMRtoi(1);
			readline();
			admax = IRLINE[0]; imax = 0;
			for (i = 1; i < 5; i++){ if (admax < IRLINE[i]){ admax = IRLINE[i]; imax = i; } }
			imaxlast = imax;
			if (IRLINE[2] > 500)  flagblindT = 0;


		}
		while (flagblindP == 1 && keyKT != 0) //lac duong ben phai
		{
			vMLtoi(1); vMRtoi(20);
			readline();
			admax = IRLINE[0]; imax = 0;
			for (i = 1; i < 5; i++){ if (admax < IRLINE[i]){ admax = IRLINE[i]; imax = i; } }
			imaxlast = imax;
			if (IRLINE[2] > 500)  flagblindP = 0;

		}
		hc(3, 10); wn16s(imax);
		hc(4, 10); wn16s(admax);

		demled++;
		if (demled > 30){ demled = 0; LEDLtoggle(); LEDRtoggle(); }
	}
}

//========================================================
void robotblackline() //ANALOG OK
{
	long int lastvalueline = 0, valueline = 0, value = 0, online = 0;
	int i = 0, j = 0
		, imin = 0;
	long int avrg = 0, sum = 0;
	unsigned int admin;
	unsigned char imax;
	int imaxlast = 0;
	unsigned int  admax;
	unsigned int demled = 0;
	unsigned int flagblindT = 0;
	unsigned int flagblindP = 0;
	float udk, sumi = 0, err, lasterr;

	int iminlast = 0;
	DDRA = 0x00;
	PORTA = 0x00;

	LcdClear();
	hc(0, 1);
	ws("BLACK LINE");
	hc(1, 10);
	ws("FOLOWER");
	LEDL = 1; LEDR = 1;

	//doc lan dau tien  de khoi dong gia tri iminlast; 
	readline();
	admin = IRLINE[0]; imin = 0;
	for (i = 1; i<5; i++){ if (admin>IRLINE[i]){ admin = IRLINE[i]; imin = i; } }
	iminlast = imin;
	admin = 1024;
	admax = 0;
	//calib
	while (keyKT != 0)
	{
		//doc gia tri cam bien       
		readline();

		for (i = 1; i<5; i++){ if (admin>IRLINE[i]){ admin = IRLINE[i]; imin = i; } }
		//hc(3,10);wn16s(admin);
		hc(3, 10); wn16s(admin);

		for (i = 1; i < 5; i++){ if (admax < IRLINE[i]){ admax = IRLINE[i]; imax = i; } }
		hc(4, 10); wn16s(admax);
	}
	//test gia tri doc line  
	online = 0;
	while (1)
	{
		//doc gia tri cam bien       
		readline();
		for (i = 0; i < 5; i++)
		{
			value = IRLINE[i];
			if (value < 280) online = 1;
			avrg = avrg + i * 1000 * value;
			sum = sum + value;
		}
		//hc(1,10);wn16s(online);
		if (online == 1)
		{
			valueline = (int)(avrg / sum);
			// hc(2,10);wn16s(valueline);
			online = 0;
			avrg = 0;
			sum = 0;
		}
		else
		{
			if (lastvalueline > 1935)
				valueline = 2000;
			else
				valueline = 1800;
		}
		err = 1935 - valueline;
		if (err > 100) err = 100;
		if (err < -100) err = -100;
		sumi = sumi + err / 35;
		if (sumi > 6) sumi = 6;
		if (sumi < -6) sumi = -6;
		udk = err / 7 + sumi + (err - lasterr) / 30;
		if (udk > 10) { udk = 9; sumi = 0; }
		if (udk < -10){ udk = -9; sumi = 0; }
		//hc(5,10);wn16s(udk);
		vMLtoi(10 + udk); vMRtoi(10 - udk);

		lastvalueline = valueline;
		lasterr = err;
	}

	while (keyKT != 0)
	{
		//doc gia tri cam bien       
		readline();
		admin = IRLINE[0]; imin = 0;
		for (i = 1; i<5; i++){ if (admin>IRLINE[i]){ admin = IRLINE[i]; imin = i; } }
		hc(2, 10); wn16s(iminlast);
		hc(3, 10); wn16s(imin);
		hc(4, 10); wn16s(admin);

		if ((imin - iminlast > 1) || (imin - iminlast < -1))  //tranh truong hop nhay bo trang thai
		{
		}
		else
		{
			switch (imin)
			{
			case 0:
				vMLtoi(1); vMRtoi(15);
				//flagblindT = 0; 
				flagblindP = 1;
				break;
			case 1:
				vMLtoi(2); vMRtoi(8);
				break;
			case 2:
				vMLtoi(10); vMRtoi(10);
				break;
			case 3:
				vMLtoi(8); vMRtoi(2);
				break;
			case 4:
				vMLtoi(15); vMRtoi(1);
				flagblindT = 1;
				//flagblindP = 0;
				break;
			default:
				// vMLtoi(5); vMRtoi(5) ;
				break;
			}

			iminlast = imin;
		}


		while (flagblindT == 1 && keyKT != 0) //lac duong ben trai
		{
			vMLtoi(20); vMRtoi(2);
			readline();
			admin = IRLINE[0]; imin = 0;
			for (i = 1; i<5; i++){ if (admin>IRLINE[i]){ admin = IRLINE[i]; imin = i; } }
			iminlast = imin;
			if (IRLINE[2] < 310)  flagblindT = 0;

		}
		while (flagblindP == 1 && keyKT != 0) //lac duong ben phai
		{
			vMLtoi(2); vMRtoi(20);
			readline();
			admin = IRLINE[0]; imin = 0;
			for (i = 1; i<5; i++){ if (admin>IRLINE[i]){ admin = IRLINE[i]; imin = i; } }
			iminlast = imin;
			if (IRLINE[2] < 310)  flagblindP = 0;

		}


		demled++;
		if (demled > 30){ demled = 0; LEDLtoggle(); LEDRtoggle(); }
	}
}
//========================================================
void bluetooth()
{
	unsigned char kytu;
	unsigned int demled;

	LcdClear();
	hc(0, 10);
	ws("BLUETOOTH");
	hc(1, 25);
	ws("DRIVE");

	LEDL = 1; LEDR = 1;

	while (keyKT != 0)
	{
		LEDL = 1; LEDR = 1;
		delay_ms(100);
		LEDL = 0; LEDR = 0;
		delay_ms(100);

		if (rx_counter)
		{
			//LcdClear();
			hc(2, 42);
			kytu = getchar();
			LcdCharacter(kytu);
			//putchar(getchar());
			if (kytu == 'S'){ vMLtoi(0); vMRtoi(0); }
			if (kytu == 'F'){ vMLtoi(100); vMRtoi(100); }
			if (kytu == 'B'){ vMLlui(100); vMRlui(100); }
			if (kytu == 'R'){ vMLtoi(100); vMRtoi(0); }
			if (kytu == 'L'){ vMLtoi(0); vMRtoi(100); }

			demled++;
			if (demled > 1000){ demled = 0; LEDLtoggle(); LEDRtoggle(); }
		}
	}
}
//========================================================

//Chuong trinh test robot
void testmotor()
{
	LcdClear();
	hc(0, 10);
	ws("TEST MOTOR");

	vMRtoi(20);
	vMLtoi(20);
	while (keyKT != 0)
	{
		hc(2, 0);
		ws("MotorL");
		hc(2, 45);
		wn16(QEL);
		hc(3, 0);
		ws("MotorR");
		hc(3, 45);
		wn16(QER);
		delay_ms(10);
	}

	vMRstop();
	vMLstop();
}
//========================================================
// UART TEST
void testuart()
{
	if (rx_counter)
	{
		LcdClear();
		hc(0, 10);
		ws("TEST UART");
		putchar(getchar());
	}

}
//========================================================
// UART TEST
void testrf()
{


}

//========================================================
void testir()
{
	unsigned int AD[8];

	DDRA = 0x00;
	PORTA = 0x00;

	clear();
	hc(0, 10);
	ws("TEST IR");

	while (keyKT != 0)
	{

		AD[0] = read_adc(0);
		AD[1] = read_adc(1);
		AD[2] = read_adc(2);
		AD[3] = read_adc(3);
		AD[4] = read_adc(4);
		AD[5] = read_adc(5);
		AD[6] = read_adc(6);
		AD[7] = read_adc(7);

		hc(1, 0); ws("0."); wn164(AD[0]);
		hc(1, 43); ws("1."); wn164(AD[1]);
		hc(2, 0); ws("2."); wn164(AD[2]);
		hc(2, 43); ws("3."); wn164(AD[3]);
		hc(3, 0); ws("4."); wn164(AD[4]);
		hc(3, 43); ws("5."); wn164(AD[5]);
		hc(4, 0); ws("6."); wn164(AD[6]);
		hc(4, 43); ws("7."); wn164(AD[7]);

		delay_ms(1000);
	}

}

//========================================================
void outlcd1()
{
	LcdClear();
	hc(0, 5);
	ws("<SELF TEST>");
	hc(1, 0);
	ws("************");
}
//========================================================
void chopledtheoid()
{
	unsigned char i;
	DDRA = 0xFF;

	switch (id)
	{
	case 1:
		LEDR = 1;
		LEDL = 1; PORTA.4 = 1; delay_ms(10);
		LEDL = 0; PORTA.4 = 0; delay_ms(30);
		break;
	case 2:
		LEDR = 1;
		LEDL = 1; PORTA.6 = 1; delay_ms(10);
		LEDL = 0; PORTA.6 = 0; delay_ms(30);
		break;
	case 3:
		LEDR = 1;
		LEDL = 1; PORTA.7 = 1; delay_ms(10);
		LEDL = 0; PORTA.7 = 0; delay_ms(30);
		break;
	case 4:
		LEDR = 1;
		LEDL = 1; PORTA.5 = 1; delay_ms(10);
		LEDL = 0; PORTA.5 = 0; delay_ms(30);
		break;
	case 5:
		LEDL = 1;
		LEDR = 1; PORTA.4 = 1; delay_ms(10);
		LEDR = 0; PORTA.4 = 0; delay_ms(30);
		break;
	case 6:
		LEDL = 1;
		LEDR = 1; PORTA.6 = 1; delay_ms(10);
		LEDR = 0; PORTA.6 = 0; delay_ms(30);
		break;
	case 7:
		LEDL = 1;
		LEDR = 1; PORTA.7 = 1; delay_ms(10);
		LEDR = 0; PORTA.7 = 0; delay_ms(30);
		break;
	case 8:
		LEDL = 1;
		LEDR = 1; PORTA.5 = 1; delay_ms(10);
		LEDR = 0; PORTA.5 = 0; delay_ms(30);
		break;
	case 9:
		LEDL = 1; LEDR = 1; PORTA.4 = 1; delay_ms(10);
		LEDL = 0; LEDR = 0; PORTA.4 = 0; delay_ms(30);
		break;
	};
	//LEDL=1;delay_ms(100);
	//LEDL=0;delay_ms(100);
	//for(i=0;i<id;i++)
	//{
	//    LEDR=1;delay_ms(150);
	//    LEDR=0;delay_ms(150);
	//}
}
//========================================================
//========================================================
void testRCservo()
{
	clear();
	hc(0, 10);
	ws("RC SERVO");
	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: 7.813 kHz
	// Mode: Phase correct PWM top=0xFF
	// OC0 output: Non-Inverted PWM
	TCCR0 = 0x65;     //15.32Hz
	TCNT0 = 0x00;
	OCR0 = 0x00;

	// Timer/Counter 2 initialization
	// Clock source: System Clock
	// Clock value: 7.813 kHz
	// Mode: Phase correct PWM top=0xFF
	// OC2 output: Non-Inverted PWM
	ASSR = 0x00;      //15.32Hz
	TCCR2 = 0x67;
	TCNT2 = 0x00;
	OCR2 = 0x00;

	while (keyKT != 0)
	{
		LEDL = 1; LEDR = 1;//PORTB.3=1;
		OCR0 = 2; OCR2 = 2;
		delay_ms(2000);

		LEDL = 0; LEDR = 0;//PORTB.3=1;
		OCR0 = 10; OCR2 = 10;
		delay_ms(2000);
	}
	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: Timer 0 Stopped
	// Mode: Normal top=0xFF
	// OC0 output: Disconnected
	TCCR0 = 0x00;
	TCNT0 = 0x00;
	OCR0 = 0x00;

	// Timer/Counter 2 initialization
	// Clock source: System Clock
	// Clock value: Timer2 Stopped
	// Mode: Normal top=0xFF
	// OC2 output: Disconnected
	ASSR = 0x00;
	TCCR2 = 0x00;
	TCNT2 = 0x00;
	OCR2 = 0x00;

}

void selftest()
{
	outlcd1();
	hc(2, 0);
	ws("1.ROBOT WALL"); delay_ms(200);
	while (flagselftest == 1)
	{
		//------------------------------------------------------------------------
		//test menu kiem tra  robot 
		chopledtheoid();
		if (keyKT == 0)
		{
			id++;
			if (id > 11){ id = 1; }
			switch (id)
			{

			case 1:
				outlcd1();
				hc(2, 0);
				ws("1.ROBOT WALL"); delay_ms(200);
				break;
			case 2:
				outlcd1();
				hc(2, 0);
				ws("2.BLUETOOTH "); delay_ms(200);
				break;
			case 3:
				outlcd1();
				hc(2, 0);
				ws("3.WHITE LINE"); delay_ms(200);
				break;
			case 4:
				outlcd1();
				hc(2, 0);
				ws("4.BLACK LINE"); delay_ms(200);
				break;
			case 5:
				outlcd1();
				hc(2, 0);
				ws("5.TEST MOTOR"); delay_ms(200);
				break;
			case 6:
				outlcd1();
				hc(2, 0);
				ws("6.TEST IR   "); delay_ms(200);
				break;
			case 7:
				outlcd1();
				hc(2, 0);
				ws("7.TEST RF   "); delay_ms(200);
				break;
			case 8:
				outlcd1();
				hc(2, 0);
				ws("8.TEST UART "); delay_ms(200);
				break;
			case 9:
				outlcd1();
				hc(2, 0);
				ws("9.RC SERVO "); delay_ms(200);
				break;
			case 10:
				outlcd1();
				hc(2, 0);
				ws("10.UPDATE RB"); delay_ms(200);
				break;
			};
		}
		if (keyKP == 0)
		{
			switch (id)
			{
			case 1:
				robotwall();
				break;
			case 2:
				bluetooth();
				break;
			case 3:
				robotwhiteline();
				break;
			case 4:
				robotblackline();
				break;
			case 5:
				testmotor();
				break;
			case 6:
				testir();
				break;
			case 7:
				testrf();
				break;
			case 8:
				testuart();
				break;
			case 9:
				testRCservo();
				break;
			case 10:
				testposition();
				break;

			};

		}


	}//end while(1)  
}
#ifdef DEBUG_EN
char debugMsgBuff[32];
#endif
void debug_out(char *pMsg, unsigned char len)
{
#ifdef DEBUG_EN
	char i = 0;
	for (i = 0; i < len; i++)
	{
		putchar(*pMsg++);
		delay_us(300);
	}
#endif
	return;
}
//[NGUYEN]Set bit and clear bit 
#define setBit(p,n) ((p) |= (1 << (n)))
#define clrBit(p,n) ((p) &= (~(1) << (n)))

//[NGUYEN] Update position. 64ms/frame 
//call setUpdateRate() in MAIN to init.
char timer2Count = 0;
char posUpdateFlag = 0;
#define distThresh 100

IntBall oldPos;
void initPos()
{
	oldPos.x = rbctrlHomeX;
	oldPos.y = rbctrlHomeY;
}

IntBall estimatePos(IntBall curPos)
{
	return curPos;
}

void updatePosInit()
{
	// Timer/Counter 2 initialization
	// Clock source: System Clock
	// Clock value: 7.813 kHz
	// Mode: CTC top=OCR2
	// OC2 output: Disconnected
	ASSR = 0x00;
	TCCR2 = 0x0F;
	TCNT2 = 0x12;
	OCR2 = 254;
	// Timer(s)/Counter(s) Interrupt(s) initialization
	setBit(TIMSK, OCIE2);
}
//[NGUYEN]

interrupt[TIM2_COMP] void timer2_comp_isr(void)
{
	unsigned char i = 0;
	LEDRtoggle();
	if (timer2Count++ < 2)
		return;
	else
	{
		timer2Count = 0;
	}


	if (nRF24L01_RxPacket(RxBuf) == 1)         // Neu nhan duoc du lieu
	{
		IntRobot intRb;
		for (i = 0; i < 28; i++)
		{
			*(uint8_t *)((uint8_t *)&rb + i) = RxBuf[i];
		}


		idRobot = fmod(rb.id, 10); // doc id 
		cmdCtrlRobot = (int)rb.id / 10; // doc ma lenh

		intRb = convertRobot2IntRobot(rb);

		switch (idRobot)
		{
		case 1:
			robot11 = intRb;
			break;
		case 2:
			robot12 = intRb;
			break;
		case 3:
			robot13 = intRb;
			break;
		case 4:
			robot21 = intRb;
			break;
		case 5:
			robot22 = intRb;
			break;
		case 6:
			robot23 = intRb;
			break;

		}
		if (idRobot == ROBOT_ID)
		{
			LEDL = !LEDL;
			cmdCtrlRobot = (int)rb.id / 10; // doc ma lenh          
			posUpdateFlag = 1;
			robotctrl = intRb;
			if ((robotctrl.x - oldPos.x >= distThresh) || (robotctrl.y - oldPos.y >= distThresh))
			{
				IntBall estPos;
				IntBall curPos;
				curPos.x = robotctrl.x;
				curPos.y = robotctrl.y;
				estPos = estimatePos(curPos);
				robotctrl.x = estPos.x;
				robotctrl.y = estPos.y;

			}
			oldPos.x = robotctrl.x;
			oldPos.y = robotctrl.y;
		}

	}
}
unsigned char readposition()
{
	return;
}

//========================================================
//          HAM MAIN
//========================================================
void main(void)
{
	// For Testing purpose only, creating a fake robot
	IntRobot rbFake;
	unsigned char flagreadrb;
	unsigned int adctest;
	unsigned char i;
	float PIdl, PIdr, pl, il, pr, ir, ur, ul;

	// Testing robot declaration
	rbFake.id = 4;
	rbFake.x = -42;
	rbFake.y = 48;
	rbFake.ox = -35;
	rbFake.oy = -50;
	rbFake.ball.x = 0;
	rbFake.ball.y = 0;

	//------------- khai  bao chuc nang in out cua cac port
	DDRA = 0xFF;
	DDRB = 0b10111111;
	DDRC = 0b11111100;
	DDRD = 0b11110010;

	//------------- khai  bao chuc nang cua adc
	// ADC initialization
	// ADC Clock frequency: 1000.000 kHz
	// ADC Voltage Reference: AVCC pin
	ADMUX = ADC_VREF_TYPE & 0xff;
	ADCSRA = 0x83;
	//---------------------------------------------------------------------   
	//------------- khai  bao chuc nang cua bo timer dung lam PWM cho 2 dong co
	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: 1000.000 kHz   //PWM 2KHz
	// Mode: Ph. correct PWM top=0x00FF
	// OC1A output: Non-Inv.
	// OC1B output: Non-Inv.
	// Noise Canceler: Off
	// Input Capture on Falling Edge
	// Timer1 Overflow Interrupt: On  // voi period =1/2khz= 0.5ms
	// Input Capture Interrupt: Off
	// Compare A Match Interrupt: Off
	// Compare B Match Interrupt: Off
	TCCR1A = 0xA1;
	TCCR1B = 0x02;
	TCNT1H = 0x00;
	TCNT1L = 0x00;
	ICR1H = 0x00;
	ICR1L = 0x00;
	OCR1AH = 0x00;
	OCR1AL = 0x00;
	OCR1BH = 0x00;
	OCR1BL = 0x00;
	// Timer(s)/Counter(s) Interrupt(s) initialization  timer0
	TIMSK = 0x04;

	//OCR1A=0-255; MOTOR LEFT
	//OCR1B=0-255; MOTOR RIGHT
	for (i = 0; i < 1; i++)
	{
		LEDL = 1; LEDR = 1;
		delay_ms(100);
		LEDL = 0; LEDR = 0;
		delay_ms(100);
	}

	//khai  bao su dung cua glcd
	SPIinit();
	LCDinit();

	// khai  bao su dung rf dung de cap nhat gia tri vi tri cua robot
	init_NRF24L01();
	SetRX_Mode();  // chon kenh tan so phat, va dia chi phat trong file nRF14l01.c
	// khai bao su dung encoder
	initencoder(); //lay 2 canh len  xuong
	// khai bao su dung uart
	inituart();

	// Set interrupt timer 2
	updatePosInit();
	// Set for oldPos variable
	initPos();

	#asm("sei")

	//man hinh khoi dong robokit
	hc(0, 10);
	ws("<AKBOTKIT>");
	hc(1, 0);
	ws("************");

	//robotwhiteline();  
	//robotblackline();       
	//kiem tra neu nhan va giu nut trai se vao chuong trinh selftest (kiem tra hoat dong cua robot)
	while (keyKT == 0)
	{
		cntselftest++;
		if (cntselftest > 10)
		{
			while (keyKT == 0);//CHO NHA NUT AN
			cntselftest = 0;
			flagselftest = 1;
			selftest();
		}
		delay_ms(100);
	}

	// vao chuong trinh chinh sau khi bo qua phan selftest   
	hc(2, 0);
	ws("MAIN PROGRAM");
	settoadoHomRB();

	// code you here  

	while (1)
	{
#ifdef !DEBUG_MODE    
		{
			//LEDR=!LEDR;
			//PHUC
			////     //=========================================================   PHUC ID
			//         chay theo banh co dinh huong tan cong
			readposition();
			calcvitri(0, 0);    // de xac dinh huong tan cong

			//flagtancong=1;
			if (flagtancong == 1)
			{
				flagtask = 2;
				rb_wait(50);

			}
			else
			{
				if (offsetphongthu < 0)    offsetphongthu = -offsetphongthu;//lay do lon
				if (robotctrl.ball.y <= 0)
				{
					setRobotX = robotctrl.ball.x;
					setRobotY = robotctrl.ball.y + offsetphongthu;

					flagtask = 0;
					rb_wait(200);

				}
				else
				{
					setRobotX = robotctrl.ball.x;
					setRobotY = robotctrl.ball.y - offsetphongthu;

					flagtask = 0;
					rb_wait(200);

				}

				setRobotX = robotctrl.ball.x + offsetphongthu;
				setRobotY = robotctrl.ball.y;
				rb_wait(200);
				rb_goball();
				rb_wait(200);
			}
			ctrrobot();// can phai luon luon chay de dieu khien robot   
		}
#else  
		{

#ifdef DEBUG_EN   
			{
				char dbgLen;
				// left speed
				dbgLen = sprintf(debugMsgBuff, "Left Speed: %d \n\r", leftSpeed);
				debug_out(debugMsgBuff, dbgLen);

				dbgLen = sprintf(debugMsgBuff, "Right Speed: %d \n\n\r", rightSpeed);
				debug_out(debugMsgBuff, dbgLen);
			}
#endif  

			movePoint(robotctrl, 0, 0, 0, 'f');
			setSpeed(leftSpeed, rightSpeed);

		}
#endif
	} //end while(1)
}

