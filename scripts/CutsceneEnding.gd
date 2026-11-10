extends Control

@onready var story_label: Label = $MarginContainer/StoryLabel
@onready var play_again_button: Button = $PlayAgainButton

func _ready() -> void:
	play_again_button.pressed.connect(_on_play_again_pressed)
	
	var gm = get_node_or_null("/root/GameManager")
	var hearts = gm.hearts if gm else 0
	var lives = gm.lives if gm else 3
	
	story_label.text = "im blue da be do da be di\n\nHearts Collected: %d\nLives Remaining: %d" % [hearts, lives]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") or event.is_action_pressed("ui_accept"):
		_on_play_again_pressed()

func _on_play_again_pressed() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.reset_game()
	get_tree().change_scene_to_file("res://scenes/CutsceneIntro.tscn")
