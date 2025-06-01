extends Node

var current_scene = "world"
var next_scene = ""
var transition_scene = false

var player_posx_world = 10
var player_posy_world = 36

var player_posx_world2 = 28
var player_posy_world2 = 110

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

var slime_inattack_range_player = false #主角被攻击范围内是否有史莱姆
var slime_attack_cooldown_player = true #主角被史莱姆攻击是否冷却中

#关于史莱姆的变量声明
const health_slime = 100 #史莱姆血量
const attack_slime = 10 #史莱姆攻击力
const speed_slime = 60 #史莱姆速度
