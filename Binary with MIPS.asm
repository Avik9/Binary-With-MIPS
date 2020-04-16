# @author Avik Kadakia
# @NetID: akadakia
# @Email: avik.kadakia@stonybrook.edu

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Put your additional .data declarations here
minus: .asciiz "-"
plus: .asciiz "+"
dec: .word 0
hex_value: .word 0

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beq $a0, 0, zero_args # if $a0 has 0 arguments, go to zero_args
    beq $a0, 1, one_arg
    beq $a0, 2, two_args
    beq $a0, 3, three_args
    beq $a0, 4, four_args
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory
    
start_coding_here:
    # Start the assignment by writing your code here
	
##################################### PART I #######################################
	#
	#	$t0 - Holds the argument												#
	#	$t1 - Holds individual characters from the arguments					#
	#	$t2 - Holds the value that $t1 is compared to							#
	#	$t3 - Number of arguments												#
	#	$t4 - Contains the value $t3 is compared to								#
	#
####################################################################################	
	
	# $t1 = Second character in the command line
	
	lw $t0, addr_arg0
	lbu $t1, 1($t0) # Loads the character at the second location of the first argument
	bne $t1, $0, print_invalid_operation # Prints invalid argument if it is not empty
	
	# $t3 = number of arguments, $t0 = 2
	# if there are less than 2 arguments total, it prints invalid args 
	
	lw $t3, num_args # adds the number of arguments in $t3
	li $t4, 3 # Adds 3 to $t4
    beq $t3, $t4, print_invalid_args 

	li $t4, 4 # Adds 4 to $t4
    beq $t3, $t4, print_invalid_args
	
	li $t4, 5 # Adds 5 to $t4
    bgt $t3, $t4, print_invalid_args

	#$t1 = first character in the command line
	
	lw $t0, addr_arg0 # Adds first argument to $t0
	lbu $t1, 0($t0)
	
	li $t2, '2' # $t2 = 2
    beq $t1, $t2, two_and_hex_loop 
    
    li $t2, 'S' # $t2 = S
	beq $t1, $t2, two_and_hex_loop
	
	li $t2, 'L' # $t2 = L
	beq $t1, $t2, decimal_number
	
	li $t2, 'D' # $t2 = D
	beq $t1, $t2, Napier_location_numeral
	
	lw $t3, num_args # adds the number of arguments in $t1
	li $t4, 2 # Adds 2 to $t4
    beq $t3, $t4, print_invalid_operation
	
	# $t0 = Holds the argument 
	# $t3 = number of arguments
	# $t4 = 5
	
	lw $t3, num_args # adds the number of arguments in $t3
	li $t4, 5 # $t4 = 5
    bne $t3, $t4, print_invalid_args # if there aren't 5 arguments total, it prints invalid args
	
	# Adds the first character from the command line to $t0
	
	lw $t0, addr_arg0 
	lbu $t1, 0($t0)
	
	li $t2, 'A' #$t1 = A
	beq $t1, $t2, count_of_chars

	# Prints INVALID_OPERATION

print_invalid_operation:

	la $a0, invalid_operation_error
    li $v0, 4
    syscall
    j exit

	# Prints INVALID_ARGS
	
print_invalid_args:
	
	la $a0, invalid_args_error
    li $v0, 4
    syscall
    j exit

##################################### PART II ######################################
	#																			#
	#	$t0 - Holds the argument												#
	#	$t1 - Holds individual characters from the arguments					#
	#	$t2 - Holds the value that $t1 is compared to							#
	#	$t3 - Holds the final Answer											#
	#																			#
####################################################################################
  
    # Loop to check if all the characters in Hex and Two's complement are 
    # between '0' - '9' or 'A' - 'F'

two_and_hex_loop:
	
	lw $t0, addr_arg1 # Adds first argument to $t0
	lbu $t1, 0($t0)
	
two_and_hex_number_loop:
	li $t2, '0' # $t2 = '0'
	blt $t1, $t2 print_invalid_args # if $t0 is less than 0, it jumps to print_invalid_args
	
	# If the current character is less than 9, it goes on to the next 
	# character. If it is more than 9, it goes on to check if it is a letter
	
	li $t2, 58 # $t2 = '9' + 1
	blt $t1, $t2, next_char
	bgt $t1, $t2, two_and_hex_letter_loop
	
