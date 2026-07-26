extends Label


func _process(_delta):

	text = (
		"Score: " + str(RoundManager.score)
		+ "\nDeaths: " + str(RoundManager.death_count)
	)
