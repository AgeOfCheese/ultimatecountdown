extends NumberedObject


# Called when the node enters the scene tree for the first time.
func _ready():
	object_number = 0

func apply_effect(player):
	player.add_score()
	

func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("players"):
		apply_effect(body)
		queue_free()
