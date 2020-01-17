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
			BEQ     DISPLAY
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


/* Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
 *    Parameters: R0 = the decimal value of the digit to be displayed
 *    Returns: R0 = bit patterm to be written to the HEX display
 */

SEG7_CODE:  MOV     R1, #BIT_CODES  
            ADD     R1, R0         // index into the BIT_CODES "array"
            LDRB    R0, [R1]       // load the bit pattern (to be returned)
            MOV     PC, LR              

BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2      // pad with 2 bytes to maintain word alignment


/* Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4 */
DISPLAY:    LDR     R8, =0xFF200020 // base address of HEX3-HEX0
            MOV     R0, R5          // display R5 on HEX1-0
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            MOV     R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R0, #8
            ORR     R4, R0
			
            MOV     R0, R6             
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
			MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            LSL     R0, #16
            ORR     R4, R0
            MOV     R0, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R0, #24
            ORR     R4, R0

            STR     R4, [R8]        // display the numbers from R6 and R5
            LDR     R8, =0xFF200030 // base address of HEX5-HEX4
            MOV     R0, R7          // display R5 on HEX1-0
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1

            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            MOV     R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R0, #8
            ORR     R4, R0

            STR     R4, [R8]        // display the number from R7
			B 		END

DIVIDE:   	MOV    	R2, #0			// Setting the quotients to zero
DTEN:       CMP    	R0, #10			// Checking if the value is greater than the Divisor to the Second power
            BLT    	DIV_END			// Moving to the next function if Divisor is greater than the remaining value
            SUB    	R0, #10			// Subtracting the divisor from the remaining value
            ADD    	R2, #1			// incrementing Tens value for each time through the full function
            B      	DTEN			// going back to beginning of function
DIV_END:    MOV    	R1, R2       	// quotient in R1 (remainder in R0)
            MOV    	PC, LR

END:      	B       END    
          .end