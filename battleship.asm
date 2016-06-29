.data

start_message:	.asciiz	"\nStart showing a One-Player Battleship Game."
cruiser: 	.asciiz	"\nEnter the cruiser 3x[0-9a-z]: "
destroyer: 	.asciiz	"\nEnter the destroyer 2x[0-9a-z]: "
submarine:	.asciiz	"\nEnter the submarine: "
shot:		.asciiz	"\nYour Turn:\nEnter the next shot [0-9a-z] or peek (/): "
system_shot:	.asciiz "\nSystem Turn:"
duplicate_shot:	.asciiz	"\n***** A duplicate shot! *****"
invalid_shot:	.asciiz	"\n***** An invalid shot!  *****"
next_game:	.asciiz "\nNew game? (y/n) "
test:		.asciiz "test"

cruiser_hori:	.word 4, 5, 10, 11, 16, 17, 22, 23, 28, 29, 34, 35
cruiser_vert:	.word 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35

destroyer_hori:	.word 5, 11, 17, 13, 29, 35
destroyer_vert:	.word 30, 31, 32, 33, 34, 35

user:   .ascii   "\n\n    . . . . . .     . . . . . .      0 1 2 3 4 5"
         .ascii     "\n    . . . . . .     . . . . . .      6 7 8 9 a b"
         .ascii     "\n    . . . . . .     . . . . . .      c d e f g h"
         .ascii     "\n    . . . . . .     . . . . . .      i j k l m n"
         .ascii     "\n    . . . . . .     . . . . . .      o p q r s t"
         .asciiz    "\n    . . . . . .     . . . . . .      u v w x y z\n"

system:   .ascii   "\n\n    . . . . . .     . . . . . .      0 1 2 3 4 5"
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

main:					
	la	$a0, start_message	
	li	$v0, 4			
	syscall				
	la	$a0, user		
	li	$v0, 4 			
	syscall				
	la	$a0, cruiser		
	li	$v0, 4 			
	syscall				
	la	$a0, buf		
	li	$a1, 4			
	li	$v0, 8			
	syscall				
	lb	$a0, buf		
	jal 	convert			
	move	$a2, $a0		
	lb	$a0, buf+1		
	jal 	convert			
	move	$a1, $a0		
	lb	$a0, buf+2			
	jal 	convert			
	move	$t0, $a0		
	jal 	plot_ship_user		
	move	$t0, $a1		
	jal 	plot_ship_user		
	move	$t0, $a2		
	jal	plot_ship_user		
	la	$a0, user		
	li	$v0, 4 			
	syscall				
	la	$a0, destroyer		
	li	$v0, 4 			
	syscall				
	la	$a0, buf		
	li	$a1, 3			
	li	$v0, 8			
	syscall				
	lb	$a0, buf		
	jal 	convert			
	move	$a1, $a0		
	lb	$a0, buf+1		
	jal 	convert			
	move	$t0, $a0		
	jal 	plot_ship_user		
	move	$t0, $a1		
	jal	plot_ship_user		
	la	$a0, user		
	li	$v0, 4 				
	syscall				
	la	$a0, submarine		
	li	$v0, 4			
	syscall				
	la	$a0, buf		
	li	$a1, 2			
	li	$v0, 8			
	syscall				
	lb	$a0, buf		
	jal 	convert			
	move	$t0, $a0		
	jal 	plot_ship_user		
	la	$a0, user		
	li	$v0, 4			
	syscall				
	la	$t7, 0			
	la	$t6, 0			
	la	$t5, 0			
	jal 	system_cruiser
	la	$a0, system		
	li	$v0, 4			
	syscall		
	jal	system_destroyer
	la	$a0, system		
	li	$v0, 4			
	syscall	
	jal	system_submarine
	la	$a0, system		
	li	$v0, 4			
	syscall
	j	next_shot_user
next_shot_user:				
	la	$a0, shot			
	li	$v0, 4			
	syscall				
	la	$a0, buf		
	li	$a1, 2			
	li	$v0, 8			
	syscall				
	lb	$a0, buf		
	jal 	convert			
	move	$t0, $a0		
	jal 	plot_user		
	la	$a0, user		
	li	$v0, 4			
	syscall				
	beq	$t7, 6, new_game	
	beq	$t5, 0, next_shot_system
	j 	next_shot_user		
