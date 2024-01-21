class_name Dash
extends PlayerState

var angle

func enter(_msg := {}) -> void:
	player.animation.play("dash")
	player.main_collision.disabled = true
	player.jump_collision.disabled = true
	player.jump_peak_collision.disabled = false
	player.wall_collision.disabled = true
	
	player.main_hurtbox.disabled = true
	player.jump_hurtbox.disabled = true
	player.jump_peak_hurtbox.disabled = false
	player.wall_hurtbox.disabled = true
	
	player.dashing = true
	player.wall_jump_buffer = false
	player.can_attack = false
	angle = player.ray.rotation

func exit() -> void:
	player.animation.rotate(-angle)

func update(delta: float) -> void:
	if !player.dashing and player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
		
	elif !player.dashing and player.wallcheck.is_colliding():
		state_machine.transition_to("Wall")
		
	elif !player.dashing and !player.is_on_floor():
		state_machine.transition_to("Fall")
		
	elif Input.is_action_just_pressed("grapple") and player.ray.is_colliding():
		state_machine.transition_to("Grapple")
	
	elif Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.dashing = false
		player.dash_timer.stop()
		player.dash_cooldown.start()
		state_machine.transition_to("Idle")
		
	elif Input.is_action_just_pressed("jump") and !player.is_on_floor():
		player.dashing = false
		player.dash_timer.stop()
		player.dash_cooldown.start()
		state_machine.transition_to("Fall", {dash_cancel = true})


func physics_update(delta: float) -> void:
	
	if player.can_dash:
		player.velocity.x = move_toward(player.velocity.x, 0, 40)
		player.velocity.y = 20 * sin(angle)
#		player.velocity.x = 80 * cos(angle)
		if player.velocity.x > 0:
			player.direction = 1
		else:
			player.direction = -1
		player.can_dash = false
		player.dash_timer.start()
		player.animation.rotate(angle)




func _on_dash_cooldown_timeout():
	player.can_dash = true


func _on_dash_timer_timeout():
	player.velocity.x = 370 * cos(angle)
	player.velocity.y = 350 * sin(angle)
	player.dashing = false
	player.dash_cooldown.start()
