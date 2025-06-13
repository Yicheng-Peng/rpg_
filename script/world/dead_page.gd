extends Node2D

@onready var color_rect = $ColorRect
@onready var label = $ColorRect/Label
@onready var button = $ColorRect/Button

func _ready():
	color_rect.modulate.a = 0.0
	label.visible = false
	button.visible = false
	await fade_in()
	label.visible = true
	button.visible = true
	button.connect("pressed", _on_button_pressed)

func _on_button_pressed():
	button.disabled = true
	await fade_out()
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func fade_in():
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 2.0)
	await tween.finished

func fade_out():
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, 2.0)
	await tween.finished
