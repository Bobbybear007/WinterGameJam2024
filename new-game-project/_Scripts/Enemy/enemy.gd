extends CharacterBody2D

# === Exported Variables === #
@export var move_duration_min: float = 1.0      # Minimum time to move before idling (seconds)
@export var move_duration_max: float = 3.0      # Maximum time to move before idling (seconds)
@export var idle_duration_min: float = 1.0      # Minimum time to idle (seconds)
@export var idle_duration_max: float = 3.0      # Maximum time to idle (seconds)
@export var speed: float = 50                   # Movement speed (pixels per second)
@export var walk_range: float = 100             # Range for random walking (pixels)

# === State Enumeration === #
enum State {
	STATE_MOVE,   # Enemy is moving
	STATE_IDLE    # Enemy is idling
}

# === Internal Variables === #
var current_state: State = State.STATE_IDLE
var target_position: Vector2 = Vector2.ZERO
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# === Timers (created at runtime and added as children) === #
@onready var movement_timer: Timer = Timer.new()
@onready var idle_timer: Timer = Timer.new()

# === AnimatedSprite2D === #
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	rng.randomize()

	# Add timers as children
	add_child(movement_timer)
	add_child(idle_timer)

	# Configure and connect timers
	movement_timer.one_shot = true
	movement_timer.connect("timeout", Callable(self, "_on_movement_timeout"))

	idle_timer.one_shot = true
	idle_timer.connect("timeout", Callable(self, "_on_idle_timeout"))

	# Randomly decide the initial state
	if rng.randi_range(0, 1) == 0:
		_start_moving(true)
	else:
		_start_idling(true)

func _physics_process(delta: float) -> void:
	match current_state:
		State.STATE_MOVE:
			var direction = (target_position - position).normalized()
			velocity = direction * speed
			move_and_slide()

			# Flip the sprite (optional, for left/right)
			if direction.x != 0 and animated_sprite:
				animated_sprite.flip_h = direction.x < 0

			# If we're close to our target, switch to idle
			if position.distance_to(target_position) < 5:
				_start_idling()

		State.STATE_IDLE:
			# Just stay still
			velocity = Vector2.ZERO
			move_and_slide()

# === Movement Functions === #
func _start_moving(initial: bool = false) -> void:
	current_state = State.STATE_MOVE
	pick_random_position()

	# Set a random move duration
	var move_duration = rng.randf_range(move_duration_min, move_duration_max)
	movement_timer.wait_time = move_duration
	movement_timer.start()

	# Play walking animation
	if animated_sprite:
		animated_sprite.play("Move")
	else:
		print("Warning: AnimatedSprite2D is null when trying to play 'walk'")

func _on_movement_timeout() -> void:
	_start_idling()

# === Idle Functions === #
func _start_idling(initial: bool = false) -> void:
	current_state = State.STATE_IDLE
	velocity = Vector2.ZERO
	move_and_slide()

	# Set a random idle duration
	var idle_duration = rng.randf_range(idle_duration_min, idle_duration_max)
	idle_timer.wait_time = idle_duration
	idle_timer.start()

	# Play idle animation
	if animated_sprite:
		animated_sprite.play("Idle")
	else:
		print("Warning: AnimatedSprite2D is null when trying to play 'idle'")

func _on_idle_timeout() -> void:
	_start_moving()

# === Helper Functions === #
func pick_random_position() -> void:
	var rand_offset = Vector2(
		rng.randi_range(-walk_range, walk_range),
		rng.randi_range(-walk_range, walk_range)
	)
	target_position = position + rand_offset
