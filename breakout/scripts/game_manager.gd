extends Node
#This script keeps track of the player's score & save data

var high_score = 0
var score = 0
var level = 1

func _ready() -> void:
	loadGame()

# Is called by res://scripts/ball.gd upon hitting a brick,
# checks if high_score should be increased
func addPoints(points):
	score += points
	if score > high_score:
		high_score = score

# Converts the previous game's score and the high score into a dictionary
# Expand to saving 5 highest scores while connecting the game to the main menu
func saveScore():
	var save_dict = {
		"recent_game_score" : score,
		"high_score" : high_score
	}
	return save_dict

# Writes the save_dict dictionary to a JSON file
func saveGame():
	# Opens the save file in write mode, creates a new file if one is not found
	var save_file = FileAccess.open("user://breakout_save.save", FileAccess.WRITE)
	var json_string = JSON.stringify(saveScore())
	save_file.store_line(json_string)

# Parses save file contents into a dictionary, assigns high_score if there is relevant data
func loadGame():
	# Checks if the save file exists
	if not FileAccess.file_exists("user://breakout_save.save"):
		return # Error - The save file is missing, misnamed, or otherwise inaccessible
	
	# Opens the save file in read mode
	var save_file = FileAccess.open("user://breakout_save.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		
		# Creates a JSON object to parse save file data
		var json = JSON.new()
		
		# Checks for errors parsing the save file
		# Just a debugging tool
		var parse_results = json.parse(json_string)
		if not parse_results == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		# Assigns json data to a dictionary
		var save_data = json.data
		
		# Assigns high_score
		high_score = int(save_data["high_score"])

# Updates the score number in the game
func _process(delta: float) -> void:
	$CanvasLayer/ScoreLabel.text = "Score: " + str(score)
	$CanvasLayer/LevelLabel.text = "Level: " + str(level)
	$CanvasLayer/HighScoreLabel.text = "High Score: " + str(high_score)
