extends CanvasLayer

export var highscore = []

func blink():
	$Label.visible = !$Label.visible

func game_over(score):
	highscore.push_back(score)
	$Highscore.text = "Highscores:\n";
	for i in range(0, len(highscore)):
		$Highscore.text += str(i + 1) + ": " + str(highscore[i]) + "\n"
		print($Highscore.text)
	$Highscore.visible = true
	$GameOver.visible = true
	$Label.visible = true
	$Label/BlinkTimer.start()

func game_start():
	print("hiding hud")
	$Highscore.visible = false
	$GameOver.visible = false
	$Label/BlinkTimer.stop()
	$Label.visible = false

func _on_Level_game_started():
	game_start()

func _on_Level_game_over(score):
	game_over(score)