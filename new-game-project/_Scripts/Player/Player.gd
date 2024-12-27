extends CharacterBody2D

@export var speed = 40

@onready var visuals = $Visuals
@onready var base_animation_player = $Visuals/PlayerBase
@onready var hat_animation_player = $Visuals/Hat
@onready var jacket_animation_player = $Visuals/Jacket

var direction = 1
var input = Vector2()
var has_pickup = false

func _ready() -> void:
	direction = 1

func get_input() -> void:
	input = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input * speed

func handle_flip() -> void:
	if input.x == 0:
		return
	
	if round(input.x) != direction:
		direction *= -1
		visuals.scale.x = direction

func play_animation(name):
	base_animation_player.play(name)
	hat_animation_player.play(name)
	jacket_animation_player.play(name)

func handle_animation() -> void:
	if input.x == 0 and input.y == 0:
		play_animation("idle")
	else:
		play_animation("move")

func temporary_toggle_test() -> void:
	if Input.is_action_just_pressed("HatToggle"):
		hat_animation_player.visible = !hat_animation_player.visible
		
	if Input.is_action_just_pressed("JacketToggle"):
		jacket_animation_player.visible = !jacket_animation_player.visible

func _process(delta: float) -> void:
	handle_flip()
	handle_animation()
	temporary_toggle_test()

func _physics_process(delta) -> void:
	get_input()
	move_and_slide()

func _on_pickup_object_picked_up() -> void:
	print("Pickup object collected!")
	has_pickup = true
	print("has_pickup is now: ", has_pickup)

func add_pickup_object(pickup_object):
	print("Connecting pickup object signal")
	pickup_object.connect("picked_up", Callable(self, "_on_pickup_object_picked_up"))

func has_pickup_item() -> bool:
	print("has_pickup_item() called, returning: ", has_pickup)
	return has_pickup
