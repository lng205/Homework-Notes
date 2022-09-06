/*
 * main.c
 *
 *  Created on: 2021Äê8ÔÂ24ÈÕ
 *      Author: yb
 */


#include <msp430.h>
#include "myheader.h"

volatile unsigned char Mode = AUTO;                 //system mode
StrKeyFlag KeyFlag;									//button flag
volatile bool DisplayFlag;							//InkPaper refresh flag
volatile bool AudioFlag;							//22.050kHz refresh flag
volatile unsigned int RefreshCount = 0;             //30Hz refresh counter

/**
 * main.c
 */
int main(void)
{
	/***********************************************
	FAT file system variables
	***********************************************/
    FATFS fatfs;                                    //File system object
    FIL fil;                                        //File object
    FILINFO finfo;                                  //file info
    DIRS dirss;                                     //Directory object struct
    char path[PATH_LENTH] = {""};					//path string
    char FileName[FILE_NUM][FILENAME_LENTH];		//file name string
    char *result3;									//file type judge result
	/***********************************************
	file reading variables
	***********************************************/
    unsigned char buffer[BUFFER_SIZE];              //file reading buffer
    unsigned int br;                                //file reading pointer
    bool FirstClustFlag;                            //first clust flag
    unsigned int count;                             //clust reading pointer
	/***********************************************
	file playing variables
	***********************************************/
    unsigned int MusicData;                         //music value data
    unsigned char PlayNum;							//current file order number
    unsigned char MusicNum;							//total file number

    unsigned char TempCount = 0;                    //Count*0.77=Distance(CM)
    unsigned char DistanceLevel = 0;
    unsigned char DistanceLevelBuf = 0;
    unsigned char PauseCount = 0;                   //pause signature counter
    unsigned int RefreshCount_30Hz = 0;             //30Hz refresh counter
    unsigned int RefreshCount_10Hz = 0;             //10Hz refresh counter
    unsigned char InfraRedCount = 0;
    unsigned char AnimationNumCount = 0;            //Animation time count
    unsigned char AnimationNum = 0;                 //Animation Num

    WDTCTL = WDTPW | WDTHOLD;                       // stop watchdog timer
    Clock_Init();
    Io_Init();
    InkPaper_Init();
    Timer_Init();
    SDCard_init();
    f_mount(0, &fatfs);                             //load file system
    if(f_opendir(&dirss,path) == FR_OK)             //open content
    {
        PlayNum=0;
        while (f_readdir(&dirss, &finfo) == FR_OK)  //read file name oderly
        {
            if (finfo.fattrib & AM_ARC )
            {
                if( !finfo.fname[0] ) break;        //empty name->end of the file
                result3 = strstr(finfo.fname, ".WAV");	//whether a wav file
                if(result3!=NULL)
                {
                    memcpy(&FileName[PlayNum][0],&finfo.fname,sizeof(finfo.fname));
                    PlayNum++;
                }
            }
        }
        MusicNum = PlayNum;
        PlayNum = 0;
        DIS_IMG(PlayNum, Mode);
        DisplayFlag = false;
        TA0CCTL0 |= CCIE;   //Enable TimerA Interrupt
        while(1)
        {
            memcpy(&finfo.fname,&FileName[PlayNum][0],13);          //read file data
            f_open(&fil,finfo.fname,FA_OPEN_EXISTING|FA_READ);
            br = 1;
            FirstClustFlag = false;
            DisplayFlag = true;
            while(1)
            {
                if(DisplayFlag == true)         //refresh InkPaper
                {
                    DIS_IMG(PlayNum, Mode);
                    DisplayFlag = false;
                }
                f_read(&fil,buffer,(sizeof(buffer)),&br);
                if(br == 0) break;
                _EINT();
                while(count < BUFFER_SIZE)      //play one clust
                {
                    if(FirstClustFlag == false) //discard the first clust
                    {
                        FirstClustFlag = true;
                        break;
                    }
                    if(AudioFlag == true)           //timerA0 set
                    {
                        AudioFlag = false;
                        RefreshCount_30Hz++;
                        RefreshCount_10Hz++;
                        if((P6IN&BIT0) == BIT0) TempCount++;    //counting
                        if(KeyFlag.S1 == false)                 //not paused
                        {
                            MusicData = buffer[count]<<Buf;     //12bit dac playing 8bit file
                            count++;
                            DACValue(MusicData);
                        }
                    }
                    if(RefreshCount_30Hz >= REFRESH_30HZ)
                    {
                        RefreshCount_30Hz = 0;
                        LedPlay(MusicData, AnimationNum);
                        if(Mode == MANUAL_ULTRASONIC) P1OUT &= ~BIT3;   //UltraSonic OFF
                    }
                    if(RefreshCount_10Hz >= REFRESH_10HZ)
                    {
                        RefreshCount_10Hz = 0;
                        AnimationNumCount++;
                        if(AnimationNumCount >= ANIMATION_THRESHOLD)
                        {
                            AnimationNumCount = 0;
                            AnimationNum++;
                        }
                        if(Mode == AUTO)
                        {
                            if((P6IN&BIT5) == BIT5)     //audience detected
                            {
                                InfraRedCount = 0;
                                KeyFlag.S1 = false;     //clear pause flag
                            }
                            else if(InfraRedCount <= INFRARED_THRESHOLD)
                                InfraRedCount++;        //counting
                            else KeyFlag.S1 = true;     //pause
                        }
                        if(Mode == MANUAL_ULTRASONIC)
                        {
                            DistanceLevel = TempCount / DISTANCE_STEP;      //result
                            TempCount = 0;                                  //reset counter
                            if(PauseCount == PAUSE_THRESHOLD)
                                KeyFlag.S1 ^= true;
                            if(DistanceLevel == 0) PauseCount++;            //pause counting
                            else PauseCount = 0;
                            if(DistanceLevel == 0 && DistanceLevelBuf == 1)         //1->0
                            {
                                KeyFlag.S2 = true;      //next song
                                KeyFlag.S1 = false;     //clear pause flag
                            }
                            else if(DistanceLevel == 1 && DistanceLevelBuf == 0)    //0->1
                            {
                                KeyFlag.S3 = true;      //previous song
                                KeyFlag.S1 = false;     //clear pause flag
                            }
                            DistanceLevelBuf = DistanceLevel;
                            P1OUT |= BIT3;                          //UltraSonic ON
                        }
                    }
                }
                _DINT();
                count=0;
                if(KeyFlag.S3 == true)              //next
                {
                    KeyFlag.S3 = false;             //clear flag
                    break;
                }
                else if(KeyFlag.S2 == true)         //previous
                {
                    KeyFlag.S2 = false;             //clear flag
                    if(PlayNum>=1) PlayNum-=2;		//previous song
                    else PlayNum=MusicNum-2;		//avoid overflow
                    break;
                }
            }
            f_close(&fil);							//close current file
            PlayNum++;								//next song
            if(PlayNum>=MusicNum) PlayNum=0;		//avoid overflow
        }
    }
}

