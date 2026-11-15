extends CharacterBody2D

@export var max_speed: float = 120.0
@export var slow_speed: float = 40.0
@export var acceleration: float = 1200.0
@export var friction: float = 1000.0
@export var health: int = 3

var current_speed: float = 120.0

func _ready():
	health = get_tree().get_meta("max_health", health)
	var box = $CanvasLayer/Hearts
	while box.get_child_count() < health:
		box.add_child(box.get_child(0).duplicate())
	update_hearts()
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

func hit() -> void:
	health -= 1
	if health <= 0:
		get_tree().set_meta("last_floor", get_tree().current_scene.scene_file_path)
		get_tree().change_scene_to_file.call_deferred("res://scenes/death.tscn")
		
	update_hearts()

func update_hearts():
	var hearts = $CanvasLayer/Hearts.get_children()
	for i in hearts.size():
		hearts[i].visible = i < health
	
