class_name Jump
extends PlayerState

var wall_direction = 0

func enter(_msg := {}) -> void:
	if _msg.has("do_double_jump"):
		if Input.is_action_just_pressed("jump") and !player.is_on_floor() and player.can_double_jump:
			player.velocity.y = move_toward(player.double_jump_velocity, 0, 100)
			player.can_double_jump = false
	
	elif _msg.has("do_wall_jump"):
		if Input.is_action_just_pressed("jump") and !player.is_on_floor() and player.wallcheck.is_colliding():
			player.velocity.y = move_toward(player.jump_velocity, 0, 100)
			player.velocity.x = player.wallcheck.get_collision_normal().x * player.speed
			player.wall_jump_buffer_timer.start()
			player.wall_jump_buffer = true
			wall_direction = player.wallcheck.get_collision_normal().x
	
	elif Input.is_action_pressed("jump"):
			player.velocity.y = move_toward(player.jump_velocity, 0, 100)
	
	player.animation.play("jump")
	player.main_collision.disabled = true
	player.jump_collision.disabled = false
	player.jump_peak_collision.disabled = true
	player.wall_collision.disabled = true

func exit() -> void:
	# Code to execute when exiting the idle state
	pass

func update(delta: float) -> void:
	if player.is_on_floor() and player.velocity.y >= 0:
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	
	elif !player.is_on_floor() and player.velocity.y > 0:
		state_machine.transition_to("Fall")
		
	elif !player.is_on_floor() and Input.is_action_just_pressed("jump") and player.can_double_jump:
		state_machine.transition_to("Jump", {do_double_jump = true})
		
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
	if player.wall_jump_buffer and wall_direction * direction < 0 :
		pass
	elif direction:
		if player.velocity.x > player.speed and direction*player.velocity.x > 0:
			player.velocity.x = move_toward(player.velocity.x, direction*player.speed, 5)
		elif direction*player.velocity.x < 0:
			player.velocity.x = move_toward(player.velocity.x, direction*player.speed, 80)
		else:
			player.velocity.x = move_toward(player.velocity.x, direction*player.speed, 15)
			
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, 5)
	#player.velocity.y += gel.gravity * delta
	player.move_and_slide()

func _on_wall_jump_buffer_timer_timeout():
	player.wall_jump_buffer = false
