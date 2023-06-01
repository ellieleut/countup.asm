;
;Ellie Leutenegger ECE109 001 03/23/2023
;This program takes a user input and prints the number of stars correlated to a number input.
;However, if the input is q, the program says goodbye. Invalid inputs are not echoed.
;
			
	.ORIG 0x3000
	
		;Clear registers
START		AND R0, R0, #0	
			AND R1, R1, #0
			AND R2, R2, #0
			AND R3, R3, #0
			AND R4, R4, #0
			AND R5, R5, #0
			AND R6, R6, #0
			AND R7, R7, #0
			
		;Prompt user for a value
			LEA R0, PROMPT1		;Load R0 with start prompt
			PUTS				;Print prompt to console
GETINPUT1	GETC				;Waits for user to enter a value
			OUT					
			ADD R3, R0, #0		;Moves input into R3
	
		;Check if input is q	
			LD R1, q			;Load the ASCII value for the letter q
    		NOT R1, R1		  	;Negate
    		ADD R1, R1, #1		;Add 1
    		ADD R1, R1, R3		;Add the negated number to input
  			BRz QUIT	      	;Branch to DONE if the result is zero
    	;Check if input is valid, if not do not echo
    		LD R1, NEG0
    		ADD R2, R1, R3
    		BRn GETINPUT1
    		LD R1, NEG9
    		ADD R2, R1, R3
    		BRp GETINPUT1
    		
		;Obtain second input	
GETINPUT2	GETC				;Wait for second input
			OUT
			ADD R4, R0, #0		;Move input into R4
			
		;Check if input is LF	
			LD R5, LF			;Load the ASCII value for linefeed
    		NOT R5, R5		  	
    		ADD R5, R5, #1
    		ADD R5, R5, R4  	
    		BRz STARS			;Branch to STARS if result is zero, input is complete
    	;Check if q again	
    		LD R5, q			;Load the ASCII value for the letter q
    		NOT R5, R5		  	
    		ADD R5, R5, #1
    		ADD R5, R5, R4  	
  			BRz QUIT	      	;Branch to QUIT if the result is zero
  		;Check if input is valid, if not do not echo
    		LD R1, NEG0
    		ADD R2, R1, R4
    		BRn GETINPUT2
    		LD R1, NEG9
    		ADD R2, R1, R4
    		BRp GETINPUT2
  		;Check if first input is 0-4	
    		AND R5, R5, #0		;Clear R5
    		LD R5, FIVE			;Load the ASCII value for the number 5
    		NOT R5, R5
    		ADD R5, R5, #1		
    		ADD R5, R5, R3		
    		BRzp invalid		;If zero or positive, input is outside 0-4 range
  			
		;Multiply first input by ten and add it to second input
			ADD R3, R3, #-16	;Change inputs into binary by subtracting a total of 48
			ADD R3, R3, #-16
			ADD R3, R3, #-16
			ADD R4, R4, #-16
			ADD R4, R4, #-16
			ADD R4, R4, #-16
			
			AND R6, R6, #0
MULTIPLY	ADD R6, R6, #10		;Load R6 with decimal 10 (multiplicand)
			ADD R3, R3, #-1		;Decrement the multiplier
			BRp MULTIPLY		;Moves when multiplier is consumed
			
			ADD R6, R6, R4		;Adds two inputs together
			
		;Print out stars correlated to two-digit input			
			LEA R0, PROMPT4		;Load I see stars prompt
			PUTS				;Print
			NOT R6, R6			;Negate input
			ADD R6, R6, #1		
			LD R5, ONE			;Load 1 in R5 to start counter
			BR LOOP				;Branch to looping stars

LOOP		LEA R0, PROMPTS		;Load *
			PUTS				;Print
			ADD R5, R5, #1
			ADD R2, R6, R5
			BRnz LOOP			;Keep printing *s
			
			BR FINI				;Keep branch to finish otherwise
			
FINI		LEA R0, PROMPT5		;Load done message
			PUTS				;Print
			BR START			;Go back to start
		
		;Print out stars correlated to one-digit input			
STARS		ADD R4, R3, #0		;Put the one digit into R4
			ADD R4, R4, #-16	;Convert to binary 
			ADD R4, R4, #-16
			ADD R4, R4, #-16
			
			LD R6, ZEROO		;Load R2 with zero value
			ADD R2, R2, R6
			BRz DONE			;If R2=R4, print no stars and all done
			
			LEA R0, PROMPT4		;Load I see stars prompt
			PUTS				;Print
			NOT R4, R4	
			ADD R4, R4, #1
			LD R5, ONE			;Load R5 with 1
			
LOOPS		LEA R0, PROMPTS		;Load *
			PUTS				;Print
			ADD R5, R5, #1
			ADD R2, R4, R5
			BRnz LOOPS			;Keep looping till stars are printed
			
			BR FINI				;Keep branch to finish otherwise
		
		;These are just the branch prompts I wanted at the end altogether	
invalid		LEA R0, PROMPT3
			PUTS
			BRnzp START
				
QUIT		LEA R0, PROMPT2		;Load R0 with address of string start
			PUTS		
			HALT

DONE		LEA R0, PROMPT5
			PUTS
			BR START
						
PROMPT1	.STRINGZ	"\n\nEnter a number (0-49): "
PROMPT2	.STRINGZ	"\n\nGoodbye!!!\n\n"
PROMPT3 .STRINGZ	"\nInvalid input, try again!"
PROMPT4	.STRINGZ	"\n\nI see stars!\n"
PROMPT5	.STRINGZ	"\n\nAll Done"
PROMPTS	.STRINGZ	"*"
q		.FILL		x71
NEG0	.FILL		#-48
NEG9	.FILL		#-57
ZERO	.FILL		x30
NEG		.FILL		x2d
LF		.FILL		x0a
FIVE	.FILL		x35
ONE		.FILL		x01
ZEROO	.FILL		x00

.END