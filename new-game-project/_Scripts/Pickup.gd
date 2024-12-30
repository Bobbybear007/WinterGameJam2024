extends Area2D

signal picked_up

func _ready() -> void:
	
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body is CharacterBody2D:
		print("Player entered pickup area")
		
		emit_signal("picked_up")
		queue_free()
