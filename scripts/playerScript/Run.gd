class_name Run
extends PlayerState

func enter(_msg := {}) -> void:
	player.animation.play("run")
	player.main_collision.disabled = false
	player.jump_collision.disabled = true
	player.jump_peak_collision.disabled = true
	player.wall_collision.disabled = true
	
	player.main_hurtbox.disabled = false
	player.jump_hurtbox.disabled = true
	player.jump_peak_hurtbox.disabled = true
	player.wall_hurtbox.disabled = true
	
	player.can_double_jump = true
	player.wall_jump_buffer = false
	player.can_attack = true


func exit() -> void:
	# Code to execute when exiting the run state
	pass


func update(delta: float) -> void:
	# Code to execute every frame while in the run state
	if player.velocity.x == 0:
		state_machine.transition_to("Idle")
		
	elif !player.is_on_floor():
		player.coyote_flag = true
		player.coyote_timer.start()
		state_machine.transition_to("Fall")
	
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
		
	elif Input.is_action_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")


func physics_update(delta: float) -> void:
	# Code to execute every physics frame while in the run state
	if Input.get_axis("move_left", "move_right"):
		player.direction = Input.get_axis("move_left", "move_right")
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		if player.velocity.x > player.speed and direction*player.velocity.x > 0:
			player.velocity.x = move_toward(player.velocity.x, direction*player.speed, 5)
		elif direction*player.velocity.x < 0:
			player.velocity.x = move_toward(player.velocity.x, direction*player.speed, 100)
		else:
			player.velocity.x = move_toward(player.velocity.x, direction*player.speed, 20)
			
	else:
		if player.velocity.x > player.speed:
			player.velocity.x = move_toward(player.velocity.x, player.direction*player.speed, 30)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, 50)
	#player.velocity.y += gel.gravity * delta
	player.move_and_slide()


func _on_coyote_timer_timeout():
	player.coyote_flag = false
