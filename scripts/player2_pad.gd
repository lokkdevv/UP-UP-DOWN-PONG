extends CharacterBody2D

enum STATE  {
	moving  ,
	stopped ,
	stunned }

var current_state: STATE = STATE.stopped
var speed: float = 550.0
var input_dir: float = 0.0
var mobile_input: int = 0

func _physics_process(delta: float) -> void:
	update_state();
	
	if current_state == STATE.moving:
		velocity.y = input_dir * speed
	elif current_state == STATE.stopped:
		velocity.y = 0
	
	move_and_slide()
	
	global_position.y = clampf(global_position.y                    ,
	 0.0 + $CollisionShape2D.shape.size.y / 2                       ,
	 get_viewport_rect().size.y - $CollisionShape2D.shape.size.y / 2)

func update_state():
	input_dir = Input.get_axis("up2", "down2")
	if mobile_input:
		input_dir = float(mobile_input)
	match current_state:
		STATE.moving:
			if input_dir == 0:
				current_state = STATE.stopped
		STATE.stopped:
			if input_dir != 0:
				current_state = STATE.moving
		STATE.stunned:
			velocity = Vector2.ZERO
