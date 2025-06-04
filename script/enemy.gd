extends CharacterBody2D
class_name Enemy

@export var enemy_name: String = "UnnamedEnemy"
@export var max_health: int = 100
@export var speed: float = 40.0
@export var damage: int = 10

@export var walk_animation: String = "walk"
@export var idle_animation: String = "idle"
@export var dead_animation: String = "dead"

enum State { PATROL, CHASE }

var state = State.PATROL

var health: int
var player_chase: bool = false
var player_in = null
var player_in_attack_range: bool = false
var can_take_damage := true
var enemy_inattack_range := false
var enemy_attack_cooldown := true

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var patrol_radius: float = 200
@export var patrol_speed: float = 50
var patrol_target: Vector2

func _ready():
	health = max_health
	add_to_group("enemies")
	_set_random_patrol_target()
	$AnimatedSprite2D.play(idle_animation)

func _physics_process(delta):
	update_health()
	be_damaged()

	match state:
		State.PATROL:
			_process_patrol(delta)
		State.CHASE:
			_process_chase(delta)

# 等待状态控制变量
var is_waiting := false
var wait_timer := 0.0
var flip_timer := 0.0
var look_dir := 1  # 用于左右切换

func _process_patrol(delta):
	if is_waiting:
		wait_timer -= delta
		flip_timer -= delta

		if flip_timer <= 0.0:
			look_dir *= -1
			$AnimatedSprite2D.flip_h = look_dir < 0
			flip_timer = 0.5

		$AnimatedSprite2D.play(idle_animation)

		if wait_timer <= 0.0:
			is_waiting = false
			_set_random_patrol_target()
		return

	# 检测路径是否走完
	if nav_agent.is_navigation_finished():
		is_waiting = true
		wait_timer = 2.0
		flip_timer = 0.5
		look_dir = 1
		return

	# 正常移动
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * patrol_speed
	move_and_slide()

	# 🧠 检测“几乎卡住”就重新选目标
	if velocity.length() < 2.0:  # 可调节阈值
		print("⚠️ 巡逻卡住，重选目标")
		is_waiting = true
		wait_timer = 1.0
		flip_timer = 0.5
		look_dir = 1
		return

	# 正常播放走路动画
	$AnimatedSprite2D.play(walk_animation)
	$AnimatedSprite2D.flip_h = direction.x < 0

func _set_random_patrol_target():
	var offset = Vector2(
		randf_range(-patrol_radius, patrol_radius),
		randf_range(-patrol_radius, patrol_radius)
	)
	patrol_target = global_position + offset
	nav_agent.set_target_position(patrol_target)

func _process_chase(delta):
	# ✅ 如果主角已在攻击范围内，不再移动
	if player_in_attack_range:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play(idle_animation)
		return

	# 设置当前追击目标为主角位置
	if player_in:
		nav_agent.set_target_position(player_in.global_position)

	# 获取路径上的下一个点
	if not nav_agent.is_navigation_finished():
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		$AnimatedSprite2D.play(walk_animation)
		$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		# 如果路径走完（贴身），就站立
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play(idle_animation)


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in = body
		state = State.CHASE

func _on_detection_area_body_exited(body):
	if body == player_in:
		player_in = null
		state = State.PATROL
		_set_random_patrol_target()

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_range = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_range = false

func be_damaged():
	if player_in_attack_range and global.player_current_attack and can_take_damage:
		health -= (global.attack_base + global.attack_add)
		can_take_damage = false
		$take_damage_cooldown.start()
		
		if health <= 0:
			# 播放死亡动画并禁用行为
			velocity = Vector2.ZERO
			set_physics_process(false)
			$AnimatedSprite2D.play(dead_animation)
			$AnimatedSprite2D.frame = 0  # 重置动画
			await $AnimatedSprite2D.animation_finished
			queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func update_health():
	var healthbar = $healthbar_enemy
	healthbar.value = health
	healthbar.visible = health < max_health

func enemy():
	pass
