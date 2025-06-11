extends Node2D

@onready var fade_layer: CanvasLayer = $NavigationRegion2D/TileMap/UI_Layer/FadeLayer

func _ready():
	#await get_tree().create_timer(0.2).timeout
	await fade_layer.transition_with_scene_name("Scene: Home")
