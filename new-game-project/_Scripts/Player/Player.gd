extends CharacterBody2D

@export var speed = 40

@onready var visuals = $Visuals
@onready var base_animation_player = $Visuals/PlayerBase
@onready var hat_animation_player = $Visuals/Hat
@onready var jacket_animation_player = $Visuals/Jacket

var direction = 1
var input = Vector2()

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
