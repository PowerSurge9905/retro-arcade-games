extends StaticBody2D
# This script controls the paddle

# Sets the paddle's speed
@export var speed = 500 + (30 * (BreakoutGameManager.level - 1))

# Detects if the player is using the left/right arrow keys
# Checks if paddleCanMove in game_manager.gd is true
# To make the paddle move itself, un-comment the longer if statements and comment the shorter if statement,
# Vice-versa for only player control
func _process(delta):
	var move_direction = 0
	#if (Input.is_action_pressed("ui_left") || $"../Ball".position.x < (position.x - 20)) && BreakoutGameManager.paddleCanMove:
	if (Input.is_action_pressed("ui_left") && BreakoutGameManager.paddleCanMove):
		move_direction = -1
	#elif (Input.is_action_pressed("ui_right") || $"../Ball".position.x > (position.x + 20)) && BreakoutGameManager.paddleCanMove:
	elif (Input.is_action_pressed("ui_right") && BreakoutGameManager.paddleCanMove):
		move_direction = 1
	
	# Moves the paddle
	position.x += move_direction * speed * delta
	
	# Keeps the paddle within the screen
	position.x = clamp(position.x, 100, 1052)
