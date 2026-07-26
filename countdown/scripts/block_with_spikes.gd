extends NumberedObject

@onready var spike_hitbox = $SpikeHitbox

func _ready():
	object_number = 2
	spike_hitbox.connect("body_entered", _on_area_2d_body_entered)


func _on_area_2d_body_entered(body):

	# Leave this empty for now if Player.gd
	# doesn't have a take_damage() function.
	
	if body.is_in_group("players"):
		body.take_damage()
