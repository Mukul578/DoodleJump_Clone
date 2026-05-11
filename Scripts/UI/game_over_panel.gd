extends Control


signal retry_requested

@onready var final_score_label: Label = %FinalScoreLabel
@onready var retry_button: Button = %RetryButton


func _ready() -> void:
	retry_button.pressed.connect(_on_retry_button_pressed)
	hide()


func show_game_over(final_score: int) -> void:
	final_score_label.text = "Score: " + str(final_score)
	show()


func _on_retry_button_pressed() -> void:
	retry_requested.emit()
