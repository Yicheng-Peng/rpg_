extends Control

var bag = preload("res://Resource/items/bag.tres")

@onready var bag_grid_container: GridContainer = $bag_ui/GridContainer
@onready var data_about_player_label: Label = $bag_ui/data_about_player
@onready var _0: Node2D = $"bag_ui/GridContainer/0"

@onready var _21_sword: ColorRect = $"bag_ui/GridContainer/21"
@onready var _22_helmet: ColorRect = $"bag_ui/GridContainer/22"
@onready var _23_armor: ColorRect = $"bag_ui/GridContainer/23"
@onready var _24_boots: ColorRect = $"bag_ui/GridContainer/24"

var slot_items = {}
var last_equipped_items = {
	"weapon": null,
	"helmet": null,
	"armor": null,
	"boots": null
}

func _ready():
	global.bag_inventory = bag
	visible = false
	update_data_about_player()
	for index in bag_grid_container.get_children().size():
		update_slot(index)
		if index == 0:
			continue
		bag_grid_container.get_child(index).gui_input.connect(Callable(self, "_on_gui_input").bind(index))

	bag.item_changed.connect(Callable(self, "update_slot"))
	update_slots_position()

func _process(delta: float) -> void:
	_0.global_position = get_global_mouse_position()
	update_slots_position()
	update_data_about_player()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("bag"):
		visible = !visible

func update_slot(indexes):
	for index in indexes:
		bag_grid_container.get_child(index).set_item(bag.items[index])

func update_equip():
	var weapon_item = bag.items[21]
	var helmet_item = bag.items[22]
	var armor_item = bag.items[23]
	var boots_item = bag.items[24]

	var has_changes = false

	if weapon_item != last_equipped_items["weapon"]:
		last_equipped_items["weapon"] = weapon_item
		has_changes = true
	if helmet_item != last_equipped_items["helmet"]:
		last_equipped_items["helmet"] = helmet_item
		has_changes = true
	if armor_item != last_equipped_items["armor"]:
		last_equipped_items["armor"] = armor_item
		has_changes = true
	if boots_item != last_equipped_items["boots"]:
		last_equipped_items["boots"] = boots_item
		has_changes = true

	if has_changes:
		var add_attack = 0
		var add_defense = 0
		var add_health = 0
		var add_speed = 0

		global.attack_add = 0
		global.health_add = 0
		global.denfense_add = 0
		global.speed_add = 0

		for item in [weapon_item, helmet_item, armor_item, boots_item]:
			if item != null:
				add_attack += item.attack
				add_defense += item.defense
				add_health += item.health
				add_speed += item.speed

		global.attack_add += add_attack
		global.denfense_add += add_defense
		global.health_add += add_health
		global.speed_add += add_speed

	update_data_about_player()

	# ✅ 检查是否有 medicine 装到了装备格子，立即使用
	for index in [21, 22, 23, 24]:
		var item = bag.items[index]
		if item != null and item is Item and item.type == Item.ItemType.medicine:
			var heal_amount = item.medecine_add_health
			global.health_now = min(global.health_now + heal_amount, global.health_base + global.health_add)
			print("❤️ 使用药品（格子 %d），恢复血量：%d" % [index, heal_amount])
			bag.remove_item(index)
			update_data_about_player()

func update_data_about_player():
	data_about_player_label.text = "Health: " + str(global.health_now) + "/" + str(global.health_base + global.health_add) + "\nattack: " + str(global.attack_base + global.attack_add) + "  \ndenfense: " + str(global.denfense_base + global.denfense_add) + "\nspeed: " + str(global.speed_base + global.speed_add)

func _on_gui_input(event, index):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			bag.swap_item(0, index)
			update_equip()


func update_slots_position():
	var sprite = $bag_ui/AnimatedSprite2D
	var texture: Texture2D = sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
	var sprite_size = texture.get_size()
	var center = sprite.global_position + Vector2(-45, -70)
	var offset = Vector2(75, 40)

	var top_left = center - sprite_size / 2 - offset
	var top_right = center + Vector2(sprite_size.x / 2, -sprite_size.y / 2) + Vector2(offset.x, -offset.y)
	var bottom_left = center + Vector2(-sprite_size.x / 2, sprite_size.y / 2) + Vector2(-offset.x, offset.y)
	var bottom_right = center + sprite_size / 2 + offset

	_22_helmet.global_position = top_left
	_21_sword.global_position = top_right
	_23_armor.global_position = bottom_left
	_24_boots.global_position = bottom_right
