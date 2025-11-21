extends Node2D
# This script sets up the bricks within the level

# Preloads the brick
@onready var brickObject = preload("res://breakout/scenes/brick.tscn")

# Sets the number of rows and columns of bricks,
# as well as how far from the edge of the screen they should be (in pixels)
var columns = BreakoutGameManager.columns
var rows = BreakoutGameManager.rows + BreakoutGameManager.level - 1
var margin = 54

# Runs setupLevel() upon the game starting
func _ready() -> void:
	setupLevel()
	BreakoutGameManager.showManager()
	BreakoutGameManager.bricksLeft = get_tree().get_nodes_in_group('Brick').size()

# Places the bricks in the level
func setupLevel():
	rows = 8 if rows > 8 else rows
	for r in rows:
		for c in columns:
			# Creates a new brick and places it using the current row (r) and column (c)
			var newBrick = brickObject.instantiate()
			add_child(newBrick)
			newBrick.position = Vector2(margin + (95 * c), margin - 25 + (30 * r))
			
			# Passes the current row to the newly created brick
			# Used for particle color calculation
			newBrick.brickRow = r
			
			# Gives each brick a color from colors[] depending on what the current row is
			var sprite = newBrick.get_node('Sprite2D')
			if r < 2:
				sprite.modulate = BreakoutGameManager.colors[0] #Green
			elif r < 4:
				sprite.modulate = BreakoutGameManager.colors[1] #Yellow
			elif r < 6:
				sprite.modulate = BreakoutGameManager.colors[2] #Orange
			else:
				sprite.modulate = BreakoutGameManager.colors[3] #Red
