extends Node2D


func _ready() -> void:
	
	$CenterContainer/setting_menu/voice_Slider.value = db_to_linear(AudioServer.get_bus_index("Master"))

func _on_new_play_pressed() -> void:
	$CenterContainer/main_button.visible = false
	$CenterContainer/create_new_game.visible = true
	
func _on_enter_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world/world_home.tscn")
	global.player_name = $CenterContainer/create_new_game/name.text

func _on_continue_play_pressed() -> void:
	var file := ConfigFile.new()
	var err = file.load_encrypted_pass("user://niuzi_game_save_data", global.key)
	if err != OK:
		print("❌ 读取失败")
		return
	global.current_scene = file.get_value("scene", "current_scene", "world")
	global.next_scene = file.get_value("scene", "next_scene", "")
	global.transition_scene = file.get_value("scene", "transition_scene", false)

	global.player_name = file.get_value("player", "name")
	global.grade_player = file.get_value("player", "grade")
	global.health_base = file.get_value("player", "health_base")
	global.health_now = file.get_value("player", "health_now")
	global.health_player = file.get_value("player", "health_player")
	global.attack_base = file.get_value("player", "attack_base")
	global.speed_base = file.get_value("player", "speed_base")
	global.denfense_base = file.get_value("player", "defense_base")

	global.health_add = file.get_value("bonus", "health_add")
	global.attack_add = file.get_value("bonus", "attack_add")
	global.speed_add = file.get_value("bonus", "speed_add")
	global.denfense_add = file.get_value("bonus", "defense_add")
	
	global.bag_inventory = file.get_value("bag","bag")

	print("✅ 游戏读取成功")
	
	get_tree().change_scene_to_file("res://scenes/world/world_home.tscn")

func _on_setting_pressed() -> void:
	$CenterContainer/main_button.visible = false
	$CenterContainer/setting_menu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	$CenterContainer/main_button.visible = true
	$CenterContainer/setting_menu.visible = false
	$CenterContainer/continue_play.visible = false
	$CenterContainer/create_new_game.visible = false
	$CenterContainer/help.visible = false


func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func _on_voice_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"),value)


func _on_help_pressed() -> void:
	$CenterContainer/main_button.visible = false
	$CenterContainer/help.visible = true
