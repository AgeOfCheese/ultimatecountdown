extends Node
#constants
const PLACEMENT_SCENE_PATH = "res://scenes/placement.tscn"
const LEVEL_SCENE_PATH = "res://scenes/level.tscn"
const OBJECT_POOl: Array[PackedScene] = [
preload("res://scenes/numbered_objects/Portal.tscn"), 
preload("res://scenes/numbered_objects/StandardWall.tscn"),
preload("res://scenes/numbered_objects/BlockWithSpikes.tscn"),
preload("res://scenes/numbered_objects/Flamethrower.tscn"),
preload("res://scenes/numbered_objects/ShieldBlock.tscn"),
preload("res://scenes/numbered_objects/JumpPad.tscn"),
preload("res://scenes/numbered_objects/StandardPlatform.tscn"),
preload("res://scenes/numbered_objects/RandClone.tscn"),
preload("res://scenes/numbered_objects/BlackHole.tscn"),
preload("res://scenes/numbered_objects/DamagePlatform.tscn"),
preload("res://scenes/numbered_objects/Cloud.tscn")]
#signals
signal round_complete
signal round_failed  # NEW
#variables
var level_objects: Array[Dictionary] = []
var objects_to_place = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

func _ready():
	round_complete.connect(advance_round)
	round_failed.connect(advance_round)  # NEW — failing also ticks the round forward

func _process(delta):
	pass

func advance_round():
	decrement_level_objects()
	get_tree().call_deferred("change_scene_to_file", PLACEMENT_SCENE_PATH)

func end_placement():
	get_tree().call_deferred("change_scene_to_file", LEVEL_SCENE_PATH)

func add_object(object_id: String, pos: Vector2, rot: float = 0.0):
	for i in range(level_objects.size() - 1, -1, -1):
		if level_objects[i].get("id") == object_id:
			level_objects.remove_at(i)
	var new_object_data = {
		"id": object_id,
		"position": pos,
		"rotation": rot
	}
	level_objects.append(new_object_data)

func decrement_level_objects():
	for i in range(level_objects.size() - 1, -1, -1):
		var current_id = int(level_objects[i].get("id"))
		var new_id = current_id - 1
		if new_id < 0:
			level_objects.remove_at(i)
		else:
			level_objects[i]["id"] = str(new_id)

func get_level_objects() -> Array[Dictionary]:
	return level_objects