two_and_hex_letter_loop:

	# Checks if the letter is less than 'A'. If it is, it prints invalid_args
	# The, it checks if the letter is greater than 'F' and does the same if 
	# it is. Else, it continues to the next character.
	
	li $t2, 'A' 
	blt $t1, $t2, print_invalid_args
	
	li $t2, 'F'
	bgt $t1, $t2, print_invalid_args
	
next_char:
	addi $t0, $t0, 1 # Adds one to the address of the first byte which moves it to the next byte
	lbu $t1, 0($t0) # Loads the first byte after the address has been moved
	
	beq $t1, $0, calculate # If the input has reached a null character, it calculates the answer
	j two_and_hex_number_loop # Jumps to the beginning of the loop
	
calculate:
	
	lw $t0, addr_arg1 # Adds first argument to $t0
	lbu $t1, 0($t0)
	li $t3, 0 # Loading 0 to t3

hex_loop:

	sll $t3, $t3, 4 # Shifting t3 to the left / Multiplying it by 2
	
	li $t2, '0' # Loading 0 to t2
	beq $t1, $t2, hex_next_var # If not equal, go to hex_next_var

	li $t2, 58 # $t2 = ':' = 9 + 1 in ASCHII 
	blt $t1, $t2, a_num # If not equal, go to a_num

	li $t2, 'G' # $t2 = 'G' = 'F' + 1 in ASCHII
	blt $t1, $t2, a_alpha # If not equal, go to a_alpha

	j print_invalid_args
	
a_num:

	addi $t1, $t1, -48 # Made the string an integer
	or $t3, $t3, $t1 # Adding the string to the final answer
	j hex_next_var

a_alpha:

	addi $t1, $t1, -55 # Made the string an alphabet
	or $t3, $t3, $t1 # Adding the string to the final answer
	j hex_next_var

hex_next_var:

	addi $t0, $t0, 1 # Moving one space
	lbu $t1, 0($t0) # Holds the individual character from $t0
	
	bne $t1, $0, hex_loop # If not equal, go to hex_loop

	lw $t0, addr_arg0 # Add argument 0 to t0
	lbu $t1, 0($t0)
	
	sw $t3, hex_value # Store t3 to hex_value
	
	li $t2, '2' # $t1 = 2
    beq $t1, $t2, Part_II_Done # If equal, be done

	li $t2, 'S' # $t1 = S
	beq $t1, $t2, hexadecimal # If equal, calculate hexadecimal
	
	j print_invalid_operation
	
Part_II_Done:

	move $a0, $t3 # Move final amswer to a0 to print
	li $v0, 1 # Print as an integer
	syscall
	j exit

##################################### PART III ######################################
	#																			#
	#	$t0 - Holds the argument												#
	#	$t1 - Holds individual characters from the arguments					#
	#	$t2 - Holds the value that $t1 is compared to							#
	#	$t3 - Holds the final answer from hex									#
	#	$t4 - Holds the first character from $t3								#
	#	$t5 - Checks Sign														#
	#																			#
####################################################################################
hexadecimal:
	
	# Checks if the first bit is 1, only way it is one is if 
	# the first character in the input is 8 or higher.

	lw $t3, addr_arg1 # Add the first argument to t3
	lbu $t4, 0($t3)
	li $t5, '8' # Add 8 to t5
	bgeu $t4, $t5, print_minus 
	
	# If it reaches here that means the value is positive
	lw $t3, hex_value
	move $a0, $t3 # Moving the answer to print
	beqz $a0, print_plus
	j Part_III_Done
	
print_plus:

	# Prints the + sign and the answer

	la $a0, plus
	li $v0, 4
    syscall 
	move $a0, $t3
	j Part_III_Done
	
print_minus: 

	# Prints the - sign and the answer

	lw $t3, hex_value
	
	sll $t3,$t3,1 # Moves all the bits to the left to remove the leftmost bit
	srl $t3,$t3,1 # Moves all the bits to the right to get a 0 at the leftmost bit

	la $a0, minus
	li $v0, 4
    syscall 
	move $a0, $t3
	
