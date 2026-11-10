extends Area2D
class_name EndTrigger

var triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	if body is Player or body.is_in_group("player"):
		triggered = true
		var gm = get_node_or_null("/root/GameManager")
		if gm:
			gm.complete_level()
