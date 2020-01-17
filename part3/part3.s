/* Program that counts consecutive 1's */

			.text                   // executable code follows
			.global _start                  
_start:                             
			MOV     R4, #TEST_NUM   // load the data word ...
			MOV		R10, #MaskOne
			MOV		R11, #MaskTwo
			LDR		R10, [R10]
			LDR 	R11, [R11]
			MOV		R5, #0			//sets r3 to 0
			SUBS    R4, #4
			MOV 	R6, #0
			MOV		R7, #0
			
NEXT:		ADD     R4, #4			//moves pointer to next word
			LDR     R1, [R4]        // into R1
			CMP     R1, #0			//check if word is 0
			BEQ     END
			BL		ONES			//runs ones
			CMP		R5, R0			//checks if last word had greatest number of ones
			BGE		NZEROS			//if not goes to next
			MOV		R5, R0			//if yes stores it in r3
NZEROS:		LDR		R1, [R4]
			BL		ZEROS
			CMP		R6, R0			//checks if last word had greatest number of ones
			BGE		Alternative			//if not goes to next
			MOV		R6, R0			//if yes stores it in r3
			B		Alternative	  		//goes to next word		
Alternative:LDR     R1, [R4]
			EOR		R9, R1, R10
			EOR		R8, R1, R11
			CMP		R9, R8
			MOVGE   R1, R8
			CMP		R8, R9
			MOVGE	R1, R9
			BL		ONES
			CMP		R7, R0			//checks if last word had greatest number of ones
			BGE		NEXT			//if not goes to next
			MOV		R7, R0			//if yes stores it in r3
			B		NEXT	  		//goes to next word	

ONES:	   	MOV     R0, #0          // R0 will hold the result
LOOPO:		CMP     R1, #0          // loop until the data contains no more 1's
			MOVEQ   PC, LR            
			LSR     R2, R1, #1      // perform SHIFT, followed by AND
			AND     R1, R1, R2      
			ADD     R0, #1          // count the string length so far
			B       LOOPO  

ZEROS:		MOV     R0, #0          // R0 will hold the result
			NEG		R1, R1
			SUBS	R1, #1
LOOPZ:		CMP     R1, #0          // loop until the data contains no more 1's
			MOVEQ   PC, LR            
			LSR     R2, R1, #1      // perform SHIFT, followed by AND
			AND     R1, R1, R2      
			ADD     R0, #1          // count the string length so far
			B       LOOPZ	

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
		  .word   0x10000000 
		  .word   0x103f3542  
		  .word   0x1023554f
		  .word   0xaaaaaa00
		  .word   0x00000000
MaskOne:  .word   0xaaaaaaaa
MaskTwo:  .word   0x55555555

          .end                            
