extends RigidBody2D
# This script controls whether a brick is deleted from the scene

# Hides the brick and disables its collision upon being hit by the ball
# Is called by res://scripts/ball.gd upon hitting a brick
func hit():
	
	# Adds one point to the player's score, see res://scripts/game_manager.gd
	GameManager.addPoints(1)
	
	# Makes the brick invisable and disables its collision
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	
	var bricksLeft = get_tree().get_nodes_in_group('Brick')
	
	# THE "OR" CONDITION HERE IS FOR DEBUGGING PURPOSES,
	# I DO NOT WANT TO HAVE TO PLAY THE WHOLE LEVEL JUST TO TEST THIS FEATURE
	# HOLDING UP ARROW WHILE THE BALL HITS A BRICK MOVES ON TO THE NEXT LEVEL
	if bricksLeft.size() == 1 || Input.is_action_pressed("ui_up"):
		get_parent().get_node("Ball").is_active = false
		await get_tree().create_timer(1).timeout
		GameManager.level += 1
		get_tree().reload_current_scene()
	else:
		# Waits one second, then fully removes the brick from the scene
		await get_tree().create_timer(1).timeout
		queue_free()
