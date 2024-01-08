extends Control


func _on_play_pressed():
	var loader_scene = load("res://scenes/level_loader.tscn")
	var loader_instance = loader_scene.instantiate()
	get_parent().add_child(loader_instance)
	
	Signals.change_level.emit(load("res://scenes/levels/hub.tscn"))
	queue_free()

func _on_test_room_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_pressed():
	get_tree().quit()
