extends CharacterBody2D

@export var speed = 40

@onready var visuals = $Visuals
@onready var base_animation_player = $Visuals/PlayerBase
@onready var hat_animation_player = $Visuals/Hat
@onready var jacket_animation_player = $Visuals/Jacket
@onready var item_pickup_ui: ContainerSelection = null  # Initialize as null to handle assignment dynamically

var has_pickup = false
var direction = 1
var input = Vector2()
var has_hat = false  # Default is no hat until picked up

func _ready():
	# Initialize the item_pickup_ui with the correct node path
	item_pickup_ui = $"../CanvasLayer/ItemPickupUI"
	if item_pickup_ui == null:
		print("Error: ItemPickupUI not found! Check the node path.")
	else:
		print("ItemPickupUI successfully initialized.")

	# Connect the hat pickup signal
	var hat_pickup = $"../HatPickup"  # Adjust to your hat's node path
	if hat_pickup:
		print("Connecting hat_picked_up signal to the Player")
		hat_pickup.connect("hat_picked_up", Callable(self, "hat_picked_up"))
	else:
		print("Hat pickup node not found!")

	# Connect other pickup objects
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
	show_pickup_ui()

func has_pickup_item() -> bool:
	print("has_pickup_item() called, returning:", has_pickup)
	return has_pickup

func show_pickup_ui():
	if item_pickup_ui == null:
		print("Error: ItemPickupUI is null!")
		return
	item_pickup_ui.display_panel()
	print("ItemPickupUI is now visible.")
	
	await get_tree().create_timer(2.0).timeout
	item_pickup_ui.visible = false
	print("ItemPickupUI is now hidden.")

func hat_picked_up() -> void:
	print("Hat pickup signal received!")
	hat_animation_player.visible = true
	print("Hat visibility is now:", hat_animation_player.visible)

func get_input() -> void:
	input = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input * speed

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func _process(delta: float) -> void:
	handle_animation()
	handle_flip()

func handle_animation() -> void:
	if input.x == 0 and input.y == 0:
		play_animation("idle")
	else:
		play_animation("move")

func play_animation(name: String) -> void:
	base_animation_player.play(name)
	hat_animation_player.play(name)
	jacket_animation_player.play(name)

func handle_flip() -> void:
	if input.x == 0:
		return

	if round(input.x) != direction:
		direction *= -1
		visuals.scale.x = direction

func drop_hat() -> void:
	# Hides the hat sprite
	hat_animation_player.visible = false
	has_hat = false
