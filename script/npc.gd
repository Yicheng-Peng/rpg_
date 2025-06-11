extends Node2D
class_name NPCBase

@export var npc_name: String = "Unnamed"
@export var dialogue_resource: Dialogies
@export var idle_animation_name: String = "idle"

signal dialogue_requested(dialogue: Dialogies)

var player_in_range := false  # 标记玩家是否在范围内

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
		$Area2D.connect("body_exited", Callable(self, "_on_body_exited"))
	else:
		push_warning("未找到 Area2D 节点，无法检测靠近对话")

func _on_body_entered(body: Node):
	if body.name == "player":
		player_in_range = true
		
func _on_body_exited(body: Node):
	if body.name == "player":
		player_in_range = false

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("continue_dialogue"):
		print("触发对话：", dialogue_resource)
		emit_signal("dialogue_requested", dialogue_resource)
		player_in_range = false
