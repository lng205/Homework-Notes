/*
 * myheader.h
 *
 *  Created on: 2021Äê8ÔÂ17ÈÕ
 *      Author: yb
 */

#ifndef MYHEADER_H_
#define MYHEADER_H_

#include <stdbool.h>
#include <Dac7571\dac7571.h>
#include <dr_sdcard/integer.h>
#include <dr_sdcard/ff.h>
#include <string.h>
#include <dr_sdcard/HAL_SDCard.h>
#include "InkPaper/Paper_Display.h"

#define BUFFER_SIZE 2048
#define Buf 4                   //12bit dac playing 8bit audio
#define DELAY_BUTTON  335544    //20ms
#define FILE_NUM 6              //number of files
#define FILENAME_LENTH 13       //longest file name
#define PATH_LENTH 15           //longest file path
#define MUSIC_INTERVAL 380      //8*1024*1024/22050=380.43
#define REFRESH_30HZ 735        //22050/30=735
#define REFRESH_10HZ 2205       //22050/10=2205
#define DISTANCE_STEP 20
#define PAUSE_THRESHOLD 10      //1s
#define INFRARED_THRESHOLD 200  //20s
#define LED_BASEVALUE 2112
#define LED_STEP_16 16
#define LED_STEP_4 80
#define ANIMATION_THRESHOLD 50  //5s

//mode
#define AUTO 0
#define MANUAL 1
#define MANUAL_ULTRASONIC 2

typedef struct{
    bool S1;                   //S1 flag
    bool S2;                   //S2 flag
    bool S3;                   //S3 flag
    bool S4;                   //S4 flag
}StrKeyFlag;

void Timer_Init();
void Clock_Init();
void Io_Init();
void LedPlay(unsigned int value, unsigned char AnimationNum);
void LedColoumOn(unsigned int Num);
void LedFloorOn(unsigned char Num);

#endif /* MYHEADER_H_ */
