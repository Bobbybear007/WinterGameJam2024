extends TileMapLayer

@export var speed: float = 100

func _process(delta: float) -> void:
	position.y += delta * speed
