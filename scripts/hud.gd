# scripts/HUD.gd
extends CanvasLayer

# UI Labels
@onready var score_label: Label = $ScoreLabel
@onready var lives_label: Label = $LivesLabel
@onready var game_over_label: Label = $GameOverLabel
@onready var high_label: Label = get_node_or_null(^"HighScoreLabel")  # optional

# Setup On Start
func _ready() -> void:
	# show the saved high score if it exists
	if high_label:
		high_label.text = "Highest Score: %d" % ScoreManager.get_high_score()

	# hide the "GAME OVER" text at the beginning
	if is_instance_valid(game_over_label):
		game_over_label.visible = false

# Public Functions (Called By Game Or Player)
func set_score(value: int) -> void:
	if is_instance_valid(score_label):
		score_label.text = "Score: %d" % value

func set_lives(value: int) -> void:
	if is_instance_valid(lives_label):
		lives_label.text = "Lives: %d" % value

func set_high_score(v: int) -> void:
	if high_label:
		high_label.text = "Highest Score: %d" % v

# Game Over Text
func show_game_over() -> void:
	if is_instance_valid(game_over_label):
		game_over_label.visible = true

func hide_game_over() -> void:
	if is_instance_valid(game_over_label):
		game_over_label.visible = false
