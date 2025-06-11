extends Node2D

@onready var fade_layer: CanvasLayer = $NavigationRegion2D/TileMap/UI_Layer/FadeLayer

func _ready():
	await fade_layer.transition_with_scene_name("Scene: Grassland")
