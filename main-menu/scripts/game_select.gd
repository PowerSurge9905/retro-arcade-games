extends Control

@onready var menu_select_sound: AudioStreamPlayer = $"../AudioStreamPlayer"

func _ready() -> void:
	menu_select_sound.play();

func _on_back_btn_pressed() -> void:
	menu_select_sound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://main-menu/scenes/main_menu.tscn")

func _on_breakout_btn_pressed() -> void:
	menu_select_sound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://breakout/scenes/level.tscn")

func _on_star_sweeper_btn_pressed() -> void:
	menu_select_sound.play()
	await get_tree().create_timer(0.2).timeout
	print("Star Sweeper Game was selected!")
