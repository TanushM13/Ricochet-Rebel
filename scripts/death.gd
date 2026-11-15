extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(get_tree().get_meta("last_floor", "res://scenes/floor_1.tscn"))
