extends CharacterBody2D
# This script controls the ball

# Sets the ball's speed, assigns it a Vector2 variable, and assigns the ball as active
var speed = 200
var dir = Vector2.DOWN
var is_active = true

# Makes the ball move upon starting the game
func _ready() -> void:
	# Moves ball left and down
	velocity = Vector2(speed * -1, speed)

# Checks whether the ball collides with anything (walls, bricks)
func _physics_process(delta: float) -> void:
	if is_active:
		# Checks if the ball is currently colliding with anything
		# Sets 'collision' to 'true' if there is a collision
		var collision = move_and_collide(velocity * delta)
		
		# Reverses the ball's direction upon collision
		if collision:
			velocity = velocity.bounce(collision.get_normal())
			# Check if the object the ball collided with has the 'hit' method
			# Calls 'hit' if it does (see res://scripts/brick.gd)
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit()
		
		# Makes sure the ball doesn't slow down too much along the vertical axis
		if (velocity.y > 0 and velocity.y < 100):
			velocity.y = -200
		
		# Makes sure the ball doesn't slow down too much along th horizontal axis
		if (velocity.x == 0):
			velocity.x = -200

# Reload the scene if the ball touches the bottom of the screen
func gameOver():
	GameManager.saveGame()
	GameManager.score = 0
	get_tree().reload_current_scene()

func disableBall():
	is_active = false

# Detects if the ball touches the bottom of the screen
func _on_death_plane_body_entered(body: Node2D) -> void:
	gameOver()
