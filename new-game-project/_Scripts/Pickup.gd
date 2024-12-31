extends Area2D

signal picked_up(object_name)

@export var object_name: String = ""  # Default to an empty string

func _ready() -> void:
    # Use the node's name if object_name is not set
    if object_name == "":
        object_name = name  # Fallback to the node's name
    
    if not is_connected("body_entered", Callable(self, "_on_body_entered")):
        connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
    # Check if the body is a player and if the player already has an item
    if body is CharacterBody2D and body.has_method("has_pickup_item"):
        if body.has_pickup_item():
            print("Player already has an object and cannot pick up another.")
            return  # Prevent picking up the item

        print("Player picked up " + object_name)
        emit_signal("picked_up", object_name)
        queue_free()
