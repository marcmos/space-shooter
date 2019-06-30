extends RigidBody2D

var thrust = Vector2(0, 300)
var torque = 5000

var sprite_rect

export (PackedScene) var bullet
onready var bullet_container = get_node("BulletContainer")

func is_game_over():
	return get_parent().game_over

func _ready():
	position.x = get_viewport().size.x / 2
	sprite_rect = Vector2($Sprite.get_rect().size.x * $Sprite.scale.x, \
		$Sprite.get_rect().size.y * $Sprite.scale.y)

func _process(delta):
	if is_game_over():
		return
	
	if Input.is_action_pressed("shoot"):
		shoot()

func _integrate_forces(state):
	if is_game_over():
		applied_force = Vector2()
		applied_torque = 0
		return
	
	if Input.is_action_pressed("up"):
		applied_force = thrust.rotated(rotation)
	else:
		applied_force = Vector2()
	var rotation_dir = 0
	if Input.is_action_pressed("right"):
		rotation_dir += 1
	if Input.is_action_pressed("left"):
		rotation_dir -= 1

	applied_torque = rotation_dir * torque

func beyond_bounds():
	return position.y + (sprite_rect.y / 2) < $Camera2D.limit_top or \
		position.x + (sprite_rect.x / 2) < $Camera2D.limit_left

func shoot():
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(rotation, $Muzzle.global_position, linear_velocity)

func _on_BorderTimer_timeout():
	if not is_game_over():
		$Camera2D.limit_left += 1