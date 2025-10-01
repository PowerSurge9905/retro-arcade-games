extends Control

@onready var menu_select_sound: AudioStreamPlayer = $"../AudioStreamPlayer"

func _ready() -> void:
	menu_select_sound.play();

func _on_back_btn_pressed() -> void:
	menu_select_sound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://main_menu.tscn")
