# first attempt at writing to block device 
# Whitespace compiler makes my job easier.

var 4 block_base        # buffer limit is (base + 4096)
var 4 block_limit       # limit is (base + 4096 + 8)  (4 for trigger, 4 for indexer)
var 4 block_indexer     # limit - 8
var 4 block_trigger     # limit - 4




procedure 0 init ()
	    	 [4 device_table_entry_ptr]
{

  # Find the console entry in the device table, based on its code (5).
  (= &device_table_entry_ptr 0x1000)
  while ((not (== *(4)device_table_entry_ptr 5))) {

    # Advance to the next entry.
    (= &device_table_entry_ptr (+ device_table_entry_ptr 12))

  }

  # Grab the base and then the limit.
  (= &block_base *(4)(+ device_table_entry_ptr 4))
  (= &block_limit *(4)(+ device_table_entry_ptr 8))
  (= &block_indexer (- block_limit 8))
  (= &block_trigger (- block_limit 4))

}


        # testing write abilities

procedure 0 write (4 strptr 4 block_number)        # strptr - address of first byte in string
	    	  [1 current_char
		   4 block_address]
{

    (= &block_address block_base)   # initialize block_address to start at buffer base
    (= block_indexer block_number)  # put block_number in buffer

  (= &current_char *(1)strptr)      #I think current_char is the first character

  while ((!= current_char 0)) {


    # Add the character to (block_base + offset)
    # increment offset by 4.
    (= block_address current_char)    # this must be where current_char changes to next value
    (= &block_address (+ block_address 1))

  }
  
  (= block_trigger 1)       # put 1 in trigger for write

}

# ===================================================================

# The entry point.  Make a string and print it!

string message "Just as long as you stand."

procedure 4 main ()
	    	 []
{
  (init)

  (write message)
  return 3              # 3 is supposedly lucky

}
