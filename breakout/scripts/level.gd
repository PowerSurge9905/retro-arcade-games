extends Node2D
# This script sets up the bricks within the level

# Preloads the brick
@onready var brickObject = preload("res://scenes/brick.tscn")

# Sets the number of rows and columns of bricks,
# as well as how far from the edge of the screen they should be (in pixels)
var columns = 12
var rows = 2
var margin = 50

# An array of colors for dynamically coloring the bricks in
var colors = [
		Color(0, 1, 0, 1),
		Color(1, 1, 0, 1),
		Color(1, 0.5, 0, 1),
		Color(1, 0, 0, 1)
		]

# Runs setupLevel() upon the game starting
func _ready() -> void:
	$CanvasLayer/PauseMenu.visible = false
	setupLevel()

# Places the bricks in the level
func setupLevel():
	for r in rows:
		for c in columns:
			# Creates a new brick and places it using the current row (r) and column (c)
			var newBrick = brickObject.instantiate()
			add_child(newBrick)
			newBrick.position = Vector2(margin + (95 * c), margin - 25 + (30 * r))
			
			# Gives each brick a color from colors[] depending on what the current row is
			var sprite = newBrick.get_node('Sprite2D')
			if r <= 8:
				sprite.modulate = colors[0] #Green
			if r < 6:
				sprite.modulate = colors[1] #Yellow
			if r < 3:
				sprite.modulate = colors[2] #Orange
			if r == 0:
				sprite.modulate = colors[3] #Red
