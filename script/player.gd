extends CharacterBody2D

@onready var bag_system_scene = preload("res://scenes/bag/bag_system.tscn")  # 加载背包场景
var bag_instance : Control = null  # 背包实例
var is_bag_open : bool = false  # 背包是否打开的状态

#关于主角变量声明
var attack_ip = global.attack_ip_player
var current_dir = "right" #主角目前的方向

var slime_inattack_range = global.slime_inattack_range_player #主角被攻击范围内是否有史莱姆
var slime_attack_cooldown = global.slime_attack_cooldown_player #主角被史莱姆攻击是否冷却中

#关于敌人变量声明
var attack_by_slime = global.attack_slime #史莱姆攻击力

#初始站立状态
func _ready():
	$AnimatedSprite2D.play("idel_new")

#主角行为的处理器
func _physics_process(delta):
	if not is_bag_open:  # 只有当背包未打开时才处理主角行为
		player_movement(delta)
		be_attack_by_slime()
		attack()
		update_health()
		#current_cemera()
			
		if global.health_now <= 0:
			global.player_alive = false
			global.health_now = 0
			self.queue_free()
	
	# 按下 B 键时打开背包
	if Input.is_action_just_pressed("bag"):
		toggle_inventory()

# 切换背包的显示和隐藏
func toggle_inventory():
	if is_bag_open:
		# 如果背包已经打开，关闭它
		hide_inventory()
	else:
		# 如果背包没有打开，打开它
		open_inventory()
	is_bag_open = !is_bag_open

# 打开背包场景
func open_inventory():
	if bag_instance == null:
		bag_instance = bag_system_scene.instantiate()
		get_tree().current_scene.add_child(bag_instance)
		bag_instance.position = Vector2(575,310)
		# 暂停主场景更新
		set_process(false)  

func hide_inventory():  
	if bag_instance != null:      
		bag_instance.queue_free()  # 删除弹窗实例
		bag_instance = null
		# 恢复主场景更新
		set_process(true) 

func update_position():
	if global.current_scene == "world":
		position = Vector2(global.player_posx_world, global.player_posy_world)
	if global.current_scene == "world2":
		position = Vector2(global.player_posx_world2, global.player_posy_world2)

#处理主角移动
#func player_movement(delta):
	#if Input.is_action_pressed("right"):
		#current_dir ="right"
		#play_anim(1)
		#velocity.x = global.speed_base + global.speed_add
		#velocity.y = 0
	#elif Input.is_action_pressed("left"):
		#current_dir ="left"
		#play_anim(1)
		#velocity.x = -(global.speed_base + global.speed_add)
		#velocity.y = 0
	#elif Input.is_action_pressed("down"):
		#current_dir ="down"
		#play_anim(1)
		#velocity.y = global.speed_base + global.speed_add
		#velocity.x = 0
	#elif Input.is_action_pressed("up"):
		#current_dir ="up"
		#play_anim(1)
		#velocity.y = -(global.speed_base + global.speed_add)
		#velocity.x = 0
	#else:
		#play_anim(0)
		#velocity.x = 0
		#velocity.y = 0
#
	#move_and_slide()
	
func player_movement(delta):
	if Input.is_action_pressed("right") and can_action:
		current_dir ="right"
		play_anim(1)
		velocity.x = global.speed_base + global.speed_add
		velocity.y = 0
	elif Input.is_action_pressed("left") and can_action:
		current_dir ="left"
		play_anim(1)
		velocity.x = -(global.speed_base + global.speed_add)
		velocity.y = 0
	elif Input.is_action_pressed("down") and can_action:
		current_dir = "right"
		play_anim(1)
		velocity.y = global.speed_base + global.speed_add
		velocity.x = 0
	elif Input.is_action_pressed("up") and can_action:
		current_dir = "left"
		play_anim(1)
		velocity.y = -(global.speed_base + global.speed_add)
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

#处理主角移动的动画
#func play_anim(movement):
	#var dir = current_dir
	#var anim = $AnimatedSprite2D
	#
	#if dir == "right":
		#anim.flip_h = false
		#if movement == 1:
			#anim.play("side_walk")
		#elif movement == 0:
			#if attack_ip == false:
				#anim.play("side_idle")
			#
	#if dir == "left":
		#anim.flip_h = true
		#if movement == 1:
			#anim.play("side_walk")
		#elif movement == 0:
			#if attack_ip == false:
				#anim.play("side_idle")
			#
	#if dir == "down":
		#anim.flip_h = true
		#if movement == 1:
			#anim.play("front_walk")
		#elif movement == 0:
			#if attack_ip == false:
				#anim.play("front_idle")
			#
	#if dir == "up":
		#anim.flip_h = true
		#if movement == 1:
			#anim.play("back_walk")
		#elif movement == 0:
			#if attack_ip == false:
				#anim.play("back_idle")
				
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "left":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_new")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idel_new")
			
	if dir == "right":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_new")
		elif movement == 0:
			if attack_ip == false:
				anim.play("idel_new")

func player():
	pass

#被攻击范围内是否有敌人进入
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		slime_inattack_range = true

#被攻击范围内是否有敌人离开
func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		slime_inattack_range = false

#被史莱姆攻击
func be_attack_by_slime():
	if slime_inattack_range and slime_attack_cooldown == true:
		var be_damage = attack_by_slime - (global.denfense_base + global.denfense_add)
		if be_damage < 0:
			be_damage = 5
		global.health_now = global.health_now - be_damage
		slime_attack_cooldown = false
		$attack_cooldown.start()

#主角攻击
#func attack():
	#var dir = current_dir
	#if Input.is_action_just_pressed("attack"):
		#global.player_current_attack = true
		#attack_ip = true
		#if dir == "right":
			#$AnimatedSprite2D.flip_h = false
			#$AnimatedSprite2D.play("side_attack")
			#$deal_attack_timer.start()
		#if dir == "left":
			#$AnimatedSprite2D.flip_h = true
			#$AnimatedSprite2D.play("side_attack")
			#$deal_attack_timer.start()
		#if dir == "down":
			#$AnimatedSprite2D.play("front_attack")
			#$deal_attack_timer.start()
		#if dir == "up":
			#$AnimatedSprite2D.play("back_attack")
			#$deal_attack_timer.start()

var can_action = true  # 用于控制是否可以攻击或进行其他操作的标志

func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack") and can_action:
		global.player_current_attack = true
		attack_ip = true
		can_action = false
		$deal_attack_timer.wait_time = 0.9
		$deal_attack_timer.start()
		
		if dir == "left":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_new")
		if dir == "right":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_new")
		
		await $deal_attack_timer.timeout  # 等待定时器超时
		can_action = true

#主角主动攻击冷却
func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

#主角被史莱姆攻击冷却结束
func _on_attack_cooldown_timeout():
	slime_attack_cooldown = true

#主角血条更新
func update_health():
	var healthbar = $healthbar
	healthbar.value = global.health_now
	healthbar.visible = true
	

func _on_re_blood_timeout():
	if global.health_now < 100:
		global.health_now = global.health_now + 20
		if global.health_now > 100:
			global.health_now = 100
	if global.health_now <= 0:
		global.health_now = 0

#func current_cemera():
	#if global.current_scene == "world":
		#$world_cemara.enabled = true
		#$world_2_cemera.enabled = false
	#elif global.current_scene == "world_2":
		#$world_cemara.enabled = false
		#$world_2_cemera.enabled = true


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.
