extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		body.change_walking_audio_to_grass()


func _on_body_exited(body: Node2D) -> void:
	if body is PlayerController:
		body.change_walking_audio_to_concrete()
