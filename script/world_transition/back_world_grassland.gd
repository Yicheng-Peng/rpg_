extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.if_back = true
		get_tree().change_scene_to_file("res://scenes/world/world_glassland.tscn")
