extends Node2D

@export var shield_limit: int = 5
@export var streak_window: float = 0.8
@export var cooldown_time: float = 1.5

var hits: int = 0
var overheated: bool = false
var cooldown: Timer

func _ready() -> void:
	$Timer.one_shot = true
	$Timer.stop()
	cooldown = Timer.new()
	cooldown.one_shot = true
	cooldown.wait_time = cooldown_time
	cooldown.timeout.connect(_on_cooldown_timeout)
	add_child(cooldown)

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func hit() -> void:
	if overheated:
		return
	hits += 1
	$Timer.start(streak_window)
	if hits >= shield_limit:
		overheat()

func overheat() -> void:
	overheated = true
	hits = 0
	modulate = Color.RED
	$Timer.stop()
	$ShieldBody/CollisionShape2D.set_deferred("disabled", true)
	cooldown.start()

func _on_timer_timeout() -> void:
	hits = 0

func _on_cooldown_timeout() -> void:
	overheated = false
	hits = 0
	modulate = Color.WHITE
	$ShieldBody/CollisionShape2D.set_deferred("disabled", false)
