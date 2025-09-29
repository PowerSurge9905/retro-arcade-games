extends CharacterBody2D
# This script controls the ball

# Stores all sound players as variables
@onready var sound_bounce = $BounceSoundPlayer
@onready var sound_break = $BreakSoundPlayer
@onready var sound_game_over = $GameOverSoundPlayer
@onready var sound_life_lost = $LifeLostSoundPlayer

# Sets the ball's speed and status as active
var speed = 200 + (20 * (GameManager.level - 1))
var dir = Vector2.DOWN
var is_active = false

# Gives the ball velocity, allows the countdown to play,
# then activates the ball and gives the player control over the paddle
func _ready() -> void:
	velocity = Vector2(speed * -1, speed)
	await get_tree().create_timer(4.5).timeout
	is_active = true
	GameManager.paddleCanMove = true

# Checks whether the ball collides with anything (walls, bricks)
func _physics_process(delta: float) -> void:
	if is_active:
		# Checks if the ball is currently colliding with anything
		# Sets 'collision' to 'true' if there is a collision
		var collision = move_and_collide(velocity * delta)
		
		# Reverses the ball's direction upon collision
		if collision:
			velocity = velocity.bounce(collision.get_normal())
			
			# Makes sure the ball doesn't slow down too much along the vertical axis
			@warning_ignore("integer_division")
			if (velocity.y > 0 and velocity.y < speed / 2):
				velocity.y = speed
			@warning_ignore("integer_division")
			if (velocity.y <= 0 and velocity.y > speed / -2):
				velocity.y = speed * -1
			
			# Makes sure the ball doesn't slow down too much along the horizontal axis
			@warning_ignore("integer_division")
			if (velocity.x > 0 and velocity.x < speed / 4):
				velocity.x = speed
			@warning_ignore("integer_division")
			if (velocity.x <= 0 and velocity.x > speed / -4):
				velocity.x = speed * -1
				
			# Check if the object the ball collided with has the 'hit' method
			# Calls 'hit' if it does (see res://scripts/brick.gd)
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit()
				sound_break.play()
			else:
				sound_bounce.play()

# Reload the scene if the ball touches the bottom of the screen
func gameOver():
	# Halts paddle movement without pausing other processes
	GameManager.paddleCanMove = false
	# Save game
	GameManager.saveGame()
	# Play the game over sound, wait 3 seconds
	sound_game_over.play()
	await get_tree().create_timer(3).timeout
	# Reset scene, score, level, row count, and lives
	GameManager.score = 0
	GameManager.level = 1
	GameManager.rows = 2
	GameManager.lives = 3
	get_tree().reload_current_scene()

# Returns the ball to its starting position
func toCenter():
	position.x = 576
	position.y = 440
	velocity = Vector2(speed * -1, speed)

# Subtracts one life, returns ball to center, starts countdown
func lifeLost():
	sound_life_lost.play()
	GameManager.lives -= 1
	await get_tree().create_timer(3).timeout
	toCenter()
	GameManager.startCountdown = true
	disableBall()
	await get_tree().create_timer(4.5).timeout
	enableBall()

# Stops all ball movement
func disableBall():
	is_active = false

# Resumes ball movement
func enableBall():
	is_active = true

# Detects if the ball touches the bottom of the screen
func _on_death_plane_body_entered(_body: Node2D) -> void:
	if GameManager.lives == 1:
		gameOver()
	else:
		lifeLost()
