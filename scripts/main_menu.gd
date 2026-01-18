extends Control

func _on_ai_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/main.tscn")

func _on_pvp_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/main_pvp.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
