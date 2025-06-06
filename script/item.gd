extends Resource

class_name Item

enum ItemType { WEAPON, HELMET, ARMOR, BOOTS, medicine}
@export var name:String = ""
@export var type : ItemType
@export var describe:String = ""
@export var texture:Texture2D

@export var attack : int = 0
@export var defense : int = 0
@export var health : int = 0
@export var speed : int = 0

@export var medecine_add_health : int = 0
