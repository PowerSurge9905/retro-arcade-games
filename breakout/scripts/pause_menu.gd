extends Control

# Hides the pause menu and countdown on start, then starts countdown
func _ready() -> void:
	$PauseContainer.visible = false
	$CountdownContainer.visible = false
	countdown()

# Resumes play
func resume():
	$PauseContainer.visible = false
	get_tree().paused = false

# Pauses play
func pause():
	if GameManager.canPause:
		get_tree().paused = true
		$PauseContainer.visible = true

# A countdown to the game starting
# Gives the player a moment to analyze the game
func countdown():
	GameManager.canPause = false
	$CountdownContainer.visible = true
	$"CountdownContainer/Countdown Label".text = "READY?"
	await get_tree().create_timer(2).timeout
	$"CountdownContainer/Countdown Label".text = "3"
	await get_tree().create_timer(0.5).timeout
	$"CountdownContainer/Countdown Label".text = "2"
	await get_tree().create_timer(0.5).timeout
	$"CountdownContainer/Countdown Label".text = "1"
	await get_tree().create_timer(0.5).timeout
	$"CountdownContainer/Countdown Label".text = "GO!"
	await get_tree().create_timer(1).timeout
	$CountdownContainer.visible = false
	GameManager.canPause = true

func levelComplete():
	GameManager.canPause = false
	$"CountdownContainer/Countdown Label".text = "LEVEL CLEARED!"
	$CountdownContainer.visible = true
	await get_tree().create_timer(3).timeout
	$CountdownContainer.visible = false
	GameManager.canPause = true

# Checks for whether the game is currently paused and if the player presses ESCAPE
# Pauses/Unpauses based on current pause state
func escPress():
	if Input.is_action_just_pressed("pause") && !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") && get_tree().paused:
		resume()

# Resumes the game when the Resume button is pressed
func _on_resume_button_pressed() -> void:
	resume()

# Exits the game when the Quit button is pressed
# Will send the player back to the main menu in the final verison
func _on_quit_button_pressed() -> void:
	# Make this change the scene to the main menu once it's functional
	get_tree().quit()

func _process(_delta):
	escPress()
	
	if GameManager.startCountdown:
		GameManager.startCountdown = false
		countdown()
	
	if GameManager.levelComplete:
		GameManager.levelComplete = false
		levelComplete()
