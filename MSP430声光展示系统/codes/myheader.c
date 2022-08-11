/*
 * myheader.c
 *
 *  Created on: 2021��8��17��
 *      Author: yb
 */
#include "myheader.h"
/*----------------------------------------------------------------------------
@��������initClock();
@��������UCS���г�ʼ��,����Ч����MCLK:16MHZ,SMCLK:8MHZ,ACLK:32KHZ;
@�����������;
@�����������;
*ATTATION*����;
*/
void Clock_Init()
{
     UCSCTL6 &= ~XT1OFF;          //����XT1
     P5SEL |= BIT2 + BIT3;        //XT2���Ź���ѡ��
     UCSCTL6 &= ~XT2OFF;          //��XT2

     //����ϵͳʱ��������1,FLL control loop�ر�SCG0=1,�ر���Ƶ�����û��Զ���UCSCTL0~1����ģʽ
     __bis_SR_register(SCG0);

     //�ֶ�ѡ��DCOƵ�ʽ��ݣ�8�ֽ��ݣ���ȷ��DCOƵ�ʴ��·�Χ��
     UCSCTL0 = DCO0+DCO1+DCO2+DCO3+DCO4;
     //DCOƵ�ʷ�Χ��28.2MHz���£�DCOƵ�ʷ�Χѡ������bitλ���ı�ֱ����������ѹ�������ı�DCO���Ƶ�ʣ�
     UCSCTL1 = DCORSEL_4;
     //fDCOCLK/32����Ƶ����Ƶ��
     UCSCTL2 = FLLD_5;

     //n=8,FLLREFCLKʱ��ԴΪXT2CLK
     //DCOCLK=D*(N+1)*(FLLREFCLK/n)
     //DCOCLKDIV=(N+1)*(FLLREFCLK/n)
     UCSCTL3 = SELREF_5 + FLLREFDIV_3;
     //ACLK��ʱ��ԴΪDCOCLKDIV,MCLK\SMCLK��ʱ��ԴΪDCOCLK
     UCSCTL4 = SELA_4 + SELS_3 +SELM_3;
     //ACLK��DCOCLKDIV��32��Ƶ�õ���SMCLK��DCOCLK��2��Ƶ�õ�
     UCSCTL5 = DIVA_5 +DIVS_1;
}

/*----------------------------------------------------------------------------
@��������Io_Init();
@��������LED��������ͨ�ŹܽŽ��г�ʼ��;
@�����������;
@�����������;
*ATTATION*�� ��;
*/
void Io_Init()
{
    //P3.0, P3.1 -> Dac
    P3OUT |= BIT0 + BIT1;
    P3DIR |= BIT0 + BIT1;
    P3REN |= BIT0 + BIT1;
    //P2.0 -> PwAmp Shutdown
    P2DIR |= BIT0;
    P2OUT |= BIT0;

    //P1.2, P2.3, P2.6 -> Button
    P1DIR &= ~BIT2;     //S1
    P1REN |= BIT2;
    P1OUT |= BIT2;      //pull up resistance
    P1IES &= ~BIT2;     //NegEdge trigger
    P1IFG = 0;          //clear IF
    P1IE |= BIT2;       //interrupt S1 enable

    P2DIR &= ~(BIT3+BIT6);      //S3,S4
    P2REN |= BIT3+BIT6;
    P2OUT |= BIT3+BIT6;
    P2IES &= ~(BIT3+BIT6);
    P2IFG = 0;
    P2IE |= BIT3 + BIT6;        //interrupt S4 enable
    //P1.4, P2.2, P2.7, P3.2, P3.3, P3.4 -> InkPaper
    P1DIR |= BIT4;
    P2DIR |= BIT7;
    P3DIR |= BIT2 + BIT3 + BIT4;
    P2DS |= BIT7;               //High Drive Level for LED multiplexing
    P3DS |= BIT3 + BIT4;

    //-> Led Cube
    P8DIR |= BIT1;
    P7DIR |= BIT4;
    P8DIR |= BIT2;
    P3DIR |= BIT7;
    P1DIR |= BIT0;
    P1DIR |= BIT5;
    P2DIR |= BIT4;
    P2DIR |= BIT5;
    P4DIR |= BIT7;
    P1DIR |= BIT6;
    P6DIR |= BIT6;
    P6DIR |= BIT1;
    P6DIR |= BIT2;
    P6DIR |= BIT3;
    P6DIR |= BIT4;
    P7DIR |= BIT0;
    P3DIR |= BIT6;
    P3DIR |= BIT5;

    P1OUT &= ~BIT6;
    P6OUT &= ~BIT6;
    P6OUT &= ~BIT1;
    P6OUT &= ~BIT2;

    //P1.3 set as UltraSoinic Trigger
    P1DIR |= BIT3;
}

