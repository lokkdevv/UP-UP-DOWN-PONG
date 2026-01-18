extends Control

@onready var player_1_score: Label = $player1_score
@onready var player_2_score: Label = $player2_score

func _process(delta: float) -> void:
	player_1_score.text = str(Global.player1_score)
	player_2_score.text = str(Global.player2_score)
	
	if Global.player1_score == 10 || Global.player2_score == 10:
		Global.player2_score = 0
		Global.player1_score = 0
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
