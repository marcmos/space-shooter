extends Node

var restart_cooldown = true

export (PackedScene) var Level

var level

func is_game_over():
	return level.game_over

func game_over():
	restart_cooldown = true
	$RestartTimer.start()

func instance_level():
	var new_level = Level.instance()
	new_level.connect("game_over", self, "_on_Level_game_over")
	new_level.connect("game_over", $HUD, "_on_Level_game_over")
	new_level.connect("game_started", $HUD, "_on_Level_game_started")
	return new_level

func _process(delta):
	if level == null:
		level = instance_level()
		add_child(level)

	$HUD/Score.text = str(level.score())

	if is_game_over() and (not restart_cooldown) and Input.is_action_pressed("up"):
		level.queue_free()
		level = null

func _on_Mob_hit():
	#mob_hits += 1
	pass

func _on_RestartTimer_timeout():
	restart_cooldown = false
	print("restart now possible")

func _on_Level_game_over(score):
	game_over()