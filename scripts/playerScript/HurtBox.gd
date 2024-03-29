class_name HurtBox
extends Area2D

@export var health := 5;
@onready var invincibility_timer = $InvincibiltyTimer

func _on_area_entered(hitbox: HitBox):
	if hitbox == null:
		return
	take_damage(hitbox.damage)

func take_damage(damage):
	health -= damage
	invincibility_timer.start()
#	for child in find_children("*", "CollisionShape2D"):
#		child.set_deferred("disabled", true)
	monitoring = false
	
	if health <= 0:
		get_parent().queue_free()


func _on_invincibilty_timer_timeout():
#	for child in find_children("*", "CollisionShape2D"):
#		child.set_deferred("disabled", false)
	monitoring = true