#pragma vector=PORT1_VECTOR
__interrupt void Port_1(void)
{
    _DINT();
    __delay_cycles(DELAY_BUTTON);
    if(P1IFG&BIT2)          //S1
    {
        if(P1IN&BIT2)       //button lifted
        {
            if(Mode == AUTO)
            {
                Mode = MANUAL_ULTRASONIC;
                DisplayFlag = true;
            }
            else if(Mode == MANUAL) KeyFlag.S1 ^= true;
        }
        P1IFG &= ~BIT2;
    }
    _EINT();
}

#pragma vector=PORT2_VECTOR
__interrupt void Port_2(void)
{
    _DINT();
    __delay_cycles(DELAY_BUTTON);
    if(P2IFG&BIT3)          //S3
    {
        if(P2IN&BIT3)
        {
            if(Mode == MANUAL)
            {
                KeyFlag.S1 = false;     //clear pause flag
                KeyFlag.S3 = true;
            }
        }
        P2IFG &= ~BIT3;
    }
    else                    //S4
    {
        if(P2IN&BIT6)
        {
            if(Mode == AUTO)
            {
                Mode = MANUAL;
                DisplayFlag = true;
            }
            else
            {
                Mode = AUTO;
                DisplayFlag = true;
                KeyFlag.S1 = false;
            }
        }
        P2IFG &= ~BIT6;
    }
    _EINT();
}

//audio playing interval
#pragma vector=TIMER0_A0_VECTOR
__interrupt void Timer_A0(void)
{
    AudioFlag = true;
}
