extends Node2D
class_name NPCBase

@export var npc_name: String = "Unnamed"
@export var dialogue_resource: Dialogies
@export var idle_animation_name: String = "idle"

signal dialogue_requested(dialogue: Dialogies)

func _ready():
	add_to_group("npcs")

	# 播放该 NPC 的专属动画
	if $AnimatedSprite2D.sprite_frames.has_animation(idle_animation_name):
		$AnimatedSprite2D.play(idle_animation_name)
	else:
		push_warning("NPC '" + npc_name + "' 的动画 '" + idle_animation_name + "' 不存在！")

	# 注册靠近检测事件
	if $Area2D:
		$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	else:
		push_warning("未找到 Area2D 节点，无法检测靠近对话")

func _on_body_entered(body: Node):
	if body.name == "player":
		print(dialogue_resource)
		emit_signal("dialogue_requested", dialogue_resource)
"res://art/avator/you.png"
