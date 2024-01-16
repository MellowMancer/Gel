class_name Wall
extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity.y = 0
	player.animation.play("wall")
	player.main_collision.disabled = true
	player.jump_collision.disabled = true
	player.jump_peak_collision.disabled = true
	player.wall_collision.disabled = false
	
	player.main_hurtbox.disabled = true
	player.jump_hurtbox.disabled = true
	player.jump_peak_hurtbox.disabled = true
	player.wall_hurtbox.disabled = false
	
	player.wall_jump_buffer = false
	player.can_attack = true

func exit() -> void:
	# Code to execute when exiting the idle state
	pass

func update(delta: float) -> void:	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {do_wall_jump = true})
		
	elif not player.wallcheck.is_colliding() :
		state_machine.transition_to("Fall")
		
	elif Input.is_action_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")
		
	#elif Input.is_action_pressed("grapple") and player.ray.is_colliding():
	#	state_machine.transition_to("Grapple")



func physics_update(delta: float) -> void:
	
	if Input.get_axis("move_left", "move_right"):
		player.direction = Input.get_axis("move_left", "move_right")
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		if player.velocity.x > player.speed and direction*player.velocity.x > 0:
			player.velocity.x = move_toward(player.velocity.x, direction*player.speed, 5)
		elif direction*player.velocity.x < 0:
			player.velocity.x = move_toward(player.velocity.x, direction*player.speed, 80)
		else:
			player.velocity.x = move_toward(player.velocity.x, direction*player.speed, 15)
			
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, 30)
	#player.velocity.y += gel.gravity * delta
	player.move_and_slide()
