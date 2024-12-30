# fan.gd
extends StaticBody2D  # because Fan is a StaticBody2D

func _ready():
    # Connect the DropArea child’s body_entered signal
    $DropArea.connect("body_entered", Callable(self, "_on_DropArea_body_entered"))

func _on_DropArea_body_entered(body: Node) -> void:
    # Check if body is Player
    if body.name == "Player" and body.has_method("drop_hat"):
        body.drop_hat()
