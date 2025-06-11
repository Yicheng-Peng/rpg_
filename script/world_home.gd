extends Node2D

@onready var fade_layer: CanvasLayer = $FadeLayer

func _ready():
	await fade_layer.transition_with_scene_name("Scene: Home")
