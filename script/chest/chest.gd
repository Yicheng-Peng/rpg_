extends Area2D
class_name Chest

@export var items: Array[Item] = []
var is_opened := false

@onready var anim := $AnimatedSprite2D

func _ready():
	anim.play("close")
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "player" and not is_opened:
		open_chest(body)

func open_chest(player):
	is_opened = true
	anim.play("opening")
	for item in items:
		add_item_to_bag(item)

	await anim.animation_finished
	anim.play("open")

func add_item_to_bag(item: Item):
	var inventory = global.bag_inventory
	if inventory == null:
		return

	for i in range(1, inventory.items.size()):
		if inventory.items[i] == null:
			inventory.set_item(i, item.duplicate())
			show_item_popup("Got item：%s" % item.name)
			return
	
func show_item_popup(text: String):
	var label := Label.new()
	label.text = text
	
	var settings := LabelSettings.new()
	settings.font_size = 12  
	settings.font_color = Color(1, 1, 0)  
	label.label_settings = settings
	
	label.modulate.a = 0.9
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	label.position = Vector2(-70, -25)

	add_child(label)

	var tween := get_tree().create_tween()
	tween.tween_property(label, "position:y", label.position.y - 32, 1.2)
	tween.tween_property(label, "modulate:a", 0.0, 1.2)
	tween.tween_callback(label.queue_free)


func _on_to_world_home_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	pass
