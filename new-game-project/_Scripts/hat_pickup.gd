extends Area2D

signal hat_picked_up

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		print("Player entered pickup area")
		emit_signal("hat_picked_up")
		print("Signal emitted: hat_picked_up")
		queue_free()
