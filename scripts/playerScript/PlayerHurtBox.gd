class_name PlayerHurtBox
extends Area2D

@export var health := 5;
@onready var invincibility_timer = $InvincibiltyTimer

func _on_area_entered(hitbox: HitBox):
	if hitbox == null:
		return
	take_damage(hitbox.damage)
	owner.recoil(hitbox.global_position)

func take_damage(damage):
	health -= damage
	invincibility_timer.start()
#	for child in find_children("*", "CollisionShape2D"):
#		child.set_deferred("disabled", true)

	
	if health <= 0:
		get_parent().queue_free()


func _on_invincibilty_timer_timeout():
#	for child in find_children("*", "CollisionShape2D"):
#		child.set_deferred("disabled", false)
	set_collision_mask_value(2, true)
