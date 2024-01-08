class_name Idle
extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	player.animation.play("idle")
	player.main_collision.disabled = false
	player.jump_collision.disabled = true
	player.jump_peak_collision.disabled = true
	player.wall_collision.disabled = true
	
	player.can_double_jump = true
	player.wall_jump_buffer = false

func exit() -> void:
	# Code to execute when exiting the idle state
	pass

func update(delta: float) -> void:
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		state_machine.transition_to("Run")
		
	elif Input.is_action_pressed("jump"):
		state_machine.transition_to("Jump")
		
	elif !player.is_on_floor():
		state_machine.transition_to("Fall")
		
	elif Input.is_action_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")



func physics_update(delta: float) -> void:
	# Code to execute every physics frame while in the idle state
	pass
