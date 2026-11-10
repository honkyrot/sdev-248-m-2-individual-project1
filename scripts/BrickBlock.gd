extends StaticBody2D
class_name BrickBlock

func _ready() -> void:
	$BottomArea.body_entered.connect(_on_bottom_body_entered)

func _on_bottom_body_entered(body: Node2D) -> void:
	if body is Player or body.is_in_group("player"):
		if body.velocity.y <= 0:
			hit(body)

func hit(player: CharacterBody2D = null) -> void:
	if player and player.velocity.y < 0:
		player.velocity.y = 50.0
