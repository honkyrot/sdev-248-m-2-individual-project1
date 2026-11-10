extends CharacterBody2D
class_name PinkHeart

@export var speed: float = 50.0
@export var gravity: float = 600.0
@export var is_spawned_from_block: bool = false

var direction: float = 1.0 # Moves right by default like Mario mushroom
var is_emerging: bool = false
var collected: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var pickup_area: Area2D = $PickupArea

func _ready() -> void:
	pickup_area.body_entered.connect(_on_pickup_entered)
	if is_spawned_from_block:
		_emerge_from_block()

func _emerge_from_block() -> void:
	is_emerging = false
	collision_mask = 1 # Re-enable world collision to walk and slide

func _physics_process(delta: float) -> void:
	if is_emerging or collected:
		return

	if position.y > 270.0:
		queue_free()
		return

	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 400.0)
	else:
		velocity.y = 0.0

	velocity.x = direction * speed

	move_and_slide()

	# Rebound when bumping into walls or obstacles
	if is_on_wall():
		direction *= -1.0

func _on_pickup_entered(body: Node2D) -> void:
	if collected or is_emerging:
		return
	if body is Player or body.is_in_group("player"):
		collected = true
		
		# Give player extra hit / powerup
		if body.has_method("power_up"):
			body.power_up()
			
		queue_free()
