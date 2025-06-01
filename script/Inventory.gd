extends Resource
class_name Inventory

@export var items: Array[Resource] = []
@export var name: String

signal item_changed(indexs)

func swap_item(index, target_index):
	var item = items[index]
	var target_item = items[target_index]
	if item is Item and target_item is Item and item.name == target_item.name:
		target_item.number += item.number
	else:
		items[target_index] = item
		items[index] = target_item
		emit_signal("item_changed",[index,target_index])
	
func remove_item(index):
	items[index] = null
	emit_signal("item_changed",[index])
	
func set_item(index,item,number):
	items[index] = item
	if item != null:
		items[index].number = number
	emit_signal("item_changed",[index])
