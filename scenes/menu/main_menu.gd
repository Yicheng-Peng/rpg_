extends Node2D


func _ready() -> void:
	
	$CenterContainer/setting_menu/voice_Slider.value = db_to_linear(AudioServer.get_bus_index("Master"))

func _on_new_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world/world_home.tscn")


func _on_continue_play_pressed() -> void:
	$CenterContainer/main_button.visible = false
	$CenterContainer/continue_play.visible = true

func _on_setting_pressed() -> void:
	$CenterContainer/main_button.visible = false
	$CenterContainer/setting_menu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	$CenterContainer/main_button.visible = true
	$CenterContainer/setting_menu.visible = false
	$CenterContainer/continue_play.visible = false


func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func _on_voice_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"),value)
