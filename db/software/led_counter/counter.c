/*
 * counter.c
 *
 *  Created on: 2 oct. 2024
 *      Author: antonin.kenzi
*/

#include "io.h"
#include "system.h"
#include "sys/alt_irq.h"
#include "sys/alt_sys_init.h"
#include <altera_avalon_timer_regs.h>
#include <sys/alt_irq.h>
#include <stdio.h>

void int_timer_interrupt(void);
static void time_isr(void * context, alt_u32 id);

int main()
{
	printf("Lets start counting\n");
	IOWR_8DIRECT(LEDS_BASE,0,0);
	int_timer_interrupt();
	while(1);
	return 0;
}


void int_timer_interrupt(void)
{
	//register isr HAL
	alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID,TIMER_0_IRQ, (void *)time_isr,NULL,0x0);
	//Start timer
	IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_0_BASE ,ALTERA_AVALON_TIMER_CONTROL_CONT_MSK
											|ALTERA_AVALON_TIMER_CONTROL_START_MSK
											|ALTERA_AVALON_TIMER_CONTROL_ITO_MSK);
}


static void time_isr(void * context, alt_u32 id)
{
	static int counter=0;
	// clear interupt
	IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE,0);
	counter++;
	printf("counter 1s =%d\n",counter);
	IOWR_8DIRECT(LEDS_BASE,0,counter);
}
