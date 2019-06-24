extends Node

export (PackedScene) var Mob

signal game_start
signal game_over(score)

var mob_hits = 0
var game_over = true
var restart_cooldown

func is_game_over():
	return game_over

func game_start():
	if restart_cooldown:
		return
	
	emit_signal("game_start")
	mob_hits = 0
	game_over = false

func score():
	return $Player/Camera2D.limit_left / 100 + mob_hits * 10

func _process(delta):
	if game_over:
		if Input.is_action_pressed("up"):
			game_over = false
			emit_signal("game_start")
		return
	
	$Terrain.add_hills_if_necessary($Player.position)

	$Player/Camera2D.limit_left = max($Player.position.x - 500, $Player/Camera2D.limit_left)
	$HUD/Score.text = str(score())
	
func _on_Mob_hit():
	mob_hits += 1

func spawn_mob():
	var mob = Mob.instance()
	mob.connect("hit", self, "_on_Mob_hit")
	
	add_child(mob)

	mob.position = Vector2($Player.position.x + rand_range(1000, 5000), -rand_range(100, 200))
	
	mob.linear_velocity = Vector2(-rand_range(score() + 200, score() * 2), rand_range(0, 200))
	mob.angular_velocity = rand_range(-2, 2)
	
func _on_Player_body_entered(body):
	if game_over:
		return
	else:
		game_over = true
		restart_cooldown = true
		$RestartTimer.start()
		emit_signal("game_over", score())

func _on_RestartTimer_timeout():
	restart_cooldown = false
