/*
 * DAC7571.c
 *
 *  Created on: 2014-7-15
 *      Author: dean
 */
#include "dac7571.h"
#include "IIC.h"
void DACValue(unsigned int Value)
{
	unsigned char i,j;

	j=Value;            //LSB[7:0]
	i=(Value>>8)&0x0f;  //MSB[11:8]

	/*start();
	senddata(0x08);
	waitack();*/
	start();
	senddata(0x98);
	waitack();
	senddata(i);
	waitack();
	senddata(j);
	waitack();
}


