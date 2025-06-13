extends Node2D

@onready var fade_layer: CanvasLayer = $FadeLayer
@onready var player = $NavigationRegion2D/TileMap/player

func _ready():
	if global.if_back == true:
		player.position = Vector2(200, 200)
		global.if_back = false
	await fade_layer.transition_with_scene_name("Scene: Dark World")

func _process(delta):
	if all_enemies_defeated():
		await fade_layer.transition_with_scene_name("You Win")
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func all_enemies_defeated() -> bool:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy != null:
			return false 
	return true
