extends Control


@export_group("UI")
@export var character_name_text : Label
@export var text_box : Label
@export var left_avatar : TextureRect
@export var right_avatar : TextureRect

@export_group("dialogue")
@export var main_dialogue : Dialogies

var dialogue_index := 0
var typing_tween : Tween

func display_next_dialogue():
	if dialogue_index >= len(main_dialogue.dialogues):
		visible = false
		return
	
	var dialogue := main_dialogue.dialogues[dialogue_index]
	
	if typing_tween and typing_tween.is_running():
		typing_tween.kill()
		text_box.text = dialogue.content
		dialogue_index += 1
	else:
		character_name_text.text = dialogue.name
		
		typing_tween = get_tree().create_tween()
		text_box.text = ""
		for character in dialogue.content:
			typing_tween.tween_callback(append_character.bind(character)).set_delay(0.05)
		typing_tween.tween_callback(func():dialogue_index += 1)
		
		if dialogue.show_on_left:
			left_avatar.texture = dialogue.avatar
			right_avatar.texture = null
		else:
			left_avatar.texture = null
			right_avatar.texture = dialogue.avatar
	
func append_character(character : String):
	text_box.text += character
		
func _ready():
	# 监听所有 NPC 的 dialogue_requested 信号
	for npc in get_tree().get_nodes_in_group("npcs"):
		npc.connect("dialogue_requested", Callable(self, "start_dialogue_with"))
	
	# 初始隐藏对话框
	visible = false

func start_dialogue_with(dialogue_resource: Dialogies):
	main_dialogue = dialogue_resource
	dialogue_index = 0
	text_box.text = ""
	character_name_text.text = ""
	visible = true
	display_next_dialogue()

func _click(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		display_next_dialogue()
