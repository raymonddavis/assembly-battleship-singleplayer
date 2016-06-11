.data

start_message:	.asciiz	"\nStart showing a One-Player Battleship Game."
cruiser: 	.asciiz	"\nEnter the cruiser 3x[0-9a-z]: "
destroyer: 	.asciiz	"\nEnter the destroyer 2x[0-9a-z]: "
submarine:	.asciiz	"\nEnter the submarine: "
shot:		.asciiz	"\nEnter the next shot [0-9a-z]: "
duplicate_shot:	.asciiz	"\n***** A duplicate shot! *****"
invalid_shot:	.asciiz	"\n***** An invalid shot!  *****"
next_game:	.asciiz "\nNew game? (y/n) "

board:   .ascii   "\n\n    . . . . . .     . . . . . .      0 1 2 3 4 5"
         .ascii     "\n    . . . . . .     . . . . . .      6 7 8 9 a b"
         .ascii     "\n    . . . . . .     . . . . . .      c d e f g h"
         .ascii     "\n    . . . . . .     . . . . . .      i j k l m n"
         .ascii     "\n    . . . . . .     . . . . . .      o p q r s t"
         .asciiz    "\n    . . . . . .     . . . . . .      u v w x y z\n"
         
reset:   .ascii   "\n\n    . . . . . .     . . . . . .      0 1 2 3 4 5"
         .ascii     "\n    . . . . . .     . . . . . .      6 7 8 9 a b"
         .ascii     "\n    . . . . . .     . . . . . .      c d e f g h"
         .ascii     "\n    . . . . . .     . . . . . .      i j k l m n"
         .ascii     "\n    . . . . . .     . . . . . .      o p q r s t"
         .asciiz    "\n    . . . . . .     . . . . . .      u v w x y z\n"
	
offset1: .half     6,   8,  10,  12,  14,  16  
         .half    55,  57,  59,  61,  63,  65
         .half   104, 106, 108, 110, 112, 114
         .half   153, 155, 157, 159, 161, 163
         .half   202, 204, 206, 208, 210, 212
         .half   251, 253, 255, 257, 259, 261
	 
offset2: .half    22,  24,  26,  28,  30,  32  
         .half    71,  73,  75,  77,  79,  81
         .half   120, 122, 124, 126, 128, 130
         .half   169, 171, 173, 175, 177, 179
         .half   218, 220, 222, 224, 226, 228
         .half   267, 269, 271, 273, 275, 277
         
buf:	.space	200

.text 
.globl main

main:					# program starts here
	la	$a0, start_message	# load start_message message
	li	$v0, 4			# print string
	syscall				# print
	la	$a0, board		# load board
	li	$v0, 4 			# print string
	syscall				# print
	la	$a0, cruiser		# load cruiser message
	li	$v0, 4 			# print string
	syscall				# print
	la	$a0, buf		# load buf
	li	$a1, 4			# 4 bytes
	li	$v0, 8			# read string
	syscall				# read
	lb	$a0, buf		# first cruiser placement 
	jal 	convert			# call convert
	move	$a2, $a0		# move $a0 into $a2
	lb	$a0, buf+1		# scond cruiser palcement
	jal 	convert			# call convert
	move	$a1, $a0		# move $a0 into $a1
	lb	$a0, buf+2		# third cruiser placement	
	jal 	convert			# call convert
	move	$t0, $a0		# move $a0 into $t0
	jal 	plot_ship		# call plot_ship
	move	$t0, $a1		# move $a1 into $t0
	jal 	plot_ship		# call plot_ship
	move	$t0, $a2		# move $a2 into $t0
	jal	plot_ship		# call plot_ship
	la	$a0, board		# load board
	li	$v0, 4 			# print string		
	syscall				# print
	la	$a0, destroyer		# load destroyer message
	li	$v0, 4 			# print string
	syscall				# print
	la	$a0, buf		# load buf
	li	$a1, 3			# 3 bytes
	li	$v0, 8			# read string
	syscall				# read
	lb	$a0, buf		# first destroyer placement 
	jal 	convert			# call convert
	move	$a1, $a0		# move $a0 into $a1
	lb	$a0, buf+1		# scond destroyer palcement
	jal 	convert			# call convert
	move	$t0, $a0		# move $a0 into $t0
	jal 	plot_ship		# call plot_ship
	move	$t0, $a1		# move $a1 into $t0
	jal	plot_ship		# call plot_ship
	la	$a0, board		# load board
	li	$v0, 4 			# print string		
	syscall				# print
	la	$a0, submarine		# load destroyer message
	li	$v0, 4			# print string
	syscall				# print
	la	$a0, buf		# load buf
	li	$a1, 2			# 2 bytes
	li	$v0, 8			# read string
	syscall				# read
	lb	$a0, buf		# submarine placement
	jal 	convert			# call convert
	move	$t0, $a0		# move $a0 into $t0
	jal 	plot_ship		# call plot_ship
	la	$a0, board		# load board
	li	$v0, 4			# print string
	syscall				# print
	la	$t7, 0			# score = 0 (once this hits 6 the game is over)
	j next_shot			# jump to next_shot
