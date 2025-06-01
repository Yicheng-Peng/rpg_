extends Control

var bag = preload("res://items/bag.tres")

@onready var bag_grid_container: GridContainer = $bag_ui/GridContainer
@onready var data_about_player_label: Label = $bag_ui/data_about_player
@onready var _0: Node2D = $"bag_ui/GridContainer/0"

@onready var _21_sword: ColorRect = $"bag_ui/GridContainer/21"
@onready var _22_helmet: ColorRect = $"bag_ui/GridContainer/22"
@onready var _23_armor: ColorRect = $"bag_ui/GridContainer/23"
@onready var _24_boots: ColorRect = $"bag_ui/GridContainer/24"

# 存储格子 21-24 中的物品（通过格子的索引）
var slot_items = {}

# 保存上一次装备的状态
var last_equipped_items = {
	"weapon": null,
	"helmet": null,
	"armor": null,
	"boots": null
}


func _ready():
	update_data_about_player()
	for index in bag_grid_container.get_children().size():
		update_slot(index)
		if index == 0:
			continue
		bag_grid_container.get_child(index).gui_input.connect(Callable(self,"_on_gui_input").bind(index))
		
	bag.item_changed.connect(Callable(self,"update_slot"))
	
	update_slots_position()

func _process(delta:float):
	_0.global_position = get_global_mouse_position()
	update_slots_position()
	
func update_slot(indexes):
	for index in indexes:
		bag_grid_container.get_child(index).set_item(bag.items[index])
	
func update_equip():
	var weapon_item = bag.items[21]
	var helmet_item = bag.items[22]
	var armor_item = bag.items[23]
	var boots_item = bag.items[24]
	
	# 判断装备是否发生变化
	var has_changes = false
# 判断武器装备是否变化
	if weapon_item != last_equipped_items["weapon"]:
		last_equipped_items["weapon"] = weapon_item
		has_changes = true
		
	# 判断头盔装备是否变化
	if helmet_item != last_equipped_items["helmet"]:
		last_equipped_items["helmet"] = helmet_item
		has_changes = true
		
	# 判断盔甲装备是否变化
	if armor_item != last_equipped_items["armor"]:
		last_equipped_items["armor"] = armor_item
		has_changes = true
		
	# 判断靴子装备是否变化
	if boots_item != last_equipped_items["boots"]:
		last_equipped_items["boots"] = boots_item
		has_changes = true
		
	# 如果装备发生了变化，才更新属性
	if has_changes:
		var add_attack = 0
		var add_denfense = 0
		var add_health = 0
		var add_speed = 0
		global.attack_add = 0
		global.health_add = 0
		global.denfense_add = 0
		global.speed_add = 0

		if weapon_item != null:      
			add_attack += weapon_item.attack        
			add_denfense += weapon_item.defense       
			add_health += weapon_item.health       
			add_speed += weapon_item.speed
		
		if helmet_item != null:              
			add_attack += helmet_item.attack        
			add_denfense += helmet_item.defense       
			add_health += helmet_item.health       
			add_speed += helmet_item.speed
	  
		if armor_item != null:             
			add_attack += armor_item.attack        
			add_denfense += armor_item.defense       
			add_health += armor_item.health       
			add_speed += armor_item.speed
	  
		if boots_item != null:              
			add_attack += boots_item.attack        
			add_denfense += boots_item.defense       
			add_health += boots_item.health     
			add_speed += boots_item.speed
	
		global.attack_add += add_attack
		global.denfense_add += add_denfense
		global.health_add += add_health
		global.speed_add += add_speed
	
	update_data_about_player()


func update_data_about_player():
	data_about_player_label.text = "grade: " + str(global.grade_player) + "  \nHealth: " + str(global.health_now) + "/" +str(global.health_base + global.health_add) + "\nattack: " + str(global.attack_base + global.attack_add) + "  \ndenfense: " + str(global.denfense_base + global.denfense_add) + "\nspeed: " + str(global.speed_base + global.speed_add)

func _on_gui_input(event,index):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			bag.swap_item(0,index)
			update_equip()

func update_slots_position():
	_21_sword.global_position = Vector2(255,40)
	_22_helmet.global_position = Vector2(345,40)
	_23_armor.global_position = Vector2(255,80)
	_24_boots.global_position = Vector2(345,80)
