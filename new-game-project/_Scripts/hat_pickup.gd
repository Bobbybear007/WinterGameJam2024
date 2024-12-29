extends Area2D

signal hat_picked_up

func _ready():
	
	print("Children of this node:", get_children())

	
	var pickup_area = get_node("Pickup_area")
	if pickup_area:
		
		pickup_area.connect("body_entered", Callable(self, "_on_body_entered"))
	else:
		print("Pickup_area node not found")

func _on_body_entered(body: Node2D) -> void:
	
	if body.name == "Player" and body.has_method("drop_hat"):
		print("Player entered pickup area")
		emit_signal("hat_picked_up")
		queue_free()
