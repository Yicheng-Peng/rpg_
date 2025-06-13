extends Node2D

@onready var enter_button = $CenterContainer/create_new_game/enter
@onready var name_input = $CenterContainer/create_new_game/name

func _ready() -> void:
	enter_button.disabled = true
	name_input.connect("text_changed", Callable(self, "_on_name_text_changed"))
	$CenterContainer/setting_menu/voice_Slider.value = db_to_linear(AudioServer.get_bus_index("Master"))

func _on_name_text_changed(new_text: String) -> void:
	enter_button.disabled = new_text.strip_edges() == ""

func _on_new_play_pressed() -> void:
	$CenterContainer/main_button.visible = false
	$CenterContainer/create_new_game.visible = true
	
func _on_enter_pressed() -> void:
	if name_input.text.strip_edges() != "": 
		global.player_name = $CenterContainer/create_new_game/name.text
		get_tree().change_scene_to_file("res://scenes/world/new_game_introduction.tscn")
	else:
		print("Name cannot be empty!")

func _on_continue_play_pressed() -> void:
	var file := ConfigFile.new()
	var err = file.load_encrypted_pass("user://niuzi_game_save_data", global.key)
	if err != OK:
		show_error_popup("    No save data found. 
		Please start a new game.")
		return
	global.current_scene = file.get_value("scene", "current_scene", "world")

	global.player_name = file.get_value("player", "name")
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
	
func show_error_popup(message: String) -> void:
	var popup = $CenterContainer/main_button/continue_play/error_popup
	popup.get_node("Label").text = message
	popup.popup_centered()

	await get_tree().create_timer(2.0).timeout
	popup.hide()