next_shot_system:
	la	$a0, system_shot		
	li	$v0, 4			
	syscall		
	jal 	plot_system		
	la	$a0, user		
	li	$v0, 4			
	syscall				
	beq	$t6, 6, new_game	
	beq	$t5, 0, next_shot_user
	j 	next_shot_system	
invalid:				
	la	$a0, invalid_shot	
	li	$v0, 4			
	syscall				
	la	$a0, user		
	li	$v0, 4			
	syscall				
	j 	next_shot_user		
new_game:				
	la	$a0, next_game		
	li	$v0, 4			
	syscall				
	la	$a0, buf		
	li	$a1, 2			
	li	$v0, 8			
	syscall				
	lb	$a0, buf		
	beq 	$a0, 'n', exit		
	li      $t0, 0			
L10:	lb      $t1, reset($t0)		
	sb      $t1, user($t0)		
	sb	$t1, system($t0)	
	add     $t0, $t0, 1		
	beq     $t0, 280, L20		
	j       L10			
L20:    j 	main				
exit:					
	li	$v0, 10			
	syscall				
convert: 				
	sub	$a0, $a0, 48		
	blt	$a0, 0, under 		
	bgt 	$a0, 9, over 		
	jr 	$ra 			
under:					
	beq	$a0, -1, show_system	
	li	$a0, -5
	beq	$a0, -5, invalid	
	jr	$ra			
over:					
	blt	$a0, 49, invalid
	sub	$a0, $a0, 39		
	jr	$ra			
show_system:
	la	$a0, system		
	li	$v0, 4			
	syscall				
	j	next_shot_user		
plot_ship_user:				
	mul 	$t0, $t0, 2		
	li 	$t2, 'O'		
	lh 	$t1, offset1($t0)	
	sb 	$t2, user($t1)		
	jr	$ra			
plot_user:				
	mul 	$t0, $t0, 2		
	lh	$t1, offset1($t0)	
	lh	$t2, offset2($t0)	
	lb	$t0, system($t1)		
	beq	$t0, 'O', plot_hit_user	
	beq	$t0, '.', plot_miss_user	
	la	$a0, duplicate_shot	
	li	$v0, 4			
	syscall				
	jr 	$ra			
plot_hit_user:				
	li	$t5, 1
	add	$t7, $t7, 1		
	li 	$t3, 'X'		
	sb 	$t3, system($t1)		
	sb 	$t3, user($t2)		
	jr	$ra			
plot_miss_user:				
	li	$t5, 0
	li 	$t3, '+'		
	sb 	$t3, system($t1)		
	sb 	$t3, user($t2)		
	jr	$ra			
system_cruiser:
	li	$a1, 2
	li 	$v0, 42       
	add 	$a0, $a0, 2
	syscall
	#li	$a0, 1
	beq	$a0, 1, system_cruiser_hori
	beq 	$a0, 0, system_cruiser_vert
system_cruiser_hori:
	la	$t2, cruiser_hori
	j 	LSCH2
LSCH1:	
	beq	$t0, $t2, LSCH2
	addi	$t2, $t2, 2
	add     $t3, $t3, 1		
	beq     $t3, 13, LSCH3		
	j       LSCH1			
LSCH2:
	li	$t3, 0
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	random_number
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
        la	$a3, ($a0)
        move	$t0, $a3
	j 	LSCH1
LSCH3:
	la	$a1, ($a0)
	add	$a1, $a1, 1
	la	$a2, ($a1)
	add	$a2, $a2, 1
	move	$t0, $a0
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	plot_ship_system
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
	move	$t0, $a1
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	plot_ship_system
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
	move	$t0, $a2
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	plot_ship_system
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4	
	jr	$ra
system_cruiser_vert:
	j 	LSCV2
LSCV1:	lb      $t2, cruiser_vert($t3)		
	beq	$t0, $t2, LSCV2
	add     $t3, $t3, 1		
	beq     $t3, 13, LSCV3		
	j       LSCV1			
