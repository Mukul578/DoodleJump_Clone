extends CharacterBody2D


const GRAVITY: float = 1800.0
const JUMP_VELOCITY: float = -950.0
const MOVE_SPEED: float = 420.0
const WRAP_MARGIN: float = 48.0

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_horizontal_movement()
	move_and_slide()
	_try_jump_from_platform()
	_apply_screen_wrap()

func _apply_gravity(delta: float) -> void:
	velocity.y += GRAVITY * delta

func _handle_horizontal_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * MOVE_SPEED

func _try_jump_from_platform() -> void:
	if velocity.y < 0.0:
		return
		
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		
		if collision.get_normal().y < -0.7:
			velocity.y = JUMP_VELOCITY
			break

func _apply_screen_wrap() -> void:
	var viewport_width := get_viewport_rect().size.x
	
	if global_position.x < -WRAP_MARGIN:
		global_position.x = viewport_width + WRAP_MARGIN
	elif global_position.x > viewport_width + WRAP_MARGIN:
		global_position.x = -WRAP_MARGIN
