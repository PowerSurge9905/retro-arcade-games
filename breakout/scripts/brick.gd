extends RigidBody2D
# This script controls brick breaking and brick particle spawning

# Used for calculating broken brick particle color
var brickRow = 0
var green = GameManager.colors[0]
var yellow = GameManager.colors[1]
var orange = GameManager.colors[2]
var red = GameManager.colors[3]

# Hides the brick and disables its collision upon being hit by the ball
# Is called by res://scripts/ball.gd upon hitting a brick
func hit():
	
	# Adds one point to the player's score, see res://scripts/game_manager.gd
	GameManager.addPoints(1)
	
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
	
	var bricksLeft = get_tree().get_nodes_in_group('Brick')
	print(bricksLeft.size())
	
	# THE "OR" CONDITION HERE IS FOR DEBUGGING PURPOSES,
	# I DO NOT WANT TO HAVE TO PLAY THE WHOLE LEVEL JUST TO TEST THIS FEATURE
	# HOLDING UP ARROW WHILE THE BALL HITS A BRICK MOVES ON TO THE NEXT LEVEL
	# If there is one brick left, reload the scene and move on to the next level,
	# otherwise, just fully remove the hit brick from the scene
	if bricksLeft.size() == 1 || Input.is_action_pressed("ui_up"):
		GameManager.paddleCanMove = false
		GameManager.levelComplete = true
		get_parent().get_node("Ball").is_active = false
		await get_tree().create_timer(3).timeout
		GameManager.level += 1
		get_tree().reload_current_scene()
	else:
		# Waits 3 seconds, then fully removes the brick from the scene
		await get_tree().create_timer(1).timeout
		queue_free()
