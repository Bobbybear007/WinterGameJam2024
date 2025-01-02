extends Node2D

# The path to the main menu scene
const MAIN_MENU_SCENE_PATH = "res://Scenes/Game/main_menu.tscn"

func _ready():
    # Create a Timer instance dynamically
    var timer = Timer.new()
    add_child(timer)  # Add the Timer to the scene tree
    timer.wait_time = 7  # Set the wait time (in seconds)
    timer.one_shot = true  # Ensure the Timer triggers only once
    timer.start()  # Start the Timer
    # Connect the timeout signal to a function in this script
    timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout():
    # Change to the main menu scene
    var result = get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)
    if result != OK:
        print("Error: Main menu scene could not be loaded.")
