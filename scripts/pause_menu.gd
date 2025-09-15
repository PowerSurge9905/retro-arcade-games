extends Control

@onready var level = $"../../"

# Resumes play
func resume():
	self.visible = false
	get_tree().paused = false

# Pauses play
func pause():
	get_tree().paused = true
	self.visible = true

# Checks for whether the game is currently paused and if the player presses ESCAPE
# Pauses/Unpauses based on current pause state
func testEsc():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

# Resumes the game when the Resume button is pressed
func _on_resume_button_pressed() -> void:
	resume()

# Exits the game when the Quit button is pressed
# Will send the player back to the main menu in the final verison
func _on_quit_button_pressed() -> void:
	# Make this change the scene to the main menu once it's functional
	get_tree().quit()

func _process(delta):
	testEsc()
