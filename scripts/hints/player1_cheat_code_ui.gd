extends Control

enum CheatInput { UP, DOWN }

@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var container: HBoxContainer = $CanvasLayer/HBoxContainer
@onready var input_timer: Timer = $input_timer
@onready var interval_timer: Timer = $interval_timer

@onready var up_hint = load("res://scenes/hints/up_hint.tscn")
@onready var down_hint = load("res://scenes/hints/down_hint.tscn")

var rand_inputs := []
var input_index := 0

func _ready() -> void:
	canvas_layer.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if !canvas_layer.visible:
		return
	if !(event is InputEventKey):
		return
	
	if event.is_action_pressed("up"): 
		_check_input(CheatInput.UP)
	if event.is_action_pressed("down"):
		_check_input(CheatInput.DOWN)

func _on_input_timer_timeout() -> void:
	_fail()

func _check_input(input: CheatInput):
	if input_index >= rand_inputs.size() or input != rand_inputs[input_index]:
		_fail()
		return
	
	input_timer.start()
	
	input_index += 1
	
	if input_index >= rand_inputs.size():
		_success()
		_reset()

func _reset():
	canvas_layer.visible = false
	input_index = 0
	rand_inputs.clear()
	for child in container.get_children():
		child.queue_free()

func _success():
	Global.player1_ability = true

func _fail():
	Global.player1_ability = false
	_reset()

func _on_interval_timer_timeout() -> void:
	rand_inputs.clear()
	for child in container.get_children():
		child.queue_free()
	
	for i in range(0, randi_range(5, 8)):
		var rnd = randf()
		if rnd >= 0.5:
			rand_inputs.append(CheatInput.UP)
		else:
			rand_inputs.append(CheatInput.DOWN)
	
	for rnd in rand_inputs:
		if rnd == CheatInput.UP:
			var hint = up_hint.instantiate()
			container.add_child(hint)
		elif rnd == CheatInput.DOWN:
			var hint = down_hint.instantiate()
			container.add_child(hint)
	
	canvas_layer.visible = true
	input_timer.start()
	interval_timer.wait_time = randi_range(15, 22)
