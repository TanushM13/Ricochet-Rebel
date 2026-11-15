extends CharacterBody2D

var bounces: int = 0
@export var max_bounces: int = 3
@export var reflect_boost: float = 2.5

func _physics_process(delta: float) -> void:
	var impact = move_and_collide(velocity*delta)
	
	if not impact == null:
		var thing = impact.get_collider()
		if thing.is_in_group("player") or thing.is_in_group("enemies"):
			thing.hit()
			queue_free()
			return
		velocity = velocity.bounce(impact.get_normal())
		if thing.is_in_group("shield"):
			thing.get_parent().hit()
			set_collision_mask_value(2, false)
			set_collision_mask_value(3, true)
			set_collision_mask_value(4, false)
			modulate = Color.DARK_BLUE
			velocity *= reflect_boost
		else:
			bounces += 1
		if bounces > max_bounces: queue_free()
			
	rotation = velocity.angle()
	