next_shot:				# prompts user for next shot
	la	$a0, shot		# load shot message	
	li	$v0, 4			# print string
	syscall				# print
	la	$a0, buf		# load buf
	li	$a1, 2			# 2 bytes
	li	$v0, 8			# read string
	syscall				# read
	lb	$a0, buf		# shot position
	jal 	convert			# call convert
	beq	$a0, -5, invalid	# if invalid input call invalid
	move	$t0, $a0		# move $a0 into $t0
	jal 	plot			# call plot
	la	$a0, board		# load board
	li	$v0, 4			# print string
	syscall				# print
	beq	$t7, 6, new_game	# $t7 == 6 call new_game
	j 	next_shot		# call next_shot
invalid:				# print invalid message and print board agian
	la	$a0, invalid_shot	# load invalid message
	li	$v0, 4			# print string
	syscall				# print
	la	$a0, board		# load board
	li	$v0, 4			# print string
	syscall				# print
	j 	next_shot		# jump to next_shot
new_game:				# prompts user if they want a new game
	la	$a0, next_game		# load next_game message
	li	$v0, 4			# print string
	syscall				# print
	la	$a0, buf		# load buf
	li	$a1, 2			# 2 bytes
	li	$v0, 8			# read string
	syscall				# read
	lb	$a0, buf		# load buf byte
	beq 	$a0, 'n', exit		# $a0 == n call exit
	li      $t0, 0			# set counter to 0
L10:	lb      $t1, reset($t0)		# load byte from reset
	sb      $t1, board($t0)		# load byte into board
	add     $t0, $t0, 1		# increment $t0
	beq     $t0, 280, L20		# $t0 == 280 jump tp L20
	j       L10			# repeat loop
L20:    j main				# jump to main
exit:					# ends the game
	li	$v0, 10			# print exit
	syscall				# print
convert: 				# convert input into correct int 0-9 or a-z (returns to line under called position)
	sub	$a0, $a0, 48		# subtract 48 to get number value
	blt	$a0, 0, under 		# > 0 goto under
	bgt 	$a0, 9, over 		# > 9 goto over
	jr 	$ra 			# jump to line under convert call
under:					# if input is a symbol or other	(called from under returns to line under convert)
	li	$a0, -5			# set error message to code -5 (invalid character) for later check
	jr	$ra			# jump to line under convert call
over:					# if the input is a character (called from convert return to line under convert)
	sub	$a0, $a0, 39		# a-z
	jr	$ra			# jump to line under convert call
plot_ship:				# plots ships (returns to line under plot)
	mul 	$t0, $t0, 2		# mulitply $t0 by 2
	li 	$t2, 'O'		# store ship marker (O) in $t2
	lh 	$t1, offset1($t0)	# get offset for grid 1 store in $t1
	sb 	$t2, board($t1)		# plot $t2 on board using offset $t1
	lh 	$t1, offset2($t0)	# get offset for grid 2 store in $t1
	sb 	$t2, board($t1)		# plot $t2 on board using offset $t1
	jr	$ra			# jump to line under plot_ship call
plot:					# plot the shot (returns to line under called position)
	mul 	$t0, $t0, 2		# mulitply $t0 by 2
	lh	$t1, offset1($t0)	# get offset for grid 1 store in $t1
	lh	$t2, offset2($t0)	# get offset for grid 2 store in $t2
	lb	$t0, board($t1)		# load byte $t0 from board using offset $t1
	beq	$t0, 'O', plot_hit	# $t0 == 0 call plot_hit
	beq	$t0, '.', plot_miss	# $t0 == . call plot_miss
	la	$a0, duplicate_shot	# else load duplicate_shot message
	li	$v0, 4			# print string
	syscall				# print
	jr 	$ra			# return to line under plot
plot_hit:				# plot hits (called from plot returns to line under plot)
	add	$t7, $t7, 1		# increment score (at 6 game over)
	li 	$t3, 'X'		# store hit marker (X) in $t3
	sb 	$t3, board($t1)		# plot $t3 on board using offset $t1
	sb 	$t3, board($t2)		# plot $t3 on board using offset $t2
	jr	$ra			# jump to line under plot_hit call
plot_miss:				# plot misses (called from plot returns to line under plot)
	li 	$t3, '+'		# store hit marker (+) in $t3
	sb 	$t3, board($t1)		# plot $t3 on board using offset $t1
	sb 	$t3, board($t2)		# plot $t3 on board using offset $t2
	jr	$ra			# jump to line under plot_miss call