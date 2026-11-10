extends CharacterBody2D
class_name Player

@export var speed: float = 130.0
@export var acceleration: float = 800.0
@export var friction: float = 1000.0
@export var jump_velocity: float = -300.0
@export var min_jump_velocity: float = -100.0
@export var gravity: float = 650.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_dead: bool = false
var is_powered_up: bool = false
var is_invulnerable: bool = false
var dead_timer: float = 0.0

var tex_normal: Texture2D = preload("res://assets/player.png")
var tex_jump: Texture2D = preload("res://assets/player_jump.png")
var tex_dead: Texture2D = preload("res://assets/player_dead.png")

func _physics_process(delta: float) -> void:
	if is_dead:
		_process_death(delta)
		return

	# Fall death check (fell into pit)
	if position.y > 270.0:
		die(true)
		return

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 400.0)
	else:
		velocity.y = 0.0

	# Jump handling
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Variable jump height
	if Input.is_action_just_released("jump") and velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity

	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		sprite.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	move_and_slide()

	# Update sprite texture
	if not is_on_floor():
		sprite.texture = tex_jump
	else:
		sprite.texture = tex_normal

func bounce(stomp_force: float = -200.0) -> void:
	velocity.y = stomp_force

func power_up() -> void:
	if is_powered_up:
		return
	is_powered_up = true
	sprite.scale = Vector2(1.25, 1.25)

func revert_power_up() -> void:
	is_powered_up = false
	is_invulnerable = true
	sprite.scale = Vector2(1.0, 1.0)
	sprite.modulate.a = 0.5
	await get_tree().create_timer(1.2).timeout
	is_invulnerable = false
	sprite.modulate.a = 1.0

func take_damage() -> void:
	if is_invulnerable or is_dead:
		return
	if is_powered_up:
		revert_power_up()
	else:
		die()

func die(force_death: bool = false) -> void:
	if is_dead:
		return
	if is_invulnerable and not force_death:
		return
	if is_powered_up and not force_death:
		revert_power_up()
		return
		
	is_dead = true
	sprite.texture = tex_dead
	collision_shape.set_deferred("disabled", true)
	velocity = Vector2(0, -200.0)

func _process_death(delta: float) -> void:
	dead_timer += delta
	velocity.y += gravity * delta
	position += velocity * delta
	if dead_timer > 2.0:
		var gm = get_node_or_null("/root/GameManager")
		if gm:
			gm.player_lose_life()
