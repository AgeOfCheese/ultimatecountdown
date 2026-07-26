extends NumberedObject

func _ready():
	object_number = 9
	print("ready")


func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("players"):
		print("OIWHOEHFOIEHF")
		body.take_damage()
