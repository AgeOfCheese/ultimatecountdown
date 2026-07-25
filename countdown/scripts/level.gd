extends Node2D

const PLAYER = preload("uid://c8ak77dijp28l")

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_player = PLAYER.instantiate()
	new_player.position = $Start/Marker2D.position
	add_child(new_player) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
