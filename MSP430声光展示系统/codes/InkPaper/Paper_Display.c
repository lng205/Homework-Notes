#include <msp430.h>
#include "InkPaper\InkPaper.h"
#include "InkPaper\Paper_Display.h"

const unsigned char init_data[]=
{
    0x50,0xAA,0x55,0xAA,0x55,0xAA,0x11,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x0F,0x0F,0x0F,0x0F,
    0x0F,0x0F,0x0F,0x01,0x00,0x00,0x00,0x00,0x00,
};

void MyRESET()
{
	nRST_L;
	DELAY_mS(10);//1ms
 	nRST_H;
  	DELAY_mS(10);//1ms
}
void DELAY_100nS(unsigned int delaytime)   // 30us
{
	int i,j;
	for(i=delaytime;i>0;i--)
		for(j=10;j>0;j--);
}

void DELAY_mS(unsigned int delaytime)    	// 1ms
{
	int i;
	for(i=delaytime;i>0;i--)
		__delay_cycles(200);
}

void READBUSY()
{
    while((P2IN&BIT2) == BIT2);
    DELAY_M(2);
}
void DELAY_S(unsigned int delaytime)     //  1s
{
    int i;
    for(i=delaytime;i>0;i--)
        {
            __delay_cycles(3276);
        }
}
void DELAY_M(unsigned int delaytime)     //  1M
{
    int i;
    for(i=delaytime;i>0;i--)
        DELAY_S(60);
}

void DIS_IMG_WHITE(void)
{
    unsigned int row, col;
    unsigned int pcnt;      //pixel counter

    SPI4W_WRITECOM(0x4E);
    SPI4W_WRITEDATA(0x00);  // set RAM x address count to 0;
    SPI4W_WRITECOM(0x4F);
    SPI4W_WRITEDATA(0xF9);  // set RAM y address count to 250-1;  2D13
    DELAY_S(5);
    SPI4W_WRITECOM(0x24);
    DELAY_S(5);
    pcnt = 0;
    for(row=0; row<16; row++)  //upper 9 bytes for file info
    {
        for(col=0; col<250; col++)
        {
            SPI4W_WRITEDATA(0xFF);
            pcnt++;
        }
    }
    SPI4W_WRITECOM(0x22);
    SPI4W_WRITEDATA(0xC7);    // (Enable Clock Signal, Enable CP) (Display update,Disable CP,Disable Clock Signal)
    SPI4W_WRITECOM(0x20);
    DELAY_mS(1);
    READBUSY();
}

void InkPaper_Init()
{
    MyRESET();
    READBUSY();
    SPI4W_WRITECOM(0x01);       // Gate Setting
    SPI4W_WRITEDATA(0xF9);    // MUX Gate lines=250-1=249(F9H)
    SPI4W_WRITEDATA(0x00);    // B[2]:GD=0[POR](G0 is the 1st gate output channel)  B[1]:SM=0[POR](left and right gate interlaced)  B[0]:TB=0[POR](scan from G0 to G319)
    SPI4W_WRITECOM(0x3A);       // number of dummy line period   set dummy line for 50Hz frame freq
    SPI4W_WRITEDATA(0x06);    // Set 50Hz   A[6:0]=06h[POR] Number of dummy line period in term of TGate
    SPI4W_WRITECOM(0x3B);       // Gate line width   set gate line for 50Hz frame freq
    SPI4W_WRITEDATA(0x0B);    // A[3:0]=1011(78us)  Line width in us   78us*(250+6)=19968us=19.968ms
    SPI4W_WRITECOM(0x3C);         // Select border waveform for VBD
    SPI4W_WRITEDATA(0x33);    // GS1-->GS1  开机第一次刷新Border从白到白

    SPI4W_WRITECOM(0x11);     // Data Entry Mode
    //modified : set A2 = 1, the address counter is updated in the y direction
    SPI4W_WRITEDATA(0x05);    // 01 –Y decrement, X increment
    SPI4W_WRITECOM(0x44);     // set RAM x address start/end, in Page 22
    SPI4W_WRITEDATA(0x00);    // RAM x address start at 00h;
    SPI4W_WRITEDATA(0x0f);    // RAM x address end at 0fh(15+1)*8->128    2D13
    SPI4W_WRITECOM(0x45);     // set RAM y address start/end, in Page 22
    SPI4W_WRITEDATA(0xF9);    // RAM y address start at FAh-1;          2D13
    SPI4W_WRITEDATA(0x00);    // RAM y address end at 00h;          2D13

    SPI4W_WRITECOM(0x2C);       // Vcom= *(-0.02)+0.01???
    SPI4W_WRITEDATA(0x4B);    //-1.4V

    WRITE_LUT();
    SPI4W_WRITECOM(0x21);       // Option for Display Update
    SPI4W_WRITEDATA(0x83);      // A[7]=1(Enable bypass)  A[4]=0全黑(value will be used as for bypass)
    DIS_IMG_WHITE();         // 全黑到全白清屏，这样可防止开机出现花屏的问题

    SPI4W_WRITECOM(0x21);       //
    SPI4W_WRITEDATA(0x03);      // 后面刷新恢复正常的前后2幅图比较
    SPI4W_WRITECOM(0x3C);       // Select border waveform for VBD
    SPI4W_WRITEDATA(0x73);      // VBD-->HiZ  后面刷新时Border都是高阻
}

