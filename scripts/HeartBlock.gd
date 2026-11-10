extends StaticBody2D
class_name QuestionBlock

@export var drops_pink_heart: bool = false
@export var contains_red_heart: bool = true
var is_hit: bool = false

@onready var sprite: Sprite2D = $Sprite2D
var red_heart_scene = preload("res://scenes/RedHeart.tscn")
var pink_heart_scene = preload("res://scenes/PinkHeart.tscn")

func _ready() -> void:
	$BottomArea.body_entered.connect(_on_bottom_body_entered)

func _on_bottom_body_entered(body: Node2D) -> void:
	if is_hit:
		return
	if body is Player or body.is_in_group("player"):
		if body.velocity.y <= 0:
			hit(body)

func hit(player: CharacterBody2D = null) -> void:
	if is_hit:
		return
	is_hit = true
	
	if player and player.velocity.y < 0:
		player.velocity.y = 50.0

	sprite.region_rect = Rect2(64, 0, 16, 16)
	
	if drops_pink_heart and pink_heart_scene:
		var p_heart = pink_heart_scene.instantiate()
		p_heart.position = position + Vector2(0, -16)
		p_heart.is_spawned_from_block = true
		get_parent().add_child(p_heart)
	elif contains_red_heart and red_heart_scene:
		var heart = red_heart_scene.instantiate()
		heart.position = position + Vector2(0, -16)
		heart.is_spawned_from_block = true
		get_parent().add_child(heart)
