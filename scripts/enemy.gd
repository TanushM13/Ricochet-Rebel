extends CharacterBody2D

@export var bullet_speed = 80 # cause it should be faster than the player so you cant dodge it too easily, shield mechanic needed!
@export var move_speed = 40 # not zombies, actual fighting enemies!
@export var keep_distance = 120
@export var personal_space = 24
@export var acceleration = 200
@export var health: int = 1
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
	velocity = velocity.move_toward(wanted, acceleration * delta)
	move_and_slide()


func _on_shoot_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null: return
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.velocity = global_position.direction_to(player.global_position) * bullet_speed
	get_tree().current_scene.add_child(bullet)
	


func _on_move_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null: return
	target_position = player.global_position + Vector2.from_angle(randf() * TAU)*keep_distance
	$MoveTimer.wait_time = randf_range(1.0, 2.0)
	
func hit() -> void:
	health -= 1
	if health <= 0:
		queue_free()
