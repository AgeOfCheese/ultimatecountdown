extends NumberedObject

@onready var shield_hitbox = $ShieldHitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	object_number = 4
	shield_hitbox.connect("body_entered", apply_effect)

func apply_effect(player):
	if player.has_method("add_shield"):
		player.add_shield()
