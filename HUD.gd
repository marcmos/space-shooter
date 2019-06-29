extends CanvasLayer

export var highscore = []

func _ready():
	get_tree().get_root().connect("size_changed", self, "_on_resize")
	_on_resize()

func blink():
	$Label.visible = !$Label.visible

func game_over(score):
	highscore.push_back(score)
	highscore.sort()
	highscore.invert()
	$Highscore.text = "Highscores:\n";
	for i in range(0, len(highscore)):
		$Highscore.text += str(i + 1) + ": " + str(highscore[i]) + "\n"
		print($Highscore.text)
	$Highscore.visible = true
	$GameOver.visible = true
	$Label.visible = true
	$Label/BlinkTimer.start()

func game_start():
	$Highscore.visible = false
	$GameOver.visible = false
	$Label/BlinkTimer.stop()
	$Label.visible = false

func _on_Level_game_started():
	game_start()

func _on_Level_game_over(score):
	game_over(score)

func set_x_centered(node):
	node.rect_position.x = get_viewport().size.x / 2 - node.rect_size.x / 2

func _on_resize():
	set_x_centered($Label)
	set_x_centered($GameOver)