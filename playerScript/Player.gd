class_name Player
extends CharacterBody2D

const speed = 100.0
const jump_velocity = -400.0
const double_jump_velocity = -300
const terminal_velocity = 700

var animation
var main_collision
var jump_collision
var jump_peak_collision
var wall_collision

var ray
var grapplepoint
var global_mouse_position
var grappling = false

var wall_jump_buffer_timer
var coyote_timer
var dash_timer
var dash_cooldown
var stomp_timer

var wallcheck
#var raycast
#var ledgecheck
var can_double_jump = true
var can_dash = true
var wall_jump_buffer = false
var coyote_flag = false
var dashing
var direction = 1
var gravity = 700
var dir

func _ready():
	animation = $AnimatedSprite2D
	
	main_collision = $MainCollision
	jump_collision = $JumpCollision
	jump_peak_collision = $JumpPeakCollision
	wall_collision = $WallCollision
	
	wallcheck = $WallCheck
	
	coyote_timer = $CoyoteTimer
	wall_jump_buffer_timer = $WallJumpBufferTimer
	dash_cooldown = $DashCooldown
	dash_timer = $DashTimer
	stomp_timer = $StompTimer
	grapplepoint = get_parent().get_node("GrapplePoint")
	#grapplepoint = $GrapplePoint
	ray = $GrappleRay
	
func _physics_process(delta):
	if(wallcheck.is_colliding() and velocity.y > 1):
		velocity.y = 50
	elif dashing == true or grappling == true:
		pass
	else:
		velocity.y += gravity * delta
	if velocity.y > terminal_velocity:
		velocity.y = move_toward(velocity.y, terminal_velocity, 100)
	elif velocity.y < -terminal_velocity:
		velocity.y = move_toward(velocity.y, -terminal_velocity, 100)
	
		
	global_mouse_position = get_global_mouse_position()
	ray.look_at(global_mouse_position)
	animation.flip_h = direction < 0 if !dashing else false
	wallcheck.target_position.x = -10.8333 if animation.flip_h else 10.8333
	wall_collision.position.x = -4.583 if animation.flip_h else 4.583
	move_and_slide()
	Signals.position_update.emit(position)
