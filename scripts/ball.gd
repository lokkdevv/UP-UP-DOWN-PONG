extends CharacterBody2D

var speed := 1000.0
var direction := Vector2.ZERO

var top_limit := 0.0
var bottom_limit := 0.0

func _ready() -> void:
	top_limit = Global.top + $CollisionShape2D.shape.radius / 2
	bottom_limit = Global.bottom - $CollisionShape2D.shape.radius / 2
	#start_dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	direction = Vector2.LEFT

func _physics_process(delta: float) -> void:
	if global_position.y <= top_limit or global_position.y >= bottom_limit:
		direction.y = -direction.y
	if global_position.x >= get_viewport_rect().size.x - $CollisionShape2D.shape.radius / 2:
		direction.x = -direction.x
	
	velocity = direction.normalized() * speed
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("paddle"):
		direction.x = -direction.x
		direction.y = (global_position.y - body.global_position.y) / (body.get_child(0).shape.size.y / 2)
		direction.y += randf_range(-0.1, 0.1)
