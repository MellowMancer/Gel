extends CharacterBody2D


func _ready():
	$AnimatedSprite2D.play("default")
	
func _physics_process(delta):
	velocity.x = move_toward(-80, 0, 40)
	move_and_slide()
