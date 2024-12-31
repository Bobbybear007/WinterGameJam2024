extends Area2D

@export var required_object: String = ""  # Default to empty, will be set dynamically by the prisoner script

signal object_delivered(prisoner_name)

func _ready() -> void:
    print("Area2D is ready. Required object:", required_object)

    # Connect the body_entered signal
    if not is_connected("body_entered", Callable(self, "_on_body_entered")):
        connect("body_entered", Callable(self, "_on_body_entered"))

func set_required_object(new_object: String) -> void:
    required_object = new_object
    print("Updated required_object for Area2D:", required_object)

func _on_body_entered(body):
    if body is CharacterBody2D and body.has_method("has_pickup_item"):
        print("Player entered the interaction area.")
        check_player_object(body)

func check_player_object(player: Node) -> void:
    if player.has_pickup_item():
        var player_item = player.get_pickup_item()
        if player_item == required_object:
            print("Player delivered the correct object:", required_object)
            emit_signal("object_delivered", get_parent().name)
            on_object_delivered(player)
        else:
            print("Player has a different object:", player_item, ". Required:", required_object)
    else:
        print("Player has no object to deliver.")

func on_object_delivered(player: Node) -> void:
    print("Object successfully delivered to prisoner:", get_parent().name)
    player.remove_pickup_item()
    if player.has_method("on_item_delivered"):
        player.on_item_delivered(required_object)
    queue_free()
