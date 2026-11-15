extends CharacterBody2D

@export var bullet_speed = 80 # cause it should be faster than the player so you cant dodge it too easily, shield mechanic needed!
@export var move_speed = 40 # not zombies, actual fighting enemies!
@export var keep_distance = 120
@export var personal_space = 24
@export var acceleration = 200
@export var health: int = 1
@export var bullets_per_shot: int = 1
@export var spread = 0.3
@export var bullet_bounces = 3
@export var shield_dodge = 0.4
var target_position: Vector2
var bullet_scene = preload("res://scenes/bullet.tscn")

func _physics_process(delta: float) -> void:
	var wanted: Vector2
	if global_position.distance_to(target_position) > 4:
		wanted = global_position.direction_to(target_position) * move_speed
	else:
		wanted = Vector2.ZERO
	for other in get_tree().get_nodes_in_group("enemies"):
		if other == self: continue
		if global_position.distance_to(other.global_position) < personal_space:
			wanted += other.global_position.direction_to(global_position) * move_speed

	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		if global_position.distance_to(player.global_position) < 50:
			wanted += player.global_position.direction_to(global_position) * move_speed * 2

	velocity = velocity.move_toward(wanted, acceleration * delta)
	move_and_slide()


func _on_shoot_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null: return
	var aim = global_position.direction_to(player.global_position)
	for i in bullets_per_shot:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.velocity = aim.rotated((i - (bullets_per_shot - 1) / 2.0) * spread) * bullet_speed
		bullet.max_bounces = bullet_bounces
		get_tree().current_scene.add_child(bullet)


func _on_move_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null: return
	var side = player.global_position.direction_to(global_position).angle() + randf_range(-1.0, 1.0)
	var back = player.get_node("ShieldPivot").global_rotation + PI
	side = lerp_angle(side, back, shield_dodge)
	target_position = player.global_position + Vector2.from_angle(side)*keep_distance
	$MoveTimer.wait_time = randf_range(1.0, 2.0)

func hit() -> void:
	health -= 1
	if health <= 0:
		remove_from_group("enemies")
		$ShootTimer.stop()
		$CollisionShape2D.set_deferred("disabled", true)
		var t = create_tween()
		t.tween_property(self, "modulate:a", 0.0, 0.3)
		t.parallel().tween_property(self, "scale", scale * 1.5, 0.3)
		t.tween_callback(queue_free)
