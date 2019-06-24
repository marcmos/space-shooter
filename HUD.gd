extends CanvasLayer

export var highscore = []

func blink():
	$Label.visible = !$Label.visible

func game_over(score):
	print(score)
	highscore.push_back(score)
	$Highscore.text = "Highscores:\n";
	for i in range(0, len(highscore) - 1):
		$Highscore.text += str(i + 1) + ": " + str(highscore[i]) + "\n"
		print($Highscore.text)
	$Highscore.visible = true
	$GameOver.visible = true

func game_start():
	$Highscore.visible = false
	$GameOver.visible = false
	$Label/BlinkTimer.stop()
	$Label.visible = false
