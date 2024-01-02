extends Control


func _on_play_pressed():
	pass # Replace with function body.


func _on_test_room_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	#get_node("MarginContainer").hide()
	
	#get_node("LoadingScreen").loadLevel("res://scenes/test_area.tscn")

func _on_quit_pressed():
	get_tree().quit()
