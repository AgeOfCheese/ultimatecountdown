extends NumberedObject


# Called when the node enters the scene tree for the first time.
func _ready():
	object_number = 0

func apply_effect(player):
	player.add_score()
	
