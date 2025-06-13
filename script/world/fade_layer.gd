extends CanvasLayer

@onready var rect = $ColorRect
@onready var label = $Label

func _ready():
	rect.hide()
	label.hide()
	global.can_action = false
func transition_with_scene_name(scene_name: String) -> void:
	rect.modulate.a = 1.0 
	rect.show()
	label.text = scene_name
	label.modulate.a = 0.0
	label.show()
	var tween_label = create_tween()
	tween_label.tween_property(label, "modulate:a", 1.0, 0.5)
	await tween_label.finished

	await get_tree().create_timer(1.0).timeout

	var tween_fade = create_tween()
	tween_fade.tween_property(rect, "modulate:a", 0.0, 0.5)
	tween_fade.tween_property(label, "modulate:a", 0.0, 0.5)
	await tween_fade.finished
	
	global.can_action = true
	label.hide()
	rect.hide()