void WRITE_LUT()
{
	unsigned char i;
	SPI4W_WRITECOM(0x32);//write LUT register
	for(i=0;i<29;i++)
        SPI4W_WRITEDATA(init_data[i]);//write LUT register
}

void DIS_IMG(unsigned char Page, unsigned char Mode)
{
    unsigned int row, col;
    unsigned int pcnt;      //pixel counter

    SPI4W_WRITECOM(0x4E);
    SPI4W_WRITEDATA(0x00);  // set RAM x address count to 0;
    SPI4W_WRITECOM(0x4F);
    SPI4W_WRITEDATA(0xF9);  // set RAM y address count to 250-1;  2D13
    DELAY_S(5);
    SPI4W_WRITECOM(0x24);
    DELAY_S(5);
    pcnt = 0;
    for(row=0; row<9; row++)  //upper 9 bytes for file info
    {
        for(col=0; col<250; col++)
        {
            SPI4W_WRITEDATA(PAGE[Page][pcnt]);
            pcnt++;
        }
    }
    pcnt = 0;
    for(; row<16; row++)    //lower 7 bytes for mode info
    {
        for(col=0; col<250; col++)
        {
            SPI4W_WRITEDATA(MODE[Mode][pcnt]);
            pcnt++;
        }
    }
    SPI4W_WRITECOM(0x22);
    SPI4W_WRITEDATA(0xC7);    // (Enable Clock Signal, Enable CP) (Display update,Disable CP,Disable Clock Signal)
    SPI4W_WRITECOM(0x20);
    DELAY_mS(1);
    READBUSY();
}

void SPI4W_WRITECOM(unsigned char INIT_COM)
{
	unsigned char TEMPCOM;
	unsigned char scnt;
	TEMPCOM=INIT_COM;
	nCS_H;
	nCS_L;
	SCLK_L;
	nDC_L;
	for(scnt=0;scnt<8;scnt++)
	{
		if(TEMPCOM&0x80)
			SDA_H_P;
		else
			SDA_L_P;
		DELAY_100nS(10);
		SCLK_H;
		DELAY_100nS(10);
		SCLK_L;
		TEMPCOM=TEMPCOM<<1;
		DELAY_100nS(10);
	}
	nCS_H;
}

void SPI4W_WRITEDATA(unsigned char INIT_DATA)
{
	unsigned char TEMPCOM;
	unsigned char scnt;
	TEMPCOM=INIT_DATA;
	nCS_H;
	nCS_L;
	SCLK_L;
	nDC_H;
	for(scnt=0;scnt<8;scnt++)
	{
		if(TEMPCOM&0x80)
			SDA_H_P;
		else
			SDA_L_P;
		DELAY_100nS(10);
		SCLK_H;
		DELAY_100nS(10);
		SCLK_L;
		TEMPCOM=TEMPCOM<<1;
		DELAY_100nS(10);
	}
	nCS_H;
}

