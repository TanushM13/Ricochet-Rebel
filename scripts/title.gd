extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if has_node("Difficulty"):
		mode = hearts.find(get_tree().get_meta("max_health", 3))
		$Difficulty.text = "difficulty: " + modes[mode]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/floor_1.tscn")

var modes = ["Easy", "Normal", "Hard"]
var hearts = [5, 3, 1]
var mode = 1

func _on_difficulty_pressed() -> void:
	mode = (mode + 1) % modes.size()
	get_tree().set_meta("max_health", hearts[mode])
	$Difficulty.text = "difficulty: " + modes[mode]
