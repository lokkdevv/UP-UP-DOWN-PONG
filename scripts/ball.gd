extends CharacterBody2D

var speed := 1000.0
var min_speed := 1000.0
var max_speed := 1400.0
var direction := Vector2.ZERO

var top_limit := 0.0
var bottom_limit := 0.0

func _ready() -> void:
	top_limit = Global.top + $CollisionShape2D.shape.radius
	bottom_limit = Global.bottom - $CollisionShape2D.shape.radius
	if randi_range(-1, 1) >= 0:
		direction = Vector2.LEFT
	else:
		direction = Vector2.RIGHT
	direction = direction.rotated(randf_range(-0.1, 0.1) * PI)

func _process(delta: float) -> void:
	speed = clampf(speed, min_speed, max_speed)

func _physics_process(delta: float) -> void:
	if global_position.y <= top_limit or global_position.y >= bottom_limit:
		speed = lerpf(speed, speed + 100.0, 0.5)
		direction.y = -direction.y
	
	speed -= delta * 300
	
	if get_parent().get_child(1).name == "ai":
		if global_position.x > %ai.get_child(0).global_position.x + 100:
			Global.player1_score += 1
			get_tree().reload_current_scene()
			return
	else:
		if global_position.x > %players.get_child(1).global_position.x + 100:
			Global.player1_score += 1
			get_tree().reload_current_scene()
			return
	if global_position.x < %players.get_child(0).global_position.x - 100:
		Global.player2_score += 1
		get_tree().reload_current_scene()
		return
	
	velocity = direction.normalized() * speed
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("paddle"):
		direction.x = -direction.x
		direction.y = (global_position.y - body.global_position.y) / (body.get_child(0).shape.size.y / 2)
		direction.y += randf_range(-0.1, 0.1)
		speed = lerpf(speed, speed + 500.0, 0.5)
