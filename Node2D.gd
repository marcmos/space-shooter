extends Node

export var num_hills = 2
export var slice = 10
export var hill_range = 100

export (PackedScene) var Mob

var screensize
var terrain
var texture = preload("res://rock.png");

signal game_start
signal game_over(score)

var started = false
var score

func reset():
	score = 0

	$Player.reset()
	
	$MobTimer.start()
	$Player/BorderTimer.start()
	$Player.enabled = true


func _ready():
	randomize()
	terrain = Array()
	
	screensize = get_viewport().get_visible_rect().size
	#var start_y = screensize.y * 3/4 + (-hill_range + randi() % hill_range * 2)
	var start_y = 500
	
	terrain.append(Vector2(0, start_y))
	add_hills()
	
	reset()

func _process(delta):
	if not started and Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		emit_signal("game_start")
	
	if terrain[-1].x < $Player.position.x + screensize.x:
		add_hills()
		
	$Player/Camera2D.limit_left = max($Player.position.x - 500, $Player/Camera2D.limit_left)
	$HUD/Score.text = str(score + $Player/Camera2D.limit_left / 100)
	
func add_hills():
	var hill_width = screensize.x / num_hills
	var hill_slices = hill_width / slice
	var start = terrain[-1]
	var poly = PoolVector2Array()
	for i in range(num_hills):
		var height = randi() % hill_range
		start.y -= height
		for j in range(0, hill_slices):
			var hill_point = Vector2()
			hill_point.x = start.x + j * slice + hill_width * i
			hill_point.y = start.y + height * cos(2 * PI / hill_slices * j)
			$Line2D.add_point(hill_point)
			terrain.append(hill_point)
			poly.append(hill_point)
		start.y += height
	var shape = CollisionPolygon2D.new()
	var ground = Polygon2D.new()
	$StaticBody2D.add_child(shape)
	poly.append(Vector2(terrain[-1].x, screensize.y))
	poly.append(Vector2(start.x, screensize.y))
	shape.polygon = poly
	ground.polygon = poly
	ground.texture = texture
	add_child(ground)

func _on_Mob_hit():
	score += 10

func _on_MobTimer_timeout():
	var mob = Mob.instance()
	mob.connect("hit", self, "_on_Mob_hit")
	
	add_child(mob)

	mob.position = Vector2($Player.position.x + rand_range(1000, 5000), -rand_range(100, 200))
	
	mob.linear_velocity = Vector2(-rand_range(score + 200, score * 2), rand_range(0, 200))
	mob.angular_velocity = rand_range(-2, 2)

func _on_Node2D_game_start():
	reset()

func _on_Node2D_game_over(score):
	$Player.enabled = false

func _on_Player_game_over():
	emit_signal("game_over", score)
