extends Node2D

const PLAYER = preload("uid://c8ak77dijp28l")
@onready var end_hitbox = $End/Marker2D/EndHitbox

func _ready():
	var new_player = PLAYER.instantiate()
	new_player.position = $Start/Marker2D.position
	add_child(new_player)

	end_hitbox.connect("body_entered", player_entered_exit)

	spawn_level_objects()

func spawn_level_objects():
	for object_data in RoundManager.level_objects:
		var object_number = object_data.get("number")
		var object_pos = object_data.get("position")

		if object_number == null or object_pos == null:
			push_warning("Skipping malformed level object entry: %s" % object_data)
			continue

		var scene = RoundManager.OBJECT_POOl.get(object_number)
		if scene == null:
			push_warning("No scene found in OBJECT_POOl for number: %s" % object_number)
			continue


		var new_object = scene.instantiate()
		new_object.position = object_pos
		add_child(new_object)

func _process(_delta):
	pass

func player_entered_exit(body):
	if body.is_in_group("players"):
		RoundManager.round_complete.emit()
