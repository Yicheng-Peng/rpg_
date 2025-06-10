extends Control

func _ready():
	visible = false

func _process(delta):
	if Input.is_action_just_pressed("game_in_menu"):
		visible = !visible

func _on_save_pressed() -> void:
	var file = ConfigFile.new()
	file.set_value(global.player_name,"name",global.player_name)
	# 场景信息
	file.set_value("scene", "current_scene", global.current_scene)
	file.set_value("scene", "next_scene", global.next_scene)
	file.set_value("scene", "transition_scene", global.transition_scene)

	# 主角基本属性
	file.set_value("player", "name", global.player_name)
	file.set_value("player", "health_base", global.health_base)
	file.set_value("player", "health_now", global.health_now)
	file.set_value("player", "health_player", global.health_player)
	file.set_value("player", "attack_base", global.attack_base)
	file.set_value("player", "speed_base", global.speed_base)
	file.set_value("player", "defense_base", global.denfense_base)

	# 主角加成属性
	file.set_value("bonus", "health_add", global.health_add)
	file.set_value("bonus", "attack_add", global.attack_add)
	file.set_value("bonus", "speed_add", global.speed_add)
	file.set_value("bonus", "defense_add", global.denfense_add)
	
	file.set_value("bag","bag",global.bag_inventory)
	
	file.save_encrypted_pass("user://niuzi_game_save_data", global.key)
	print("saved!")

func _on_back_to_game_pressed() -> void:
	visible = false

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _on_help_pressed() -> void:
	$ColorRect/menu.visible = false
	$ColorRect/help.visible = true

func _on_back_pressed() -> void:
	$ColorRect/help.visible = false
	$ColorRect/menu.visible = true
