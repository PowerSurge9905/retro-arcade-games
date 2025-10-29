extends Control

@onready var menu_select_sound: AudioStreamPlayer = $VBoxContainer/AudioStreamPlayer


func _on_options_btn_pressed() -> void:
	print("Options button was pressed")
	menu_select_sound.play()


func _on_quit_btn_pressed() -> void:
	menu_select_sound.play()
	get_tree().quit()


func _on_game_list_btn_pressed() -> void:
	
	get_tree().change_scene_to_file("res://game-select.tscn")
	
