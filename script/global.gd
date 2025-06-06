extends Node

var current_scene = "world"
var next_scene = ""
var transition_scene = false

#关于主角变量声明
var grade_player = 1 #主角的等级

var health_base = 100 #主角的基础血量
var health_now = 100
var health_player = 100 #主角目前血量
var attack_base = 50 #主角基础攻击力
var speed_base = 100 #主角基础速度
var denfense_base = 0 #主角的基础防御力

var health_add = 0 #头盔增加的血量
var attack_add = 0 #武器增加的攻击力
var speed_add = 0 #鞋子增加的速度
var denfense_add = 0 #盔甲增加的防御力

var player_alive = true #主角是否存活
var attack_ip_player = false 
var player_current_attack = false #主角现在是否能攻击

var bag_inventory: Inventory = null
