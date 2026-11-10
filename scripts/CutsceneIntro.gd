extends Control

func _ready() -> void:
	$StartButton.pressed.connect(_on_start_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") or event.is_action_pressed("ui_accept"):
		_on_start_button_pressed()

func _on_start_button_pressed() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.reset_game()
	get_tree().change_scene_to_file("res://scenes/level.tscn")
