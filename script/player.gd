extends CharacterBody2D

# 关于主角变量声明
var attack_ip = global.attack_ip_player
var current_dir = "right"
var slime_inattack_range = global.slime_inattack_range_player
var slime_attack_cooldown = global.slime_attack_cooldown_player
var attack_by_slime = global.attack_slime

var can_action = true  # 控制是否可以攻击或其他操作

# 初始动画
func _ready():
	$AnimatedSprite2D.play("idel_new")

# 主角行为逻辑
func _physics_process(delta):
	player_movement(delta)
	be_attack_by_slime()
	attack()
	update_health()

	if global.health_now <= 0:
		global.player_alive = false
		global.health_now = 0
		self.queue_free()

# 主角移动
func player_movement(delta):
	if Input.is_action_pressed("right") and can_action:
		current_dir = "right"
		play_anim(1)
		velocity.x = global.speed_base + global.speed_add
		velocity.y = 0
	elif Input.is_action_pressed("left") and can_action:
		current_dir = "left"
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
		velocity = Vector2.ZERO

	move_and_slide()

# 播放动画
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D

	if dir == "left":
		anim.flip_h = false
		if movement == 1:
			anim.play("walk_new")
		elif movement == 0 and not attack_ip:
			anim.play("idel_new")

	elif dir == "right":
		anim.flip_h = true
		if movement == 1:
			anim.play("walk_new")
		elif movement == 0 and not attack_ip:
			anim.play("idel_new")

# 攻击逻辑
func attack():
	if Input.is_action_just_pressed("attack") and can_action:
		global.player_current_attack = true
		attack_ip = true
		can_action = false
		$deal_attack_timer.wait_time = 0.9
		$deal_attack_timer.start()

		if current_dir == "left":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_new")
		elif current_dir == "right":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_new")

		await $deal_attack_timer.timeout
		can_action = true

# 攻击冷却结束
func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

# 史莱姆攻击主角逻辑
func be_attack_by_slime():
	if slime_inattack_range and slime_attack_cooldown:
		var be_damage = attack_by_slime - (global.denfense_base + global.denfense_add)
		if be_damage < 0:
			be_damage = 5
		global.health_now -= be_damage
		slime_attack_cooldown = false
		$attack_cooldown.start()

# 史莱姆攻击冷却结束
func _on_attack_cooldown_timeout():
	slime_attack_cooldown = true

# 血条更新
func update_health():
	$healthbar.value = global.health_now
	$healthbar.visible = true

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		slime_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		slime_inattack_range = false

func _on_re_blood_timeout():
	if global.health_now < 100:
		global.health_now += 20
		if global.health_now > 100:
			global.health_now = 100
	if global.health_now <= 0:
		global.health_now = 0
