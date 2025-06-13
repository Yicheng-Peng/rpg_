extends Node

var current_scene = ""
var current_scene_name = ""

var player_name = null

var health_base = 200
var health_now = 200
var health_player = 200 
var attack_base = 60 
var speed_base = 100
var denfense_base = 0 

var health_add = 0 
var attack_add = 0 
var speed_add = 0 
var denfense_add = 0 

var player_alive = true 
var can_action = true

var attack_ip_player = false 
var player_current_attack = false

var bag_inventory: Inventory = null

var key = "niuzi"

var if_back = false
