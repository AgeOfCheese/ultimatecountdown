extends NumberedObject


# Called when the node enters the scene tree for the first time.
func _ready():
	object_number = 3

func apply_effect(player):
	if true:
		player.take_damage()
