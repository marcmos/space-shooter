extends Node2D

export (PackedScene) var Mob

signal game_started
signal game_over(score)

var game_started = false
var game_over = false

var camera_left

var mob_hits = 0

func game_over_condition():
	if game_over:
		return
	
	game_over = true
	$Player/Camera2D.current = false
	$MobTimer.stop()
	emit_signal("game_over", score())

func score():
	return $Player/Camera2D.limit_left / 100 + mob_hits * 10

func spawn_mob():
	var mob = Mob.instance()
	
	mob.position = Vector2($Player.position.x + rand_range(1000, 5000), -rand_range(100, 200))
	mob.linear_velocity = Vector2(-rand_range(score() + 200, score() * 2), rand_range(0, 200))
	mob.angular_velocity = rand_range(-2, 2)
	
	mob.connect("hit", self, "_on_Mob_hit")
	
	add_child(mob)

func camera_left_margin():
	return $Player/Camera2D.global_position.x - get_viewport().size.x / 2

func monotonic_left_margin_update(value, guaranteed_step):
	camera_left = max(camera_left, value) + guaranteed_step
	return camera_left

func _ready():
	camera_left = camera_left_margin()
	$Player/Camera2D.limit_left = camera_left

func _process(delta):
	$Terrain.add_hills_if_necessary($Player.position)
	
	if game_started and not game_over:
		$Player/Camera2D.limit_left = monotonic_left_margin_update(camera_left_margin(), 2 + $Player/Camera2D.limit_left * 0.0005)
		
		if $Player.beyond_bounds():
			game_over_condition()

	if not game_started and Input.is_action_pressed("up"):
		game_started = true
		emit_signal("game_started")
		$Player.gravity_scale = 0.1

func _on_Player_body_entered(body):
	game_over_condition()

func _on_MobTimer_timeout():
	spawn_mob()

func _on_Mob_hit():
	mob_hits += 1