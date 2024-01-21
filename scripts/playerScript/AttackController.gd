extends Node

func _process(delta: float) -> void:
	if(get_parent().can_attack and Input.is_action_pressed("attack")):
		var player = get_parent()
		player.hit_box.disabled = false
		player.can_attack = false
		player.attack_timer.start()
		player.animation.play("air_attack")
		


func _on_attack_timer_timeout():
	var player = get_parent()
	player.hit_box.disabled = true
	player.can_attack = true
	
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			player.animation.play("idle")
		else:
			player.animation.play("run")
		
	elif player.wallcheck.is_colliding():
		player.animation.play("wall")
	
	elif player.dashing:
		player.animation.play("dash")
		
	elif !player.is_on_floor():
		player.animation.play("jump_peak")
