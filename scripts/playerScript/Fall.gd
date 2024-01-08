class_name Fall
extends PlayerState

func enter(_msg := {}) -> void:
	if Input.is_action_pressed("jump") and player.is_on_floor():
		player.velocity.y = move_toward(player.jump_velocity, 0, 100)
	
	if _msg.has("dash_cancel"):
		player.velocity.y = move_toward(player.velocity.y, -50, 1000)
	player.animation.play("jump_peak")
	player.main_collision.disabled = true
	player.jump_collision.disabled = true
	player.jump_peak_collision.disabled = false
	player.wall_collision.disabled = true
	
	player.wall_jump_buffer = false

func exit() -> void:
	# Code to execute when exiting the idle state
	pass

func update(delta: float) -> void:
	if player.is_on_floor() and player.velocity.y >= 0:
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	
	elif !player.is_on_floor() and Input.is_action_just_pressed("jump") and player.can_double_jump and !player.coyote_flag:
		state_machine.transition_to("Jump", {do_double_jump = true})
		
	elif !player.is_on_floor() and Input.is_action_pressed("jump") and player.coyote_flag:
		state_machine.transition_to("Jump")
		
	elif player.wallcheck.is_colliding() and player.velocity.y >= 0:
		state_machine.transition_to("Wall")
		
	elif Input.is_action_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")
		
	elif Input.is_action_just_pressed("grapple") and player.ray.is_colliding():
		state_machine.transition_to("Grapple")
		
	#elif Input.is_action_pressed("stomp"):
	#	state_machine.transition_to("Stomp")



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
		player.velocity.x = move_toward(player.velocity.x, 0, 4)
	#player.velocity.y += gel.gravity * delta
	player.move_and_slide()
