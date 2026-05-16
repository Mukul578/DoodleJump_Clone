extends AnimatableBody2D


@export var move_distance: float = 180.0
@export var move_speed: float = 90.0

var start_x: float
var time: float = 0.0
var direction: float = 1.0


func _ready() -> void:
	setup_start_position()


func _physics_process(delta: float) -> void:
	time += delta
	global_position.x += direction * move_speed * delta
	
	var offset := sin(time * move_speed / move_distance) * move_distance
	global_position.x = start_x + offset


func setup_start_position() -> void:
	start_x = global_position.x
