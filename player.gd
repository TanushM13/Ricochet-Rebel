extends CharacterBody2D

@export var max_speed: float = 600.0
@export var slow_speed: float = 200.0
@export var acceleration: float = 6000.0
@export var friction: float = 5000.0

var current_speed: float = 600.0

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("slow_down"):
		current_speed = slow_speed
	else:
		current_speed = max_speed
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * current_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()
	
