extends Area2D
class_name RedHeart

@export var is_spawned_from_block: bool = false
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if is_spawned_from_block:
		_pop_out()

func _pop_out() -> void:
	var gm = get_node_or_null("/root/GameManager")
	if gm:
		gm.add_heart(1)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	if body is Player or body.is_in_group("player"):
		collected = true
		collision_shape.set_deferred("disabled", true)
		var gm = get_node_or_null("/root/GameManager")
		if gm:
			gm.add_heart(1)
		queue_free()
