# Number_System
A program does 5 different operations in total. 
The operations interpreting a string of hexadecimal digits as a two’s complement number, 
interpreting a string of hexadecimal digits as a sign/magnitude number, 
converting a location numeral to decimal positional notation, 
converting a decimal number to a location numeral, 
collecting counts of characters.


In this first part of the assignment my program makes sure that each operation is valid and has been given the correct number
of parameters. It performs the validations in the following order:

1. The first command-line argument must be a string of length one that consists of one of the following characters:

      2, S, L, D or A. If the argument is a letter, it must be given in uppercase. If the argument is not one
      of these strings, print the string found at label invalid operation error and exit the program (via
      system call #10). This string contains a newline character at the end, so you do not need to provide your own.

2. If the first command-line argument is 2, S,L or D then there must be exactly one other argument. If the total
number of command-line arguments is not two, print the string found at label invalid args error and
exit the program (via system call #10). 

3. If the first command-line argument is A, then there must be exactly four other arguments. If the total number
of command-line arguments is not five, it prints the string found at label invalid args error and exit the
program (via system call #10).

                         Interpret a String of Hexadecimal Digits as a Two’s Complement Number

The 2 operation treats the second command-line argument as a string of hexadecimal digit characters (‘0’ – ‘9’,‘A’ – ‘F’)
that represent a two’s-complement number. The leftmost character represents the most significant nibble (4 bits) 
of the integer. The operation converts the string into a 32-bit integer, storing in a single register. Using system 
call #1, the operation then prints the contents of the register in decimal, followed by a newline character (‘\n’).

                         Interpret a String of Hexadecimal Digits as a Sign/Magnitude Number
                          
The S operation treats the second command-line argument as a string of hexadecimal digit characters (‘0’ – ‘9’,
‘A’ – ‘F’) that represent a sign/magnitude number. The leftmost character represents the most significant nibble
(4 bits) of the integer and contains the sign bit. The operation converts the string into a 32-bit, two’s complement
integer, storing in a single register. Using system call #1, the operation then prints the contents of the register in
decimal, followed by a newline character (‘\n’).

                         Convert a Location Numeral to Decimal Positional Notation
                         
The D operation treats the second command-line argument as a location numeral, converts it to its equivalent
decimal form, and prints the decimal form to the screen, followed by a newline character (‘\n’). As explained at
the linked article, location numerals provide an alternative to binary positional notation (i.e., what we use today
instead). The lowercase Latin alphabet letters a, b, c, ..., z represent the numbers 2^0, 2^1, ...., 2^25, respectively.
When multiple letters are written together, the corresponding values are added together. For example, becgdb =
21 + 24 + 22 + 26 + 23 + 21 = 9610. Note that letters can be repeated and that they do not necessarily appear in
alphabetical order.

To accommodate location numerals with fewer than 8 letters we will allow the character ‘0’ to appear anywhere in the 
string. A ‘0’ does not contribute to the value of the numeral. A string consisting of all ‘0’ will represent the value 0.

                              Convert a Decimal Number to a Location Numeral

The L operation treats the second command-line argument as a decimal number (given as a string), converts the
argument string to an integer, and then converts/prints the integer to abbreviated, alphabetically sorted location
numerals using only lowercase letters in the output. The output string is followed by a newline character (‘\n’).
There must be no repeated characters in the output.

                                        Collect Counts of Characters

The A operation treats the second command-line argument as a general string of letters, digits and punctuation
marks. Depending on three additional command line arguments, it counts the number of uppercase letters and/or
lowercase letters and/or digits characters in the string. Note that each count can be at most 8, meaning that 4 bits
are sufficient to store each count. In light of this, the operation computes the three counts and stores them as three
nibbles in a register, with the count of digits in the rightmost (least significant) nibble, the count of lowercase
letters in the second least significant nibble, and the count of uppercase letters in the third least significant nibble.

An example will help to illustrate the idea. Suppose the input is "Ja#S!517". The counts of uppercase letters,
lowercase letters and digits are, respectively, 2, 1 and 3. In 4-bit binary (i.e., nibbles), these values are 00102,
00012 and 00112, respectively. Thus, the register containing these counts would have the contents

00000000000000000000001000010011

which is the output of the operation. System call #35 will allow you to print an integer in binary. Load the value
to be printed in $a0, load 35 into $v1 and then invoke syscall. After printing the binary string, followed it
with a newline character (‘\n’).

The operation always takes three additional arguments: the single characters ‘Y’ and ‘N’, in any combination.
The first instance of ‘Y’/‘N’ indicates whether or not we should include the count of uppercase letters in the
result; the second instance of ‘Y’/‘N’ indicates whether we should include the count of lowercase letters in the
result; and the third instance of ‘Y’/‘N’ indicates whether we should include the count of digits in the result.

As an example, suppose the following were given as the command-line arguments:

A Ja#S!517 N Y Y

This input indicates that we want to count only the lowercase letters and digits in the second argument. Therefore,
the output of the operation will be:

00000000000000000000000000010011

You may assume that the third, fourth and fifth arguments, if they are present, are always either ‘Y’ or ‘N’.