LSCV2:
	li	$t3, 0
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	random_number
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
        move	$t0, $a0
	j 	LSCV1
LSCV3:
	la	$a1, ($a0)
	add	$a1, $a1, 6
	la	$a2, ($a1)
	add	$a2, $a2, 6
	move	$t0, $a0
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	plot_ship_system
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
	move	$t0, $a1
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	plot_ship_system
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
	move	$t0, $a2
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	plot_ship_system
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4	
	jr	$ra
system_destroyer:
	li	$a1, 2
	li 	$v0, 42       
	add 	$a0, $a0, 2
	syscall
	li	$a0, 0
	beq	$a0, 1, system_destroyer_hori
	beq 	$a0, 0, system_destroyer_vert
system_destroyer_hori:
	j 	LSCH2
LSDH1:	lb      $t2, destroyer_hori($t3)
	la	$t4, ($t0)
	mul 	$t4, $t4, 2		
	lh	$t1, offset1($t4)		
	lb	$t4, system($t1)		
	beq	$t4, 'O', LSDV2			
	beq	$t0, $t2, LSDH2
	add     $t3, $t3, 1		
	beq     $t3, 8, LSDH3		
	j       LSDH1			
LSDH2:
	li	$t3, 0
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	random_number
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
      	la	$t0, ($a0)
	j 	LSDH1
LSDH3:
	la	$a1, ($a0)
	add	$a1, $a1, 1
	move	$t0, $a0
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	plot_ship_system
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
	move	$t0, $a1
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	plot_ship_system
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4	
	jr	$ra
system_destroyer_vert:
	j 	LSDV2
LSDV1:	lb      $t2, destroyer_vert($t3)
	la	$t4, ($t0)
	mul 	$t4, $t4, 2		
	lh	$t1, offset1($t4)		
	lb	$t4, system($t1)		
	beq	$t4, 'O', LSDV2		
	beq	$t0, $t2, LSDV2
	add     $t3, $t3, 1		
	beq     $t3, 8, LSDV3		
	j       LSDV1			
LSDV2:
	li	$t3, 0
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	random_number
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
        la	$t0, ($a0)
	j 	LSDV1
LSDV3:
	la	$a1, ($a0)
	add	$a1, $a1, 6
	move	$t0, $a0
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	plot_ship_system
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
	move	$t0, $a1
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	plot_ship_system
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4	
	jr	$ra
system_submarine:
	j 	LS2
LS1:	
	la	$t4, ($t0)
	mul 	$t4, $t4, 2		
	lh	$t1, offset1($t4)		
	lb	$t4, system($t1)		
	beq	$t4, 'O', LS2	
	j       LS3			
LS2:
	li	$t3, 0
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	random_number
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
      	la	$t0, ($a0)
	j 	LS1
LS3:
	move	$t0, $a0
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	plot_ship_system
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
	jr	$ra
plot_ship_system:			
	mul 	$t0, $t0, 2		
	li 	$t2, 'O'		
	lh 	$t1, offset1($t0)	
	sb 	$t2, system($t1)	
	jr	$ra			
plot_system:				
	subu  	$sp, $sp, 4      
        sw    	$ra, ($sp) 
	jal 	random_number		
	lw    	$ra, ($sp)      
        addu  	$sp, $sp, 4
	move 	$t0, $a0
	mul 	$t0, $t0, 2		
	lh	$t1, offset1($t0)	
	lh	$t2, offset2($t0)	
	lb	$t0, user($t1)		
	beq	$t0, 'O', plot_hit_system	
	beq	$t0, '.', plot_miss_system	
	j	plot_system
plot_hit_system:			
	li	$t5, 1
	add	$t6, $t6, 1		
	li 	$t3, 'X'		
	sb 	$t3, user($t1)	
	sb 	$t3, system($t2)	
	jr	$ra			
plot_miss_system:			
	li	$t5, 0
	li 	$t3, '+'		
	sb 	$t3, user($t1)	
	sb 	$t3, system($t2)	
	jr	$ra			
random_number:	
	li	$a1, 35
	li 	$v0, 42       
	add 	$a0, $a0, 35
	syscall
	jr	$ra