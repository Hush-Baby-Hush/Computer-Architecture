.text

# // Ignore integer overflow for addition
# int update_alert_level(unsigned int* stockpiles, unsigned int cutoff,
#   unsigned int alert_level) {
#     int total_monster = 0;
#     for (int i = 0; i < 10; i++) {
#         total_monster += stockpiles[i];
#     }
#     if (total_monster < cutoff) {
#         return alert_level + 1;
#     } else if (total_monster == cutoff) {
#         return alert_level;
#     } else {
#         return alert_level - 1;
#     }
# }
# // a0: unsigned int *stockpiles
# // a1: unsigned int cutoff
# // a2: unsigned int alert_level

.globl update_alert_level
update_alert_level:
	; move	$t0, $a0		# t0 = array base address(stockpiles)
	; move 	$t1, $a1		# t1 = cutoff
	; move 	$t2, $a2 		# t2 = alert_level
	li		$t3, 0			# t3 = total_monster
	li		$t4, 0			# t4 = i
	li		$t5, 10			# t5 = 10
for_loop:
	bge		$t4, $t5, done_loop		# see if i<10
	sll		$t6, $t4, 2		# t6=i*4
	add 	$t6, $a0, $t6	# t6 = & stockpiles[i]
	lw		$t6, 0($t6)		# stockpiles[i]
	add		$t3, $t3, $t6	# total_monster += stockpiles[i];
	addi  	$t4, $t4, 1    	# i++
	j		for_loop
done_loop:
	bgt		$t3, $a1, greater	# if total_monster > cutoff, go to greater
	bne		$t3, $a1, less		# if total_monster < cutoff, go to less
	move	$v0, $a2
	jr		$ra

less:
	addi	$a2, $a2, 1		# alert_level = alert_level + 1
	move	$v0, $a2
	jr		$ra

greater:
	sub		$a2, $a2, 1		# alert_level = alert_level - 1
	move	$v0, $a2
	jr		$ra