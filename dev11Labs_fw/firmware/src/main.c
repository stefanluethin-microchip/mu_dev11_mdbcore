/*******************************************************************************
  Main Source File

  Company:
    Microchip Technology Inc.

  File Name:
    main.c

  Summary:
    This file contains the "main" function for a project.

  Description:
    This file contains the "main" function for a project.  The
    "main" function calls the "SYS_Initialize" function to initialize the state
    machines of all modules in the system
 *******************************************************************************/

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stddef.h>                     // Defines NULL
#include <stdbool.h>                    // Defines true
#include <stdlib.h>                     // Defines EXIT_FAILURE
#include "definitions.h"                // SYS function prototypes


// *****************************************************************************
// *****************************************************************************
// Section: Main Entry Point
// *****************************************************************************
// *****************************************************************************
//-SL:
volatile uint32_t myCnt;
volatile uint32_t finalLedCnt;
#define cEchoCnt 10
#define PRESSED  0
#define RELEASED 1
volatile bool sysTickTmrExFlag;

char charArray[3] = {'b','c','d'};
volatile uint32_t char2prntIdx; //- index for 'charArray'
void testEnd(void);


void sysTickTimeout_handler(uintptr_t context)
{
	sysTickTmrExFlag=true;
}

int main ( void )
{
    /* Initialize all modules */
    SYS_Initialize ( NULL );
    printf("\n\r");
    printf("\n\r START CICDtesting ...");

     //-SL: inits
    myCnt=0; //-SL: central counter
    finalLedCnt=0;
    sysTickTmrExFlag=false; //-SL: SysTickWrap-event flag
     //-SL: SW0 defined as GPIO-In but still need to call this fct to enable In
    SW0_InputEnable();
    char2prntIdx=0; //- default char-to-print = 'b'

    SYSTICK_TimerStart();
    SYSTICK_TimerCallbackSet(&sysTickTimeout_handler, (uintptr_t) NULL);
    
    while ( true )
    {
        /* Maintain state machines of all polled MPLAB Harmony modules. */
        if(sysTickTmrExFlag)
        {
            sysTickTmrExFlag=false;
            LED0_Toggle();
            finalLedCnt++;
        
            myCnt++;
            if(cEchoCnt/2>=myCnt)
            {
                printf("a");
            } else if ((cEchoCnt/2<myCnt) & (cEchoCnt>=myCnt))
            {
                //printf("b");
                printf("%c",charArray[char2prntIdx]);
                if (cEchoCnt==myCnt)
                    myCnt=0;
            } else
                printf("ERROR1");
        }
        
        if(SW0_Get() == PRESSED)
        {
            testEnd();
        }
    }

    /* Execution should not come here during normal operation */

    return ( EXIT_FAILURE );
}

void testEnd(void)
{
    printf("\n\r testEnd with finalLedCnt=%d\n\r ",(int)finalLedCnt);
    printf("\n\r");
    while(1){}
}
