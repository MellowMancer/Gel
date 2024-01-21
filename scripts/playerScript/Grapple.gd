class_name Grapple
extends PlayerState

@export var tension = 0.5
var position
var angle
var length
var old_vel_x
var old_vel_y
var dir


func enter(_msg := {}) -> void:
	#player.velocity.y = 0
	player.animation.play("jump_peak")
	player.main_collision.disabled = true
	player.jump_collision.disabled = true
	player.jump_peak_collision.disabled = false
	player.wall_collision.disabled = true
	
	player.main_hurtbox.disabled = true
	player.jump_hurtbox.disabled = true
	player.jump_peak_hurtbox.disabled = false
	player.wall_hurtbox.disabled = true
	
	if Input.is_action_just_pressed("grapple"):
		if player.ray.is_colliding():
			player.grapplepoint.global_position = player.ray.get_collision_point()
			position = player.ray.get_collision_point()
			length = (player.global_position).distance_to(player.grapplepoint.global_position)
			player.grapplepoint.visible = true
			player.grappling = true
			
	player.can_attack = false


func exit() -> void:
	player.grapplepoint.visible = false
	player.grappling = false
	
	
func update(delta: float) -> void:
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	
	elif !player.is_on_floor() and Input.is_action_pressed("jump") and !Input.is_action_pressed("grapple"):
		state_machine.transition_to("Jump", {do_double_jump = true})

	elif Input.is_action_pressed("dash") and player.can_dash and !Input.is_action_pressed("grapple"):
		state_machine.transition_to("Dash")
	
	elif !Input.is_action_pressed("grapple") and !player.is_on_floor():
		state_machine.transition_to("Fall")
		
	#elif Input.is_action_pressed("stomp"):
	#	state_machine.transition_to("Stomp")


func physics_update(delta):
	if Input.get_axis("move_left", "move_right"):
		player.direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_pressed("grapple"):
		player.grapplepoint.global_position = position
		angle = player.global_position.angle_to_point(player.grapplepoint.global_position) + PI/2

		old_vel_y = player.velocity.y
		old_vel_x = player.velocity.x
		player.velocity.y = old_vel_y * sin(angle) * sin(angle) + old_vel_x * sin(angle) * cos(angle)
		player.velocity.x = old_vel_x * cos(angle) * cos(angle) + old_vel_y * sin(angle) * cos(angle)
		player.velocity.y += delta * player.gravity * sin(angle) * sin(angle)
		player.velocity.x += 3 * delta * player.gravity * cos(angle) * sin(angle)
		player.velocity.y = move_toward(player.velocity.y, 0, 1)
		player.velocity.x = move_toward(player.velocity.x, 0, 1)
		
