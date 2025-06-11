extends Node2D

@onready var dialogue = $ColorRect/Dialogue
@export var dialogue_resource: Dialogies

func _ready() -> void:
	dialogue.visible = true
	await dialogue.start_dialogue_with_yield(dialogue_resource) 
	get_tree().change_scene_to_file("res://scenes/world/world_home.tscn")
