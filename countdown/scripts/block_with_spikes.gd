extends NumberedObject

@onready var spike_hitbox = $Area2D

func _ready():
	object_number = 2


func _on_area_2d_body_entered(body):

	# Leave this empty for now if Player.gd
	# doesn't have a take_damage() function.

	if body.is_in_group("player"):
		print("Player touched spikes!")
