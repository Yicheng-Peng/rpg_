extends Resource
class_name Inventory

@export var items: Array[Resource] = []
@export var name: String

signal item_changed(indexs)

func swap_item(index, target_index):
	var item = items[index]
	var target_item = items[target_index]

	# 物品不再判断叠加，直接交换
	items[target_index] = item
	items[index] = target_item
	emit_signal("item_changed", [index, target_index])

func remove_item(index):
	items[index] = null
	emit_signal("item_changed", [index])

func set_item(index, item):
	items[index] = item
	emit_signal("item_changed", [index])
