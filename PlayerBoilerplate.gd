class_name PlayerState
extends State

# Typed reference to the player node.
var player: Player

func _ready() -> void:
	# The states are children of the `Player` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	await owner.ready

	player = owner as Player
	
	assert(player != null)
