extends Node
#constants
const PLACEMENT_SCENE_PATH = "res://scenes/placement.tscn"
const LEVEL_SCENE_PATH = "res://scenes/level.tscn"
const VICTORY_SCENE_PATH = "res://scenes/victory.tscn"  # NEW — adjust path if different
const FAILURE_SCENE_PATH = "res://scenes/failure.tscn"  # NEW — adjust path if different
const WINS_TO_VICTORY = 10  # NEW
const DEATHS_TO_FAILURE = 5  # NEW
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
signal round_failed
#variables
var level_objects: Array[Dictionary] = []
var objects_to_place = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
var round_number : int = 0
var win_count : int = 0    # NEW
var death_count : int = 0  # NEW

func _ready():
	round_complete.connect(_on_round_complete)  # CHANGED
	round_failed.connect(_on_round_failed)      # CHANGED

func _process(delta):
	pass

# NEW — handles a win: increments win_count, checks for overall victory
func _on_round_complete():
	win_count += 1
	if win_count >= WINS_TO_VICTORY:
		get_tree().call_deferred("change_scene_to_file", VICTORY_SCENE_PATH)
		return
	advance_round()

# NEW — handles a death: increments death_count, checks for overall failure
func _on_round_failed():
	death_count += 1
	if death_count >= DEATHS_TO_FAILURE:
		get_tree().call_deferred("change_scene_to_file", FAILURE_SCENE_PATH)
		return
	advance_round()

func advance_round():
	decrement_level_objects()
	round_number += 1
	get_tree().call_deferred("change_scene_to_file", PLACEMENT_SCENE_PATH)

func end_placement():
	print("FINAL OBJECT LIST:")
	print(level_objects)
	get_tree().call_deferred(
		"change_scene_to_file",
		LEVEL_SCENE_PATH
	)

func add_object(object_id: String, pos: Vector2, rot: float = 0.0):
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

func replace_object(old_id: String, new_id: String, pos: Vector2, rot: float = 0.0):
	for object in level_objects:
		if object["id"] == old_id and object["position"] == pos:
			level_objects.erase(object)
			var new_object = {
				"id": new_id,
				"position": pos,
				"rotation": rot
			}
			level_objects.append(new_object)
			print(level_objects)
			print("Replaced object", old_id, "with", new_id)
			return
