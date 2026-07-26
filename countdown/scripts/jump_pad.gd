extends NumberedObject


@export var jump_force: float = -600.0


func _ready():
	object_number = 5



func apply_effect(player):

	if player.is_in_group("players"):

		# Bounce player upward
		player.velocity.y += jump_force



func _on_area_2d_body_entered(body):

	apply_effect(body)