Part_III_Done:

	li $v0, 1
	syscall
	j exit

##################################### PART IV ######################################
	#	This part convers the String to an integer								#
	#																			#
	#	$t0 - Holds the argument												#
	#	$t1 - Holds individual characters from the arguments					#
	#	$t2 - Holds the value that $t1 is compared to							#
	#	$t3 - Register's current value											#
	#	$t4 - Char's int value after subtracting ASCHII							#
	#	$t5 - Holds 10000000													#
	#	$t6 - Holds 10															#
	#	$t7 - $t4 * $t5															#
	#	$t8 - Final Answer														#
	#																			#
####################################################################################
decimal_number:

	lw $t0, addr_arg1 # Adds first argument to $t0
	lbu $t1, 0($t0)
	
	li $t3, 7 # Holds the highest power of 10
	li $t4, 0 # Integer value of the input char
	li $t5, 10000000 # 2^7th power
	li $t6, 10 # Divide by 10 everytime you move right
	li $t7, 0 # $t4 * $t5
	li $t8, 0 # Final Answer

Decimal_loop:

	li $t2, '0' # If the current character is 0, get next character
	beq $t1, $t2, Decimal_next_var

	li $t2, '0' # Checks for any characters below 0
	blt $t1, $t2, print_invalid_args 
	
	li $t2, '9' # Checks for any characters above 9
	bgt $t1, $t2, print_invalid_args

	addi $t4, $t1, -48 # Converts the String to its integer value

	mul $t7, $t4, $t5 # Multiples the char's integer value to power of 10
	add $t8, $t8, $t7 # Adds to the final answer

Decimal_next_var:

	div $t5, $t6 # Divides 2^(some power) by 10 till it reaches 1
	mflo $t5 # Quotient from the division
	addi $t0, $t0, 1 
	lbu $t1, 0($t0)

	bne $t1, $0, Decimal_loop

############################### PART IV - Continued #############################
	#	This part converts the onteger to derive the final answer				#
	#																			#
	#	$t0 - Holds the input as an integer										#
	#	$t1 - Holds individual characters from the arguments					#
	#	$t2 - Holds the value that $t1 is compared to							#
	#	$t3 - Holds 'a'															#
	#																			#
####################################################################################

	move $t0, $t8 # Saving the integer to t0
	
	li $t3, 'a' #

	# Making all the other values 0 so they would not interrupt with the calculations

	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0

Binary_loop:

	andi $t1, $t0, 1 # If the current character is a 1, it saves a 1, otherwise, it saves a 0

	li $t2, 0 # t2 = 0
	beq $t1, $t2, Binary_next_var # If current value equals 0, get next value

	move $a0, $t3 # Get ready to print
	li $v0, 11
	syscall

Binary_next_var:

	srl $t0, $t0, 1 # Get the next bit in the binary of the current integer
	addi $t3, $t3, 1 # Add 1 to the current alphabet

	bnez $t0, Binary_loop

Part_IV_Done:

	j exit

##################################### PART V ######################################
	#																			#
	#	$t0 - Holds the argument												#
	#	$t1 - Holds individual characters from the arguments					#
	#	$t2 - Holds the value that $t1 is compared to							#
	#	$t3 - Holds the power of 2												#
	#	$t4 - Holds 2															#
	#	$t5 - The shifted value is stored here									#
	#	$t6 - Final Answer														#
	#																			#
####################################################################################

Napier_location_numeral:

	lw $t0, addr_arg1 # Adds first argument to $t0
	lbu $t1, 0($t0)
	li $t3, 0
	li $t6, 0

Napier_loop:
	li $t2, '0'
	beq $t1, $t2, Napier_next_var

	li $t2, 'a'
	blt $t1, $t2, print_invalid_args 
	
	li $t2, 'z'
	bgt $t1, $t2, print_invalid_args

	addi $t3, $t1, -97 # Subtract 97, value of 'a'
	li $t4, 1 # Going toi get doubled everytime we move left

	sllv $t5, $t4, $t3 # The number gets doubled based on the number on t3

	add $t6, $t6, $t5 # Add them to the final answer
	
