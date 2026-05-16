extends Node2D

@export var platform_scene: PackedScene
@export var moving_platform_scene: PackedScene
@export_range(0.0, 1.0, 0.05) var moving_platform_chance: float = 0.2
@export var player: Node2D
@export var camera: Camera2D

@export var initial_platform_count: int = 12
@export var min_vertical_gap: float = 90.0
@export var max_vertical_gap: float = 150.0
@export var horizontal_margin: float = 80.0
@export var spawn_ahead_distance: float = 900.0

@export var cleanup_margin: float = 200.0

var highest_platform_y: float
var spawned_platforms: Array[Node2D] = []

func _ready() -> void:
	if platform_scene == null:
		push_error("PlatformSpawner: platform_scene no está asignada.")
		return
	
	if player == null:
		push_error("PlatformSpawner: player no está asignado.")
		return
	
	if camera == null:
		push_error("PlatformSpawner: camera no está asignada.")
		return
	
	await get_tree().process_frame
	
	highest_platform_y = player.global_position.y + 200.0
	_spawn_initial_platforms()


func _process(delta: float) -> void:
	if camera == null:
		return
	
	var target_spawn_y := camera.global_position.y - spawn_ahead_distance
	
	while highest_platform_y > target_spawn_y:
		_spawn_next_platform()
	
	_cleanup_old_platforms()


func _spawn_initial_platforms() -> void:
	for i in initial_platform_count:
		_spawn_next_platform()


func _spawn_next_platform() -> void:
	var viewport_width := get_viewport_rect().size.x
	
	var gap := randf_range(min_vertical_gap, max_vertical_gap)
	highest_platform_y -= gap
	
	var x := randf_range(horizontal_margin, viewport_width - horizontal_margin)
	_spawn_platform(Vector2(x, highest_platform_y))


func _spawn_platform(spawn_position: Vector2) -> void:
	var scene_to_spawn := _get_platform_scene_to_spawn()
	
	if scene_to_spawn == null:
		return
	
	var platform := scene_to_spawn.instantiate() as Node2D
	get_parent().add_child(platform)
	platform.global_position = spawn_position
	
	if platform.has_method("setup_start_position"):
		platform.setup_start_position()
	
	spawned_platforms.append(platform)


func _get_platform_scene_to_spawn() -> PackedScene:
	if moving_platform_scene != null and randf() < moving_platform_chance:
		return moving_platform_scene
	
	return platform_scene


func _cleanup_old_platforms() -> void:
	var viewport_height := get_viewport_rect().size.y
	var camera_bottom_y := camera.global_position.y + viewport_height * 0.5
	var cleanup_y := camera_bottom_y + cleanup_margin
	
	for i in range(spawned_platforms.size() -1, -1, -1):
		var platform := spawned_platforms[i]
		
		if not is_instance_valid(platform):
			spawned_platforms.remove_at(i)
			continue
		
		var is_below_camera := platform.global_position.y > cleanup_y
		
		if is_below_camera:
			platform.queue_free()
			spawned_platforms.remove_at(i)
