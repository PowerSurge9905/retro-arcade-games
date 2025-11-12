# scripts/debris.gd 
extends Area2D

# Movement / Look
@export var base_speed: float = 180.0      # speed at easy difficulty
@export var max_speed_bonus: float = 0.20  # up to +20% extra speed at max difficulty
@export var spin_deg_per_sec: float = 120.0
@export var randomize_spin_dir: bool = true

# Internal State
var _dir: Vector2 = Vector2.ZERO     # unit direction for movement
var _spin_sign: float = 1.0          # +1 or -1 for spin direction
var _game: Node = null               # reference to Game.gd for difficulty

# Setup On Start
func _ready() -> void:
	add_to_group("debris")
	add_to_group("Runtime")  # helps Game.gd clear everything on restart

	# connect to player hits
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	# find the Game node (we read difficulty from there)
	_game = get_tree().get_first_node_in_group("game_root")

	# pick a random spin direction if enabled
	if randomize_spin_dir and randf() < 0.5:
		_spin_sign = -1.0

# Speed From Game
func set_base_speed(v: float) -> void:
	# Game.gd may override our base speed
	base_speed = v

# Aim And Go
func launch_towards(point: Vector2) -> void:
	# set direction toward a target point (usually the player)
	var to := point - global_position
	if to.length() > 0.0:
		_dir = to.normalized()
	else:
		_dir = Vector2.ZERO

# Movement
func _physics_process(delta: float) -> void:
	# read difficulty 0..1 from Game if it exists (otherwise use 0)
	var t: float = 0.0
	if _game and _game.has_method("get_difficulty_t"):
		t = clampf(_game.get_difficulty_t(), 0.0, 1.0)

	# speed gets higher with difficulty
	var mult: float = 1.0 + max_speed_bonus * t
	var pixels_per_second := base_speed * mult

	# move and spin
	global_position += _dir * pixels_per_second * delta
	rotation_degrees += _spin_sign * spin_deg_per_sec * delta

# Hit Player Once And Remove
func _on_body_entered(body: Node) -> void:
	if body and body.has_method("take_damage"):
		body.take_damage(1)
	queue_free()
