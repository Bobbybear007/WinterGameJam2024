extends CharacterBody2D

@export var sus_time = 2
@export var speed = 25

@onready var animated_sprite = $AnimatedSprite2D

var player_chase = false
var player_in_hit_range = false
var player_has_item = false
var player = null

# --------------------------
# RANDOM MOVEMENT VARIABLES
# --------------------------
@export var move_duration_min: float = 1.0      # Minimum time to move before idling (seconds)
@export var move_duration_max: float = 3.0      # Maximum time to move before idling (seconds)
@export var idle_duration_min: float = 1.0      # Minimum time to idle (seconds)
@export var idle_duration_max: float = 3.0      # Maximum time to idle (seconds)
@export var walk_range: float = 100             # Range for random wandering

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var movement_timer: Timer = Timer.new()
@onready var idle_timer: Timer = Timer.new()

enum State {
    MOVE,
    IDLE
}
var current_state: State = State.IDLE
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
    rng.randomize()

    # Add Timers to the scene tree
    add_child(movement_timer)
    add_child(idle_timer)

    # Configure Timers
    movement_timer.one_shot = true
    movement_timer.connect("timeout", Callable(self, "_on_movement_timeout"))

    idle_timer.one_shot = true
    idle_timer.connect("timeout", Callable(self, "_on_idle_timeout"))

    # Randomly start moving or idling
    if rng.randi_range(0, 1) == 0:
        _start_moving(true)
    else:
        _start_idling(true)

# ------------------------------------------------------
# DETECTION / CHASE LOGIC
# ------------------------------------------------------
func _on_detection_area_body_entered(body: Node2D) -> void:
    if body is CharacterBody2D:
        player = body
        if player.has_method("has_pickup_item"):  # Ensure the method exists to prevent runtime errors
            player_has_item = player.has_pickup_item()
            if player_has_item:
                print("Player has item. Using short sus time:", sus_time)
                call_deferred("start_chase")
                
                # Use the full node path to access GuardAlert
                var guard_alert = get_node("/root/Game/Stuff/GuardAlert")
                if guard_alert:
                    guard_alert.play()  # Play the GuardAlert sound
                else:
                    print("GuardAlert node not found!")
            else:
                print("Yeah no this weirdo looks perfectly normal, no weird bulges or anything 😏")
        else:
            print("The detected body does not have the method 'has_pickup_item'.")




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

# ------------------------------------------------------
# PROCESS AND PHYSICS
# ------------------------------------------------------
func _process(delta: float) -> void:
    handle_animation()
    if player_chase and player_in_hit_range:
        call_deferred("_change_scene")

func _physics_process(delta: float) -> void:
    if player_chase and player:
        # --- CHASE LOGIC (no wall collision detection here) ---
        position += (player.position - position).normalized() * speed * delta
    else:
        # --- RANDOM WANDERING with WALL COLLISION DETECTION ---
        match current_state:
            State.MOVE:
                
                var direction = (target_position - position).normalized()
                
                var motion = direction * speed * delta
                
                
                var collision = move_and_collide(motion)
                if collision:
                    
                    pick_random_position()
                else:
                    
                    position += motion

                
                if position.distance_to(target_position) < 5:
                    _start_idling()
            State.IDLE:
                
                pass

# ------------------------------------------------------
# ANIMATION
# ------------------------------------------------------
func handle_animation() -> void:
    
    if player_chase and player:
        
        animated_sprite.play("Move")
        animated_sprite.scale.x = 1 if player.position.x > position.x else -1
    else:
        
        if current_state == State.MOVE:
            animated_sprite.play("Move")
            animated_sprite.scale.x = 1 if target_position.x > position.x else -1
        else:
            animated_sprite.play("Idle")


# ------------------------------------------------------
# HIT AREA & SCENE CHANGE
# ------------------------------------------------------
func _on_hit_area_body_entered(body):
    if body.name == "Player":
        player_in_hit_range = true

func _on_hit_area_body_exited(body: Node2D) -> void:
    player_in_hit_range = false

func _change_scene():
    get_tree().change_scene_to_file("res://Scenes/Game/kill_map.tscn")

# ------------------------------------------------------
# RANDOM MOVEMENT IMPLEMENTATION
# ------------------------------------------------------
func _start_moving(initial: bool = false) -> void:
    current_state = State.MOVE
    pick_random_position()

    var move_duration = rng.randf_range(move_duration_min, move_duration_max)
    movement_timer.wait_time = move_duration
    movement_timer.start()

func _on_movement_timeout() -> void:
    _start_idling()

func _start_idling(initial: bool = false) -> void:
    current_state = State.IDLE

    var idle_duration = rng.randf_range(idle_duration_min, idle_duration_max)
    idle_timer.wait_time = idle_duration
    idle_timer.start()

func _on_idle_timeout() -> void:
    _start_moving()

func pick_random_position() -> void:
    var rand_offset = Vector2(
        rng.randi_range(-walk_range, walk_range),
        rng.randi_range(-walk_range, walk_range)
    )
    target_position = position + rand_offset
