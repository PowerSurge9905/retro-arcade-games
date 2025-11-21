extends Control

@onready var menu_select_sound: AudioStreamPlayer = $VBoxContainer/AudioStreamPlayer

# Exits application
func _on_quit_btn_pressed() -> void:
	menu_select_sound.play()
	get_tree().quit()

# Changes scene to games list
func _on_game_list_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main-menu/scenes/game-select.tscn")
	self.queue_free()