Napier_next_var:

	addi $t0, $t0, 1
	lbu $t1, 0($t0) # Holds the individual character from $t0
	
	bne $t1, $0, Napier_loop

Part_V_Done:
	move $a0, $t6
	li $v0, 1
	syscall  
	j exit

##################################### PART VI ######################################
	#																			#
	#	$t0 - Holds the argument												#
	#	$t1 - Holds individual characters from the arguments					#
	#	$t2 - Holds the value that $t1 is compared to							#
	#	$t3 - Counter for number of Capital letter								#
	#	$t4 - Counter for number of lowercase letter							#
	#	$t5 - Counter for number of digits										#
	#	$t6 - Final Answer														#
	#																			#
####################################################################################
count_of_chars:

	lw $t0, addr_arg1 # Adds first argument to $t0
	lbu $t1, 0($t0) # Holds the individual character from $t0
	
	li $t3, 0 # Counter for the number of upper case digits
	li $t4, 0 # Counter for the number of lower case digits
	li $t5, 0 # Counter for the number of digit digits

count_chars_loop: 

	li $t2, '0' # $t1 = '0'
	blt $t1, $t2, char_next_variable
 # If the current character is less than '0', it goes to the next character

	li $t2, '9' # $t1 = '9'
	blt $t1, $t2 add_digit # if $t2 is less than 9, it jumps to add_digit
	
	li $t2, 'A' # $t1 = 'A'
	blt $t1, $t2, char_next_variable
 # If the current character is less than 'A', it goes to the next character

	li $t2, 'Z' # $t1 = 'Z'
	blt $t1, $t2 add_upper_case # if $t2 is less than Z, it jumps to add_digit

	li $t2, 'a' # $t1 = 'a'
	blt $t1, $t2, char_next_variable
 # If the current character is less than 'a', it goes to the next character

	li $t2, 'z' # $t1 = 'z'
	blt $t1, $t2 add_lower_case # if $t2 is less than z, it jumps to add_digit

add_upper_case:

	addi $t3, $t3, 1
	j char_next_variable

add_lower_case:

	addi $t4, $t4, 1
	j char_next_variable

add_digit:

	addi $t5, $t5, 1
	j char_next_variable

char_next_variable:

	addi $t0, $t0, 1
	lbu $t1, 0($t0) # Holds the individual character from $t0
	
	bne $t1, $0, count_chars_loop

argument_U: # U: Upper Case

	lw $t0, addr_arg2 
	lbu $t1, 0($t0)
	
	li $t2, 'Y' # $t2 = Y
    beq $t1, $t2, argument_l
    
    li $t2, 'N' # $t2 = N
    bne $t1, $t2, print_invalid_args

	li $t3, 0 # Counter for the number of uppercase digits
     
argument_l: # l: Lower Case

	lw $t0, addr_arg3 
	lbu $t1, 0($t0)
	
	li $t2, 'Y' # $t2 = Y
    beq $t1, $t2, argument_d
    
    li $t2, 'N' # $t2 = N
    bne $t1, $t2, print_invalid_args

	li $t4, 0 # Counter for the number of lowercase digits

argument_d: # d: Digit 

	lw $t0, addr_arg4
	lbu $t1, 0($t0)
	
	li $t2, 'Y' # $t2 = Y
    beq $t1, $t2, Part_VI_Done 
    
    li $t2, 'N' # $t2 = N
    bne $t1, $t2, print_invalid_args
    
    li $t5, 0 # Counter for the number of digits 
   
Part_VI_Done:

	move $t6, $t3 # Saving the value of t3 to t6
	sll $t6, $t6, 4 # Move 4 bits to the left

	or $t6, $t6, $t4 # Saving the value of t4 to t6
	sll $t6, $t6, 4 # Move 4 bits to the left

	or $t6, $t6, $t5 # Saving the value of t5 to t6
	
	move $a0, $t6
	li $v0, 35
	syscall  
	j exit
     
exit:
    li $a0, '\n'
    li $v0, 11
    syscall
    li $v0, 10
    syscall
