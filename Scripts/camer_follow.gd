extends Camera2D


@export var player: Node2D
@export var vertical_offset: float = 200.0

var highest_camera_y: float

func _ready() -> void:
	highest_camera_y = global_position.y

func _process(delta: float) -> void:
	if player == null:
		return
		
	var target_y := player.global_position.y + vertical_offset
	
	if target_y < highest_camera_y:
		highest_camera_y = target_y
		global_position.y = highest_camera_y
