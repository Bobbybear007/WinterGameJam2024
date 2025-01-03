extends CharacterBody2D

#============================
#         Variables
#============================
@export var speed = 40

@onready var visuals = $Visuals
@onready var base_animation_player = $Visuals/PlayerBase
@onready var hat_animation_player = $Visuals/Hat
@onready var jacket_animation_player = $Visuals/Jacket
@onready var item_pickup_ui: ContainerSelection = null  # Initialize as null to handle assignment dynamically
@export var total_items_to_deliver: int = 3  # Total number of items to deliver
@onready var ui_element = $"../CanvasLayer/ItemPickupUI"
@onready var player_walking_audiostream = $AudioStreamPlayer_Walking

@onready var item_pickup_sound = $audio_item_pickup
@onready var item_drop_sound = $audio_item_dropoff



var has_pickup = false
var current_pickup_item: String = ""  # Holds the name of the currently picked-up object
var direction = 1
var input = Vector2()
var has_hat = false  # Default is no hat until picked up
var delivered_items: Array = []  # Tracks the names of delivered items
var UI_open: bool = false


#============================
#       Initialization
#============================
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
        print("Connecting hat_picked_up signal to the Player.")
        if not hat_pickup.is_connected("hat_picked_up", Callable(self, "hat_picked_up")):
            hat_pickup.connect("hat_picked_up", Callable(self, "hat_picked_up"))
    else:
        print("Error: Hat pickup node not found!")
        
    
    update_ui_visibility()
    print("ui_element:", ui_element)
    if ui_element == null:
        print("Error: Failed to find ItemPickupUI. Check the node path.")
    else:
        print("ItemPickupUI successfully assigned.")
    update_ui_visibility()

    # Connect other pickup objects
    connect_pickup_object($"../Noodles", "Noodles")
    connect_pickup_object($"../Screwdriver", "Screwdriver")
    connect_pickup_object($"../ToiletPaper", "ToiletPaper")

# Helper function for connecting pickup objects
func connect_pickup_object(pickup_node, name: String):
    if pickup_node:
        print("Connecting", name, "pickup object signal to the Player.")
        add_pickup_object(pickup_node)
    else:
        print("Error:", name, "pickup object not found!")
        
        


    


#============================
#       Pickup Logic
#============================
func add_pickup_object(pickup_object):
    print("Connecting pickup object signal to the Player for:", pickup_object.name)
    var connected = pickup_object.connect("picked_up", Callable(self, "_on_pickup_object_picked_up"))
    print("Signal connection result for", pickup_object.name, ":", connected)


func _on_pickup_object_picked_up(object_name: String) -> void:
    if has_pickup:
        print("Player already has an object and cannot pick up another one.")
        return  # Prevent picking up another object

    print("Pickup object collected:", object_name)
    has_pickup = true
    current_pickup_item = object_name  # Store the name of the collected object
    print("has_pickup is now:", has_pickup)
    print("Current pickup item:", current_pickup_item)
    UI_open = true
    
    item_pickup_sound.play()
    
    


func has_pickup_item() -> bool:
    print("has_pickup_item() called, returning:", has_pickup)
    return has_pickup

func get_pickup_item() -> String:
    print("get_pickup_item() called, returning:", current_pickup_item)
    return current_pickup_item

func remove_pickup_item():
    print("Removing pickup item:", current_pickup_item)
    current_pickup_item = ""
    has_pickup = false  # Ensure this is properly reset
    print("has_pickup is now:", has_pickup)
    item_drop_sound.play()
    
   








#============================
#         Win State
#============================


func on_item_delivered(item_name: String) -> void:
    if item_name in delivered_items:
        print("Item", item_name, "has already been delivered.")
        return

    delivered_items.append(item_name)
    print("Delivered items:", delivered_items)

    if delivered_items.size() >= total_items_to_deliver:
        print("All items delivered! Transitioning to next scene.")
        go_to_next_scene()

func go_to_next_scene() -> void:
    var next_scene = preload("res://Scenes/Game/win_map.tscn")  # Directly specify the scene path
    if next_scene:
        get_tree().change_scene_to_packed(next_scene)  # Use for a PackedScene
    else:
        print("Error: Unable to load the next scene.")








#============================
#         Hat Logic
#============================
func hat_picked_up() -> void:
    print("Hat pickup signal received!")
    hat_animation_player.visible = true
    print("Hat visibility is now:", hat_animation_player.visible)

func drop_hat() -> void:
    # Hides the hat sprite
    hat_animation_player.visible = false
    has_hat = false

#============================
#     Input and Movement
#============================



func get_input() -> void:
    input = Input.get_vector("Left", "Right", "Up", "Down")
    velocity = input * speed
    if velocity.length()>0:
        if !player_walking_audiostream.playing:
            player_walking_audiostream.play()
    else:
        player_walking_audiostream.stop()
        

    
    
func _physics_process(delta: float) -> void:
    get_input()
    move_and_slide()

#============================
#   Animation and Visuals
#============================
func _process(delta: float) -> void:
    handle_animation()
    handle_flip()
    update_ui_visibility()
    
    if Input.is_action_just_pressed("quit"):
      get_tree().change_scene_to_file("res://Scenes/Game/main_menu.tscn")




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




func update_ui_visibility():
    if ui_element == null:
        print("Error: ui_element is null. Check node path.")
        return
    ui_element.visible = UI_open

        
        

# Example function to toggle the UI state
func toggle_ui():
    UI_open = !UI_open
    update_ui_visibility()
    
    
    
    
    
    
    
