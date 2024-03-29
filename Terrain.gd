extends StaticBody2D

export var num_hills = 2
export var slice = 10
export var hill_range = 0

var screensize
var terrain
var texture = preload("res://res/rock.png")

func set_hill_range(r):
	hill_range = min(r, int(get_viewport_rect().size.y / 3))

func add_hills_if_necessary(position):
	if terrain[-1].x < position.x + screensize.x:
		add_hills()

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
			$TerrainLine.add_point(hill_point)
			terrain.append(hill_point)
			poly.append(hill_point)
		start.y += height
	var shape = CollisionPolygon2D.new()
	var ground = Polygon2D.new()
	add_child(shape)
	poly.append(Vector2(terrain[-1].x, screensize.y * 2))
	poly.append(Vector2(start.x, screensize.y * 2))
	shape.polygon = poly
	ground.polygon = poly
	ground.texture = texture
	add_child(ground)

func _ready():
	randomize()
	terrain = Array()
	
	screensize = get_viewport().get_visible_rect().size
	hill_range = int(screensize.y * 1/6)
	var start_y = screensize.y * 4/5

	terrain.append(Vector2(0, start_y))
	add_hills()
