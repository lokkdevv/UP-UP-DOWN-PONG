extends CharacterBody2D

@export var ball: CharacterBody2D
var speed: float = 550.0
var move_dir: int = 0

func _physics_process(delta: float) -> void:
	if global_position.y < ball.global_position.y - randf_range(20, 45):
		move_dir = 1
	elif global_position.y > ball.global_position.y + randf_range(20, 45):
		move_dir = -1
	else:
		move_dir = 0
	
	velocity.y = lerpf(velocity.y, move_dir * speed, delta * 20)
	move_and_slide()
	
	global_position.y = clampf(global_position.y                    ,
	 0.0 + $CollisionShape2D.shape.size.y / 2                       ,
	 get_viewport_rect().size.y - $CollisionShape2D.shape.size.y / 2)
