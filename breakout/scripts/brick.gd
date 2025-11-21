extends RigidBody2D
# This script controls brick breaking and brick particle spawning

# Used for calculating broken brick particle color

var brickRow = 0
var green = BreakoutGameManager.colors[0]
var yellow = BreakoutGameManager.colors[1]
var orange = BreakoutGameManager.colors[2]
var red = BreakoutGameManager.colors[3]

# Hides the brick and disables its collision upon being hit by the ball
# Is called by res://breakout/scripts/ball.gd upon hitting a brick
func hit():
	# Adds one point to the player's score, see res://breakout/scripts/breakout_game_manager.gd
	BreakoutGameManager.addPoints(1)
	
	# Sets the broken brick particle
	if brickRow < 2:
		$CPUParticles2D.color = green
	elif brickRow < 4:
		$CPUParticles2D.color = yellow 
	elif brickRow < 6:
		$CPUParticles2D.color = orange
	else:
		$CPUParticles2D.color = red
	
	# Enable particle emission, disable the brick's sprite and collision
	$CPUParticles2D.emitting = true
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	
	# If there is one brick left, reload the scene and move on to the next level,
	# otherwise, just fully remove the hit brick from the scene
	# Commented if statement is for debugging
	# Un-comment it and comment the shorter if statment to make the up arrow clear a level
	# Vice versa for just proper gameplay
	#if bricksLeft.size() == 1 || Input.is_action_pressed("ui_up"):
	if BreakoutGameManager.bricksLeft == 1:
		BreakoutGameManager.paddleCanMove = false
		BreakoutGameManager.levelComplete = true
		get_parent().get_node("Ball").is_active = false
		await get_tree().create_timer(3).timeout
		BreakoutGameManager.level += 1
		get_tree().reload_current_scene()
	else:
		# Fix issue where two bricks breaking in quick succession causes a level to not load
		# Waits 1 seconds, then fully removes the brick from the scene
		BreakoutGameManager.bricksLeft -= 1
		print(BreakoutGameManager.bricksLeft)
		await get_tree().create_timer(1).timeout
		queue_free()
