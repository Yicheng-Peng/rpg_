extends Node2D

func _ready():
	$player.position = Vector2(global.player_posx_world2, global.player_posy_world2)

func _process(delta):
	change_scene_world2_to_world()

func _on_switch_to_world_body_entered(body):
	if body.has_method("player"):
		global.next_scene = "world"
		global.transition_scene = true


func _on_switch_to_world_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene_world2_to_world():
	global.player_posx_world = 451
	global.player_posy_world = 88 #从世界2进入世界1的坐标
	if global.transition_scene == true:
		if global.current_scene == "world_2" and global.next_scene == "world":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			exchange()

func exchange():
	global.transition_scene = false
	global.current_scene = global.next_scene
	global.next_scene = ""
