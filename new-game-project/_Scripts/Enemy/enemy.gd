extends CharacterBody2D

@export var sus_time = 6
@export var short_sus_time = 2
@export var speed = 25

@onready var animated_sprite = $AnimatedSprite

var player_chase = false
var player = null

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = body

		
		if player.has_pickup_item():
			sus_time = short_sus_time
			print("Player has item. Using short sus time:", sus_time)
		else:
			sus_time = 6
			print("Player does NOT have item. Using regular sus time:", sus_time)

		call_deferred("start_chase")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = null
		player_chase = false

func start_chase() -> void:
	if player != null:
		
		sus_time = short_sus_time if player.has_pickup_item() else 6

	var timer = get_tree().create_timer(sus_time)
	await timer.timeout

	if player != null:
		player_chase = true

func _process(delta: float) -> void:
	handle_animation()

func _physics_process(delta: float) -> void:
	if player_chase and player:
		position += (player.position - position) / speed

func handle_animation() -> void:
	if player_chase:
		animated_sprite.play("Move")
		if player != null:
			animated_sprite.scale.x = 1 if player.position.x > position.x else -1
	else:
		animated_sprite.play("Idle")