/*----------------------------------------------------------------------------
@��������Timer_Init();
@�������Զ�ʱ�����г�ʼ��;
@�����������;
@�����������;
*ATTATION*�� ��;
*/
void Timer_Init()
{
    TA0CTL |= TASSEL_2 + TACLR + MC_1;      //SMCLK(8M), ������
    TA0CCR0 = MUSIC_INTERVAL;               //22.050k
}

/*----------------------------------------------------------------------------
@��������LedColoumOn();
@����������LED����;
@�����������;
@�����������;
*ATTATION*�� ��;
*/
void LedColoumOn(unsigned int Num)
{
    if(Num&BIT0 == BIT0) P8OUT |= BIT1;
    else P8OUT &= ~BIT1;
    if(Num&BIT1 == BIT1) P1OUT |= BIT0;
    else P7OUT &= ~BIT4;
    if(Num&BIT2 == BIT2) P6OUT |= BIT4;
    else P8OUT &= ~BIT2;
    if(Num&BIT3 == BIT3) P6OUT |= BIT3;
    else P3OUT &= ~BIT7;

    if(Num&BIT4 == BIT4) P7OUT |= BIT4;
    else P1OUT &= ~BIT0;
    if(Num&BIT5 == BIT5) P1OUT |= BIT5;
    else P1OUT &= ~BIT5;
    if(Num&BIT6 == BIT6) P7OUT |= BIT0;
    else P2OUT &= ~BIT4;
    if(Num&BIT7 == BIT7) P2OUT |= BIT7;
    else P2OUT &= ~BIT5;

    if(Num&BIT8 == BIT8) P8OUT |= BIT2;
    else P6OUT &= ~BIT4;
    if(Num&BIT9 == BIT9) P2OUT |= BIT4;
    else P7OUT &= ~BIT0;
    if(Num&BITA == BITA) P3OUT |= BIT6;
    else P3OUT &= ~BIT6;
    if(Num&BITB == BITB) P3OUT |= BIT3;
    else P3OUT &= ~BIT5;

    if(Num&BITC == BITC) P3OUT |= BIT7;
    else P6OUT &= ~BIT3;
    if(Num&BITD == BITD) P2OUT |= BIT5;
    else P2OUT &= ~BIT7;
    if(Num&BITE == BITE) P3OUT |= BIT5;
    else P3OUT &= ~BIT3;
    if(Num&BITF == BITF) P3OUT |= BIT4;
    else P3OUT &= ~BIT4;
}

/*----------------------------------------------------------------------------
@��������LedFloorOn();
@����������LED��;
@�����������;
@�����������;
*ATTATION*�� ��;
*/
void LedFloorOn(unsigned char Num)
{
    if(Num&BIT0 == BIT0) P6OUT &= ~BIT2;
    else P6OUT |= BIT2;
    if(Num&BIT1 == BIT1) P6OUT &= ~BIT1;
    else P6OUT |= BIT1;
    if(Num&BIT2 == BIT2) P6OUT &= ~BIT6;
    else P6OUT |= BIT6;
    if(Num&BIT3 == BIT3) P1OUT &= ~BIT6;
    else P1OUT |= BIT6;
}

