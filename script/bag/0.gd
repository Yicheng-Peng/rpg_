extends Node2D

@onready var sprite_2d:Sprite2D = $Sprite2D
@onready var label:Label = $Label

func set_item(item: Item):
	if item != null:
		sprite_2d.texture = item.texture
		label.text = ""
	else:
		sprite_2d.texture = null
		label.text = ""
