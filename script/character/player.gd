extends CharacterBody2D
class_name Player

var attack_ip := false
var current_dir = "right"
var attacking_enemies := {}

@onready var anim = $AnimatedSprite2D
@onready var healthbar = $healthbar

@export var initial_position: Vector2

func _ready():
	healthbar.max_value = global.health_base + global.health_add
	anim.play("idel_new")
	anim.connect("frame_changed", Callable(self, "_on_frame_changed"))


func _physics_process(delta):
	
	if global.player_alive == false:
		return
	
	player_movement(delta)
	attack()
	update_health()

	if global.health_now <= 0:
		global.player_alive = false
		global.health_now = 0
		global.can_action = false
		velocity = Vector2.ZERO
		anim.play("die")

		while anim.is_playing():
			await get_tree().create_timer(0.1).timeout

		get_tree().change_scene_to_file("res://scenes/menu/dead_page.tscn")

		

func player_movement(delta):
	if Input.is_action_pressed("right") and global.can_action:
		current_dir = "right"
		play_anim(1)
		velocity.x = global.speed_base + global.speed_add
		velocity.y = 0
	elif Input.is_action_pressed("left") and global.can_action:
		current_dir = "left"
		play_anim(1)
		velocity.x = -(global.speed_base + global.speed_add)
		velocity.y = 0
	elif Input.is_action_pressed("down") and global.can_action:
		play_anim(1)
		velocity.y = global.speed_base + global.speed_add
		velocity.x = 0
	elif Input.is_action_pressed("up") and global.can_action:
		play_anim(1)
		velocity.y = -(global.speed_base + global.speed_add)
		velocity.x = 0
	else:
		play_anim(0)
		velocity = Vector2.ZERO

	move_and_slide()


func play_anim(movement):
	if current_dir == "left":
		anim.flip_h = false
	elif current_dir == "right":
		anim.flip_h = true

	if movement == 1:
		anim.play("walk_new")
	elif movement == 0 and not attack_ip:
		anim.play("idel_new")

func attack():
	if Input.is_action_just_pressed("attack") and global.can_action:
		attack_ip = true
		global.can_action = false

		$deal_attack_timer.wait_time = 0.9
		$deal_attack_timer.start()

		if current_dir == "left":
			anim.flip_h = false
			anim.play("attack_new")
		elif current_dir == "right":
			anim.flip_h = true
			anim.play("attack_new")

		await $deal_attack_timer.timeout

func _on_frame_changed():
	if anim.animation == "attack_new" and anim.frame == 5:
		perform_attack_hit()

func perform_attack_hit():
	global.player_current_attack = true
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.player_in_attack_range:
			enemy.be_damaged()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
	global.can_action = true

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		body.enemy_inattack_range = true

		if not attacking_enemies.has(body):
			var timer = Timer.new()
			timer.wait_time = 0.5
			timer.one_shot = false
			timer.autostart = true
			timer.connect("timeout", Callable(self, "_on_enemy_attack_timeout").bind(body))
			add_child(timer)
			attacking_enemies[body] = timer

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		body.enemy_inattack_range = false

		if attacking_enemies.has(body):
			attacking_enemies[body].queue_free()
			attacking_enemies.erase(body)

func _on_enemy_attack_timeout(body):
	if body.enemy_inattack_range and body.enemy_attack_cooldown:
		be_attack_by_enemy(body)

func be_attack_by_enemy(body):
	if body.enemy_inattack_range and body.enemy_attack_cooldown:
		var be_damage = body.damage - (global.denfense_base + global.denfense_add)
		if be_damage < 0:
			be_damage = 5
		global.health_now -= be_damage
		body.enemy_attack_cooldown = false

		var timer = Timer.new()
		timer.wait_time = 0.5
		timer.one_shot = true
		timer.connect("timeout", Callable(self, "_on_enemy_cooldown_reset").bind(body))
		add_child(timer)
		timer.start()

func _on_enemy_cooldown_reset(body):
	if is_instance_valid(body):
		body.enemy_attack_cooldown = true


func update_health():
	$healthbar.value = global.health_now
	$healthbar.visible = true

func player():
	pass
