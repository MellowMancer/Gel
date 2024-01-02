class_name Stomp
extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	player.animation.play("fall")
	player.main_collision.disabled = true
	player.jump_collision.disabled = true
	player.jump_peak_collision.disabled = false
	player.wall_collision.disabled = true
	
	player.stomp_timer.start()

func exit() -> void:
	# Code to execute when exiting the idle state
	pass

func update(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		state_machine.transition_to("Fall", {stomp_cancel = true})
		
	elif player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
		
	elif Input.is_action_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")



func physics_update(delta: float) -> void:
	pass


func _on_stomp_timer_timeout():
	player.velocity.y = 1000

