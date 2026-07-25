extends Node2D

const PLAYER = preload("uid://c8ak77dijp28l")
@onready var end_hitbox = $End/Marker2D/EndHitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_player = PLAYER.instantiate()
	new_player.position = $Start/Marker2D.position
	add_child(new_player) # Replace with function body.
	
	#connect the end hitbox to the skibidi
	end_hitbox.connect("body_entered", player_entered_exit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func player_entered_exit(body):
	if body.is_in_group("players"):
		RoundManager.round_complete.emit()
