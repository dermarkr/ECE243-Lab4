/* Program that counts consecutive 1's */

			.text                   // executable code follows
			.global _start                  
_start:                             
			MOV     R4, #TEST_NUM   // load the data word ...
			MOV		R3, #0			//sets r3 to 0
NEXT:		LDR     R1, [R4]        // into R1
			CMP     R1, #0			//check if word is 0
			BEQ     END
			ADD     R4, #4			//moves pointer to next word
			BL		ONES			//runs ones
			CMP		R3, R0			//checks if last word had greatest number of ones
			BGE		NEXT			//if not goes to next
			MOV		R3, R0			//if yes stores it in r3
			B		NEXT	  		//goes to next word

ONES:	   	MOV     R0, #0          // R0 will hold the result
LOOP:		CMP     R1, #0          // loop until the data contains no more 1's
			MOVEQ   PC, LR            
			LSR     R2, R1, #1      // perform SHIFT, followed by AND
			AND     R1, R1, R2      
			ADD     R0, #1          // count the string length so far
			B       LOOP            

END:      	B       END             

TEST_NUM: .word   0x103fe00f  
		  .word   0x103fe06f  
		  .word   0x103fe02f  
		  .word   0x103fe06d  
		  .word   0x103fb3ce  
		  .word   0x103f7a2f  
		  .word   0x102b5c34  
		  .word   0x0000ffff  
		  .word   0x10444444  
		  .word   0x10512341  
		  .word   0x103f3542  
		  .word   0x1023554f
		  .word   0x00000000

          .end                            
