extends CharacterBody2D

var health = global.health_slime
var speed = global.speed_slime
var player_chase = false #是否追踪主角
var player_in_slime = null #获取范围内的主角
var player_inattack_range = false #史莱姆被攻击范围内是否有主角
var can_take_damage = true #史莱姆是否可以被攻击

#处理史莱姆的行为
func _physics_process(delta):
	deal_with_damage()
	upadte_health()
	
	#追踪主角或停止追踪
	if player_chase:
		position += (player_in_slime.position - position) / speed
		
		$AnimatedSprite2D.play("walk")
		 
		if(player_in_slime.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

#检测范围内是否有主角进入
func _on_detection_area_body_entered(body):
	player_in_slime = body
	player_chase = true

#检测范围内是否有主角离开
func _on_detection_area_body_exited(body):
	player_in_slime = null
	player_chase = false
	
func enemy():
	pass

#被攻击范围内是否有主角进入
func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_range = true

#被攻击范围内是否有主角离开
func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_range = false

#被主角攻击
func deal_with_damage():
	if player_inattack_range and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - (global.attack_base + global.attack_add)
			$take_damage_cooldown.start()
			can_take_damage = false
			if health <= 0:
				self.queue_free()

#史莱姆被攻击冷却结束
func _on_take_damage_cooldown_timeout():
	can_take_damage = true

#史莱姆更新血量
func upadte_health():
	var healthbar = $healthbar_enemy
	healthbar.value = health
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
