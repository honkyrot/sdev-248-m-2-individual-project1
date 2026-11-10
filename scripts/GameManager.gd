extends Node

signal lives_changed(new_lives: int)
signal hearts_changed(new_heart: int)

var starting_lives: int = 3
var lives: int = 3
var hearts: int = 0

func _ready() -> void:
	reset_game()

func reset_game() -> void:
	lives = starting_lives
	hearts = 0
	emit_signal("lives_changed", lives)
	emit_signal("hearts_changed", hearts)

func add_heart(amount: int = 1) -> void:
	hearts += amount
	emit_signal("hearts_changed", hearts)

func add_life(amount: int = 1) -> void:
	lives += amount
	emit_signal("lives_changed", lives)

func player_lose_life() -> void:
	lives -= 1
	emit_signal("lives_changed", lives)
	if lives <= 0:
		call_deferred("_trigger_game_over")
	else:
		call_deferred("_reload_level")

func _reload_level() -> void:
	get_tree().reload_current_scene()

func _trigger_game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func complete_level() -> void:
	call_deferred("_trigger_ending")

func _trigger_ending() -> void:
	get_tree().change_scene_to_file("res://scenes/CutsceneEnding.tscn")
