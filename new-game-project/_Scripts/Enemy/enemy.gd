extends CharacterBody2D

@export var sus_time = 2
@export var speed = 25

@onready var animated_sprite = $AnimatedSprite

var player_chase = false
var player_in_hit_range = false
var player_has_item = false
var player = null

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = body
		
		player_has_item = player.has_pickup_item()
		if player_has_item:
			print("Player has item. Using short sus time:", sus_time)
			call_deferred("start_chase")
		else:
			print("Yeah no this weirdo looks perfectly normal, no weird bulges or anything")

func _on_max_agro_range_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("<color=green>exited range</color>")
		player = null
		player_chase = false

func start_chase() -> void:
	var timer = get_tree().create_timer(sus_time)
	await timer.timeout

	if player != null:
		player_chase = true

func _process(delta: float) -> void:
	handle_animation()
	if player_chase and player_in_hit_range:
		call_deferred("_change_scene")

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


func _on_hit_area_body_entered(body):
	if body.name == "Player":
		player_in_hit_range = true
	
func _on_hit_area_body_exited(body: Node2D) -> void:
	player_in_hit_range = false

func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/Game/kill_map.tscn")
