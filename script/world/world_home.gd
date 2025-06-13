extends Node2D

@onready var fade_layer: CanvasLayer = $FadeLayer
@onready var player = $NavigationRegion2D/TileMap/player

func _ready():
	
	if global.if_back == true:
		player.position = Vector2(528,34)
		global.if_back = false
		
	await fade_layer.transition_with_scene_name("Scene: Home")
