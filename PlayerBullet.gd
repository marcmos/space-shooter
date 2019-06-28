extends KinematicBody2D

var vel = Vector2()
export var speed = 1000

func _ready():
	set_physics_process(true)

func start_at(dir, pos, origin_speed):
	rotation = dir
	position = pos
	vel = Vector2(speed + origin_speed.x, 0).rotated(dir + PI / 2)

func _physics_process(delta):
	position = position + vel * delta

func _on_LifetimeTimer_timeout():
	queue_free()
