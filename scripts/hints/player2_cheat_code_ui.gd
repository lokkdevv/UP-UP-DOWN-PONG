extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var container: HBoxContainer = $CanvasLayer/HBoxContainer
@onready var input_timer: Timer = $input_timer
@onready var interval_timer: Timer = $interval_timer

@onready var up_hint = load("res://scenes/hints/up_hint.tscn")
@onready var down_hint = load("res://scenes/hints/down_hint.tscn")

var input_taken := false
var can_input := false
var correct_inputs := 0

var rand_inputs := []

func _ready() -> void:
	canvas_layer.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up2") or Input.is_action_just_pressed("down2"):
		input_taken = true
	else:
		input_taken = false
	
	if input_taken:
		correct_inputs += 1
		can_input = true
		input_timer.start()
	
	if correct_inputs == container.get_child_count():
		Global.player2_ability = true
		can_input = false
		canvas_layer.visible = false
		for child in container.get_children():
			container.remove_child(child)

func _on_input_timer_timeout() -> void:
	if !input_taken:
		can_input = false
		canvas_layer.visible = false
		for child in container.get_children():
			container.remove_child(child)

func _on_interval_timer_timeout() -> void:
	for child in container.get_children():
		container.remove_child(child)
	
	for i in range(0, randi_range(5, 8)):
		var rnd = randf()
		if rnd >= 0.5:
			rand_inputs.append("up")
		else:
			rand_inputs.append("down")
	
	for rnd in rand_inputs:
		if rnd == "up":
			var hint = up_hint.instantiate()
			hint.size = Vector2(0.1, 0.1)
			container.add_child(hint)
		elif rnd == "down":
			var hint = down_hint.instantiate()
			hint.size = Vector2(0.1, 0.1)
			container.add_child(hint)
	
	canvas_layer.visible = true
	
	input_timer.start()
	can_input = true
	interval_timer.wait_time = randi_range(1, 1)
