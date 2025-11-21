extends Control

@onready var sound_exit = $ExitSoundPlayer

# Centers pause menu position
# Hides the pause menu and countdown on start, then starts countdown
func _ready() -> void:
	position = $"../../Camera2D".position
	position.x -= 116
	$PauseContainer.visible = false
	$CountdownContainer.visible = false
	$GameOverContainer.visible = false
	countdown()

# Resumes play
func resume():
	$PauseContainer.visible = false
	get_tree().paused = false

# Pauses play
func pause():
	if BreakoutGameManager.canPause:
		get_tree().paused = true
		$PauseContainer.visible = true

# A countdown to the game starting
# Gives the player a moment to analyze the game
func countdown():
	BreakoutGameManager.canPause = false
	$CountdownContainer.visible = true
	$"CountdownContainer/CountdownLabel".text = "READY?"
	await get_tree().create_timer(2).timeout
	$"CountdownContainer/CountdownLabel".text = "3"
	await get_tree().create_timer(0.5).timeout
	$"CountdownContainer/CountdownLabel".text = "2"
	await get_tree().create_timer(0.5).timeout
	$"CountdownContainer/CountdownLabel".text = "1"
	await get_tree().create_timer(0.5).timeout
	$"CountdownContainer/CountdownLabel".text = "GO!"
	await get_tree().create_timer(1).timeout
	$CountdownContainer.visible = false
	BreakoutGameManager.canPause = true

# Shows a message on level completion
func levelComplete():
	BreakoutGameManager.canPause = false
	$"CountdownContainer/CountdownLabel".text = "LEVEL CLEARED!"
	$CountdownContainer.visible = true
	await get_tree().create_timer(3).timeout
	$CountdownContainer.visible = false
	BreakoutGameManager.canPause = true

func gameOver():
	BreakoutGameManager.canPause = false
	$GameOverContainer/GameOverLabel.text = "GAME OVER"
	$GameOverContainer.visible = true
	await get_tree().create_timer(3).timeout
	$GameOverContainer.visible = false
	BreakoutGameManager.canPause = true

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

# Sends player back to main menu
# Resets Breakout
func _on_quit_button_pressed() -> void:
	BreakoutGameManager.killBreakout()
	resume()
	get_tree().change_scene_to_file("res://main-menu/scenes/main_menu.tscn")

# Constantly checks for an escape button press, level start countdown, or level completion
func _process(_delta):
	escPress()
	
	if BreakoutGameManager.startCountdown:
		BreakoutGameManager.startCountdown = false
		countdown()
	
	if BreakoutGameManager.levelComplete:
		BreakoutGameManager.levelComplete = false
		levelComplete()
	
	if BreakoutGameManager.gameOver:
		BreakoutGameManager.gameOver = false
		gameOver()
