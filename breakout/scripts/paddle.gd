extends StaticBody2D
# This script controls the paddle

# Sets the paddle's speed
@export var speed = 500

# Detects if the player is using the left/right arrow keys
# Checks if paddleCanMove in game_manager.gd is true
func _process(delta):
	var move_direction = 0
	if Input.is_action_pressed("ui_left") && GameManager.paddleCanMove:
		move_direction = -1
	elif Input.is_action_pressed("ui_right") && GameManager.paddleCanMove:
		move_direction = 1
	
	# Moves the paddle
	position.x += move_direction * speed * delta
	
	# Keeps the paddle within the screen
	position.x = clamp(position.x, 100, 1052)
