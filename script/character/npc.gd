extends Node2D
class_name NPCBase

@export var npc_name: String = "Unnamed"
@export var dialogue_resource: Dialogies
@export var idle_animation_name: String = "idle"

signal dialogue_requested(dialogue: Dialogies)

var player_in_range := false

func _ready():
	add_to_group("npcs")

	if $AnimatedSprite2D.sprite_frames.has_animation(idle_animation_name):
		$AnimatedSprite2D.play(idle_animation_name)

	if $Area2D:
		$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
		$Area2D.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node):
	if body.name == "player":
		player_in_range = true
		
func _on_body_exited(body: Node):
	if body.name == "player":
		player_in_range = false

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("continue_dialogue"):
		emit_signal("dialogue_requested", dialogue_resource)
		player_in_range = false
