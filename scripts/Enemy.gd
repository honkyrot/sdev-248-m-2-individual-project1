extends CharacterBody2D
class_name Enemy

@export var speed: float = 35.0
@export var gravity: float = 650.0

var direction: float = -1.0
var is_stomped: bool = false
var is_active: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var stomp_area: Area2D = $StompArea
@onready var body_area: Area2D = $BodyArea

var tex_flat = preload("res://assets/blue_heart_rip.png")

func _ready() -> void:
	stomp_area.body_entered.connect(_on_stomp_area_entered)
	body_area.body_entered.connect(_on_body_area_entered)
	$VisibleOnScreenNotifier2D.screen_entered.connect(func(): is_active = true)

func _physics_process(delta: float) -> void:
	if is_stomped:
		return

	# Fall death check
	if position.y > 270.0:
		queue_free()
		return

	if not is_active:
		return

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	velocity.x = direction * speed

	move_and_slide()

	# Reverse direction if hitting wall
	if is_on_wall():
		direction *= -1.0

func _on_stomp_area_entered(body: Node2D) -> void:
	if is_stomped:
		return
	if body is Player:
		# Ensure player is moving downwards or above the enemy
		if body.velocity.y >= -20.0 or body.position.y < position.y:
			stomp(body)

func stomp(player: Player) -> void:
	if is_stomped:
		return
	is_stomped = true
	player.bounce(-200.0)
	sprite.texture = tex_flat
	collision_shape.set_deferred("disabled", true)
	stomp_area.set_deferred("monitoring", false)
	body_area.set_deferred("monitoring", false)
	
	# Disappear after a short pause
	get_tree().create_timer(0.4).timeout.connect(queue_free)

func _on_body_area_entered(body: Node2D) -> void:
	if is_stomped:
		return
	if body is Player:
		# If player didn't trigger stomp area
		if not is_stomped:
			if body.has_method("take_damage"):
				body.take_damage()
			else:
				body.die()
