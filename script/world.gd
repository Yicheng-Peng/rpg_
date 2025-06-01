extends Node2D

func _ready():
	$player.position = Vector2(global.player_posx_world, global.player_posy_world)

func _process(delta):
	change_scene_world_to_world2()

func _on_switch_to_world_2_body_entered(body):
	if body.has_method("player"):
		global.next_scene = "world_2"
		global.transition_scene = true

func _on_switch_to_world_2_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene_world_to_world2():
	if global.transition_scene == true:
		if global.current_scene == "world" and global.next_scene == "world_2":
			get_tree().change_scene_to_file("res://scenes/world_2.tscn")
			exchange()
			
func exchange():
	global.transition_scene = false
	global.current_scene = global.next_scene
	global.next_scene = ""
