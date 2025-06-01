extends Resource

class_name Item

enum ItemType { WEAPON, HELMET, ARMOR, BOOTS, medicine, food}
@export var name:String = ""
@export var number:int = 1
@export var type : ItemType
@export var describe:String = ""
@export var texture:Texture2D
@export var countble:bool = true

@export var attack : int = 0
@export var defense : int = 0
@export var health : int = 0
@export var speed : int = 0

@export var buy_price : int = 0
@export var sell_price : int = 0
