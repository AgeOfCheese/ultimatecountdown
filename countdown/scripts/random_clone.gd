extends NumberedObject

const OBJECTS = {
0: preload("res://scenes/numbered_objects/Portal.tscn"),
1: preload("res://scenes/numbered_objects/StandardWall.tscn"),
2: preload("res://scenes/numbered_objects/BlockWithSpikes.tscn"),
3: preload("res://scenes/numbered_objects/Flamethrower.tscn"),
4: preload("res://scenes/numbered_objects/ShieldBlock.tscn"),
5:preload("res://scenes/numbered_objects/JumpPad.tscn"),
6: preload("res://scenes/numbered_objects/StandardPlatform.tscn"),
8: preload("res://scenes/numbered_objects/BlackHole.tscn"),
9: preload("res://scenes/numbered_objects/DamagePlatform.tscn"),
10: preload("res://scenes/numbered_objects/Cloud.tscn")
}

func _ready():

	object_number = 7

	var random_number = OBJECTS.keys().pick_random()

	var new_object = OBJECTS[random_number].instantiate()

	new_object.position = position

	get_parent().call_deferred(
		"add_child",
		new_object
	)

	queue_free()
