extends Node

@onready var player_preload = preload("res://scenes/gel.tscn")
@onready var grapple_preload = preload("res://scenes/grapple_point.tscn")

func _ready():
	Signals.change_level.connect(change_level)

func change_level(scene):
	if scene != null:
		for child in $LevelHolder.get_children():
			child.queue_free()
		
		for child in $SpawnedEntities.get_children():
			child.queue_free()

		var level_instance = scene.instantiate()
		$LevelHolder.call_deferred("add_child", level_instance)
		
		var player = player_preload.instantiate()
		var grapple = grapple_preload.instantiate()
		
		
		$SpawnedEntities.call_deferred("add_child", grapple)
		$SpawnedEntities.call_deferred("add_child", player)
		
