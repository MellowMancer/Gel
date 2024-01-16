extends Node

func _physics_process(delta):
	if(get_parent().can_attack and Input.is_action_just_pressed("attack")):
		get_parent().hit_box.disabled = false
		await(2)
		get_parent().hit_box.disabled = true
