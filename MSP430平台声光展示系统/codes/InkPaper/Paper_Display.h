/*
 * Paper_Display.h
 *
 *  Created on: 2021Äê8ÔÂ24ÈÕ
 *      Author: yb
 */

#ifndef PAPER_DISPLAY_H_
#define PAPER_DISPLAY_H_
#include <msp430.h>

void InkPaper_Init(void);
void DIS_IMG(unsigned char Page, unsigned char Mode);

//mode
#define AUTO 0
#define MANUAL 1
#define MANUAL_ULTRASONIC 2

#endif /* PAPER_DISPLAY_H_ */
