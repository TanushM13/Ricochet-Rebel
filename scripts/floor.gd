extends Node2D

@export_file("*.tscn") var next_floor: String = ""
var cleared: bool = false




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not cleared and get_tree().get_nodes_in_group("enemies").is_empty():
		cleared = true;
		if next_floor != "":
			get_tree().change_scene_to_file.call_deferred(next_floor)
			print("You win")
