extends RigidBody2D

var thrust = Vector2(0, 300)
var torque = 5000

export (PackedScene) var bullet
onready var bullet_container = get_node("BulletContainer")

func reset():
	$Camera2D.limit_left = 0
	linear_velocity.x = 0
	linear_velocity.y = 0
	angular_velocity = 0
	rotation = -PI / 2
	position.x = 0
	position.y = 0

func _ready():
	reset()

func _process(delta):
	if get_parent().is_game_over():
		return
	
	if Input.is_action_pressed("shoot"):
		shoot()

func _integrate_forces(state):
	if get_parent().is_game_over():
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

func shoot():
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(rotation, $Muzzle.global_position)
	#apply_impulse(Vector2(5, 0), Vector2(-5, 0))

func _on_BorderTimer_timeout():
	if get_parent().is_game_over():
		return

	$Camera2D.limit_left += 1

func game_start():
	reset()