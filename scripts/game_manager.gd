extends Node
#This script keeps track of the player's score and displays it during play

var score = 0
var level = 1

# Is called by res://scripts/ball.gd upon hitting a brick
func addPoints(points):
	score += points

# Updates the score number in the game
func _process(delta: float) -> void:
	$CanvasLayer/ScoreLabel.text = "Score: " + str(score)
	$CanvasLayer/LevelLabel.text = "Level: " + str(level)
