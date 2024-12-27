extends CharacterBody2D

@export var sus_time = 4
@export var speed = 25
var player_chase = false
var player = null
var first_detection = true

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position) / speed

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	# Check if this is the first time the player is detected
	if first_detection:
		# Start a delayed chase coroutine
		call_deferred("start_chase")
	else:
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func start_chase() -> void:
	# Create a timer
	var timer = get_tree().create_timer(sus_time)
	# Wait for the timer to timeout
	await timer.timeout
	if player != null:
		player_chase = true
	# Set first_detection to false after the first chase starts
	first_detection = false
