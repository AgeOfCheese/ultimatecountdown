extends NumberedObject

const JUMP_FORCE := -800

func _ready():
	object_number = 5


func _on_area_2d_body_entered(body):

	if body.is_in_group("player"):
		body.velocity.y = JUMP_FORCE
