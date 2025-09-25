extends RigidBody2D
# This script controls brick breaking and brick particle spawning

var brickRow = 0
var colors = [
		Color(0, 1, 0, 1),
		Color(1, 1, 0, 1),
		Color(1, 0.5, 0, 1),
		Color(1, 0, 0, 1)
		]

# Hides the brick and disables its collision upon being hit by the ball
# Is called by res://scripts/ball.gd upon hitting a brick
func hit():
	
	# Adds one point to the player's score, see res://scripts/game_manager.gd
	GameManager.addPoints(1)
	
	# Makes the brick invisable and disables its collision
	if brickRow < Globals.rows * 0.25:
		$CPUParticles2D.color = colors[0] #Green
	elif brickRow < Globals.rows * 0.5:
		$CPUParticles2D.color = colors[1] #Yellow
	elif brickRow < Globals.rows * 0.75:
		$CPUParticles2D.color = colors[2] #Orange
	else:
		$CPUParticles2D.color = colors[3] #Red
	$CPUParticles2D.emitting = true
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
