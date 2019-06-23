extends CanvasLayer

export var highscore = []

func _on_Timer_timeout():
	$Label.visible = !$Label.visible

func _on_Node2D_game_over(score):
	highscore.push_back(score)
	$Highscore.text = "Highscores:\n";
	for i in range(0, len(highscore) - 1):
		$Highscore.text += str(i + 1) + ": " + str(highscore[i]) + "\n"
	$Highscore.visible = true

func _on_Node2D_game_start():
	$Highscore.visible = false
	
	$Label/BlinkTimer.stop()
	$Label.visible = false
