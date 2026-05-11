extends Node2D


@export var player: Node2D
@export var camera: Camera2D
@export var fall_margin: float = 120.0
@export var score_scale: float = 0.1
@export var score_label: Label
@export var game_over_panel: Control

var start_player_y: float
var highest_player_y: float
var score: int = 0
var is_game_over: bool = false


func _ready() -> void:
	if player == null:
		push_error("Game: player no está asignado.")
		return

	start_player_y = player.global_position.y
	highest_player_y = start_player_y
	_update_hud()

	if game_over_panel != null:
		game_over_panel.retry_requested.connect(_on_retry_requested)


func _process(delta: float) -> void:
	if is_game_over:
		return
	
	if player == null or camera == null:
		return
	
	_update_score()
	_check_player_fall()


func _update_score() -> void:
	if player.global_position.y < highest_player_y:
		highest_player_y = player.global_position.y
	
	var height_reached := start_player_y - highest_player_y
	var new_score = max(0, int(height_reached * score_scale))
	
	if new_score != score:
		score = new_score
		_update_hud()


func _update_hud() -> void:
	if score_label == null:
		return
	
	score_label.text = str(score)


func _check_player_fall() -> void:
	var viewport_height := get_viewport_rect().size.y
	var camera_bottom_y := camera.global_position.y + viewport_height * 0.5
	
	if player.global_position.y > camera_bottom_y + fall_margin:
		_game_over()


func _game_over() -> void:
	if is_game_over:
		return

	is_game_over = true
	get_tree().paused = true

	if game_over_panel != null:
		game_over_panel.show_game_over(score)


func _on_retry_requested() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
