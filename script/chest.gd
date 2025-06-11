extends Area2D
class_name Chest

@export var items: Array[Item] = []
var is_opened := false

@onready var anim := $AnimatedSprite2D

func _ready():
	anim.play("close")  # 默认关闭状态
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "player" and not is_opened:
		print("📦 玩家触发宝箱")
		open_chest(body)

func open_chest(player):
	is_opened = true
	anim.play("opening")  # 播放打开过程动画
	for item in items:
		add_item_to_bag(item)

	await anim.animation_finished
	anim.play("open")  # 播放打开后的静态动画

func add_item_to_bag(item: Item):
	var inventory = global.bag_inventory
	if inventory == null:
		print("⚠️ 背包未加载")
		return

	for i in range(1, inventory.items.size()):
		if inventory.items[i] == null:
			inventory.set_item(i, item.duplicate())
			print("📦 添加物品：%s" % item.name)
			
			# 👇 弹出提示信息
			show_item_popup("获得物品：%s" % item.name)
			return

	print("⚠️ 背包已满，无法获得：%s" % item.name)
	
func show_item_popup(text: String):
	var label := Label.new()
	label.text = text
	
	var settings := LabelSettings.new()
	settings.font_size = 12  # ✅ 更小字体
	settings.font_color = Color(1, 1, 0)  # 黄色
	label.label_settings = settings
	
	label.modulate.a = 0.9
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# ✅ 设置为相对于宝箱的局部坐标上方浮动
	label.position = Vector2(-70, -25)  # 比原来稍微近一点更协调

	add_child(label)

	# ✅ 添加浮动和淡出动画
	var tween := get_tree().create_tween()
	tween.tween_property(label, "position:y", label.position.y - 32, 1.2)
	tween.tween_property(label, "modulate:a", 0.0, 1.2)
	tween.tween_callback(label.queue_free)


func _on_to_world_home_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.