/*----------------------------------------------------------------------------
@��������LedPlay();
@������Led�ƿ�;
@���������unsigned int value, ������С�����������򲥷ż���ֵ��������;
@�����������;
*ATTATION*�� ��;
*/
#define ANIMATIONNUM_LENGTH 255
const unsigned char RANDOM[ANIMATIONNUM_LENGTH] =
{
    1,1,3,0,4,5,3,3,2,2,1,0,3,0,2,4,0,1,4,3,3,1,4,3,2,3,4,0,1,4,1,2,
    0,3,5,4,5,2,2,4,1,5,4,4,2,0,1,1,0,0,4,3,2,2,2,3,3,4,4,2,5,2,5,2,
    1,0,3,5,5,3,3,4,3,1,3,1,1,0,3,3,3,4,0,4,3,3,2,3,0,5,0,4,2,1,4,3,
    4,1,3,2,0,3,4,1,1,1,5,1,4,3,4,0,4,5,3,3,1,4,4,2,0,3,3,5,0,0,4,1,
    3,1,5,2,3,3,1,0,3,1,1,0,3,3,0,3,5,3,2,4,1,2,4,4,1,1,2,4,5,1,3,1,
    3,4,2,0,2,5,2,3,3,4,1,2,5,3,0,1,1,4,4,2,2,3,4,2,4,3,4,1,2,1,3,5,
    5,4,0,3,1,4,4,1,1,0,4,3,1,3,4,5,3,3,2,4,1,2,1,1,3,5,1,4,2,5,4,5,
    5,4,5,3,0,1,4,4,4,1,2,1,0,5,3,4,2,0,0,0,2,2,3,3,0,4,2,5,2,5
};
volatile unsigned ValueLevelBuf;
void LedPlay(unsigned int value, unsigned char AnimationNum)
{
    unsigned int ValueLevel;
    switch(RANDOM[AnimationNum])
    {
        case 0:
        {
            if(value < LED_BASEVALUE) value = LED_BASEVALUE;
            ValueLevel = (value-LED_BASEVALUE)/LED_STEP_16;
            if(ValueLevel > 16) ValueLevel = 16;
            else if(ValueLevel + 1 < ValueLevelBuf) ValueLevel = ValueLevelBuf - 2;
            switch(ValueLevel)
            {
                case 0:
                {
                    LedFloorOn(0b0110);
                    LedColoumOn(0b0000000000000000);
                    break;
                }
                case 1:
                {
                    LedFloorOn(0b0110);
                    LedColoumOn(0b0000000001000000);
                    break;
                }
                case 2:
                {
                    LedFloorOn(0b0110);
                    LedColoumOn(0b0000000001100000);
                    break;
                }
                case 3:
                {
                    LedFloorOn(0b0110);
                    LedColoumOn(0b0000001001100000);
                    break;
                }
                case 4:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0000011001100000);
                    break;
                }
                case 5:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0000111001100000);
                    break;
                }
                case 6:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0000111011100000);
                    break;
                }
                case 7:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0000111011101000);
                    break;
                }
                case 8:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0000111011101100);
                    break;
                }
                case 9:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0000111011101110);
                    break;
                }
                case 10:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0000111011101111);
                    break;
                }
                case 11:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0000111011111111);
                    break;
                }
                case 12:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0000111111111111);
                    break;
                }
                case 13:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0001111111111111);
                    break;
                }
                case 14:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0011111111111111);
                    break;
                }
                case 15:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b0111111111111111);
                    break;
                }
                case 16:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b1111111111111111);
                    break;
                }
                default: break;
            }
            ValueLevelBuf = ValueLevel;
            break;
        }
        case 1:
        {
            if(value < LED_BASEVALUE) value = LED_BASEVALUE;
            ValueLevel = (value-LED_BASEVALUE)/LED_STEP_4;
            if(ValueLevel > 4) ValueLevel = 4;
            switch(ValueLevel)
            {
                case 0:
                {
                    LedFloorOn(0b0000);
                    break;
                }
                case 1:
                {
                    LedFloorOn(0b1000);
                    LedColoumOn(0b1000000000000000);
                    break;
                }
                case 2:
                {
                    LedFloorOn(0b1100);
                    LedColoumOn(0b1100110000000000);
                    break;
                }
                case 3:
                {
                    LedFloorOn(0b1110);
                    LedColoumOn(0b1110111011100000);
                    break;
                }
                case 4:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b1111111111111111);
                    break;
                }
                default: break;
            }
            break;
        }
        case 2:
        {
            if(value < LED_BASEVALUE) value = LED_BASEVALUE;
            ValueLevel = (value-LED_BASEVALUE)/LED_STEP_4;
            if(ValueLevel > 4) ValueLevel = 4;
            switch(ValueLevel)
            {
                case 0:
                {
                    LedFloorOn(0b0000);
                    break;
                }
                case 1:
                {
                    LedFloorOn(0b0110);
                    LedColoumOn(0b0000011001100000);
                    break;
                }
                case 2:
                {
                    LedFloorOn(0b0110);
                    LedColoumOn(0b1001011001101001);
                    break;
                }
                case 3:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b1001011001101001);
                    break;
                }
                case 4:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b1111111111111111);
                    break;
                }
                default: break;
            }
            break;
        }
        case 3:
        {
            if(value < LED_BASEVALUE) value = LED_BASEVALUE;
            ValueLevel = (value-LED_BASEVALUE)/LED_STEP_4;
            if(ValueLevel > 4) ValueLevel = 4;
            switch(ValueLevel)
            {
                case 0:
                {
                    LedFloorOn(0b0000);
                    break;
                }
                case 1:
                {
                    LedFloorOn(0b0001);
                    LedColoumOn(0b0000000000000001);
                    break;
                }
                case 2:
                {
                    LedFloorOn(0b0011);
                    LedColoumOn(0b0000000000110011);
                    break;
                }
                case 3:
                {
                    LedFloorOn(0b0111);
                    LedColoumOn(0b0000011101110111);
                    break;
                }
                case 4:
                {
                    LedFloorOn(0b1111);
                    LedColoumOn(0b1111111111111111);
                    break;
                }
                default: break;
            }
            break;
        }
        case 4:
        {
            LedColoumOn(0b1111111111111111);
            if(value < LED_BASEVALUE) value = LED_BASEVALUE;
            ValueLevel = (value-LED_BASEVALUE)/LED_STEP_4;
            if(ValueLevel > 4) ValueLevel = 4;
            switch(ValueLevel)
            {
                case 0:
                {
                    LedFloorOn(0b0000);
                    break;
                }
                case 1:
                {
                    LedFloorOn(0b0001);
                    break;
                }
                case 2:
                {
                    LedFloorOn(0b0011);
                    break;
                }
                case 3:
                {
                    LedFloorOn(0b0111);
                    break;
                }
                case 4:
                {
                    LedFloorOn(0b1111);
                    break;
                }
                default: break;
            }
            break;
        }
        case 5:
        {
            LedColoumOn(0b1111111111111111);
            if(value < LED_BASEVALUE) value = LED_BASEVALUE;
            ValueLevel = (value-LED_BASEVALUE)/LED_STEP_4;
            if(ValueLevel > 4) ValueLevel = 4;
            switch(ValueLevel)
            {
                case 0:
                {
                    LedFloorOn(0b0000);
                    break;
                }
                case 1:
                {
                    LedFloorOn(0b0001);
                    break;
                }
                case 2:
                {
                    LedFloorOn(0b0011);
                    break;
                }
                case 3:
                {
                    LedFloorOn(0b0111);
                    break;
                }
                case 4:
                {
                    LedFloorOn(0b1111);
                    break;
                }
                default: break;
            }
            break;
        }
        default: break;
    }
}

