extends Node2D

func _on_play_button_down() -> void:
	var next_scene = preload("res://Scenes/Game/Game.tscn")  # Directly specify the scene path
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)  # Use for a PackedScene
	else:
		print("Error: Unable to load Game.tscn")# Replace with function body.


func _on_quit_button_down() -> void:
	get_tree().quit()
