changes to kernel


1. System Call function 
	- After calling Syscall, put the type of call, arg1, arg2, and arg3.
	
	SYSCALL table
		Type	Arg0	Arg1	Arg2	Arg3	Action
		Exit	0		Status	None	None	Delete from ram (and process table)	
		Setup	1		none	none	none	Gets base and limit for all progs after init. (puts 0x00 at end of array)
												Delete caller. Copies all programs to Ram. Can only be used by pid 1.
		Fork	2								Creates a copy of program. (the creation is the child)(implement later)
			

2. Interrupt table 9 will point towards sys call function 


3. Process table needs to know where their SP and FP are. 

4. pUp (process table update) 

5. pEnd (process table end)

6. Will make update all kernal functions to have pCall built in. (just like fdone is built in)
	- So can be called right after arguments
	- Will also make fArgs built in. All functions will be like (i.e. CALL +searchArgs %G0)

7. fDone should clean up SP based on results expected (should be SP + 4(results))

Figure out
	How much space to give each process's (stack to heap.)
		Let all programs hack a stack depth of 10 and capable of holding 30 variables
			- Add 720 to each prog's limit, and set their SP to that new limit 
			
	How to use Call function
		- Arg0 can be a label, but Arg1 can be: Label(no), Reg(no), indirectReg(yes)
		
		
		
To update currently interrupted program 
	- Check current pid when a prog is interrupted. 
	- Use pUp on the current pid 
To keep track of current pid
	- When a process interrupts, pUp uses current pid to update it.
	- next_PID then looks for the next pid bigger than current (loops to 2 if bigger not found)
		- it returns the PID and the address 
		- Once one is found, current_process becomes that, and run_current_process runs it.
		
When does it jump to next process?
	- Kernel jumps to init after setting up (current_PID becomes 1) 
	- Clock interrupts process and uses run_Next (run_Process(next_PID(current_PID)))
	
process_Update_Current (process_Update(current_PID))
	- Just use process_Update on current_PID



ALL FUNCTIONS
	1. functionArgs must start by decrementing SP by 4*(amount of results), then jumping to fArgs
			i.e. 	SUBUS 	%SP	%SP	8
					JUMP	fArgs 
	2. the function itself must start by decrementing SP once, and inputting results, then calling fCall
			i.e.	SUBUS	%SP	%SP	4
					COPY	*%SP	2
					COPY	%G0	+return2
					CALL	fCall	*%G0	
					
					
					
Next:
	After a process is updated, it must increment current_PID.
		- will have an process_table_Update function that increments current_PID.
	Run_Next_Process 
	
			