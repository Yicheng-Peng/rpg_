extends CharacterBody2D
class_name Enemy

@export var enemy_name: String = "UnnamedEnemy"
@export var max_health: int = 100
@export var speed: float = 40.0
@export var damage: int = 10

@export var walk_animation: String = "walk"
@export var idle_animation: String = "idle"
@export var dead_animation: String = "dead"
@export var attack_animation: String = "attack"
@export var be_attack_animation: String = "be_attack"

@export var patrol_radius: float = 200
@export var patrol_speed: float = 50

enum State { IDLE, LOOK_AROUND, PATROL, CHASE, LOST_TARGET }
var state = State.IDLE

var health: int
var player_in = null
var player_in_attack_range: bool = false
var can_take_damage := true
var enemy_inattack_range := false
var enemy_attack_cooldown := true
var is_dead := false


@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite := $AnimatedSprite2D
@onready var healthbar = $healthbar_enemy

@export var patrol_memory_distance := 50.0 
@export var max_patrol_memory := 5

var recent_patrol_points: Array = []


var patrol_target: Vector2
var is_waiting := false
var wait_timer := 0.0
var flip_timer := 0.0
var look_dir := 1

var behavior_tree = {}

func _ready():
	healthbar.max_value = max_health
	health = max_health
	add_to_group("enemies")
	setup_behavior_tree()
	change_state(State.PATROL)

func setup_behavior_tree():
	behavior_tree = {
		"root": func() -> String:
			if is_dead:
				return "death"
			elif health <= (max_health * 0.3):
				return "flee"
			elif player_in:
				return "chase"
			elif state == State.LOST_TARGET:
				return "look_around"
			else:
				return "patrol",
		"patrol": func(): _process_patrol(get_process_delta_time()),
		"chase": func(): _process_chase(get_process_delta_time()),
		"look_around": func(): _process_lost_target(get_process_delta_time()),
		"flee": func(): _process_flee(get_process_delta_time()),
		"death": func(): _process_death(get_process_delta_time())
	}

func _physics_process(delta):
	update_health()
	be_damaged()
	evaluate_behavior_tree()

func evaluate_behavior_tree():
	var decision = behavior_tree["root"].call()
	if behavior_tree.has(decision):
		behavior_tree[decision].call()
	else:
		sprite.play(idle_animation)

func change_state(new_state):
	if state != new_state:
		state = new_state
		is_waiting = false
		wait_timer = 0
		flip_timer = 0
		
func _process_patrol(delta):
	change_state(State.PATROL)
	if is_waiting:
		wait_timer -= delta
		flip_timer -= delta
		if flip_timer <= 0.0:
			look_dir *= -1
			sprite.flip_h = look_dir < 0
			flip_timer = 0.5
		sprite.play(idle_animation)
		if wait_timer <= 0.0:
			is_waiting = false
			_set_random_patrol_target()
		return

	if nav_agent.is_navigation_finished():
		is_waiting = true
		wait_timer = 1.0
		flip_timer = 0.5
		look_dir = 1
		return

	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * patrol_speed
	move_and_slide()

	if velocity.length() < 2.0:
		is_waiting = true
		wait_timer = 1.0
		flip_timer = 0.5
		look_dir = 1
		return

	sprite.play(walk_animation)
	sprite.flip_h = direction.x < 0

func _set_random_patrol_target():
	var max_attempts = 10
	var attempts = 0
	var valid = false
	var new_target = Vector2.ZERO

	while not valid and attempts < max_attempts:
		var offset = Vector2(
			randf_range(-patrol_radius, patrol_radius),
			randf_range(-patrol_radius, patrol_radius)
		)
		new_target = global_position + offset
		valid = true

		for pt in recent_patrol_points:
			if pt.distance_to(new_target) < patrol_memory_distance:
				valid = false
				break

		attempts += 1

	patrol_target = new_target
	nav_agent.set_target_position(patrol_target)

	recent_patrol_points.append(new_target)
	if recent_patrol_points.size() > max_patrol_memory:
		recent_patrol_points.pop_front()

func _process_chase(delta):
	change_state(State.CHASE)
	if player_in_attack_range:
		velocity = Vector2.ZERO
		sprite.play(attack_animation)
		return

	if player_in:
		nav_agent.set_target_position(player_in.global_position)

	if not nav_agent.is_navigation_finished():
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		sprite.play(walk_animation)
		sprite.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		sprite.play(idle_animation)

func _process_lost_target(delta):
	change_state(State.LOST_TARGET)
	wait_timer -= delta
	flip_timer -= delta
	if flip_timer <= 0.0:
		look_dir *= -1
		sprite.flip_h = look_dir < 0
		flip_timer = 0.5
	sprite.play(idle_animation)
	if wait_timer <= 0.0:
		change_state(State.PATROL)
		_set_random_patrol_target()

func _process_flee(delta):
	change_state(State.IDLE)
	if player_in:
		enemy_inattack_range = false
		var direction = (global_position - player_in.global_position).normalized()
		velocity = direction * (speed * 0.2)
		move_and_slide()
		sprite.play(walk_animation)
		sprite.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		sprite.play(idle_animation)

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in = body

func _on_detection_area_body_exited(body):
	if body == player_in:
		player_in = null
		change_state(State.LOST_TARGET)
		wait_timer = 2.0
		flip_timer = 0.5
		look_dir = 1

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_range = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_range = false

var knockback_velocity := Vector2.ZERO
var knockback_timer := 0.0

func be_damaged():
	if player_in_attack_range and global.player_current_attack and can_take_damage:
		health -= (global.attack_base + global.attack_add)
		can_take_damage = false
		$take_damage_cooldown.start()
		update_health()
		
		if health <= 0 and not is_dead:
			_process_death(0)

func _process(delta):
	if knockback_timer > 0:
		knockback_timer -= delta

		move_and_slide()

		if knockback_timer <= 0:
			knockback_velocity = Vector2.ZERO

func _process_death(delta):
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	sprite.play(dead_animation)
	sprite.frame = 0
	await sprite.animation_finished
	queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func update_health():
	healthbar.value = health
	healthbar.visible = health < max_health

func enemy():
	pass
