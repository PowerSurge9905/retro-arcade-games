extends Control





func _on_options_btn_pressed() -> void:
	print("Options button was pressed")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_game_list_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://game-select.tscn")
