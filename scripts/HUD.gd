extends CanvasLayer

@onready var hearts_label: Label = $MarginContainer/HBoxContainer/HeartsBox/HeartsRow/HeartLabel
@onready var lives_label: Label = $MarginContainer/HBoxContainer/LivesBox/LivesRow/LivesLabel

func _ready() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.hearts_changed.connect(_on_hearts_changed)
		gm.lives_changed.connect(_on_lives_changed)
		
		# Initial update
		_on_hearts_changed(gm.hearts)
		_on_lives_changed(gm.lives)

func _on_hearts_changed(val: int) -> void:
	if hearts_label:
		hearts_label.text = "x %02d" % val

func _on_lives_changed(val: int) -> void:
	if lives_label:
		lives_label.text = "x %02d" % val
