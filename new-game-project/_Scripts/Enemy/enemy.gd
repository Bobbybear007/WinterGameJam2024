extends CharacterBody2D

@export var sus_time = 4
@export var short_sus_time = 2
@export var speed = 25
var player_chase = false
var player = null
var first_detection = true

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position) / speed

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = body
		if player.has_pickup_item():
			sus_time = short_sus_time
			print("Player has picked up the object. Using short sus time: ", sus_time)
		else:
			sus_time = 4
			print("Player has not picked up the object. Using regular sus time: ", sus_time)
		if first_detection:
			call_deferred("start_chase")
		else:
			player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = null
		player_chase = false

func start_chase() -> void:
	var timer = get_tree().create_timer(sus_time)
	await timer.timeout
	if player != null:
		player_chase = true
	first_detection = false
