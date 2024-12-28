extends CharacterBody2D

@export var speed = 40

@onready var visuals = $Visuals
@onready var base_animation_player = $Visuals/PlayerBase
@onready var hat_animation_player = $Visuals/Hat
@onready var jacket_animation_player = $Visuals/Jacket




var has_pickup = false
var direction = 1
var input = Vector2()

func _ready():
	
	var noodles = $"../Noodles"
	var screwdriver = $"../Screwdriver"
	var toilet_paper = $"../ToiletPaper"
	
	if noodles:
		add_pickup_object(noodles)
	if screwdriver:
		add_pickup_object(screwdriver)
	if toilet_paper:
		add_pickup_object(toilet_paper)


func add_pickup_object(pickup_object):
	print("Connecting pickup object signal to the Player")
	pickup_object.connect("picked_up", Callable(self, "_on_pickup_object_picked_up"))

func _on_pickup_object_picked_up() -> void:
	print("Pickup object collected!")
	has_pickup = true
	print("has_pickup is now:", has_pickup)


func has_pickup_item() -> bool:
	print("has_pickup_item() called, returning:", has_pickup)
	return has_pickup

func get_input() -> void:
	input = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input * speed

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func _process(delta: float) -> void:
	
	pass
