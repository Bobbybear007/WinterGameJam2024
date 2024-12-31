extends CharacterBody2D

@export var required_object: String = ""  # Set the required object here
@onready var interaction_area = $Area2D  # Reference to the child Area2D node

func _ready() -> void:
    print("Prisoner is ready. Required object:", required_object)

    # Update the Area2D required object
    if interaction_area.has_method("set_required_object"):
        interaction_area.set_required_object(required_object)
    else:
        print("Error: Area2D node does not have a set_required_object method.")
