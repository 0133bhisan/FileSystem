;;; A simple program that adds two numbers, demonstrating a few of the addressing modes.

	.Code

;;; The entry point.
__start:

	;; Initialize the stack at the limit.
	COPY	%SP	*+limit	;was SP

	;; Copy one of the source values into a register.
	COPY	%G0	*+x
	
	;; Allocate a space on the stack for the result.
	SUBUS	%SP	%SP	4
	
	;; Sum the two values.  In particular:
	;;   src A (%G0): A value taken from a register.
	;;   src B (*+y): A indirect value stored in a static space named by a label.
	;;   dst   (%SP): A register that contains a pointer to a main memory space.
	ADD	*%SP	%G0	*+y

	COPY	%G2		5
	COPY	%G3		6
	COPY	%G1		4
	ADD		%G4		%G2		%G1
	SUBUS	%G5		%G3		%G1
	MUL		%G5		%G5		%G5
	COPY	%G2		5
	COPY	%G3		6
	COPY	%G1		4
	ADD		%G4		%G2		%G1
	SUBUS	%G5		%G3		%G1
	COPY	%G2		5
	COPY	%G3		6
	COPY	%G1		4
	ADD		%G4		%G2		%G1
	SUBUS	%G5		%G3		%G1
	
	;; Halt the processor.
	SYSC

	.Numeric
0x00
	;; The source values to be added.
x:	5
y:	-3

	;; Assume (at least) a 16 KB main memory.
	;; need to give programs 16kb after their limit
limit:	0x5000
